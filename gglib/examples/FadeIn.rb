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
#And themes to make them look cool
require "../ext/themes"

class FadeExample < GGLib::GUIWindow
  def initialize
    super(640, 480, false, 20)
    self.caption = "GGLib Tutorial"
    self.state = StartMenu.new
  end
end

#The menu we will fade from
class StartMenu < GGLib::StateObject
  def onStart
    ##$window.setBackground("img/splash.png")
    GGLib::Button.new(:fade, "Fade", 270, 200, Proc.new{ |widget| $window.state = GGLib::FadeScreen.new(EndMenu.new, 2) }, GGLib::Themes::BlueSteel)
  end
end

#The menu we will fade to
class  EndMenu < GGLib::StateObject
  def onStart
    $window.setBackground("img/bg.png")
    GGLib::Button.new(:fade_back, "Fade Back", 270, 200, Proc.new{ |widget| $window.state = GGLib::FadeScreen.new(StartMenu.new, 2) }, GGLib::Themes::BlueSteel)
  end
end

#Launch the window
FadeExample.new.show
