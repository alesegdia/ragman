
require 'rubygems'
require 'gosu'

def getFrames(window, path, first, howMuch, width, height)
	#return(Gosu::Image::load_tiles(@window, path, width, height, false)).drop(first).take(howMuch);
end

module Direction
  None = 0
  Up = 1
  Down = 2
  Left = 3
  Right = 4
end

class Sprite
  attr_accessor :x, :y, :vel, :width, :height, :direction, :tile_x, :tile_y
  def initialize(window, speed, spritesheet, width, height)
    @window = window
    @speed = speed
    @x = @y = 0
    @animations = Hash.new
    @speed = speed
    @width = width
    @height = height
    @direction = Direction::Up

    @up_valid = false
    @down_valid = false
    @left_valid = false
    @right_valid = false
    @tile_x
    @tile_y

	load_spritesheet(spritesheet, width, height)

    @current_anim
    @vel = 1
  end

  def draw
    frame = @current_anim[Gosu::milliseconds / @speed % @current_anim.size]
    frame.draw(@x, @y, 4)
  end

  def load_spritesheet(filepath, width, height)
  	  @spritesheet = Gosu::Image::load_tiles(@window, filepath, width, height, false)
  end

  # PRE: load_spritesheet success
  def add_anim(anim_name, first, howMuch)
    @animations[anim_name] = @spritesheet.drop(first).take(howMuch)
  end

  def set_anim(name)
    @current_anim = @animations[name]
  end

  def set_tile(x, y)
  	@tile_x = x
  	@tile_y = y
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def move_up
	@y = @y - @vel
  end

  def populate_bounds(map)
  	if map.is_possible_movement(Direction::Up,
  								 x, y - vel, 0)
  	  @up_valid = true
	else
	  @up_valid = false
	end

  	if map.is_possible_movement(Direction::Down,
  								 x, y + vel, 0)
  	  @down_valid = true
	else
	  @down_valid = false
	end

  	if map.is_possible_movement(Direction::Left,
  								 x - vel, y, 0)
  	  @left_valid = true
	else
	  @left_valid = false
	end

  	if map.is_possible_movement(Direction::Right,
  								 x + vel, y, 0)
  	  @right_valid = true
	else
	  @right_valid = false
	end
  end

  def is_free(direction)
	case direction
	when Direction::Up
	  return @up_valid

	when Direction::Down
	  return @down_valid

	when Direction::Left
	  return @left_valid

	when Direction::Right
	  return @right_valid
	end
  end

  def move_down
	@y = @y + @vel
  end

  def move_left
	@x = @x - @vel
  end

  def move_right
	@x = @x + @vel
  end

end
