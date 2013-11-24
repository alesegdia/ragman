require 'rubygems'
require 'gosu'
require './Direction.rb'

class Tile
  attr_reader :image

  def initialize(image, solid)
    @solid = solid
    @image = image
  end

  def is_solid?
    @solid
  end

end

class Map
  attr_reader :map, :tilesheet, :tile_width, :tile_height, :width, :height

  # tile_width, tile_height, map_width, map_height, default_tile, tilesheet
  def initialize(window, *rest)
    @window = window
    if rest.size == 6 then
      puts "6 args!"
      # Create new empty map

	  @tile_width, @tile_height = rest[0], rest[1]
      @width, @height = rest[2], rest[3]
      default_tile = rest[4]
      puts rest[5]
      @tilesheet = rest[5]

      # Init map
      @map = Array.new(@height) { |i| Array.new(@width) { |i| default_tile } }

      # Init tiles
      @tiles = Hash.new
      spliced_tsheet = Gosu::Image::load_tiles(window,
                                               @tilesheet,
                                               @tile_width,
                                               @tile_height,
                                               false)

      spliced_tsheet.each_index { |i| add_tile(i, spliced_tsheet[i], false) }
      # @tiles[i] = Tile.new(tile_images[i], false)

    elsif rest.size == 1 then
      load_file(rest[0]) #ARGV[0])
    end
  end

  def map_info
    Struct::MapInfo.new(@tile_width, @tile_height,
                        @map_width, @map_height, @tiles_img)
  end

  def load_file(path)
    # Load file, size and array map
    filepath = File.dirname(path)
    file = File.new(path, "r")
    @tile_width, @tile_height, @width, @height =
      file.gets.split(' ').drop(1).collect! { |x| Integer(x) }

    @map = Array.new(Integer(@height)) { Array.new(Integer(@width)) }

    # Load tiles
    @tiles = Hash.new
    @tilesheet = file.gets.chomp
    tile_images = Gosu::Image::load_tiles(@window,
                                          filepath + "/" + @tilesheet,
                                          @tile_width,
                                          @tile_height,
                                          false)

    while (line = file.gets and
           line =~ /^TILE.*/)

      # Parse lines
      args = line.split(' ')
      id, solid = Integer(args[1]), args[2]
      solidity = (solid == "true") ? true : false

      # Add tile to list
      add_tile(id, tile_images[id], solidity)
      puts "tile created! #{id}"
      #puts @tiles.at(id).is_solid?
    end


    # Load map
    i = 0
    begin
      @map[i] = line.split(' ').drop(1).collect! { |x| Integer(x) }
      i += 1
    end while(line = file.gets)
  end

  def save_file(path)
	content = ""
	content << "TILESIZE #{@tile_width} #{@tile_height} #{@width} #{@height}\n"
    content << "#{@tilesheet}\n"
    @tiles.each { |key,val| content << "TILE #{key} #{(val.is_solid?) ? 'true' : 'false'}\n" }

    @map.each_index { |i|
      content << "L "
      @map[i].each { |elem|
        content << "#{elem} "
      }
      content << "\n"
    }
  	File.open(path, 'w') { |f| f.write(content) }
  end

  def add_tile (id, image, solid)
    @tiles[id] = Tile.new(image, solid)
  end

  def swap_tile(x, y, new_tile)
    x_sel = (x / @tile_width).floor
    y_sel = (y / @tile_height).floor

    if (x_sel < @width and y_sel < @height) and
        (x_sel >= 0 and y_sel >= 0) and
        (new_tile < @tiles.length)
      @map[y_sel][x_sel] = String(new_tile)
    end
  end
  
  def draw
    ##puts to_s
    @map.each_index do |i| 
      @map[i].each_index do |j|
        @tiles[Integer(@map[i][j])].image.draw(j * @tile_width,
                                               i * @tile_height,
                                               1)
      end
    end
  end

  # Made just for the editor
  def draw_offset(xoff, yoff)
    @map.each_index do |i| 
      @map[i].each_index do |j|
        @tiles[Integer(@map[i][j])].image.draw(xoff + j * @tile_width,
                                               yoff + i * @tile_height,
                                               2)
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
  
  def is_solid?(x, y)
  	puts "asked for #{x} and #{y}"
  	puts "SOLID NIGGA'" if @tiles[@map[y][x]].is_solid?
	return @tiles[@map[y][x]].is_solid?
  end

  def is_possible_movement(direction, newX, newY, tolerancia)
  	upY =    ((newY + tolerancia) / 16).floor
  	downY =  ((newY + 15 - tolerancia) / 16).floor
  	leftX =  ((newX + tolerancia)/ 16).floor
  	rightX = ((newX + 15 - tolerancia) / 16).floor

	if direction == Direction::Up
      if @tiles[@map[upY][leftX]].is_solid?
        return false
      end
      if @tiles[@map[upY][rightX]].is_solid?
		return false
      end
	  return true
    end

    if direction == Direction::Down
      if @tiles[@map[downY][leftX]].is_solid?
        return false
      end
      if @tiles[@map[downY][rightX]].is_solid?
		return false
      end

      return true
    end

    if direction == Direction::Right
      if @tiles[@map[upY][rightX]].is_solid?
        return false
      end
      if @tiles[@map[downY][rightX]].is_solid?
		return false
      end

      return true
    end

    # OK!
    if direction == Direction::Left
	  if @tiles[@map[downY][leftX]].is_solid?
        return false
      end
      if @tiles[@map[upY][leftX]].is_solid?
		return false
      end
      return true
    end
  end
end

