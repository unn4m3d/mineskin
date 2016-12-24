require 'rmagick'
require 'mineskin/unit'
module MineSkin
  module Preview
    # 2D preview
    class Preview2D
      include Unit

      def initialize(skin_data)
        @skin_data = skin_data
      end

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

      def resize(img)
        img.sample(@unit.to_f / @skin_data.unit.to_f)
      end

      def composite_texture!(tex, x, y, op: Magick::SrcOverCompositeOp)
        @image.composite!(resize(tex.texture), x * @unit, y * @unit, op)
        @image.composite!(
          resize(tex.overlay),
          x * @unit,
          y * @unit,
          op
        ) if tex.overlay
      end

      def render_head!
        composite_texture! @skin_data.head.front, 2, 1
        composite_texture! @skin_data.head.back, 8, 1
      end

      def render_body!
        composite_texture! @skin_data.body.front, 2, 3
        composite_texture! @skin_data.body.back, 8, 3
      end

      def render_legs!
        composite_texture! @skin_data.left_leg.front, 3, 6
        composite_texture! @skin_data.right_leg.front, 2, 6
        composite_texture! @skin_data.left_leg.back, 8, 6
        composite_texture! @skin_data.right_leg.back, 9, 6
      end

      def render_arms!
        composite_texture! @skin_data.left_arm.front, 4, 3
        composite_texture! @skin_data.right_arm.front, 1, 3
        composite_texture! @skin_data.left_arm.back, 7, 3
        composite_texture! @skin_data.right_arm.back, 10, 3
      end
    end
  end
end
