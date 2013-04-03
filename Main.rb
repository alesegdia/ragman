#!/usr/bin/env ruby

require './Sprite'
require './Map.rb'
require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Sprite Testing"

    @bgcolor = Gosu::Color.new(255,255,255,255)

    @sprite = Sprite.new(self, 200, "pcm_all.png", 16, 16);

	@sprite.add_anim("right", 0, 4);
	@sprite.add_anim("left", 4, 4);
	@sprite.add_anim("up", 8, 4);
	@sprite.add_anim("down", 12, 4);
    #@sprite.add_anim("anims/sw_front.png", "down", 32, 32);
    #@sprite.add_anim("anims/sw_right.png", "right", 32, 32);
    #@sprite.add_anim("anims/sw_left.png", "left", 32, 32);
    #@sprite.add_anim("anims/sw_back.png", "up", 32, 32);
    @sprite.set_anim("right")
    @sprite.warp(80, 80)

    @map = Map.new(self, ARGV[0])

  end

  def update
	correccionX = @sprite.x - ((@sprite.x).floor/16)*16
	correccionY = @sprite.y - ((@sprite.y).floor/16)*16
	tolerancia = 8

    if button_down? Gosu::KbUp then
      @sprite.set_anim("up")
      if @map.is_possible_movement("up",
      		@sprite.x, @sprite.y-@sprite.vel-tolerancia,tolerancia)
      	  correccionY != 0
        @sprite.move_up
        if correccionX != 0
        if correccionX.abs >= 8
          @sprite.x = @sprite.x + 1
        else
          @sprite.x = @sprite.x - 1
		end
		end
      end
    elsif button_down? Gosu::KbDown then
      @sprite.set_anim("down")
      if @map.is_possible_movement("down",
      		@sprite.x, @sprite.y+@sprite.vel+tolerancia,tolerancia)
        @sprite.move_down

        if correccionX != 0
        if correccionX.abs >= 8
          @sprite.x = @sprite.x + 1
        else
          @sprite.x = @sprite.x - 1
		end
		end

      end
    elsif button_down? Gosu::KbLeft then
      @sprite.set_anim("left")
      if @map.is_possible_movement("left",
      		@sprite.x-@sprite.vel-tolerancia,@sprite.y,tolerancia)
        @sprite.move_left
        if correccionY != 0
        if correccionY.abs >= 8
          @sprite.y = @sprite.y + 1
        else
          @sprite.y = @sprite.y - 1
		end
		end
      end
    elsif button_down? Gosu::KbRight then
      @sprite.set_anim("right")
      if @map.is_possible_movement("right",
      		@sprite.x+@sprite.vel+tolerancia,@sprite.y,tolerancia)
        @sprite.move_right
        if correccionY != 0
        if correccionY.abs >= 8
          @sprite.y = @sprite.y + 1
        else
          @sprite.y = @sprite.y - 1
		end
		end
      end
    end
  end

  def draw
    @map.draw
    @sprite.draw
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
