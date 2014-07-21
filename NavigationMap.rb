
require './Vec2.rb'

class NavNode

  attr_reader :links, :x, :y

  def initialize(x,y)
    @links = nil
    @x = x
    @y = y
  end

  def set_active
    @links = Array.new(4) { |i| nil }
  end

  # check for active to access
  def get_link_node( dir )
    return @links[dir]
  end

  def set_link_node( dir, node )
    @links[dir] = node
  end

  def is_active?
    return @links != nil
  end

end

class NavigationMap

  # @map:       physical file loaded map with entities
  #
  # @navmap:    copy of loaded map with navigation info
  #             intended for direct access
  #
  # @mapnodes:  active navigation nodes
  #             intended sequential access

  attr_reader :navnodes

  def initialize( map )

    @map = map
    @navmap = Array.new( @map.height ) { |y| Array.new(@map.width) { |x| NavNode.new(x,y) } }
    @navnodes = Array.new

    parse_map
  end

  def parse_map

    # capture nodes
    check_branches( @map.get_first_free, @navnodes, true )

    # set links
    # acceder a la secuencial

  end

  def check_branches( nodo, nodos, force = false )
    # puts "resolving node #{nodo.x}, #{nodo.y}"
    if force == true or (@map.is_valid(nodo) and not @navmap[nodo.y][nodo.x].is_active?) then
      @navmap[nodo.y][nodo.x].set_active
      nodos.push( @navmap[nodo.y][nodo.x] )
      if not @map.is_solid?(nodo.x+1, nodo.y) then
        continue_branch( Vec2.new( nodo.x+1, nodo.y ), Direction::Right, nodos )
      end
      if not @map.is_solid?(nodo.x-1, nodo.y) then
        continue_branch( Vec2.new( nodo.x-1, nodo.y ), Direction::Left, nodos )
      end
      if not @map.is_solid?(nodo.x, nodo.y-1) then
        continue_branch( Vec2.new( nodo.x, nodo.y-1 ), Direction::Up, nodos )
      end
      if not @map.is_solid?(nodo.x, nodo.y+1) then
        continue_branch( Vec2.new( nodo.x, nodo.y+1 ), Direction::Down, nodos )
      end
    end
  end


  def continue_branch( nodo, dir, nodos )
    if nodo != nil and @map.is_valid(nodo) then
    case dir
    when Direction::Left
      sig_nodo = Vec2.new( nodo.x - 1, nodo.y )
    when Direction::Right
      sig_nodo = Vec2.new( nodo.x + 1, nodo.y )
    when Direction::Up
      sig_nodo = Vec2.new( nodo.x, nodo.y - 1 )
    when Direction::Down
      sig_nodo = Vec2.new( nodo.x, nodo.y + 1 )
    end

    dirs = Array.new
    dirs << Direction::Right if not @map.is_solid?(nodo.x+1, nodo.y)
    dirs << Direction::Left if not @map.is_solid?(nodo.x-1, nodo.y)
    dirs << Direction::Up if not @map.is_solid?(nodo.x, nodo.y-1)
    dirs << Direction::Down if not @map.is_solid?(nodo.x, nodo.y+1)

      if dirs.size() > 2 then
        check_branches( nodo, nodos )
      end

    # puts "from #{nodo.x}, #{nodo.y} to #{sig_nodo.x}, #{sig_nodo.y}"

    if @map.is_solid?(sig_nodo.x, sig_nodo.y) then
      check_branches( nodo, nodos )
    else
      continue_branch( sig_nodo, dir, nodos )
    end
    end
  end
end
