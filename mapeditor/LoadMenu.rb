require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets'
require '../gglib/ext/themes'
require '../Map.rb'
require './Grid.rb'
require './EditionState.rb'

class LoadMenu < GGLib::StateObject
  def initialize
    super
    ##@goToEdition = nil
  end
  
  def onStart
    $window.setBackground("bground.jpg")
    @goToEdition = nil
    @map = $window.map
    puts @map.tilesheet
    puts "Load menu activated!"
    $textbox = GGLib::TextBox.new("textbox", 130, 50, 12, GGLib::Themes::BlueSteel)
    GGLib::Button.new(:loadbutton, "LOAD",  50, 50,
                      Proc.new { |widget|
                        @map.load_file($textbox.text)
                        @goToEdition = true
                      },
                      GGLib::Themes::BlueSteel)
  end
  
  def update
    if @goToEdition then
      @goToEdition = nil
      $window.state = EditionState.new
    end
  end

  def onEnd
    puts "Load menu terminated"
  end
end
