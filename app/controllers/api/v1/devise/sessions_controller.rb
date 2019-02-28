module Api::V1::Devise
  class SessionsController < DeviseTokenAuth::SessionsController
    skip_before_action :verify_authenticity_token

    def create
      # Check
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      @resource = nil
      if field
        q_value = resource_params[field]

        if resource_class.case_insensitive_keys.include?(field)
          q_value.downcase!
        end

        q = "#{field.to_s} = ? AND provider='email'"

        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? "mysql"
          q = "BINARY " + q
        end

        # LOG IN BY EMAIL AND USERNAME
        if field == :login
          @resource = resource_class.where("email = ? OR cpf = ?", q_value, q_value).first
        else
          @resource = resource_class.where(q, q_value).first
        end
        # LOG IN BY EMAIL AND USERNAME END
      end

      if @resource && valid_params?(field, q_value) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        valid_password = @resource.valid_password?(resource_params[:password])
        if (@resource.respond_to?(:valid_for_authentication?) && !@resource.valid_for_authentication? { valid_password }) || !valid_password
          render_create_error_bad_credentials
          return
        end
        # create client id
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + ::DeviseTokenAuth.token_lifespan).to_i
        }
        @resource.save

        # Verificar permissão do usuário de acordo com o aplicativo
        unless @resource.type.upcase == request.headers['App-Type']&.upcase || (@resource.type == 'Client' && request.headers['App-Type'].blank?)
          render_app_unauthorized
          return
        end

        sign_in(:user, @resource, store: false, bypass: false)

        yield @resource if block_given?

        render_create_success
      elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
        render_create_error_not_confirmed
      else
        render_create_error_bad_credentials
      end
    end

    protected

    def render_app_unauthorized
      render json: { message: 'Esta conta não está autorizada acessar este aplicativo' }, status: :forbidden
    end

    def render_create_success
      render json: resource_data(resource_json: @resource.token_validation_response)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in,
        keys: [:login, :password, :password_confirmation]
      )
    end
  end
end
