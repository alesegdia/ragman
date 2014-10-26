module GGLib

class SplashScreen < Gosu::Window
  def initialize(width=640, height=480, img = "null.png", caption = "Loading...")
    super(width, height, false, 20)
    self.caption = caption
    @background_image = Gosu::Image.new(self, img, true)
    @done=false
  end
  
  #Override this method and include all initialization methods here *except for opening the window*.
  def load
    
  end
  
  #Override with method with the code needed to initialize the main application window.
  def createWindow
    
  end
  
  def update
    load 
    @done=true
    if @done
      puts "\nLaunching in:\n3"
      sleep(1)
      puts "2"
      sleep(1)
      puts "1"
      sleep(1)
      puts "0"
      close
      createWindow
    end 
  end

  def draw
    @background_image.draw(0, 0, 0)
  end
end

end #module GGLib