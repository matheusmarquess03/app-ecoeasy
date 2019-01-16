module Images
  class Attach
    attr_reader :relation, :encoded_image

    def initialize(relation, encoded_image)
      @relation = relation
      @encoded_image = encoded_image
    end

    def run
      return if encoded_image.blank?

      relation.attach(io: decoded_image, filename: filename)

      decoded_image.unlink
    end

    private

    def decoded_image
      @decoded_image ||= Decode.new(encoded_image, filename).run
    end

    def filename
      @filename ||= "image_file_#{Time.now.to_i}"
    end
  end
end
