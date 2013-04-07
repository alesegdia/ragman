require 'rubygems'
require 'gosu'
require 'Map'
require 'Sprite'
require 'Direction'

module ActionType
  MoveLeft = 1
  MoveRight = 2
  MoveUp = 3
  MoveDown = 4
  Idle = 0
end

def pickup_dir
  return [Direction::Up,
  	      Direction::Down,
  	      Direction::Left,
  	      Direction::Right].choice
end

class Behaviour
  def initialize(sprite, map)
    @sprite = sprite
    @map = map
    @action = ActionType::Idle
  end

  def think
	@sprite.populate_bounds(@map)

  	case @sprite.direction

  	# UP
	when Direction::Up
	  if @sprite.is_free(Direction::Up)
	  #if not @map.is_solid?(@sprite.tile_x, @sprite.tile_y-1)
	  	@action = ActionType::MoveUp
	  	puts 'polling up'
	  else
	  	@action = ActionType::Idle
	  	@sprite.direction = pickup_dir #Direction::Right
	  end

	# DOWN
	when Direction::Down
	  if @sprite.is_free(Direction::Down)
  	  #if not @map.is_solid?(@sprite.tile_x, @sprite.tile_y+1)
	    @action = ActionType::MoveDown
	    puts 'polling down'
	  else
	  	@action = ActionType::Idle
	  	@sprite.direction = pickup_dir #Direction::Left
	  end

  	# LEFT
    when Direction::Left
      if @sprite.is_free(Direction::Left)
  	  #if not @map.is_solid?(@sprite.tile_x-1, @sprite.tile_y)
	    @action = ActionType::MoveLeft
  	    puts 'polling left'
	  else
	  	@action = ActionType::Idle
	  	@sprite.direction = pickup_dir #Direction::Up
	  end

  	# RIGHT
	when Direction::Right
	  if @sprite.is_free(Direction::Right)
  	  #if not @map.is_solid?(@sprite.tile_x+1, @sprite.tile_y)
	    puts 'polling right'
	    @action = ActionType::MoveRight
	  else
	    @action = ActionType::Idle
	    @sprite.direction = pickup_dir #Direction::Down
	  end
    else
	  puts 'FUCK!! Im STUCK!!'
		puts "x.#{@sprite.tile_x} y.#{@sprite.tile_y}"
	  puts "x.#{@sprite.x} y.#{@sprite.y}"
  	end
  end

  def take_action
	return @action
  end
end