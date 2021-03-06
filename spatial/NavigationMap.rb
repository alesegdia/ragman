
require './math/Vec2.rb'

class NavNode

  attr_reader :links, :x, :y
  attr_accessor :h, :f, :g, :list, :parent


  def initialize(x,y)
    @links = nil
    @list = nil
    @x = x
    @y = y
    @parent = nil
    #@pos.x = x
    #@pos.y = y
    self.reset_heuristics
  end


  def is_same?( other )
	return (@x == other.x and @y == other.y)
  end

  def set_active
    @links = Array.new(4) { |i| nil }
  end

  def reset_heuristics
	@h = @f = @g = 9999999999999
  end

  def manh( px0, py0, px1, py1 )
	return (px0 - px1).abs + (py0 - py1).abs
  end

  def compute_heuristics( origin, goal )
	@g = cost_to( origin )
	@h = cost_to( goal )
	@f = @g + @h
  end

  def cost_to( node )
	return manh( @x, @y, node.x, node.y )
  end

  # check for active to access
  def get_link_node( dir )
    return @links[dir]
  end

  def is_used( dir )
    return (@links[dir] != nil)
  end

  def equals( node )
    return @x == node.x && @y == node.y
  end

  def set_link_node( dir, node )
    if not equals(node) then @links[dir] = node end
  end

  def is_active?
    return @links != nil
  end

  def debug
    puts "node (#{@x}, #{@y})"
    #for i in 0..3 do
    #  puts Direction::to_str( i ) + ": " +
    #end
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
    puts @navnodes.size()
  end

  def try_follow_link( node, dir, dx, dy, iter )
    #puts "asd"
    next_node = @navmap[node.y+dy*iter][node.x+dx*iter]
    if next_node != nil then
      if not @map.is_solid?(next_node.x,next_node.y) then
        if @navmap[next_node.y][next_node.x].is_active? then
          node.set_link_node(dir, next_node)
        else
          try_follow_link( node, dir, dx, dy, iter+1 )
        end
      end
    end
  end

  def get( x, y )
	return @navmap[y][x]
  end

  def debug
    @navnodes.each{ |n|
      n.debug
    }
  end

  def parse_map2
	(1..@map.width-2).each { |x|
		(1..@map.height-2).each { |y|
			if not @map.is_solid?( x, y ) then
				navnode = @navmap[y][x]
				navnode.debug
				navnode.set_active
				if not navnode.is_active? then
					navnode.set_active
				end
				if not @map.is_solid?(x-1,y) then
					navnode.set_link_node(Direction::Left,get(x-1,y))
				end
				if not @map.is_solid?(x+1,y) then
					navnode.set_link_node(Direction::Right,get(x+1,y))
				end
				if not @map.is_solid?(x,y+1) then
					navnode.set_link_node(Direction::Down,get(x,y+1))
				end
				if not @map.is_solid?(x,y-1) then
					navnode.set_link_node(Direction::Up,get(x,y-1))
				end
				@navnodes << navnode
			end
		}
	}
  end

  def parse_map

    # capture nodes
    check_branches( @map.get_first_free, @navnodes, true )

    # set links
    # acceder a la secuencial
    @navnodes.each{ |n|
      try_follow_link( n, Direction::Up, 0, -1, 1 )
      try_follow_link( n, Direction::Down, 0, 1, 1 )
      try_follow_link( n, Direction::Left, -1, 0, 1 )
      try_follow_link( n, Direction::Right, 1, 0, 1 )
    }

  end

  def set_links( navnode )
    try_follow_link( navnode, Direction::Up )
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
