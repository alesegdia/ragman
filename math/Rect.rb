require 'rubygems'

Rect = Struct.new(:x, :y, :w, :h) do
  def collideWith(other)
  	if self.x < other.x
  	  left = self
  	  right = other
  	else
  	  left = other
  	  right = self
  	end
  	if self.y < other.y
  	  top = self
  	  bot = other
  	else
  	  top = other
  	  bot = self
	end
    return ((left.x + left.width > right.x) or
    	   (top.y  + top.height > bot.y))
  end
end
