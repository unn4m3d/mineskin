require 'rmagick'
require 'mineskin/unit'

module MineSkin
  Cuboid = Struct.new(:top, :bottom, :left, :right, :front, :back)
  Texture = Struct.new(:texture, :overlay)

  # rubocop:disable ClassLength
  # Skin Data class
  class SkinData
    include Unit

    attr_accessor(
      :head,
      :body,
      :left_arm,
      :right_arm,
      :left_leg,
      :right_leg
    )
    attr_reader :unit
    def new_format?
      @new_format
    end

    # rubocop:disable AbcSize
    # Initializes new instance of SkinData
    # @param [String] filename Path to input file
    def initialize(filename)
      @image = Magick::Image.read(filename).first
      @new_format = @image.columns == @image.rows
      @unit = image_unit size: @image.columns
      @head = extract_head
      @body = extract_body
      @left_leg, @right_leg = extract_legs
      @left_arm, @right_arm = extract_arms
    end

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

    def new_only(*x)
      if new_format?
        return x.first if x.first.is_a? Array
        return x
      end
      nil
    end

    def extract_head
      extract(
        top:    { texture: [2, 0, 2, 2], overlay: [10, 0, 2, 2] },
        bottom: { texture: [4, 0, 2, 2], overlay: [12, 0, 2, 2] },
        right:  { texture: [0, 2, 2, 2], overlay: [8,  2, 2, 2] },
        left:   { texture: [4, 2, 2, 2], overlay: [12, 2, 2, 2] },
        front:  { texture: [2, 2, 2, 2], overlay: [10, 2, 2, 2] },
        back:   { texture: [6, 2, 2, 2], overlay: [14, 2, 2, 2] }
      )
    end

    def extract_left_arm
      return extract(
        top:    { texture: [9,  12, 1, 1], overlay: [13, 12, 1, 1] },
        bottom: { texture: [10, 12, 1, 1], overlay: [14, 12, 1, 1] },
        right:  { texture: [8,  13, 1, 3], overlay: [12, 13, 1, 3] },
        left:   { texture: [10, 13, 1, 3], overlay: [14, 13, 1, 3] },
        front:  { texture: [9,  13, 1, 3], overlay: [13, 13, 1, 3] },
        back:   { texture: [11, 13, 1, 3], overlay: [15, 13, 1, 3] }
      ) if new_format?
      extract_right_arm
    end

    def extract_right_arm
      extract(
        top:    { texture: [11, 4, 1, 1], overlay: new_only(11, 8, 1, 1) },
        bottom: { texture: [12, 4, 1, 1], overlay: new_only(12, 8, 1, 1) },
        right:  { texture: [10, 5, 1, 3], overlay: new_only(10, 9, 1, 3) },
        left:   { texture: [12, 5, 1, 3], overlay: new_only(12, 9, 1, 3) },
        front:  { texture: [11, 5, 1, 3], overlay: new_only(11, 9, 1, 3) },
        back:   { texture: [13, 5, 1, 3], overlay: new_only(13, 9, 1, 3) }
      )
    end

    # rubocop:disable RedundantReturn
    def extract_arms
      return extract_left_arm, extract_right_arm
    end

    def extract_right_leg
      extract(
        top:    { texture: [1, 4, 1, 1], overlay: new_only(1, 8, 1, 1) },
        bottom: { texture: [2, 4, 1, 1], overlay: new_only(2, 8, 1, 1) },
        right:  { texture: [0, 5, 1, 3], overlay: new_only(0, 9, 1, 3) },
        left:   { texture: [2, 5, 1, 3], overlay: new_only(2, 9, 1, 3) },
        front:  { texture: [1, 5, 1, 3], overlay: new_only(1, 9, 1, 3) },
        back:   { texture: [3, 5, 1, 3], overlay: new_only(3, 9, 1, 3) }
      )
    end

    def extract_left_leg
      return extract(
        top:    { texture: [5, 12, 1, 1], overlay: [1, 12, 1, 1] },
        bottom: { texture: [6, 12, 1, 1], overlay: [2, 12, 1, 1] },
        right:  { texture: [4, 13, 1, 3], overlay: [0, 13, 1, 3] },
        left:   { texture: [6, 13, 1, 3], overlay: [2, 13, 1, 3] },
        front:  { texture: [5, 13, 1, 3], overlay: [1, 13, 1, 3] },
        back:   { texture: [7, 13, 1, 3], overlay: [3, 13, 1, 3] }
      ) if new_format?
      extract_right_leg
    end

    def extract_legs
      return extract_right_leg, extract_left_leg
    end

    def extract_body
      extract(
        top:    { texture: [5, 4, 2, 1], overlay: new_only(5, 8, 2, 1) },
        bottom: { texture: [7, 4, 2, 1], overlay: new_only(7, 8, 2, 1) },
        right:  { texture: [4, 5, 1, 3], overlay: new_only(4, 9, 1, 3) },
        left:   { texture: [7, 5, 1, 3], overlay: new_only(7, 9, 1, 3) },
        front:  { texture: [5, 5, 2, 3], overlay: new_only(5, 9, 2, 3) },
        back:   { texture: [8, 5, 2, 3], overlay: new_only(8, 9, 2, 3) }
      )
    end
  end
end
