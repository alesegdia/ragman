require 'rubygems'
require 'gosu'

class Grid
  attr_reader :x_size, :y_size
  attr_reader :selected
  def initialize(window, image_file, cols, x_offset, y_offset, tile_width, tile_height)
    @cols = cols
    @tile_width, @tile_height = tile_width, tile_height
    @window = window
    @images = Gosu::Image::load_tiles(window,
                                     image_file,
                                     tile_width,
                                     tile_height,
                                     false)
    @x_size = cols * @tile_width
    @y_size = (@images.length / cols).ceil * @tile_height
    @selected = Array.new(2) { |i| 0 }
  end
  
  def draw(xoff,yoff)
    i,j = 0,0
    @images.each do |image|
      image.draw(xoff + i * @tile_width,
                 yoff + j * @tile_height,
                 2)
      i = (i+1) % @cols
      if (i == 0)
        j += 1
      end
    end
    if is_selected? then draw_sel(xoff,yoff) end
  end

  def draw_sel(xoff, yoff)
    color = Gosu::Color.new(0xFF00FF00)
    xpos = xoff + @selected[0] * @tile_width
    ypos = yoff + @selected[1] * @tile_height
    left = xpos - 1
    right = xpos + @tile_width + 1
    top = ypos - 1
    bot = ypos + @tile_height + 1

    @window.draw_quad(
              left, top, color,
              right, top, color,
              left, bot, color,
              right, bot, color, 2)
    @images[selected[0] + selected[1]*@cols].draw(xoff + selected[0] * @tile_width,
                                                 yoff + selected[1] * @tile_height, 2)
  end

  def select(mouse_x, mouse_y)
    # Get the tile indexes selected
    x_sel = (mouse_x / @tile_width).floor
    y_sel = (mouse_y / @tile_height).floor

    # Check that the selected tile is in range
    if (x_sel < @cols and x_sel + y_sel * @cols < @images.size) and
        (x_sel >= 0 and y_sel >= 0)
      @selected = [x_sel,y_sel]
      puts "SELECTED!"
    end
  end

  def selected_tile
    return @selected[0] + @selected[1] * @cols
  end

  def is_selected?
    return false if @selected[0] == nil
    true
  end
end
