module Images
  class Decode
    attr_reader :encoded_image, :filename

    def initialize(encoded_image, filename)
      @encoded_image = encoded_image
      @filename = filename
    end

    def run
      decoded_file = Base64.decode64(encoded_image)

      tmp_file = Tempfile.new([filename, '.png'])
      tmp_file.binmode
      tmp_file.write decoded_file
      tmp_file.rewind

      tmp_file
    end
  end
end
