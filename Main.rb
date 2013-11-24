#!/usr/bin/env ruby

require './Sprite.rb'
require './Map.rb'
require './HumanController'
require './AIController'
require './Behaviour'
require 'rubygems'
require 'gosu'
require './Direction.rb'

def norm(a, b)
  return (a/b).floor
end

class GameWindow < Gosu::Window

	# METHODS:
	#  initialize
	#  update
	#  draw
	#  button_down?
	#  draw_background

  def initialize
    super 640, 480, false
    self.caption = "Sprite Testing"

    @bgcolor = Gosu::Color.new(255,255,255,255)
	#@agent_controller = AgentController.new

    @sprite = Sprite.new(self, 200, "pcm_all.png", 16, 16);
    @cherry = Sprite.new(self, 200, "cherry.png", 16, 16);

	@sprite.add_anim("right", 0, 4)
	@sprite.add_anim("left", 4, 4)
	@sprite.add_anim("up", 8, 4)
	@sprite.add_anim("down", 12, 4)
	@sprite.set_anim("right")

	@cherry.add_anim("right", 0, 2)
	@cherry.add_anim("left", 2, 2)
	@cherry.add_anim("up", 4, 2)
	@cherry.add_anim("down", 6, 2)
	@cherry.set_anim("right")
	@cherry.direction = Direction::Up
	
	if ARGV.length == 0
	    print "hello"
		@map = Map.new(self, "pacmanmap")
	else
		@map = Map.new(self, ARGV[0])
	end
	
    @sprite.warp(80, 80)

    @cherry.warp(16,32)
    @cherry.set_tile(norm(@cherry.x, @map.tile_width),norm(@cherry.y, @map.tile_height))
    @playercontroller = HumanController.new(self, @sprite, @map)

    # setear el behaviour desde fuera, para no tener que repetir información y se cree desde AIController
    @cherrycontroller = AIController.new(@cherry, @map, Behaviour.new(@cherry, @map))

  end

  def update
		@playercontroller.update
		@cherrycontroller.update
  end

  def draw
    @map.draw
    @sprite.draw
    @cherry.draw
    puts "x.#{@cherry.tile_x} y.#{@cherry.tile_y}"
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
