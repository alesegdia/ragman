
require 'rubygems'
require 'gosu'

class Sprite
  attr_reader :x, :y, :vel
  def initialize(window, speed)
    @window = window
    @speed = speed
    @x = @y = 0
    @animations = Hash.new
    @speed = speed
    @current_anim
    @vel = 2
  end

  def draw
    frame = @current_anim[Gosu::milliseconds / @speed % @current_anim.size]
    frame.draw(@x, @y, 1)
  end

  def add_anim(filepath, anim_name, width, height)
    @animations[anim_name] = Gosu::Image::load_tiles(@window,
                               filepath,
                               width,
                               height,
                               false);
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