MineSkin
==

A gem to manipulate Minecraft skins and capes [WIP]

Currently its only features are extracting skin or cape data and rendering 2D previews

You can find documentation [here](https://unn4m3d.github.io/mineskin)

Installation
--
`gem install mineskin`

Usage
--

```ruby
require 'mineskin'
data = MineSkin::SkinData("my_skin.png")
data.head # => #<MineSkin::Cuboid ... >
data.head.top # => #<MineSkin::Texture ... >
data.head.top.texture # => #<Magick::Image ... >
data.head.top.overlay # => Magick::Image or nil

preview = MineSkin::Preview::Skin2D(data)
# background is white by default
image = preview.render(640, background: 'white') # => Magick::Image
image.format = "png"
File.open("output.png","w"){ |f| f.write image.to_blob }

# Cape operations are the same
cape = MineSkin::CapeData("my_cape.png")
cape.cape # => #<MineSkin::Cuboid ... >

cape_preview = MineSkin::Preview::Cape2D(data)
cape_image = preview.render(640) # => Magick::Image
cape_image.format = "png"
File.open("output.png","w"){ |f| f.write cape_image.to_blob }
```

Example of output.png:

![Example](output.png)
