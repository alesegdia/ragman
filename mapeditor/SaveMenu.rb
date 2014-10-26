require 'rubygems'
require 'gosu'
require 'gglib'
require './gglib/ext/widgets'
require './gglib/ext/themes'
require './spatial/Map.rb'
require './mapeditor/Grid.rb'
require './mapeditor/EditionState.rb'

class SaveMenu < GGLib::StateObject
  def initialize
    super
  end

  def onStart
  	$window.setBackground("bground.jpg")
  	@goToEdition = nil
  	@map = $window.map
  	puts @map.tilesheet
    puts "Save menu activated!"
    $textbox = GGLib::TextBox.new("textbox", 130, 50, 12, GGLib::Themes::BlueSteel)
    GGLib::Button.new(:savebutton, "SAVE", 50, 50,
    				 Proc.new { |widget|
    				   @map.save_file($textbox.text)
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
    puts "Save menu terminated"
  end
end
