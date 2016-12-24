module MineSkin
  Cuboid = Struct.new(:top, :bottom, :left, :right, :front, :back)
  Texture = Struct.new(:texture, :overlay)
end
