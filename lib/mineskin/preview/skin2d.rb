require 'rmagick'
require 'mineskin/unit'
require 'mineskin/compositor'

module MineSkin
  module Preview
    # 2D preview of skin
    class Skin2D
      include Unit
      include Compositor
      # Initializes object with skin data
      # @param [MineSkin::SkinData] skin_data Skin Data
      def initialize(skin_data)
        @skin_data = skin_data
      end

      # Renders preview
      # @param width Width of preview
      # @param [String] background Optional background color (default white)
      # @return [Magick::Image] Preview
      def render(width, background: 'white')
        @unit = image_unit size: width, count: 12
        @image = Magick::Image.new(width, 5 * width / 6) do
          self.background_color = background
        end
        render_head!
        render_body!
        render_legs!
        render_arms!
        @image
      end

      protected

      def render_head!
        composite_texture! @skin_data.head.front, 2, 1, @skin_data.unit
        composite_texture! @skin_data.head.back, 8, 1, @skin_data.unit
      end

      def render_body!
        composite_texture! @skin_data.body.front, 2, 3, @skin_data.unit
        composite_texture! @skin_data.body.back, 8, 3, @skin_data.unit
      end

      def render_legs!
        composite_texture! @skin_data.left_leg.front, 3, 6, @skin_data.unit
        composite_texture! @skin_data.right_leg.front, 2, 6, @skin_data.unit
        composite_texture! @skin_data.left_leg.back, 8, 6, @skin_data.unit
        composite_texture! @skin_data.right_leg.back, 9, 6, @skin_data.unit
      end

      def render_arms!
        composite_texture! @skin_data.left_arm.front, 4, 3, @skin_data.unit
        composite_texture! @skin_data.right_arm.front, 1, 3, @skin_data.unit
        composite_texture! @skin_data.left_arm.back, 7, 3, @skin_data.unit
        composite_texture! @skin_data.right_arm.back, 10, 3, @skin_data.unit
      end
    end
  end
end
