require 'rmagick'
require 'mineskin/unit'
require 'mineskin/extractor'
require 'mineskin/types'

module MineSkin
  class CapeData
    include Unit
    include Extractor

    attr_accessor :cape
    attr_reader :unit

    def initialize(filename)
      @image = Magick::Image.read(filename).first
      # rubocop:disable ConditionalAssignment
      if (@image.columns.to_f / @image.rows.to_f) == (22.0 / 17.0)
        @unit = (@image.columns / 22.0).ceil
      else
        @unit = (@image.columns / 64.0).ceil
      end
      extract_cape!
    end

    protected

    def extract_cape!
      @cape = extract(
        top:    { texture: [1,  0, 10, 1],  overlay: nil },
        bottom: { texture: [11, 0, 10, 1],  overlay: nil },
        right:  { texture: [0,  1, 1,  16], overlay: nil },
        left:   { texture: [11, 1, 1,  16], overlay: nil },
        front:  { texture: [12, 1, 10, 16], overlay: nil },
        back:   { texture: [1,  1, 10, 16], overlay: nil }
      )
    end
  end
end
