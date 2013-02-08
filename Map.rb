require 'rubygems'
require 'gosu'

class Tile
  attr_reader :image
  
  def initialize(solid, image)
    @solid = solid
    @image = image
  end

  def is_solid?
    @solid
  end
end

class Map
  attr_reader :map, :tile_width, :tile_height
  def initialize(window, map_path)
    
    # Load file, size and array map
    file = File.new(map_path, "r")
    @tile_width, @tile_height, @width, @height =
      file.gets.split(' ').drop(1).collect! { |x| Integer(x) }
    
    @map = Array.new(Integer(@height)) { Array.new(Integer(@width)) }
    
    # Load tiles
    tile_images = Gosu::Image::load_tiles(window,
                                          file.gets.chomp,
                                          @tile_width,
                                          @tile_height,
                                          false)
    
    @tiles = Array.new(tile_images.size)
    while (line = file.gets and
           line =~ /^TILE.*/)
      args = line.split(' ')
      id, solid = Integer(args[1]), args[2]
      solidity = (solid == "true") ? true : false
      @tiles[id] = Tile.new(solidity, tile_images[id])
      puts "tile created! #{id}"
      puts @tiles[id].is_solid?
    end
    
    # Load map
    i = 0
    begin
      @map[i] = line.split(' ').drop(1).collect! { |x| Integer(x) }
      i += 1
    end while (line = file.gets)
    
    ##puts to_s
  end

  def swap_tile(x, y, new_tile)
    x_sel = (x / @tile_width).floor
    y_sel = (y / @tile_height).floor

    if (x_sel < @width and y_sel < @height) and
        (x_sel >= 0 and y_sel >= 0) and
        (new_tile < @tiles.length)
      @map[y_sel][x_sel] = new_tile
    end
  end
  
  def draw
    ##puts to_s
    @map.each_index do |i| 
      @map[i].each_index do |j|
        @tiles[Integer(@map[i][j])].image.draw(j * @tile_width,
                                               i * @tile_height,
                                               0)
      end
    end
  end

  # Made just for the editor
  def draw(xoff, yoff)
    @map.each_index do |i| 
      @map[i].each_index do |j|
        @tiles[Integer(@map[i][j])].image.draw(xoff + j * @tile_width,
                                               yoff + i * @tile_height,
                                               0)
      end
    end
  end

  def to_s
    s = ""
    @map.each_index do |i|
      @map[i].each_index do |j|
        s << "#{@map[i][j]} "
      end
      s << "\n"
    end
    s
  end
  
  def is_possible_movement(sprite, direction)
    if direction == "up"
      mapX = sprite.x / 16
      mapY = (sprite.y - sprite.vel) / 16
      if @tiles[@map[mapY][mapX]].is_solid?
        return false
      end
      return true
    end

    if direction == "down"
      mapX = sprite.x / 16
      mapY = (sprite.y + sprite.vel + 32) / 16
      if @tiles[@map[mapY][mapX]].is_solid?
        return false
      end
      return true
    end
    
    if direction == "right"
      mapX = (sprite.x + sprite.vel + 32) / 16
      mapY = sprite.y / 16
      if @tiles[@map[mapY][mapX]].is_solid?
        return false
      end
      return true
    end
    
    if direction == "left"
      mapX = (sprite.x-2) / 16
      mapY = sprite.y / 16
      if @tiles[@map[mapY][mapX]].is_solid?
        return false
      end
      return true
    end
  end
  
end

