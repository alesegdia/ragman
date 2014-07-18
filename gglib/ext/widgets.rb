module GGLib

class DebugConsole < Widget
  def initialize(name=:unnamed, theme=Themes::blank)
    super(name, 0, 0, 640, 480, theme)
    @vline=0
    @oldtext=[]
    @textm=false
    clear
    stickFocus
    begin
      @theme.font.default = Gosu::Font.new($window, "Courier New", @theme.font.default.height)
    rescue
    end
  end  
  def acceptText?
    return true
  end
  def acceptStickyFocus?
    return true
  end
  def onKeyUp(key)
    if key==Gosu::Button::KbDelete or key==Gosu::Button::KbBackspace
      thisline=@text[@line]
      if @textm and thisline.length>0
        @text[@line]=thisline.slice(0,thisline.length-1)
      elsif thisline.length>3
        @text[@line]=thisline.slice(0,thisline.length-1)
      end
    elsif key==Gosu::Button::KbEscape or $window.button_id_to_char(key) == '`'
      sleep
    elsif key==Gosu::Button::KbReturn or key==Gosu::Button::KbEnter
      if @textm
        if @text[@line]=="/endtext"
          @textm=false
          @line+=1
          @text[@line]=">> "
        else
          @line+=1
          @text[@line]=""
        end
        return
      end
      @oldtext.push @text[@line]
      cmd=@text[@line].slice(3,@text[@line].length-3)
      if cmd.slice(cmd.size-3,3)=="/nl"
        @text[@line]=@text[@line].slice(0,@text[@line].length-3)
        @text[@line+1]="|> "
        @line+=1
      else
        runcmd(cmd)
      end
      @vline=@oldtext.size
    elsif key==Gosu::Button::KbUp
      if @vline-1 >= 0 and 
        @vline-=1
        @text[@line]=@oldtext[@vline]
      end
    elsif key==Gosu::Button::KbDown
      if @vline+1 < @oldtext.size and 
        @vline+=1
        @text[@line]=@oldtext[@vline]
      end
    end
  end
  def feedText(char)
    @text[@line]+=char.to_s unless (char=="`" || char=="\n" || char=="\r")
  end
  def justify(ln)
    fin=""
    size=ln.size
    while ln.size>70
      fin+=ln.slice(0,70)+"\fNL"
      ln=ln.slice(70,ln.size)
    end
    fin+=ln.to_s
    return fin
  end
  def respond(text)
    text=text.to_s
    @line+=1
    if text==""
      text="<no output>"
    end
    text=justify(text) if text.index("\fNL")==nil
    text=text.split("\fNL")
    mult=false
    text.each { |ln|
      if ln.slice(0,4)=="\fERR"
        @text[@line]="!> "+ln.strip
      else
        @text[@line]="^> "+ln
      end
      @line+=1
      @text[@line]=">> "
    }
  end
  def clear
    @text=[]
    @text[0]="-~*CONSOLE*~-"
    @text[1]="<Press ` (backquote) or enter '/exit' to exit>"
    @text[2]=">> "
    @line=2    
    @vline=@oldtext.size-1
  end
  private
  def runcmd(cmd)
    if cmd.slice(0,1)=="/"
      if cmd=="/exit"
        sleep
        return
      elsif cmd=="/clear"
        clear
        return
      elsif cmd=="/help"
        respond("Enter a Ruby command to execute it\fNLEnter '/' followed by a word to execute a console command\fNLFor a list of console commands, enter '/list'")
        return
      elsif cmd=="/list"
        respond("/clear\fNL/clearhist\fNL/endtext\fNL/exit\fNL/help\fNL/hist\fNL/list\fNL/text")
        return
      elsif cmd=="/hist"
        resp=""
        @oldtext.each { |item|
          resp+="\fNL"
          resp+=item
        }
        respond(resp)
        return
      elsif cmd=="/text"
        @textm=true
        @line+=1
        @text[@line]=""
        return
      elsif cmd=="/clearhist"
        @oldtext=[]
        @vline=0
        return
      end
      return
    end
    output=eval("begin\n"+cmd+"\nrescue\n'\fERR: '+$@[0]+': '+$!\nend",TOPLEVEL_BINDING)
    respond(output)
  end
  public
  def sleep
    @text=[]
    @line=0
    @vline=0
    super
  end
  def wakeUp
    @oldtext=[]
    @vline=0
    @text=false
    clear
    stickFocus
    super
  end
  def onStickyFocus
    $window.setTextInput(@textinput)
  end
  def onStickyBlur
    $window.setTextInput(nil)
  end
  def draw
    i=0
    @text.each {|line|
      @theme.font.default.draw(line, 10, 10+i*@theme.font.default.height, ZOrder::Text, 1.0, 1.0, 0xffffffff)
      i+=1
    }
  end
end

