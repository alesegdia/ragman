module GGLib


class Containable < Tile
  class Padding
    attr_reader :left, :right, :top, :bottom
    attr_accessor :container
    def initialize(t, r, b, l, contain=nil)
      @top, @right, @bottom, @left = t, r, b, l
      @container=contain
    end
    def left=(val)
      @left=val
      @container.align unless @container.nil?
    end
    def right=(val)
      @right=val
      @container.align unless @container.nil?
    end
    def top=(val)
      @top=val
      @container.align unless @container.nil?
    end
    def bottom=(val)
      @bottom=val
      @container.align unless @container.nil?
    end
  end

  class Dimension
    Infinite = -1
    attr_reader :vertical, :horizontal
    attr_accessor :container
    def initialize(h, v)
      @horizontal, @vertical = h, v
    end
    def vertical=(val)
      @vertical=val
      @container.align unless @container.nil?
    end
    def horizontal=(val)
      @horizontal=val
      @container.align unless @container.nil?
    end
  end

  module Align
    Default = -1
    Left = 0
    Center = 1
    Right = 2
  end

  module VAlign
    Default = -1
    Top = 0
    Center = 1
    Bottom = 2
  end

  attr_reader :padding, :offset, :minSize, :maxSize, :align, :valign
  attr_reader :container
  
  def initialize(x1, y1, x2, y2, container=nil)
    super(x1, y1, x2, y2)
    @padding = Padding.new(0,0,0,0)
    @offset = Dimension.new(0,0)
    @maxSize = Dimension.new(Dimension::Infinite,Dimension::Infinite)
    @minSize = Dimension.new(0,0)
    @align = Align::Default
    @valign = VAlign::Default
    @container = container
  end
  def padding=(val)
    @padding=val
    @padding.container = @container
    @container.align unless @container.nil?
  end
  def offset=(val)
    @offset=val
    @offset.container = @container
    @container.align unless @container.nil?
  end
  def minSize=(val)
    @minSize=val
    @minSize.container = @container
    @container.align unless @container.nil?
  end
  def maxSize=(val)
    @maxSize=val
    @maxSize.container = @container
    @container.align unless @container.nil?
  end
  def align=(val)
    @align=val
    @align.container = @container
    @container.align unless @container.nil?
  end
  def valign=(val)
    @valign=val
    @valign.container = @container
    @container.align unless @container.nil?
  end
end

#The Widget class is an interface between the button class and the window class which allows for user interaction with an area of the screen. This area is referred to as the widget.
#To make a Widget, simply create a class derived from Widget and override methods as needed:
#
# class MyWidget < Widget      #all widgets are subclasses of Widget
#   attr_reader :text,:font    #most widgets will have text and font attributes
#   def initialize(window,text)
#     super(window,Button::Image,0,400,640,480,"img/gui/mywidget image.png",name="My Widget")       #use super to initialize the button
#     @text=text; @font=Gosu::Font.new(window, "arial", 50)          #initialize widget specific variables
#   end
#   def draw                        #the window will call draw every time it executes GameWindow::draw
#     font.draw(text,0,0)           #you do not have to draw the image here, Button class does that for you
#     if clicked?                   #here you do widget specific things like drawing text,
#       setImage(Gosu::Image.new)   #changing the picture on mouse over or click, etc
#     end                                     
#   end
#   def onDelete        #onDelete is called when the window wants to delete the widget
#     puts "deleted"    #execute widget specific code here
#   end                 #or leave the function alone if there is no widget specific code
# end
#
#See the `Widget Programmer's Handbook` for more info.

class Widget < Containable
  
  module Event
    MsLeft=0
    MsRight=1
    KeyUp=2
    KeyDown=3
    MsLeftDrag=16
    MsRightDrag=17
  end
  
  attr_reader :window, :name, :sleeping, :defimage, :buttonId, :id, :zfocus
  attr_accessor :theme
  def initialize(name="unnamed",x1=0,y1=0,x2=1,y2=1,theme=Themes::blank,z=0) #do not modify
    super(x1,y1,x2,y2)
    @id=$window.newWidget(self)
    @theme=theme.newInstance(self)
    @name=name
    @sleeping=false
    @zfocus=z
    onInitialize
  end
  def hasFocus? #do not modify
    if $window.hasFocus == self
      return true 
    else
      return false
    end
  end
  def hasStickyFocus? #do not modify
    if $window.hasStickyFocus == self
      return true 
    else
      return false
    end
  end
  def focus #do not modify
    #debugger
    $window.setFocus(@id) 
    onMouseOver #focus is triggered by the onMouseOver event, so when the window gives a widget focus, it must preform the mouseover event 
  end  
  def blur #do not modify
    onMouseOut #blur is triggered by the onMouseOut event, so when the window blurs a widget, it must preform the mouseout event
  end
  
  def over?(x,y)
    return iTile(x,y)      
  end
  def clicked?(x,y)
    if $window.button_down?(Gosu::Button::MsLeft)
      return xTile(x,y)
    else
      return false
    end
  end
    
  def event(type, dat=nil) #do not modify
    if type==Event::MsLeft
      if acceptStickyFocus?
        stickFocus
      end
      onClick
    elsif type==Event::MsRight
      onRightClick
    elsif type==Event::KeyUp
      onKeyUp(dat)
    elsif type==Event::KeyDown
      onKeyDown(dat)
    end
  end

  def downevent(type)
    if type==Widget::Event::MsLeft
      onMouseDown
    elsif type==Widget::Event::MsRight
      onRightMouseDown
    end
  end
  
  def feedText(char)
  end
  def acceptText?
    return false
  end
  
  def acceptStickyFocus?
    return false
  end
  
  def onMouseDown
  end
  def onRightMouseDown
  end
  def onClick
  end
  def onRightClick
  end
  def onDrag(x1, y1, x2, y2)
  end
  def onRightDrag(x1, y1, x2, y2)
  end
  def onMouseOver
  end
  def onStickyFocus
  end
  def onMouseOut 
  end
  def onStickyBlur
  end
  def onInitialize
  end
  def onDelete
  end
  def onKeyUp(key)
  end
  def onKeyDown(key)
  end
  
  def stickFocus
    if acceptStickyFocus?
      $window.setStickyFocus(self)
    end
  end
  def unstickFocus
    if hasStickyFocus?
      $window.setStickyFocus(nil)
    end
  end
  
  def intDraw
    if not @sleeping
      @theme.draw
      draw
    end
  end
  
  def draw
  end
  
  def sleep
    if not @sleeping
      if hasStickyFocus?
        $window.setStickyFocus(nil)
      end
      @theme.setSleepState
      @sleeping=true
    end
  end
  def sleeping?
    return @sleeping
  end
  def wakeUp
    if @sleeping
      @theme.setWakeState
      @sleeping=false
    end
  end
  
  def button
    return Button.getButton(buttonId)
  end
  
  def del
    onDelete
    if $window.nil?
      raise "Window assigned to nil" #Very strange bug. Should be dead by now. (This is just in case.)
      return
    end
    $window.deleteWidget(self)
    super
  end
end

WidgetTextCaps = {
 ","=>"<",
 "."=>">",
 "/"=>"?",
 "'"=>"\"",
 ";"=>":",
 "["=>"{",
 "]"=>"}",
 "\\"=>"|",
 "="=>"+",
 "-"=>"_",
 "0"=>")",
 "9"=>"(",
 "8"=>"*",
 "7"=>"&",
 "6"=>"^",
 "5"=>"%",
 "4"=>"$",
 "3"=>"#",
 "2"=>"@",
 "1"=>"!",
 "`"=>"~"
}

end #module GGLib