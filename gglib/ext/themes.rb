module GGLib

$initthemes = false

module Themes

#--
########################################################################
#                          BLUE STEEL THEME                            #
########################################################################
#++

class BlueSteelTheme < ImageTheme
  @@button = nil
  def initialize
    image = ThemeImageGroup.new( 
                  $gglroot+"/media/bluesteel/generic/menusmall.png", 
                  $gglroot+"/media/bluesteel/generic/menusmall.png", 
                  $gglroot+"/media/bluesteel/generic/menusmall.png"
                )
    font = DefaultFontGroup
    super("BlueSteel.Generic", font, image)
  end
  def request(obj)
    if @@button == nil #Can't initialize at global scope because $window may not have been set
      @@button = ImageTheme.new(
                          "BlueSteel.Button", 
                          DefaultFontGroup, 
                          ThemeImageGroup.new( 
                            $gglroot+"/media/bluesteel/button/button.png", 
                            $gglroot+"/media/bluesteel/button/buttonup.png", 
                            $gglroot+"/media/bluesteel/button/buttondown.png" 
                          )
                        )
      @@textbox = ImageTheme.new(
                            "BlueSteel.TextBox", 
                            DefaultFontGroup, 
                            ThemeImageGroup.new( 
                              $gglroot+"/media/bluesteel/textbox/textbox.png", 
                              $gglroot+"/media/bluesteel/textbox/textboxactive.png" , 
                              $gglroot+"/media/bluesteel/textbox/textboxactive.png" 
                            )
                          )
      @@label = ImageTheme.new(
                        "BlueSteel.Label", 
                        DefaultFontGroup, 
                        ThemeImageGroup.new( $gglroot+"/null.png", $gglroot+"/null.png" , $gglroot+"/null.png" ) 
                      )
      @@checkbox = ImageTheme.new(
                              "BlueSteel.CheckBox.Unchecked", 
                              DefaultFontGroup, 
                              ThemeImageGroup.new( 
                                $gglroot+"/media/bluesteel/checkbox/checkbox.png", 
                                $gglroot+"/media/bluesteel/checkbox/checkboxup.png",
                                $gglroot+"/media/bluesteel/checkbox/checkboxdown.png"
                              )
                            )
      @@checkboxc = ImageTheme.new(
                                "BlueSteel.CheckBox.Checked", 
                                DefaultFontGroup, 
                                ThemeImageGroup.new( 
                                  $gglroot+"/media/bluesteel/checkbox/checkboxc.png", 
                                  $gglroot+"/media/bluesteel/checkbox/checkboxcup.png",
                                  $gglroot+"/media/bluesteel/checkbox/checkboxcdown.png"
                                )
                              )
      @@radiobtn = ImageTheme.new(
                            "BlueSteel.RadioButton.Unchecked", 
                            DefaultFontGroup, 
                            ThemeImageGroup.new( 
                              $gglroot+"/media/bluesteel/radio/radiobtn.png", 
                              $gglroot+"/media/bluesteel/radio/radiobtnup.png",
                              $gglroot+"/media/bluesteel/radio/radiobtndown.png"
                            )
                          )
      @@radiobtnc = ImageTheme.new(
                              "BlueSteel.RadioButton.Checked", 
                              DefaultFontGroup, 
                              ThemeImageGroup.new( 
                                $gglroot+"/media/bluesteel/radio/radiobtnc.png", 
                                $gglroot+"/media/bluesteel/radio/radiobtncup.png",
                                $gglroot+"/media/bluesteel/radio/radiobtncdown.png"
                              )
                            )
    end
    if obj.kind_of?(Button)
      return @@button
    elsif obj.kind_of?(TextBox)
      return @@textbox
    elsif obj.kind_of?(Label)
      return @@label
    elsif obj.kind_of?(CheckBox)
      return @@checkbox
    elsif obj.kind_of?(CheckBox::CheckedHk)
      return @@checkboxc
    elsif obj.kind_of?(RadioButton)
      return @@radiobtn
    elsif obj.kind_of?(RadioButton::CheckedHk)
      return @@radiobtnc
    end
    return self
  end
end

#--
########################################################################
#                            RUBYGOO THEME                             #
########################################################################
#++

