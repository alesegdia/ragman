require 'rubygems'
require 'gosu'
require 'gglib'
require './gglib/ext/widgets.rb'
require './gglib/ext/themes.rb'
require './spatial/Map.rb'
require './mapeditor/Grid.rb'
require './mapeditor/EditionState.rb'
# require 'NewMapState.rb'
require './mapeditor/LoadMenu.rb'
# Add ZOrder

class EditorWindow < GGLib::GUIWindow
  attr_reader :map

  def initialize
    super(800, 600, false)

    self.caption = "Ragman Map Editor"
    @rest = ARGV
    if ARGV.size == 1 then
      puts "Main.rb: 1 param"
      @map = Map.new(self, OpenMode::Edition, ARGV[0])
    elsif ARGV.size == 2 then
      puts "Main.rb: 2 param"
      @map = Map.new(self, OpenMode::Edition,
                     16, #Integer(ARGV[0]),
                     16, #Integer(ARGV[1]),
                     Integer(ARGV[0]),
                     Integer(ARGV[1]),
                     "media/map_tiles.png" )#ARGV[2])
    else
      puts "Usage:"
      puts "\t* ruby Main.rb <map file>"
      puts "\t* ruby Main.rb <map width>"
      puts "\t               <map height>\n\n"
      exit
    end
    ##@edition = EditionState.new
    ##@loadmenu = LoadMenu.new
    ##self.state = @edition
    self.state = EditionState.new
  end
end

window = EditorWindow.new.show
#window.show
