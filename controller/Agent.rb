require 'rubygems'
require 'gosu'
require './spatial/Direction.rb'
require './spatial/Entity.rb'
require './behaviour/Behaviour.rb'
require './spatial/Map.rb'

def norm(a, b)
  return (a/b).floor
end

class Agent

  def initialize(entity, map, controller)
  	@entity = entity
  	@map = map
  	@controller = controller
  	@prev_action = Direction::Up
  end

  def pathfind( from, to )

  end

  def update

  	# cambiar al behaviour cuando lo hagas virtual
  	#@entity.set_tile(norm(@entity.x,@map.tile_width),
  	#				 norm(@entity.y,@map.tile_height))

    @entity.populate_bounds(@map)
  	agent_action = @controller.poll_action
  	if @prev_action != agent_action and @entity.is_free(agent_action) then
      @entity.move(agent_action)
      @prev_action = agent_action
    elsif @entity.is_free(@prev_action) then
      @entity.move(@prev_action)
    end
    @entity.set_anim(@prev_action)
  end
end