class RubygooTheme < DrawnTheme
  @@textbox = nil
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20), 
                0xff000000, 
                0xff848484
              )
    super("Rubygoo.Generic", font)
  end
  def request(obj)
    if @@textbox == nil #Can't initialize atglobal scope because $window may not have been set
      @@textbox = RubygooTextTheme.new
      @@label = RubygooLabelTheme.new
    end
    if obj.kind_of?(TextBox)
      return @@textbox
    elsif obj.kind_of?(Label)
      return @@label
    end
    return self
  end
  def draw(x1,y1, x2, y2, state)
    if state == 1
      $window.draw_quad(x1, y1, 0xffb22222, x2, y1, 0xffb22222, x1, y2, 0xffb22222, x2, y2, 0xffb22222, ZOrder::Widget) 
      $window.draw_quad(x1+1, y1+1, 0xff6e6e6e, x2-1, y1+1, 0xff6e6e6e, x1+1, y2-1, 0xff6e6e6e, x2-1, y2-1, 0xff6e6e6e, ZOrder::Widget) 
    else
      $window.draw_quad(x1, y1, 0xffb22222, x2, y1, 0xffb22222, x1, y2, 0xffb22222, x2, y2, 0xffb22222, ZOrder::Widget) 
      $window.draw_quad(x1+1, y1+1, 0xff808080, x2-1, y1+1, 0xff808080, x1+1, y2-1, 0xff808080, x2-1, y2-1, 0xff808080, ZOrder::Widget) 
    end
  end
end

class RubygooTextTheme < DrawnTheme
  @@textbox = nil
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20), 
                0xff000000, 
                0xffb22222
              )
    super("Rubygoo.TextBox", font)
  end
  def draw(x1,y1, x2, y2, state)
    if state == 1
      $window.draw_quad(x1, y1, 0xff6e6e6e, x2, y1, 0xff6e6e6e, x1, y2, 0xff6e6e6e, x2, y2, 0xff6e6e6e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xff000000, x2-2, y1+2, 0xff000000, x1+2, y2-2, 0xff000000, x2-2, y2-2, 0xff000000, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff6e6e6e, x2-3, y1+3, 0xff6e6e6e, x1+3, y2-3, 0xff6e6e6e, x2-3, y2-3, 0xff6e6e6e, ZOrder::Widget) 
    else
      $window.draw_quad(x1, y1, 0xff808080, x2, y1, 0xff808080, x1, y2, 0xff808080, x2, y2, 0xff808080, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xff000000, x2-2, y1+2, 0xff000000, x1+2, y2-2, 0xff000000, x2-2, y2-2, 0xff000000, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff808080, x2-3, y1+3, 0xff808080, x1+3, y2-3, 0xff808080, x2-3, y2-3, 0xff808080, ZOrder::Widget) 
    end
  end
end

class RubygooLabelTheme < DrawnTheme
  @@textbox = nil
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20), 
                0xff000000, 
                0xffb22222
              )
    super("Rubygoo.Label", font)
  end
end

#--
########################################################################
#                             SHADE THEME                              #
########################################################################
#++

class ShadeTheme < DrawnTheme
  @@label = nil
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20), 
                0xffe6e6e6, 
                0xffb22222
              )
    super("Shade.Generic", font)
  end
  def request(obj)
    if @@label == nil #Can't initialize at global scope because $window may not have been set
      @@label = ShadeLabelTheme.new
      @@checkgen = ShadeCheckGenTheme.new
      @@checkgenc = ShadeCheckGenCTheme.new
    end
    if obj.kind_of?(Label)
      return @@label
    elsif obj.kind_of?(CheckBox) or obj.kind_of?(RadioButton)
      return @@checkgen
    elsif obj.kind_of?(CheckBox::CheckedHk) or obj.kind_of?(RadioButton::CheckedHk)
      return @@checkgenc
    end
    return self
  end
  def draw(x1,y1, x2, y2, state)
    if state == 1
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffbdbdbd, x2-2, y1+2, 0xffbdbdbd, x1+2, y2-2, 0xffbdbdbd, x2-2, y2-2, 0xffbdbdbd, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
    else
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffffffff, x2-2, y1+2, 0xffffffff, x1+2, y2-2, 0xffffffff, x2-2, y2-2, 0xffffffff, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
    end
  end
end

