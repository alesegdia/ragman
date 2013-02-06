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
#Load some extra widgets for us to play with
require "../ext/widgets"
#And themes to make them look cool
require "../ext/themes"

class MyGUIWindow < GGLib::GUIWindow
  def initialize
    super(640, 480, false, 20)
    self.caption = "GGLib Tutorial"
    #Rather than override methods such as update, button_down,
    #and draw, as we would with plain Gosu code, we will override
    #these methods in state objects. This allows the user to switch
    #between various game states, such as between menus and the
    #actual game, without having to litter their functions with
    #switch statements or if-else statements.
    self.state = MyStateObj.new
  end
end

#Now for our state object:
class MyStateObj < GGLib::StateObject
  #We can override the constructor as normal, but be careful not
  #to mess around with the window here! The window does not belong
  #to this state object yet: another state object is using it.
  def initialize
    super
    @myvar = 42
  end
  #This method is called right after our state object gains ownership
  #over the window. Now we can perform operations that modify the
  #window.
  def onStart
    puts "MyStateObj activated."
    #Since Gosu only allows one window instance at a time, the current
    #window is automatically sotred in the global $window.
    $window.setBackground("img/bgblue.png")
    #Whats a GUI Library without widgets?
    #A textbox:
    $textbox = GGLib::TextBox.new("textbox1", 220, 100, 12, GGLib::Themes::BlueSteel)
    #Some buttons:
    GGLib::Button.new(:button1, "Click Me", 270, 50, Proc.new{ |widget| $textbox.text = "Thank you" }, GGLib::Themes::BlueSteel)
    GGLib::Button.new(:button2, "Exit", 270, 200, Proc.new{ |widget| $window.close; exit }, GGLib::Themes::BlueSteel)
  end
  #This method is called right after our state object looses
  #ownership of the window. The window is automatically reset, but
  #if you modified anything other than the window, this is where you
  #should clean it up.
  def onEnd
    puts "MyStateObj terminated."
  end
end

#Create and launch the window.
MyGUIWindow.new.show

#To see how easy it is to customize your GUI with themeing, try 
#replacing all of the instances of GGLib::Themes::BlueSteel in
#this file to GGLib::Themes::Rubygoo for a Rubygoo like theme,
#GGLib::Themes::Shade for a dark theme, and GGLib::Themes::Windows
#for a Windows Vista like theme.