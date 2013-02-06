module GGLib

#A StaticScreen is a menu. It suspends the game and redirects all input to itself.
#StaticScreen is typically used through derivation, although it can be used otherwise.
#StaticScreen#start suspends the game and starts the menu. StaticScreen#end returns to the game.

class StateObject
  #Begin rerouting input to the static screen. DO NOT OVERRIDE THIS METHOD.
  def start 
    $window.deleteAllImages
    $window.cursor.forceVisible
    onStart
  end
  #Return control to the GameWindow. DO NOT OVERRIDE THIS METHOD.
  def end
    onEnd
    $window.deleteAllWidgets
    $window.createWidgets
    $window.deleteAllImages
    $window.cursor.unforceVisible
    onTerminate
  end
  #Equivalent to Gosu::Window#button_down
  def button_down(id)
    #do nothing by default
  end
  #Equivalent to Gosu::Window#button_down
  def button_up(id)
    #do nothing by default
  end
  #Equivalent to Gosu::Window#update
  def update
  end
  #Returns a reference to the window to which the static screen is associated.
  def window
    return $window
  end
  #This method is called when the static screen is initialized. It is ment to be overridden in derived classes.
  #This is a good place to preform tasks such as creating widgets.
  def onStart
  end
  #This method is called when the static screen is uninitialized. It is ment to be overridden in derived classes.
  #This is a good place to preform tasks such as stopping audio. Widgets are automatically destroyed on exit by the base class StaticScreen
  def onEnd
  end
  def onTerminate
  end
  #Equivalent to Gosu::Window#draw
  def draw
  end
end

class  MenuBase < StateObject
  def button_down(id)
    #if id == Gosu::Button::KbEscape
    #  close
    if id == Gosu::Button::MsLeft
      mouse($window.mouse_x,$window.mouse_y)
    end
  end
  def mouse(x,y)
    #does nothing by default
  end
end

class FadeScreen < StateObject
  public
  attr_reader :widgetID
  def initialize(fadeTo=nil, speed=1)
    $faded=false
    @image=Gosu::Image.new($window, $gglroot+"/media/black.bmp", true)
    @fading=false
    @speed=speed
    @fadeTo=fadeTo
    @color=Gosu::Color.new(0xffffffff)
  end
  def fading?
    return @fading
  end
  def onStart
    @fading=true
    @alpha=0
  end
  def draw
    if @fading
      @alpha+=@speed
      if @alpha > 255
        @alpha=255
      end
      @color.alpha=@alpha
      @image.draw(0, 0, ZOrder::Top+1, 640, 480, @color)
      if @alpha == 255
        endFade
        @widgetID = FadeIn.new(@speed)
      end
    end
  end
  def endFade
    @fading=false
    @image=nil
    self.end
    @fadeTo.start if @fadeTo!=nil
  end
  
  class FadeIn < Widget
    def initialize(speed=5)
      @image=Gosu::Image.new($window, $gglroot+"/media/black.bmp", true)
      @speed=speed
      @color=Gosu::Color.new(0x00ffffff)
      @alpha=255
      super(:FadeIn, 0, 0, 0, 0)
      wakeUp
      stickFocus
      $window.setFocus(nil)
    end
    def draw
      @alpha-=@speed
      if @alpha < 0
        @alpha=0
      end
      @color.alpha=@alpha
      @image.draw(0, 0, ZOrder::Top+1, 640, 480, @color)
      if @alpha == 0
        endFade
      end
    end
    def endFade
      unstickFocus
      $window.setFocus(nil)
      del
      $faded=true
    end
  end
  
end

end #module GGLib