class ShadeLabelTheme < DrawnTheme
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20),
                0xffe6e6e6,
                0xff848484
              )
    super("Shade.Label", font)
  end
end

class ShadeCheckGenTheme < DrawnTheme
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20),
                0xffe6e6e6,
                0xff848484
              )
    super("Shade.Checkable.Unchecked", font)
  end
  def draw(x1,y1, x2, y2, state)
    if state == 1
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffbdbdbd, x2-2, y1+2, 0xffbdbdbd, x1+2, y2-2, 0xffbdbdbd, x2-2, y2-2, 0xffbdbdbd, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+4, y1+4, 0xfffeeeee, x2-4, y1+4, 0xffeeeeee, x1+4, y2-4, 0xffeeeeee, x2-4, y2-4, 0xffeeeeee, ZOrder::Widget)
      $window.draw_quad(x1+5, y1+5, 0xff2e2e2e, x2-5, y1+5, 0xff2e2e2e, x1+5, y2-5, 0xff2e2e2e, x2-5, y2-5, 0xff2e2e2e, ZOrder::Widget) 
    else
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffffffff, x2-2, y1+2, 0xffffffff, x1+2, y2-2, 0xffffffff, x2-2, y2-2, 0xffffffff, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+4, y1+4, 0xffffffff, x2-4, y1+4, 0xffffffff, x1+4, y2-4, 0xffffffff, x2-4, y2-4, 0xffffffff, ZOrder::Widget)
      $window.draw_quad(x1+5, y1+5, 0xff2e2e2e, x2-5, y1+5, 0xff2e2e2e, x1+5, y2-5, 0xff2e2e2e, x2-5, y2-5, 0xff2e2e2e, ZOrder::Widget) 
    end
  end
end

class ShadeCheckGenCTheme < DrawnTheme
  def initialize
    font = ThemeFontGroup.new( 
                Gosu::Font.new($window, Gosu::default_font_name, 17), 
                Gosu::Font.new($window, Gosu::default_font_name, 25), 
                Gosu::Font.new($window, Gosu::default_font_name, 20),
                0xffe6e6e6,
                0xff848484
              )
    super("Shade.Checkable.Checked", font)
  end
  def draw(x1,y1, x2, y2, state)
    if state == 1
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffbdbdbd, x2-2, y1+2, 0xffbdbdbd, x1+2, y2-2, 0xffbdbdbd, x2-2, y2-2, 0xffbdbdbd, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+4, y1+4, 0xfffeeeee, x2-4, y1+4, 0xffeeeeee, x1+4, y2-4, 0xffeeeeee, x2-4, y2-4, 0xffeeeeee, ZOrder::Widget)
    else
      $window.draw_quad(x1, y1, 0xff2e2e2e, x2, y1, 0xff2e2e2e, x1, y2, 0xff2e2e2e, x2, y2, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+2, y1+2, 0xffffffff, x2-2, y1+2, 0xffffffff, x1+2, y2-2, 0xffffffff, x2-2, y2-2, 0xffffffff, ZOrder::Widget) 
      $window.draw_quad(x1+3, y1+3, 0xff2e2e2e, x2-3, y1+3, 0xff2e2e2e, x1+3, y2-3, 0xff2e2e2e, x2-3, y2-3, 0xff2e2e2e, ZOrder::Widget) 
      $window.draw_quad(x1+4, y1+4, 0xffffffff, x2-4, y1+4, 0xffffffff, x1+4, y2-4, 0xffffffff, x2-4, y2-4, 0xffffffff, ZOrder::Widget)
    end
  end
end

#--
########################################################################
#                            WINDOWS THEME                             #
########################################################################
#++

