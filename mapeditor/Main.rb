require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets'
require '../gglib/ext/themes'
require '../Map.rb'
require 'Grid.rb'

class EditorWindow < GGLib::GUIWindow
  def initialize
    super(640, 640, false)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 15)
    self.caption = "Ragman Map Editor"
    @map = Map.new(self, "pacmanmap")
    @grid = Grid.new(self, "map_tiles.png", 2, 150, 50, 16, 16)
  end

  def needs_cursor?
    true
  end

  def update
  end

  def draw
    @map.draw
    @font.draw("TILE PALETTE", 130, 10, 1)
    @grid.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
    
end

window = EditorWindow.new
window.show
