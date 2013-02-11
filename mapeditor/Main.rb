require 'rubygems'
require 'gosu'
require 'gglib'
require '../gglib/ext/widgets.rb'
require '../gglib/ext/themes.rb'
require '../Map.rb'
require 'Grid.rb'
require 'EditionState.rb'
#require 'NewMapState.rb'

# Add ZOrder

class EditorWindow < GGLib::GUIWindow
  def initialize
    super(400,400,false)
    
    self.caption = "Ragman Map Editor"
    self.state = EditionState.new

  end
end
  

window = EditorWindow.new.show
#window.show
