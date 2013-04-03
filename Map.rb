require 'rubygems'
require 'gosu'
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

MapInfo = Struct.new(:tile_width, :tile_height,
                     :map_width, :map_height, :tiles_img)

class Map
  attr_reader :map, :tilesheet, :tile_width, :tile_height, :width, :height
  
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
      load_file(ARGV[0])
    end
  end

  def map_info
    Struct::MapInfo.new(@tile_width, @tile_height,
                        @map_width, @map_height, @tiles_img)
  end
  
  def load_file(path)
    # Load file, size and array map
    file = File.new(path, "r")
    @tile_width, @tile_height, @width, @height =
      file.gets.split(' ').drop(1).collect! { |x| Integer(x) }
    
    @map = Array.new(Integer(@height)) { Array.new(Integer(@width)) }
    
    # Load tiles
    @tiles = Hash.new
    @tilesheet = file.gets.chomp
    tile_images = Gosu::Image::load_tiles(@window,
                                          @tilesheet,
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
    file += "TILESIZE #{@tile_width} #{@tile_height}\n"
    file += "TILEIMG #{@tile_img}"
    @tiles.each { |key,val| file += "TILE #{key} #{(val.is_solid?) ? 'true' : 'false'}" }

    @map.each_index { |i|
      file += "T "
      @map[i].each { |elem|
        file += "#{elem} "
      }
      file += "\n"
    }

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
	return @tiles[@map[x][y]].is_solid?
  end

=begin
  def populate_collidable(bounds)
    startX = bounds.x
    startY = bounds.y
    endX = bounds.x + bounds.w
    endY = bounds.y + bounds.h
	x = startX
	y = startY
	until x > endX do
	  until y > endY do
	  	@collidable << Rect.new( x/16 + 
	  x = x + 16
	(startX..endX).each do |x|
	  (startY..endY).each do |y|
	  	
	  end
	end
  end
=end

  def give_my_corners(x, y, sprite)
  	upY = (sprite.y / 16)
  	downY = (sprite.y + 15) / 16
  	rightX = 1
  	leftX = 1
  end

  def is_possible_movement(direction, newX, newY, tolerancia)
  	upY =    ((newY + tolerancia) / 16).floor
  	downY =  ((newY + 15 - tolerancia) / 16).floor
  	leftX =  ((newX + tolerancia)/ 16).floor
  	rightX = ((newX + 15 - tolerancia) / 16).floor

	if direction == "up"
      if @tiles[@map[upY][leftX]].is_solid?
        return false
      end
      if @tiles[@map[upY][rightX]].is_solid?
		return false
      end
	  return true
    end

    if direction == "down"
      if @tiles[@map[downY][leftX]].is_solid?
        return false
      end
      if @tiles[@map[downY][rightX]].is_solid?
		return false
      end

      return true
    end

    if direction == "right"
      if @tiles[@map[upY][rightX]].is_solid?
        return false
      end
      if @tiles[@map[downY][rightX]].is_solid?
		return false
      end

      return true
    end

    # OK!
    if direction == "left"
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

