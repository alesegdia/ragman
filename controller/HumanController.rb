require 'rubygems'
require 'gosu'
require './spatial/Direction.rb'


class HumanController

  def initialize(window, sprite, map)
    @sprite = sprite
    @map = map
    @window = window
    @direction = Direction::None
  end

  def direction
    @sprite.direction
  end

  def poll_action
    #correccionX = @sprite.x - ((@sprite.x).floor/16)*16
    #correccionY = @sprite.y - ((@sprite.y).floor/16)*16


    # CHECK INPUT AND HANDLE COLLISIONS
    if @window.button_down? Gosu::KbUp
      @direction = Direction::Up
    elsif @window.button_down? Gosu::KbDown
      @direction = Direction::Down
    elsif @window.button_down? Gosu::KbLeft
      @direction = Direction::Left
    elsif @window.button_down? Gosu::KbRight
      @direction = Direction::Right
    end

    return @direction

  end

end
