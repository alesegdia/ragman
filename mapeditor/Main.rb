require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets'
require '../gglib/ext/themes'
require '../Map.rb'
require 'Grid.rb'

# Add ZOrder

class EditorWindow < GGLib::GUIWindow
  def initialize
    super(400,400,false)
    self.caption = "Ragman Map Editor"
    self.state = EditorState.new
  end

end

class EditorState < GGLib::StateObject
  def initialize
    super
  end

  def onStart
    if ARGV.size == 1 then
      puts "Main.rb: 1 param"
      @map = Map.new(window, ARGV[0])
    elsif ARGV.size == 6
      puts "Main.rb: 6 param"
      @map = Map.new(window,
                     Integer(ARGV[0]),
                     Integer(ARGV[1]),
                     Integer(ARGV[2]),
                     Integer(ARGV[3]),
                     Integer(ARGV[4]),
                     ARGV[5])
    else
      puts "Usage:"
      puts "\t* ruby Main.rb <map file>"
      puts "\t* ruby Main.rb <tile width>"
      puts "\t               <tile height>"
      puts "\t               <map width>"
      puts "\t               <map height>"
      puts "\t               <default tile>"
      puts "\t               <tilesheet>\n\n"
      exit
    end
    
    @font = Gosu::Font.new(window, Gosu::default_font_name, 15)
    @grid = Grid.new(window, @map.tilesheet, 5, 200, 100, 16, 16)
    
    @grid_xoff, @grid_yoff = 300, 20
    @map_xoff, @map_yoff = 20, 20
  end
  
  def needs_cursor?
    true
  end
  
  def update
    
  end
  
  def make_new_map
    print "Size [tile_w tile_h map_w map_h]: "
    size = gets
    print "Tilesheet: "
    tilesheet = gets.chomp
    size = size.split.collect! { |x| Integer(x) }
    
    @map = Map.new(window, size[0], size[1], size[2], size[3], tilesheet)
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
      window.close
    when Gosu::KbN
      make_new_map
    when Gosu::MsLeft
      @grid.select(window.mouse_x - @grid_xoff,
                   window.mouse_y - @grid_yoff)

      @map.swap_tile(window.mouse_x - @map_xoff,
                     window.mouse_y - @map_yoff,
                     @grid.selected_tile)
    end
  end

end

window = EditorWindow.new
window.show
