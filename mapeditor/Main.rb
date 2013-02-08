require 'rubygems'
require 'gosu'
require 'gglib'
#require '../gglib/ext/widgets'
#require '../gglib/ext/themes'
require '../Map.rb'
require 'Grid.rb'

# Add ZOrder

class EditorWindow < GGLib::GUIWindow
  def initialize
    super(640, 640, false)
    @font = Gosu::Font.new(self, Gosu::default_font_name, 15)
    self.caption = "Ragman Map Editor"
    @map = Map.new(self, "pacmanmap")
    @grid = Grid.new(self, "map_tiles.png", 5, 200, 100, 16, 16)

    @grid_xoff, @grid_yoff = 300, 20
    @map_xoff, @map_yoff = 20, 20
  end

  def needs_cursor?
    true
  end

  def update

  end

  def draw
    @map.draw(@map_xoff, @map_yoff)
    draw_palette(300,20)
  end

  def draw_palette(x,y)
    @font.draw("TILE PALETTE", x-10, y-20, 1)
    @grid.draw(x, y)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::MsLeft
      @grid.select(mouse_x - @grid_xoff, mouse_y - @grid_yoff)
      @map.swap_tile(mouse_x - @map_xoff, mouse_y - @map_yoff, @grid.selected_tile)
    end
  end
end

window = EditorWindow.new
window.show
