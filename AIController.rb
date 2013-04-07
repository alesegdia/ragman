require 'rubygems'
require 'gosu'
require 'Direction'
require 'Sprite'
require 'Behaviour'
require 'Map'

module ActionType
  MoveLeft = 1
  MoveRight = 2
  MoveUp = 3
  MoveDown = 4
  Idle = 0
end

def norm(a, b)
  return (a/b).floor
end

class AIController

  def initialize(sprite, map, behaviour)
  	@sprite = sprite
  	@map = map
  	@behaviour = behaviour
  end

  def update

  	# cambiar al behaviour cuando lo hagas virtual
  	@sprite.set_tile(norm(@sprite.x,@map.tile_width),
  					 norm(@sprite.y,@map.tile_height))

  	@behaviour.think
  	case @behaviour.take_action
	when ActionType::MoveLeft
	  @sprite.move_left
	  @sprite.set_anim("left")
	when ActionType::MoveRight
	  @sprite.move_right
	  @sprite.set_anim("right")
	when ActionType::MoveUp
	  @sprite.move_up
	  @sprite.set_anim("up")
	when ActionType::MoveDown
	  @sprite.move_down
	  @sprite.set_anim("down")
	when ActionType::Idle
	  #do nothing
	else
	  raise UnknownStateError.new
	end
  end
end
