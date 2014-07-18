begin
  require 'rubygems'
rescue LoadError
end

require "gosu"
require "../gglib"
require "../ext/widgets"
require "../ext/themes"

class TracePanelDemoWindow < GGLib::GUIWindow
  def initialize
    super(640, 480, false, 20)
    self.caption = "GGLib Trace Panel Demo"
    self.state = TracePanelDemoState.new
  end
end

class TracePanelDemoState < GGLib::StateObject
  def onStart
    $window.setBackground("img/bg.png")
    $trace = GGLib::TracePanel.new
    GGLib::Button.new(:button1, "Open Trace", 270, 200, Proc.new{ |widget| $trace.wakeUp }, GGLib::Themes::BlueSteel)
    GGLib::Button.new(:button2, "put", 270, 280, Proc.new{ |widget| $trace.put "trace data" }, GGLib::Themes::BlueSteel)
    GGLib::Button.new(:button2, "sput", 270, 315, Proc.new{ |widget| $trace.sput "silent trace data" }, GGLib::Themes::BlueSteel)
  end
end

TracePanelDemoWindow.new.show