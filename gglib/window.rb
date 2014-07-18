module GGLib

#The GUIWindow class is the central hub of the program. It is utimately responsible for all input and output (exept for logging output). 
#The main game loops can be found in this class.
class GUIWindow < Gosu::Window
  attr_accessor :cursor, :background_image, :camera, :state
  attr_reader :images, :mapimages
  
  BlankState = StateObject.new
  
  def initialize(w=640, h=480, fullscreen=true, u=20, stateObj=BlankState)
    super(w, h, fullscreen, u)
    $window=self #pre initialize global var to allow win initialization
    @background_image = Gosu::Image.new(self, File.expand_path(File.dirname(__FILE__))+"/null.png", true)
    @cursor = Cursor.new(File.expand_path(File.dirname(__FILE__))+"/media/cursor.bmp", false)
    @framedrawn=false
    @timer=0
    @camera=Camera.new
    @images = CArray.new
    @mapimages = CArray.new
    @guiWidgets = CArray.new
    @state=stateObj
    @focused=nil
    @stickfocused=nil
    @leftdrag = MouseDragEvent.new
    @rightdrag = MouseDragEvent.new
    @state.start
    $window=self
    $theme_init_hook.call
  end
  
  def state=(val)
    @state.end
    @state = val
    @state.start
  end
  
  def widgets
    return @widgets
  end
  
  def framedrawn
    return @framedrawn
  end
  
  def button_down(id)
    @state.button_down(id)
    checkFocus
    widgetDownProc(id)
  end
  
  def button_up(id)
    @state.button_up(id)
    checkFocus                       
    widgetUpProc(id)
  end
  
  def timer
    return @timer
  end
  
  def widgets
    return @guiWidgets
  end
   
  def newImage(x,y,z,src,hardBorders=true,tracer="None")
    img=Image.new(x,y,z,src,hardBorders,tracer,@images.size)
    return @images << img
  end
  
  def newTexture(x1,y1,x2,y2,z,src,hardBorders=true,tracer="None")
    img=Texture.new(x1,y1,x2,y2,z,src,hardBorders,tracer,@images.size)
    return @images << img
  end
  
  def setImage(index,x,y,z,src,hardBorders=true,tracer="None")
    img=Image.new(x,y,z,src,@images.size,hardBorders,tracer)
    @images[index]=img
    return index
  end
  
  def setTexture(index, x1,y1,x2,y2,z,src,hardBorders=true,tracer="None")
    img=Texture.new(x1,y1,x2,y2,z,src,hardBorders,tracer,@images.size)
    @images[index]=img
    return index
  end
  
  def deleteImage(no)
    if @images[no]!=nil
      @images[no].del
    end
      @images.delete_at(no)
  end
  
  def deleteAllImages
    @images.clear
  end
  
  def setBackground(src)
    @background_image = Gosu::Image.new(self,src,true)    
  end
  
  def setMapBackground(src)
    @map_image = Gosu::Image.new(self,src,true)    
  end
  
  def newMapImage(x,y,z,src,hardBorders=true,tracer="None")
    img=Image.new(x,y,z,src,hardBorders,tracer,@mapimages.size)
    return @mapimages << img
  end
  
  def deleteMapImage(no)
    if @mapimages[no]!=nil
      @mapimages[no].del
    end
      @mapimages.delete_at(no)
  end
  
  def deleteAllMapImages
    @mapimages.clear
  end  
  
  def newWidget(widget)
    return @guiWidgets << widget
  end
  
  def deleteWidget(widget)
    id=widget.id
    @guiWidgets.delete_at(id)
  end
  
  def deleteAllWidgets
    @guiWidgets.each {|widget| widget.del}
    @guiWidgets.clear
    @focused=nil
    @stickfocused=nil
    self.text_input=nil
  end
  
  def createWidgets
    self.text_input=nil
    @focused=nil
    @stickfocused=nil
  end
  
  def setTextInput(field)
    self.text_input=field
  end
  
  def setFocus(object)
    if @focused!=nil and not @focused.sleeping? #dont blur the object if it is the window or if it is sleeping
      @focused.blur
    end
    if object==nil
      @focused=nil
    else
      @focused=@guiWidgets[object]
    end
  end
  
  def setStickyFocus(object)
    if @stickfocused!=nil
      @stickfocused.onStickyBlur
    end
    @stickfocused=object
    if @stickfocused!=nil
      @stickfocused.onStickyFocus
    end
  end
  
  def hasFocus
    return @focused
  end
  
  def hasStickyFocus
    return @stickfocused
  end
  
  def update
    checkFocus
    
    if @leftdrag.starting
      if(Gosu::distance(@leftdrag.start_x, @leftdrag.start_y, mouse_x, mouse_y) > 5)
        @leftdrag.confirmStart
      end
    elsif @rightdrag.starting
      if(Gosu::distance(@rightdrag.start_x, @rightdrag.start_y, mouse_x, mouse_y) > 5)
        @rightdrag.confirmStart
      end
    end
    
    if @timer>100
      @timer=0
    else
      @timer+=1
    end
    
    @state.update
    @framedrawn = false
  end

  def draw
    @cursor.draw
    @images.each {|img| img.draw}
    @guiWidgets.each {|widget| widget.intDraw}
    @background_image.draw(0, 0, ZOrder::Background)
    @state.draw
    @framedrawn=true
  end
  
  private
  def widgetDownProc(id)
    char=button_id_to_char(id)
    setStickyFocus(nil) if (id==Gosu::Button::MsLeft or id==Gosu::Button::MsRight) and @stickfocused!=nil #and not @stickfocused.contains?(mouse_x, mouse_y)
    if @stickfocused!=nil and not @stickfocused.sleeping? #only sticky focused widgets recieve text input 
      if id==Gosu::Button::MsLeft
        @leftdrag.start
        @focused.event
      elsif id==Gosu::Button::MsRight
        @rightdrag.start
        @focused.event
      elsif char!=nil and @stickfocused.acceptText?
        if button_down?(Gosu::Button::KbLeftShift) or button_down?(Gosu::Button::KbRightShift)
          if char=~/[A-Z]/i
            char=char.upcase!
          else
            capschar=WidgetTextCaps[char]
            if capschar!=nil
              char=capschar
            end
          end
        end
        @stickfocused.feedText(char)
      else 
        @stickfocused.event(Widget::Event::KeyDown, id)
      end
    end
    if @focused!=nil and not @focused.sleeping? and (@stickfocused==nil or @focused.id != @stickfocused.id) #normally focused widgets only recieve click input 
      if id==Gosu::Button::MsLeft
        @focused.downevent(Widget::Event::MsLeft)
      elsif id==Gosu::Button::MsRight
        @focused.downevent(Widget::Event::MsRight)
      end
    end
  end
  
  def widgetUpProc(id)
    char=button_id_to_char(id)
    setStickyFocus(nil) if (id==Gosu::Button::MsLeft or id==Gosu::Button::MsRight) and @stickfocused!=nil #and not @stickfocused.contains?(mouse_x, mouse_y)
    if @stickfocused!=nil and not @stickfocused.sleeping? #only sticky focused widgets recieve text input 
      if id==Gosu::Button::MsLeft
        if @leftdrag.inprogress
          @leftdrag.end
          @stickfocused.event(Widget::Event::MsLeftDrag)          
        else
          @leftdrag.terminate
          @stickfocused.event(Widget::Event::MsLeft)
        end
      elsif id==Gosu::Button::MsRight
        if @rightdrag.inprogress
          @rightdrag.end
          @stickfocused.event(Widget::Event::MsRightDrag)                  
        else
          @rightdrag.terminate
          @stickfocused.event(Widget::Event::MsRight)
        end
      else
        @stickfocused.event(Widget::Event::KeyUp, id)
      end
    end
    if @focused!=nil and not @focused.sleeping? and (@stickfocused==nil or @focused.id != @stickfocused.id) #normally focused widgets only recieve click input 
      if id==Gosu::Button::MsLeft
        @focused.event(Widget::Event::MsLeft)
      elsif id==Gosu::Button::MsRight
        @focused.event(Widget::Event::MsRight)
      elsif id==Gosu::Button::GpButton0
        @focused.event(Widget::Event::GpEnter)
      end
    end
  end
 
  def checkFocus
    if @focused==nil
      oldfocus=nil
    else
      oldfocus=@focused.id      
    end
    newfocus=nil
    focusFlag=false
    @guiWidgets.each { |widget|
      if (@cursor.visible and widget.over?(mouse_x,mouse_y)) and not widget.sleeping?
        if not focusFlag
          newfocus=widget.id
          focusFlag=true
        elsif widget.zfocus >= @guiWidgets[newfocus].zfocus #give focus to the widget with the highest focus zorder, or in the event of a tie, give focus to the new object
          newfocus=widget.id
        end
      else
      end
    }
    if newfocus!=nil and newfocus!=oldfocus
      @guiWidgets[newfocus].focus
    elsif newfocus==nil and oldfocus!=nil
      setFocus(nil)
    end
  end
end

end #module GGLib
