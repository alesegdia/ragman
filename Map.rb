require 'rubygems'
require 'gosu'
require './Direction.rb'
require './NavigationMap.rb'
require './Vec2.rb'

module OpenMode
  Edition = 0
  Gameplay = 1
end

module TileKind
  Free = 0
  Solid = 1
  Pacman = 2
  Pill = 3
  PowerPill = 4
  Warp = 5
  GhostSpawn = 6
  GhostBarrier = 7
  AStarNode = 8
end

class Tile
  attr_reader :image

  def initialize(image, kind)
    @kind = kind
    @image = image
  end

  def is_solid?
    @kind == TileKind::Solid
  end

end

class Map
  attr_reader :map, :tilesheet, :tile_width, :tile_height, :width, :height
  attr_reader :tile_images, :entity_info

  # tile_width, tile_height, map_width, map_height, default_tile, tilesheet
  def initialize(window, modo, *rest)
    @modo = modo
    @window = window
    if rest.size == 5 then

      # Create new empty map
      @tile_width, @tile_height = rest[0], rest[1]
      @width, @height = rest[2], rest[3]
      @tilesheet = rest[4]
      @players = Array.new()

      # Init map
      @map = Array.new(@height) { |i| Array.new(@width) { |i| TileKind::Free } }

      # Init tiles
      @tiles = Hash.new
      spliced_tsheet = Gosu::Image::load_tiles(window,
                                               @tilesheet,
                                               @tile_width,
                                               @tile_height,
                                               false)

      spliced_tsheet.each_index { |i| add_tile(i, spliced_tsheet[i]) }
      # @tiles[i] = Tile.new(tile_images[i], false)

    elsif rest.size == 1 then
      load_file(rest[0]) #ARGV[0])
    end
    if modo == OpenMode::Gameplay then
      parse_entities()
    end

    @navmap = NavigationMap.new( self )

  end

  def is_valid( nodo )
    #if nodo == nil then return false end
    nodo.x >= 0 and nodo.y >= 0 and nodo.x < @width and nodo.y < @height
  end

  def get_first_free
    for i in 0..@map.size()-1 do
      for j in 0..@map[0].size()-1 do
        if @map[i][j] == TileKind::Free then
          return Vec2.new( j, i )
        end
      end
    end
  end

  def map_info
    Struct::MapInfo.new(@tile_width, @tile_height,
                        @map_width, @map_height, @tiles_img)
  end

  def parse_entities
    @entity_info = Hash.new
    @entity_info["pills"] = Array.new
    @entity_info["powerpills"] = Array.new
    @entity_info["pacman_spawn"] = Vec2.new
    @entity_info["ghost_spawn"] = Array.new
    @entity_info["warp"] = Array.new

    for i in 0..@map.size()-1 do
      for j in 0..@map[i].size()-1 do
        case @map[i][j]
        when TileKind::Solid, TileKind::Free
          nil
        when TileKind::Pill
          @entity_info["pills"] << Vec2.new( j, i )
        when TileKind::PowerPill
          @entity_info["powerpills"] << Vec2.new( j, i )
        when TileKind::Pacman
          @entity_info["pacman_spawn"] = Vec2.new( j, i )
        when TileKind::GhostSpawn
          @entity_info["ghost_spawn"] << Vec2.new( j, i )
        when TileKind::Warp
          @entity_info["warp"] << Vec2.new( j, i )
        end
        if @map[i][j] != TileKind::Solid then
          @map[i][j] = TileKind::Free
        end
      end
    end
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
    @tile_images = Gosu::Image::load_tiles(@window, "media" + "/" + @tilesheet,
                                          @tile_width, @tile_height, false)

    for i in 0..tile_images.size() do
      add_tile(i, tile_images[i])
    end

    # Load map
    i = 0
    while line = file.gets do
      @map[i] = line.split(' ').collect! { |x| Integer(x) }
      i += 1
    end

  end

  def save_file(path)
    content = ""
    content << "SIZE #{@tile_width} #{@tile_height} #{@width} #{@height}\n"
    content << "#{@tilesheet}\n"

    @map.each_index { |i|
      @map[i].each { |elem|
        content << "#{elem} "
      }
      content << "\n"
    }
    File.open(path, 'w') { |f| f.write(content) }
  end

  def add_tile (id, image)
    @tiles[id] = Tile.new(image, id)
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

    @navmap.navnodes.each do |n|
      @tile_images[TileKind::AStarNode].draw( n.x*16, n.y*16, 1)
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
    if x >= 0 and y >= 0 and x < @width and y < @height then
      #puts "asked for #{x} and #{y}"
      #puts "SOLID NIGGA'" if @tiles[@map[y][x]].is_solid?
      return @tiles[@map[y][x]].is_solid?
    else
      return false
    end
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
      if is_solid?(rightX, upY)
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

