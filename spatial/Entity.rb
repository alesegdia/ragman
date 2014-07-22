
require './spatial/Direction.rb'
require 'rubygems'
require 'gosu'

def getFrames(window, path, first, howMuch, width, height)
	#return(Gosu::Image::load_tiles(@window, path, width, height, false)).drop(first).take(howMuch);
end


class Entity
  attr_accessor :x, :y, :vel, :width, :height, :direction, :tile_x, :tile_y
  def initialize(window, speed, spritesheet, width, height)
    @window = window
    @speed = speed
    @x = @y = 0
    @animations = {}
    @speed = speed
    @width = width
    @height = height
    @direction = Direction::Up

    @bounds_valid = [false,false,false,false,false]
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

  def warp(x, y)
    @x, @y = x, y
  end

  def populate_bounds(map)
	@bounds_valid[Direction::Up] =
      map.is_possible_movement(Direction::Up, x, y - vel, 0)
	@bounds_valid[Direction::Down] =
	  map.is_possible_movement(Direction::Down, x, y + vel, 0)
	@bounds_valid[Direction::Left] =
	  map.is_possible_movement(Direction::Left, x - vel, y, 0)
	@bounds_valid[Direction::Right] =
	  map.is_possible_movement(Direction::Right, x + vel, y, 0)
  end

  def is_free(direction)
    @bounds_valid[direction]
  end

  def move_up
	@y = @y - @vel
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

  def move(dir)
    case dir
    when Direction::Left then move_left
    when Direction::Right then move_right
    when Direction::Up then move_up
    when Direction::Down then move_down
    end
    #@x = @x + @vel * hor
	  #@y = @y + @vel * ver
  end

end
