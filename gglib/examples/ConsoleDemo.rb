begin
  require 'rubygems'
rescue LoadError
end

require "gosu"
require "../gglib"
require "../ext/widgets"
require "../ext/themes"

class ConsoleDemoWindow < GGLib::GUIWindow
  def initialize
    super(640, 480, false, 20)
    self.caption = "GGLib Console Demo"
    self.state = ConsoleDemoState.new
  end
end

class ConsoleDemoState < GGLib::StateObject
  def onStart
    $window.setBackground("img/bg.png")
    GGLib::Button.new(:button1, "Open Console", 270, 200, Proc.new{ |widget| GGLib::DebugConsole.new; GGLib::Label.new(:label1, "Enter /help for help.", 250, 300, GGLib::Themes::Shade) }, GGLib::Themes::BlueSteel)
  end
end

ConsoleDemoWindow.new.show