require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets'
require '../gglib/ext/themes'
require '../Map.rb'
require 'Grid.rb'

class LoadMenu < GGLib::StateObject
  def initialize
    super
  end

  def onStart
    puts "Load menu activated!"
  end

  def onEnd
    puts "Load menu terminated"
  end
end
