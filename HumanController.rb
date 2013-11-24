require 'rubygems'
require 'gosu'
require './Direction.rb'

class HumanController

  def initialize(window, sprite, map)
    @sprite = sprite
    @map = map
    @window = window
  end

  def update
  	#correccionX = @sprite.x - ((@sprite.x).floor/16)*16
	#correccionY = @sprite.y - ((@sprite.y).floor/16)*16

	move = true
	direction_candidate = Direction::None
	@sprite.populate_bounds(@map)

	# CHECK INPUT AND HANDLE COLLISIONS
	if @window.button_down? Gosu::KbUp
	  direction_candidate = Direction::Up
	elsif @window.button_down? Gosu::KbDown
	  direction_candidate = Direction::Down
	elsif @window.button_down? Gosu::KbLeft
	  direction_candidate = Direction::Left
	elsif @window.button_down? Gosu::KbRight
	  direction_candidate = Direction::Right
	end

    if direction_candidate != Direction::None
      if @sprite.is_free(direction_candidate)
      	@sprite.direction = direction_candidate
	  end
	end

	if not @sprite.is_free(@sprite.direction)
	  	move = false
	end

   	case @sprite.direction
    when Direction::Up
	  @sprite.set_anim("up")
	  @sprite.move_up if move
	when Direction::Down
	  @sprite.set_anim("down")
	  @sprite.move_down if move
	when Direction::Left
	  @sprite.set_anim("left")
	  @sprite.move_left if move
	when Direction::Right
	  @sprite.set_anim("right")
	  @sprite.move_right if move
	end

	end

end
