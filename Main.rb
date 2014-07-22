#!/usr/bin/env ruby

require './spatial/Entity.rb'
require './spatial/Map.rb'
require './spatial/Direction.rb'
require './controller/GhostController'
require './controller/HumanController'
require './controller/AIController'
require './controller/Agent'
require './behaviour/Behaviour'
require 'rubygems'
require 'gosu'

module GhostID
  Ruby = 0
  Bulby = 1
  Pinky = 2
  Ronso = 3
end

class GameWindow < Gosu::Window

  # PRE: mapa cargado, @ghost_entities = Hash.new
  def load_ghost( id )
    file = "media/g#{id}.png"
    ghost = Entity.new( self, 200, file, 16, 16 )
    ghost.add_anim(Direction::Right, 0, 2)
    ghost.add_anim(Direction::Left, 2, 2)
    ghost.add_anim(Direction::Up, 4, 2)
    ghost.add_anim(Direction::Down, 6, 2)
    ghost.set_anim(Direction::Up)
    ghost.direction = Direction::Down
    @ghost_entities[id] = ghost
    ghost_spawn = @map.entity_info["ghost_spawn"]
    @ghost_entities[id].warp( ghost_spawn[0].x * @map.tile_width + 16 * 2.5, ghost_spawn[0].y * @map.tile_height )
    controller = AIController.new( ghost, @map, Behaviour.new(@ghost_entities[id], @map))
    gh_controller = GhostController.new( ghost, @map, controller)
    @agents[id] = Agent.new( ghost, @map, gh_controller )
  end

  # PRE: mapa cargado
  def load_pacman()
    @pacman = Entity.new( self, 100, "media/pcm_all.png", 16, 16 )
    @pacman.add_anim(Direction::Right, 0, 4)
    @pacman.add_anim(Direction::Left, 4, 4)
    @pacman.add_anim(Direction::Up, 8, 4)
    @pacman.add_anim(Direction::Down, 12, 4)
    @pacman.set_anim(Direction::Right)
    pacman_spawn = @map.entity_info["pacman_spawn"]
    @pacman.warp( pacman_spawn.x * @map.tile_width, pacman_spawn.y * @map.tile_height )
  end


  # METHODS:
  #  initialize
  #  update
  #  draw
  #  button_down?
  #  draw_background

  def initialize
    super 640, 480, false
    self.caption = "Ragman!"

    @ghost_entities = Hash.new
    @agents = Hash.new

    @bgcolor = Gosu::Color.new(255,255,255,255)

    if ARGV.length == 0
      @map = Map.new(self, OpenMode::Gameplay, "maps/original")
    else
      @map = Map.new(self, OpenMode::Gameplay, ARGV[0])
    end

    @pills = @map.entity_info["pills"]
    @powerpills = @map.entity_info["powerpills"]
    @warps = @map.entity_info["warp"]
    @in_warp = false

    load_pacman()
    load_ghost( GhostID::Ruby )
    load_ghost( GhostID::Bulby )
    load_ghost( GhostID::Pinky )
    load_ghost( GhostID::Ronso )

    # Colocamos a pacman
    @pacman_controller = HumanController.new(self, @pacman, @map)
    @pacman_agent = Agent.new( @pacman, @map, @pacman_controller )

  end

  def update
    @pills.reject! do |pill|
      Gosu::distance( @pacman.x, @pacman.y, pill.x * 16, pill.y * 16 ) < 4
    end
    @powerpills.reject! do |pill|
      Gosu::distance( @pacman.x, @pacman.y, pill.x * 16, pill.y * 16 ) < 4
    end

    warp = nil
    for i in 0..@warps.size-1 do
      w = @warps[i]
      if Gosu::distance( @pacman.x, @pacman.y, w.x * 16, w.y * 16) < 24 then
        warp = i
      end
    end

    if warp != nil then
      if not @in_warp then
        warp_to = @warps[(warp+1) % @warps.size]
        xoff, yoff = 0, 0
        case @pacman_controller.direction
        when Direction::Left then xoff = -1.5
        when Direction::Right then xoff = 1.5
        when Direction::Up then yoff = -1.5
        when Direction::Down then yoff = 1.5
        end
        @pacman.x = (warp_to.x+xoff) * 16
        @pacman.y = (warp_to.y+yoff) * 16
      end
      @in_warp = true
    else
      @in_warp = false
    end

    #if not @in_warp then
    #  for i in 0..@warps.size-1 do
    #    warp = @warps[i]
    #    if Gosu::distance( @pacman.x, @pacman.y, warp.x * 16, warp.y * 16) < 16 then
    #      if @in_warp == false then
    #        @in_warp = true
    #      end
    #    end
    #  end
    #end

    @pacman_agent.update
    @agents.each do |k,c|
      c.update
    end

  end

  def draw
    @map.draw
    @pacman.draw
    @ghost_entities.each do |k,c|
      c.draw
    end
    @pills.each do |c|
      @map.tile_images[TileKind::Pill].draw( c.x * @map.tile_width, c.y * @map.tile_height, 2 )
    end
    @powerpills.each do |c|
      @map.tile_images[TileKind::PowerPill].draw( c.x * @map.tile_width, c.y * @map.tile_height, 2 )
    end

    col = Gosu::Color.argb(0x33FFFF00)
    @map.navmap.navnodes.each{ |n|
      for i in 0..3 do
        if n.is_used(i) then
          nxt = n.get_link_node( i )
          draw_line(
            (n.x+0.5) * @map.tile_width , (n.y+0.5) * @map.tile_height, col,
            (nxt.x+0.5) * @map.tile_width, (nxt.y+0.5) * @map.tile_height, col, 1
          )
        end
      end
    }
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
