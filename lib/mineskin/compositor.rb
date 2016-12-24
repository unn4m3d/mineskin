module MineSkin
  # Composition tools
  # @api private
  module Compositor
    # Resizes image
    # @api private
    # @param [Magick::Image] img Source image
    # @param [Integer] old_unit Unit size of source image
    # @return [Magick::Image] Resized image
    def resize(img, old_unit)
      img.sample(@unit.to_f / old_unit.to_f)
    end

    # rubocop:disable MethodLength

    # Puts texture to the specified region of {@image}
    # @param [MineSkin::Texture] tex Texture objet
    # @param [Integer] x X coordinate
    # @param [Integer] y Y coordinate
    # @param [Integer] old_unit Unit size of source image (see #resize)
    # @param [Magick::CompositeOperator] op Operator (optional)
    # @api private
    def composite_texture!(tex, x, y, old_unit, op: Magick::SrcOverCompositeOp)
      @image.composite!(
        resize(tex.texture, old_unit),
        x * @unit,
        y * @unit,
        op
      )
      @image.composite!(
        resize(tex.overlay, old_unit),
        x * @unit,
        y * @unit,
        op
      ) if tex.overlay
    end
    # rubocop:enable MethodLength
  end
end
