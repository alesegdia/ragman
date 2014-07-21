require 'rubygems'
require 'gosu'
require 'gglib'
require './gglib/ext/widgets.rb'
require './gglib/ext/themes.rb'
require './Map.rb'
require './mapeditor/Grid.rb'
require './mapeditor/LoadMenu.rb'
require './mapeditor/SaveMenu.rb'

class EditionState < GGLib::StateObject

  def initialize
    super
    puts "edition state"
  end

  def onStart
    $window.setBackground("mapeditor/bground.jpg")
    puts "starting edition!"
    @goToLoad = nil
    @goToSave = nil

    @map = $window.map


    @font = Gosu::Font.new($window, Gosu::default_font_name, 15)
    @grid_xoff, @grid_yoff = 30, 40
    @map_xoff, @map_yoff = 150, 20
    puts @map.tilesheet
    @grid = Grid.new($window, @map.tilesheet, 5, 200, 100, 16, 16)
    button_x = 20
    button_y = 120
    GGLib::Button.new(:savemap, "SAVE MAP", button_x, button_y,
                      Proc.new do |widget|
      @goToSave = true
      $window.state = GGLib::FadeScreen.new(SaveMenu.new, 32)
    end,
    GGLib::Themes::BlueSteel)

    GGLib::Button.new(:loadmap, "LOAD MAP",  button_x, button_y+50,
                      Proc.new do |widget|
      @goToLoad = true
    end,
    GGLib::Themes::BlueSteel)

    GGLib::Button.new(:loadmap, "NEW MAP", button_x, button_y+100,
                      Proc.new do |widget|
      $window.state = EditionState.new
    end,
    GGLib::Themes::BlueSteel)
  end

  def update
    if @rclick then
      @map.swap_tile(window.mouse_x - @map_xoff,
                     window.mouse_y - @map_yoff,
                     0) # HARDCODED!!   @grid.selected_tile)
    end

    if @click then
      @grid.select(window.mouse_x - @grid_xoff,
                   window.mouse_y - @grid_yoff)

      @map.swap_tile(window.mouse_x - @map_xoff,
                     window.mouse_y - @map_yoff,
                     @grid.selected_tile)
    end
    if @goToLoad then
      @goToLoad = nil
      $window.state = LoadMenu.new
    elsif @goToSave then
      @goToSave = nil
      $window.state = SaveMenu.new
    end
  end

  def draw
    @map.draw_offset(@map_xoff, @map_yoff)

    c1 = Gosu::Color.new(0x90803333)
    c2 = Gosu::Color.new(0xADFADE00)
    c3 = Gosu::Color.new(0x94DADE33)
    c4 = Gosu::Color.new(0x90445555)
    left = @map_xoff - 5
    right = @map_xoff + @map.tile_width * @map.width + 5
    top = @map_yoff - 5
    bot = @map_yoff + @map.tile_height * @map.height + 5

    $window.draw_quad(
      left, top, c1,
      right, top, c2,
      left, bot, c3,
      right, bot, c4, 1)

    c1 = Gosu::Color::BLACK

    $window.draw_quad(
      left+5, top+5, c1,
      right-5, top+5, c1,
      left+5, bot-5, c1,
      right-5, bot-5, c1, 1)

    draw_palette(@grid_xoff,@grid_yoff)
  end

  def draw_palette(x,y)
    @font.draw("TILE PALETTE", x-10, y-20, 1)
    @grid.draw(x, y)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      window.close
    when Gosu::KbN
      make_new_map
    when Gosu::MsLeft
      @click = true
    when Gosu::MsRight
      @rclick = true
    end
  end

  def button_up(id)
    case id
    when Gosu::MsLeft
      @click = false
    when Gosu::MsRight
      @rclick = false
    end
  end


  def draw_background
    10.times do
      ## poner fondo de cuadrados y de circulos
    end
  end

  def onEnd
    puts "Edition State terminated"
  end

end
