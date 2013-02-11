#!/usr/bin/env ruby

require './Sprite'
require './Map'
require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Sprite Testing"

    @bgcolor = Gosu::Color.new(255,255,255,255)

    #@sprite = Sprite.new(self, 200);
    #@sprite.add_anim("anims/sw_front.png", "down", 32, 32);
    #@sprite.add_anim("anims/sw_right.png", "right", 32, 32);
    #@sprite.add_anim("anims/sw_left.png", "left", 32, 32);
    #@sprite.add_anim("anims/sw_back.png", "up", 32, 32);
    #@sprite.set_anim("up")
    #@sprite.warp(20, 40)

    @map = Map.new(self, "pacmanmap")

  end

  def update
=begin
    if button_down? Gosu::KbUp then
      @sprite.set_anim("up")
      if @map.is_possible_movement(@sprite, "up")
        @sprite.move_up
      end
    elsif button_down? Gosu::KbDown then
      @sprite.set_anim("down")
      if @map.is_possible_movement(@sprite, "down")
        @sprite.move_down
      end
    elsif button_down? Gosu::KbLeft then
      @sprite.set_anim("left")
      if @map.is_possible_movement(@sprite, "left")
        @sprite.move_left
      end
    elsif button_down? Gosu::KbRight then
      @sprite.set_anim("right")
      if @map.is_possible_movement(@sprite, "right")
        @sprite.move_right
      end
    end
=end
  end
  
  def draw
    #@sprite.draw
    @map.draw(0,0)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  
  def draw_background
	draw_quad(
	    0,   0, @bgcolor,
	  640,   0, @bgcolor,
	    0, 480, @bgcolor,
	  640, 480, @bgcolor, 0
	)
  end
end

window = GameWindow.new
window.show
