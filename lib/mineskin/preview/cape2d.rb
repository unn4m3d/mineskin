require 'rmagick'

module MineSkin
  # Preview generators module
  module Preview
    # 2D Cape preview generator
    class Cape2D
      include Unit
      include Compositor

      # Initializes object with cape data
      # @param [MineSkin::CapeData] cape_data Cape data
      def initialize(cape_data)
        @cape_data = cape_data
      end

      # Renders cape preview
      # @param [Integer] width Width of preview
      # @param [String] background Optional background color
      # @return [Magick::Image] Rendered preview
      def render(width, background: 'white')
        @unit = image_unit size: width, count: 40
        @image = Magick::Image.new(width, 65 * width / 100) do
          self.background_color = background
        end
        render_cape!
        @image
      end

      protected

      def render_cape!
        composite_texture! @cape_data.cape.front, 5, 5, @cape_data.unit
        composite_texture! @cape_data.cape.back, 25, 5, @cape_data.unit
      end

    end
  end
end
