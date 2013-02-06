require 'rubygems'
require 'gosu'

class Grid
  def initialize(window, image_file, cols, x_offset, y_offset, tile_width, tile_height)
    @cols = cols
    @tile_width, @tile_height = tile_width, tile_height
    @x_offset, @y_offset = x_offset, y_offset
    @images = Gosu::Image::load_tiles(window,
                                     image_file,
                                     tile_width,
                                     tile_height,
                                     false)
  end
  
  def draw
    i,j = 0,0
    @images.each do |image|
      image.draw(@x_offset + i * @tile_width,
                 @y_offset + j * @tile_height,
                 0)
      i = (i+1) % @cols
      if (i == 0)
        j += 1
      end
    end
  end

end
