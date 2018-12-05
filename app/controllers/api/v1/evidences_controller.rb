module Api::V1
  class EvidencesController < ApiController
    def create
      @evidence = Evidence.new(evidence_params)
      @evidence.user_id = current_api_v1_user.id
      convert_base64_to_image_file
      @evidence.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def evidence_params
      params.fetch(:evidence, {}).permit(:description)
    end

    def convert_base64_to_image_file
      # Process the file, decode the base64 encoded file
      @decoded_file = Base64.decode64(params[:images])

      @filename = "image_file_#{Time.now.to_i}"     # this will be used to create a tmpfile and also, while setting the filename to attachment
      @tmp_file = Tempfile.new([@filename, '.png']) # This creates an in-memory file [details here][1]
      @tmp_file.binmode                             # This helps writing the file in binary mode.
      @tmp_file.write @decoded_file
      @tmp_file.rewind()

      # We create a new model instance
      @evidence.images.attach(io: @tmp_file, filename: @filename) # attach the created in-memory file, using the filename defined

      # deletes the temp file
      @tmp_file.unlink
    end
  end
end
