module Api::V1::Devise
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    skip_before_action :verify_authenticity_token
    before_action :configure_permitted_parameters

    def create
      build_resource

      unless @resource.present?
        raise DeviseTokenAuth::Errors::NoResourceDefinedError,
              "#{self.class.name} #build_resource does not define @resource,"\
              ' execution stopped.'
      end

      # give redirect value from params priority
      @redirect_url = params.fetch(
        :confirm_success_url,
        DeviseTokenAuth.default_confirm_success_url
      )

      # success redirect url is required
      if confirmable_enabled? && !@redirect_url
        return render_create_error_missing_confirm_success_url
      end

      # if whitelist is set, validate redirect_url against whitelist
      return render_create_error_redirect_url_not_allowed if blacklisted_redirect_url?

      begin
        # override email confirmation, must be sent manually from ctrl
        resource_class.set_callback('create', :after, :send_on_create_confirmation_instructions)
        resource_class.skip_callback('create', :after, :send_on_create_confirmation_instructions)

        if @resource.respond_to? :skip_confirmation_notification!
          # Fix duplicate e-mails by disabling Devise confirmation e-mail
          @resource.skip_confirmation_notification!
        end

        if @resource.save
          yield @resource if block_given?

          if @resource.confirmed?
            # email auth has been bypassed, authenticate user
            @client_id, @token = @resource.create_token
            @resource.save!
            update_auth_header
          else
            # user will require email authentication
            @resource.send_confirmation_instructions(
              client_config: params[:config_name],
              redirect_url: @redirect_url
            )
          end

          create_address if address_params.present?
          render_create_success
        else
          clean_up_passwords @resource
          render_create_error
        end
      rescue ActiveRecord::RecordNotUnique
        clean_up_passwords @resource
        render_create_error_email_already_exists
      end
    end

    private

    def create_address
      address = Address.new(address_params)
      address.user = @resource
      address.save
    end

    def address_params
      params.fetch(:address, {}).permit(:street, :number, :complement, :district, :city, :state, :country, :zip_code, :latitude, :longitude, :default)
    end

    def account_update_params
      params.require(:registration).permit(:name, :nickname, :cpf, :phone_number, :email, :password, :password_confirmation, :current_password)
    end

    protected

    def render_create_success
      resource_json_response = resource_data.merge(address: @resource.addresses.as_json)
      render json: resource_json_response
    end

    def render_update_success
      resource_json_response = @resource.type == 'Client' ? resource_data.merge(address: @resource.addresses.as_json) : resource_data
      render json: resource_json_response
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,
        keys: [ :email, :password, :name, :cpf, :phone_number ])
    end
  end
end
