module GGLib

class Theme
  attr_reader :name
  def setDefaultState
  end
  def setOverState
  end
  def setDownState
  end
  #Returns an estimated width for the Theme. (May not be equal to the actual width.)
  def width
  end
  #Returns an estimated height for the Theme. (May not be equal to the actual height.)
  def height
  end
  def request(obj)
    return self
  end
end

class ImageTheme < Theme
  attr_reader :image, :font, :width, :height
  def initialize(name, font, image)
    @name = name
    @image = image
    @width = Gosu::Image.new($window, @image.default).width
    @height = Gosu::Image.new($window, @image.default).height
    @font = font
  end
  def newInstance(obj)
    return ImageThemeInstance.new(self, obj)
  end
end

class DrawnTheme < Theme
  attr_reader :font
  def initialize(name, font)
    @name = name
    @font = font
  end
  def newInstance(obj)
    return DrawnThemeInstance.new(self, obj)
  end
  def width
    return 200
  end
  def height
    return 50
  end
  def draw(x1, y1, x2, y2, state)
  end  
end

class ThemeInstance
  def initialize(klass, wid)
    @klass = klass
    @state = 1
    @widget = wid
    @x1 = @widget.x1
    @y1 = @widget.y1
    @x2 = @widget.x2
    @y2 = @widget.y2
    @klass = @klass.request(@widget)
  end
  def setCoords(x1,y1,x2,y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2    
  end
  def setDefaultState
    @state = 1
  end
  def setOverState
    @state = 2
  end
  def setDownState
    @state = 3
  end
  def setSleepState
  end
  def setWakeState
    @state = 1
  end
  def font
    return @klass.font
  end
  def name
    return @klass.name
  end
  def width
    return @klass.width
  end
  def height
    return @klass.height
  end
  def draw
  end
end

class ImageThemeInstance < ThemeInstance
  def initialize(klass, wid)
    super(klass, wid)
    @image = $window.newTexture(@x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.default)
  end
  def setCoords(x1,y1,x2,y2)
    super(x1,y1,x2,y2)
    return if @image == -1
    if @state == 1
      $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.default)
    elsif @state == 2
      $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.over)
    elsif @state == 3
      $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.down)
    end
  end
  def setDefaultState
    super
    $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.default)
  end
  def setOverState
    super
    $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.over)
  end
  def setDownState
    super
    $window.setTexture(@image, @x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.down)
  end
  def setSleepState
    super
    @image = -1
    $window.deleteImage(@image)
  end
  def setWakeState
    super
    @image = $window.newTexture(@x1, @y1, @x2, @y2, ZOrder::Widget, @klass.image.default)
  end
  def image
    return @klass.image
  end
end

class DrawnThemeInstance < ThemeInstance
  def draw
    @klass.draw(@x1, @y1, @x2, @y2, @state)
  end
end

class ThemeFontGroup
  attr_accessor :default, :header, :editable, :color, :selcolor
  def initialize(default, header, editable, color=0xff000000, selcolor=0xff33FFFF)
    @default = default
    @header = header
    @editable = editable
    @color = color
    @selcolor = selcolor
  end
end

class ThemeImageGroup
  attr_accessor :default, :over, :down
  def initialize(default, over, down)
    @default = default
    @over = over
    @down = down
  end  
end

module Themes
  public
  def Themes.blank
    ImageTheme.new(
      "BlankTheme",
      ThemeFontGroup.new(
        Gosu::Font.new($window, Gosu::default_font_name, 17),
        Gosu::Font.new($window, Gosu::default_font_name, 25),
        Gosu::Font.new($window, Gosu::default_font_name, 20)
      ),
      ThemeImageGroup.new(
        $gglroot+"/null.png",
        $gglroot+"/null.png",
        $gglroot+"/null.png"
      )
    )
  end
  
  def Themes.tracePanel 
    ImageTheme.new(
      "TraceTheme",
      ThemeFontGroup.new(
        Gosu::Font.new($window, Gosu::default_font_name, 17),
        Gosu::Font.new($window, Gosu::default_font_name, 25),
        Gosu::Font.new($window, Gosu::default_font_name, 20)
      ),
      ThemeImageGroup.new(
        $gglroot+"/media/trace.png",
        $gglroot+"/null.png",
        $gglroot+"/null.png"
      )
    )
  end
end

end #module GGLib