class TracePanel < Widget
  def initialize(name=:unnamed)
    super(name, 0,0,640,60, Themes::tracePanel)
    clear
    begin
      @theme.font.default = Gosu::Font.new($window, "Courier New", @theme.font.default.height)
    rescue
    end
  end
  def acceptStickyFocus?
    return true
  end
  def onKeyUp(key)
    if key==Gosu::Button::KbDelete
      theme = Themes::blank
      sleep
    elsif key==Gosu::Button::KbReturn or key==Gosu::Button::KbEnter
      clear
    end
  end
  def wakeUp
    super
    theme = Themes::tracePanel
  end
  def sput(text)
    @line+=1
    @text[@line]=text.to_s    
  end
  def put(text)
    @line+=1
    @text[@line]=text.to_s
    wakeUp
  end
  def <<(text)
    sput(text)
  end
  def *(nullarg=nil)
    wakeUp
  end
  def ~()
    sleep
  end
  def pause
    gets
  end
  def clear
    @text=[]
    @text[0]="TRACE OUTPUT"
    @text[1]="Press DELETE to close, ENTER to clear. (Click to activate.)"
    @line=2
  end
  def draw
    i=0
    @text.each {|line|
      @theme.font.default.draw(line, 10, 10+i*@theme.font.default.height, ZOrder::Text, 1.0, 1.0, 0xffffffff)
      i+=1
    }
  end
end

class TextBox < Widget
  CaretColor=0xff646464
  TextColor=0xff646464
  SelColor=0xff33FFFF
  TextPadding=5
  def initialize(name, x, y, len=12, theme=Themes::blank, w=nil,height=nil)
    if width!=nil and height!=nil
      super(name, x, y, x+w, y+h, theme)
    else
      @theme = theme.newInstance(self) #Get specialized instance early
      @theme.setCoords(1,1,1,1) 
      super(name, x, y, x+@theme.width, y+@theme.height, theme)
      @theme.setCoords(@x1, @y1, @x2, @y2)
    end
    @textinput=Gosu::TextInput.new
    @offsety=((@theme.height-@theme.font.editable.height)/2).floor
    @maxlength=len
    @x=x
    @y=y
    @drawcursor=0
    @realwidth=@x + TextPadding
  end
  def acceptStickyFocus?
    return true
  end
  def onMouseOver
    @theme.setOverState unless self.hasStickyFocus?
  end
  def onMouseOut
    @theme.setDefaultState unless self.hasStickyFocus?
  end
  def onMouseClick
    stickFocus
  end
  def onStickyFocus
    @theme.setOverState
    $window.setTextInput(@textinput)
  end
  def onStickyBlur
    @theme.setDefaultState
    $window.setTextInput(nil)
  end
  def width
    return @maxlength
  end
  def text
    return @textinput.text
  end
  def text=(val)
    val=val.slice(0,12) if val.size>12
    @textinput.text = val
  end
  def draw
    text=@textinput.text.slice(0,12)
    if self.hasStickyFocus?
      pos_x = @x + @theme.font.editable.text_width(@textinput.text[0...@textinput.caret_pos]) + TextPadding
      sel_x = @x + @theme.font.editable.text_width(@textinput.text[0...@textinput.selection_start]) + TextPadding
      @realwidth+=@theme.font.editable.text_width(text)
      if pos_x > @realwidth
        pos_x=@realwidth+1 
        sel_x=@realwidth+1
        @textinput.text=text
      end
      @realwidth-=@theme.font.editable.text_width(text)
      if @drawcursor < 18
        $window.draw_line(pos_x, @y+@offsety, CaretColor, pos_x, @y+@theme.font.editable.height+@offsety, CaretColor, ZOrder::Text)
      elsif @drawcursor > 36
        @drawcursor=0
      end
      @drawcursor+=1
      $window.draw_quad(sel_x, @y+@offsety, @theme.font.selcolor, pos_x, @y+@offsety, @theme.font.selcolor, sel_x, @y+@theme.font.editable.height+@offsety, @theme.font.selcolor, pos_x, @y+@theme.font.editable.height+@offsety, @theme.font.selcolor, ZOrder::Text-0.5)
    end
    @theme.font.editable.draw(text, @x+TextPadding, @y+@offsety, ZOrder::Text, 1, 1, @theme.font.color)
  end
end

class Button < Widget
  TextColor=0xff000000
  attr_accessor :text
  def initialize(name, text, x, y, onClickPrc=Proc.new{}, theme = Themes::blank)
    super(name, x, y, x+100, y+30, theme)
    @text=text
    @onClickPrc=onClickPrc
    @drawx=x+((100-@theme.font.default.text_width(@text))/2).floor
    @drawy=y+((30-@theme.font.default.height)/2).floor
  end
  def x1=
    super
    @drawx=x+((100-@theme.font.default.text_width(@text))/2).floor
  end
  def y1=
    super
    @drawy=y+((30-@theme.font.default.height)/2).floor
  end
  def onMouseDown
    @theme.setDownState
  end
  def onClick
    @onClickPrc.call(self)
    if self.hasFocus?
      @theme.setOverState
    else
      @theme.setDefaultState
    end
  end
  def onMouseOver
    @theme.setOverState
  end
  def onMouseOut
    @theme.setDefaultState
  end
  def draw
    @theme.font.default.draw(@text, @drawx, @drawy, ZOrder::Text, 1, 1, @theme.font.color)
  end
