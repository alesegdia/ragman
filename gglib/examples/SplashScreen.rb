begin
  # In case you use Gosu via RubyGems.
  require 'rubygems'
rescue LoadError
  # In case you don't.
end

require "gosu"
require "../gglib"
require "../ext/splash"

class MySplashScreen < GGLib::SplashScreen
  def initialize
    super(640, 480, "img/splash.png")
  end
  def load
    #Put initialization code here.
    #This example doesn't actually have to initialize anything,
    #so we will just use Thread#sleep to kill some time.
    sleep(1) 
  end
  def createWindow
    #Once the load method is finished, create window is called.
    #This is where we should initialize and lauch our window.
    #We'll just resuse the routines from BasicExample.rb.
    require "BasicExample"
  end
end

MySplashScreen.new.show