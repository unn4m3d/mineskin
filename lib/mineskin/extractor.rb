require 'mineskin/types'

module MineSkin
  module Extractor
    # Extracts texture
    # @param [Hash] texture Texture coordinates (x,y,width,height)
    # @return [Magick::Image] Image part
    def crop(texture)
      @image.crop(
        texture[:x] * @unit,
        texture[:y] * @unit,
        texture[:width] * @unit,
        texture[:height] * @unit
      )
    end

    # Constructs a Texture object from given regions
    # @param [Hash,Array] texture Texture coordinates in array or hash
    # @param [Hash, Array, nil] overlay Optional overlay coords
    # @return [MineSkin::Texture] Texture object
    def part(texture: { x: 0, y: 0, width: 0, height: 0 }, overlay: nil)
      tex = crop coords_to_h texture

      part = Texture.new(tex, nil)
      if overlay
        over = crop coords_to_h overlay
        part.overlay = over
      end

      part
    end

    # Constructs a Cuboid from given regions
    # @param [Hash] hash Region data
    # @return [MineSkin::Cuboid] Cuboid object
    def extract(hash)
      Cuboid.new(
        part(hash[:top]),
        part(hash[:bottom]),
        part(hash[:left]),
        part(hash[:right]),
        part(hash[:front]),
        part(hash[:back])
      )
    end

    protected

    def coords_to_h(c)
      if c.is_a? Array
        {
          x: c[0],
          y: c[1],
          width: c[2],
          height: c[3]
        }
      else
        c
      end
    end
  end
end