class WindowsTheme < ImageTheme
  @@button = nil
  def initialize
    image = ThemeImageGroup.new( 
                  $gglroot+"/media/windows/generic/menusmall.png", 
                  $gglroot+"/media/bluesteel/generic/menusmall.png", 
                  $gglroot+"/media/bluesteel/generic/menusmall.png"
                )
    font = DefaultFontGroup
    super("Windows.Generic", font, image)
  end
  def request(obj)
    if @@button == nil #Can't initialize atglobal scope because $window may not have been set
      @@button = ImageTheme.new(
                          "Windows.Button", 
                          DefaultFontGroup,
                          ThemeImageGroup.new( 
                            $gglroot+"/media/windows/button/button.png", 
                            $gglroot+"/media/windows/button/buttonup.png", 
                            $gglroot+"/media/windows/button/buttondown.png"
                          )
                        )
      @@textbox = ImageTheme.new(
                            "Windows.TextBox", 
                            DefaultFontGroup, 
                            ThemeImageGroup.new( 
                              $gglroot+"/media/windows/textbox/textbox.png", 
                              $gglroot+"/media/windows/textbox/textboxup.png", 
                              $gglroot+"/media/windows/textbox/textboxup.png"
                            )
                          )
      @@label = ImageTheme.new(
                        "Windows.Label", 
                        DefaultFontGroup, 
                        ThemeImageGroup.new( $gglroot+"/null.png", $gglroot+"/null.png", $gglroot+"/null.png" )
                      )
      @@checkbox = ImageTheme.new(
                              "Windows.CheckBox.Unchecked", 
                              DefaultFontGroup, 
                              ThemeImageGroup.new( 
                                $gglroot+"/media/windows/checkbox/checkbox.png", 
                                $gglroot+"/media/windows/checkbox/checkboxup.png",
                                $gglroot+"/media/windows/checkbox/checkboxdown.png"
                              )
                            )
      @@checkboxc = ImageTheme.new(
                                "Windows.CheckBox.Checked", 
                                DefaultFontGroup, 
                                ThemeImageGroup.new( 
                                  $gglroot+"/media/windows/checkbox/checkboxc.png", 
                                  $gglroot+"/media/windows/checkbox/checkboxcup.png",
                                  $gglroot+"/media/windows/checkbox/checkboxcdown.png"
                                )
                              )
      @@radiobtn = ImageTheme.new(
                            "Windows.RadioButton.Unchecked", 
                            DefaultFontGroup, 
                            ThemeImageGroup.new( 
                              $gglroot+"/media/windows/radio/radiobtn.png", 
                              $gglroot+"/media/windows/radio/radiobtnup.png",
                              $gglroot+"/media/windows/radio/radiobtndown.png"
                            )
                          )
      @@radiobtnc = ImageTheme.new(
                              "Windows.RadioButton.Checked", 
                              DefaultFontGroup, 
                              ThemeImageGroup.new( 
                                $gglroot+"/media/windows/radio/radiobtnc.png", 
                                $gglroot+"/media/windows/radio/radiobtncup.png",
                                $gglroot+"/media/windows/radio/radiobtncdown.png"
                              )
                            )
    end
    if obj.kind_of?(Button)
      return @@button
    elsif obj.kind_of?(TextBox)
      return @@textbox
    elsif obj.kind_of?(Label)
      return @@label
    elsif obj.kind_of?(CheckBox)
      return @@checkbox
    elsif obj.kind_of?(CheckBox::CheckedHk)
      return @@checkboxc
    elsif obj.kind_of?(RadioButton)
      return @@radiobtn
    elsif obj.kind_of?(RadioButton::CheckedHk)
      return @@radiobtnc
    end
    return self
  end
end

#--
########################################################################
#                           SOLID THEME                              #
########################################################################
#++

class SolidTheme < DrawnTheme
  def initialize(color)
    font = DefaultFontGroup
    super("Solid.Generic", font)
    @color = color
  end
  def draw 
    $window.draw_quad(x1, y1, @color, x2, y1, @color, x1, y2, @color, x2, y2, @color, ZOrder::Widget) 
  end
end

def Solid(color)
  return SolidTheme.new(color)
end

#--
########################################################################
#                           END OF THEMES                              #
########################################################################
#++

$theme_init_hook = Proc.new {
  unless $initthemes
    Themes.const_set("DefaultFontGroup", ThemeFontGroup.new( 
                                                              Gosu::Font.new($window, Gosu::default_font_name, 17), 
                                                              Gosu::Font.new($window, Gosu::default_font_name, 25), 
                                                              Gosu::Font.new($window, Gosu::default_font_name, 20)
                                                            )
                            )
    Themes.const_set("BlueSteel", BlueSteelTheme.new)
    Themes.const_set("Rubygoo", RubygooTheme.new)
    Themes.const_set("Shade", ShadeTheme.new)
    Themes.const_set("Windows", WindowsTheme.new)
    $initthemes = true
  end
}
  
end #module Themes

end #module GGLib