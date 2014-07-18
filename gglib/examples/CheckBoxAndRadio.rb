begin
  # In case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # In case you don't.
end

#Load Gosu
require "gosu"
#Load GGLib
require "../gglib"
#Load extra widgets
require "../ext/widgets"
#Load extra themes
require "../ext/themes"

#Now for our state object:
class MyGUIWindow < GGLib::GUIWindow
  def initialize
    super(640, 480, false, 20)
    self.caption = "GGLib Tutorial"
    self.state = MyStateObj.new
  end
end

#Now for our state object:
class MyStateObj < GGLib::StateObject
  def onStart
    $window.setBackground("img/bgblue.png")
    #A CheckBox:
    GGLib::CheckBox.new(
      :checkbox1, #Widget name
      200, #X position
      200, #Y position
      "Check this!", #label
      false, #Set the CheckBox to be unchecked on creation
      GGLib::Themes::BlueSteel #Use the BlueSteel theme
    )
    #A RadioGroup
    GGLib::RadioGroup.new(
      :radio1, #Widget name
      200, #X position
      225, #Y position
      { "One" => 1, "Two" => 2, "Three" => 3}, #Each key in the hash is the option name and each value is the option value
      GGLib::RadioGroup::Layout::Vertical, #Align the tadio buttons verticaly. The other option is Layout::Horizontal
      GGLib::RadioGroup::Spacing::Automatic, #Set the spacing between radio buttons to be automatically sized. (You can supply your own spacing by passing an integer here.)
      GGLib::Themes::BlueSteel #Use the BlueSteel theme
    )

  end
end

#Create and launch the window.
MyGUIWindow.new.show
