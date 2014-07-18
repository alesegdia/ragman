require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets.rb'
require '../gglib/ext/themes.rb'
require '../Map.rb'
require './Grid.rb'
require './EditionState.rb'
# require 'NewMapState.rb'
require './LoadMenu.rb'
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
    elsif ARGV.size == 5 then
      puts "Main.rb: 5 param"
      @map = Map.new(self, OpenMode::Edition,
                     Integer(ARGV[0]),
                     Integer(ARGV[1]),
                     Integer(ARGV[2]),
                     Integer(ARGV[3]),
                     ARGV[4])
    else
      puts "Usage:"
      puts "\t* ruby Main.rb <map file>"
      puts "\t* ruby Main.rb <tile width>"
      puts "\t               <tile height>"
      puts "\t               <map width>"
      puts "\t               <map height>"
      puts "\t               <tilesheet>\n\n"
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
