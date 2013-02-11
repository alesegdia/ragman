require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets'
require '../gglib/ext/themes'
require '../Map.rb'
require 'Grid.rb'

class SaveMenu < GGLib::StateObject
  def initialize
    super
  end

  def onStart
    puts "Save menu activated!"
  end

  def onEnd
    puts "Save menu terminated"
  end
end
