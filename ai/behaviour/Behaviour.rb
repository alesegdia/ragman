require 'rubygems'
require 'gosu'
require './spatial/Map.rb'
require './spatial/Entity.rb'
require './spatial/Direction.rb'
require './ai/algo/astar.rb'


def pickup_dir
  return [Direction::Up,
          Direction::Down,
          Direction::Left,
          Direction::Right].sample
end

class Behaviour
  def initialize(sprite, map)
    @sprite = sprite
    @map = map
	@astar = AStar.new( @map.navmap )
    @action = Direction::Up
  end

  def think

	  (0..1).each {
		astar = AStar.new( @map.navmap )
		astar.setnodes( @map.navmap.get(1,1), @map.navmap.get(26,28) )
		while astar.step == AStarState::RUNNING do ; end
	  }

    if @sprite.is_free(@sprite.direction) then
      @action = @sprite.direction
    else
      @sprite.direction = pickup_dir
      @action = Direction::None
    end
    return @action
  end

end