end

class Label < Widget
  attr_reader :text
  def initialize(name, text, x, y, theme = Themes::blank)
    @text = text
    @initialized = false
    super(name, x, y, x+100,y+30,theme)
  end
  def text=(val)
    @initialized = false
    @text=val
  end
  def draw
    if not @initialized
      @x2 = @x1 + @theme.font.default.text_width(@text)
      @y2 = @y1 + @theme.font.default.height
      @initialized = true
    end
    @theme.font.default.draw(@text, @x1, @y1, ZOrder::Text, 1, 1, @theme.font.color)
  end
end

class CheckBox < Widget
  
  class CheckedHk < Widget
    attr_reader :x1,:y1,:x2,:y2
    def initialize(x1,y1,x2,y2)
      @x1,@y1,@x2,@y2 = x1,y1,x2,y2
    end
  end
  
  def initialize(name, x, y, text="", checked=false, theme = Themes::blank)
    @themek = theme
    super(name,x,y,x+13,y+13,theme)
    @checked = checked
  end
  def onClick
    self.checked = !@checked
  end
  def onMouseDown
    @theme.setDownState
  end
  def onMouseOver
    @theme.setOverState
  end
  def onMouseOut
    @theme.setDefaultState
  end
  def checked?
    return @checked
  end
  def checked=(val)
    return if val == @checked
    @checked = val
    if @checked
      @theme = @themek.newInstance(CheckedHk.new(@x1,@y1,@x2,@y2))
    else
      @theme = @themek.newInstance(self)
    end
  end
  def draw
    @theme.font.default.draw(name, @x1+13+1, @y1-2, ZOrder::Text)
  end
end

class RadioButton < Widget
  
  class CheckedHk < Widget
    attr_reader :x1,:y1,:x2,:y2
    def initialize(x1,y1,x2,y2)
      @x1,@y1,@x2,@y2 = x1,y1,x2,y2
    end
  end
  attr_reader :parent, :value
  def initialize(name, x, y, value, parent, checked=false, theme = Themes::blank)
    @themek = theme
    super(name,x,y,x+12,y+12,theme)
    @value = value
    @checked = checked
    @parent = parent
  end
  def onClick
    self.checked=!@checked
  end
  def onMouseDown
    @theme.setDownState
  end
  def onMouseOver
    @theme.setOverState
  end
  def onMouseOut
    @theme.setDefaultState
  end
  def checked?
    return @checked
  end
  def checked=(val)
    @checked = val
    if @checked
      if @parent.selected.nil?
        @theme = @themek.newInstance(CheckedHk.new(@x1,@y1,@x2,@y2))
        @parent.selected = self
        return
      end
      return if @parent.selected  == self
      @theme = @themek.newInstance(CheckedHk.new(@x1,@y1,@x2,@y2))
      @parent.selected.checked = false
      @parent.selected = self
    else
      return if @parent.selected  != self
      @theme = @themek.newInstance(self)
    end
  end
  def draw
    @theme.font.default.draw(name, @x1+12+1, @y1-2, ZOrder::Text)
  end
end

class RadioGroup < Widget
  module Layout
    Horizontal = 0
    Vertical = 1
  end
  module Spacing
    Auto = -1
    Automatic = -1
  end
  def initialize(name, x, y, buttons = {}, layout = Layout::Vertical, spacing = -1, theme = Themes::blank)
    super(name,x,y,x,y,Themes::blank,false)
    @buttons = Array.new(buttons.size)
    i = 0
    if layout == Layout::Horizontal
      if spacing == -1
        spacing = 75
      end
      buttons.each { |k,v|
        @buttons.push(RadioButton.new(k, x+i, y, v, self, false, theme))
        i+=spacing
      }
    else
      if spacing == -1
        spacing = 25
      end
      buttons.each { |k,v|
        @buttons.push(RadioButton.new(k, x, y+i, v, self, false, theme))
        i+=spacing
      }
    end
  end
  def theme
    return @buttons[0].theme if @buttons.size > 0
    return Themes::blank
  end
  def theme=(val)
    @buttons.each { |button|
      button.theme = val
    }
  end
  def value
    return @selected.value unless @selected.nil?
    return nil
  end
  def value=(val)
    @buttons.each { |button|
      self.selected = button if button.value == val
    }
    raise RuntimeException.new("No value #{val} in #{self.inspect} (#{self.name})")
  end
  def selected
    return @selected
  end
  def selected=(val)
    @selected = val
  end
end

end #module GGLib