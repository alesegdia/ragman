
require 'rubygems'
require 'gosu'

def getFrames(window, path, first, howMuch, width, height)
	#return(Gosu::Image::load_tiles(@window, path, width, height, false)).drop(first).take(howMuch);
end

class Sprite
  attr_accessor :x, :y, :vel, :width, :height
  def initialize(window, speed, spritesheet, width, height)
    @window = window
    @speed = speed
    @x = @y = 0
    @animations = Hash.new
    @speed = speed
    @width = width
    @height = height

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
#    @animations[anim_name] = Gosu::Image::load_tiles(@window,
#                               filepath,
#                               width,
#                               height,
#                               false);
  end

  def set_anim(name)
    @current_anim = @animations[name]
  end

  def warp(x, y)
    @x, @y = x, y
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
  
end
