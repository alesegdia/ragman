module GGLib

#The Tile class represents a rectangular region on the screen.
#It is synonymous with the Rect structure used in many C programs.
class Tile
    @@tiles = CArray.new
    #@@tile = []
    attr_accessor :x1,:y1,:x2,:y2,:inclusive,:id 
    #@inclusive decides whether or not tile edges are considered part of the tile
    def initialize(x1=0,y1=0,x2=1,y2=1,inclusive=true,id=nil) #id parameter is for use by saveload ONLY!!!!
      @x1,@y1,@x2,@y2=x1,y1,x2,y2
      #begin
      #  @x1+=0;@y1+=0;@x2+=0;@y2+=0 #check if coordinate is actually a proc (damn dynamic typing...)
      #rescue
      #  raise "Bad coord: ID#{@@tiles.size+1}"
      #end
      @inclusive=inclusive
      #@name=name
      if id==nil
        @id=@@tiles.size #volatile, id overwritten by derived classes
        @tileno=@id #secure copy of id
        @@tiles << self
      else
        @id=id
        @tileno=id
        @@tiles[id]=self
      end
    end
    
    #Find out if a point is located in the tile
    def isInTile?(x,y)
      if @inclusive
        return iTile(x,y)
      else
        return xTile(x,y)
      end
    end
    
    alias contains? isInTile?
    
    #Redefine the tile
    def setCoordinates(x1,y1,x2,y2)
      @x1,@y1,@x2,@y2=x1,y1,x2,y2
    end
    
    #Redefine the tile
    def setTile(x1,y1,x2,y2)
      @x1,@y1,@x2,@y2=x1,y1,x2,y2
    end
    
    #Translate the coordinates of the tile so that the thop left corner of the tile is at the given coordinates
    def move(x,y=@y)
      @x2=x+(@x2-@x1)
      @y2=y+(@y2-@y1)
      @y1=y
      @x1=x
    end
    
    #translate the cordinates of the tile so that the center of the tile is at the given point
    def centerOn(x, y)
      hwidth=((@x2-@x1)/2).ceil.abs
      hheight=((@y2-@y1)/2).ceil.abs
      @x2=x+hwidth
      @y2=y+hheight
      @y1=y-hheight
      @x1=x-hwidth
    end
    
    #Returns the width of the tile
    def height
      return (@y2-@y1).abs
    end  
    
    #Returns the hieght of the tile    
    def width
      return (@x2-@x1).abs
    end
    
    #Resize the dimensions of the tile to be w by h units
    def resize(w, h)
      @x2 = @x1 + w
      @y2 = @y1 + h
    end
    
    #Find out if a point is located in the tile, including the edges of the tile
    def iTile(x,y)
      return (x>=@x1 and x<=@x2 and y>=@y1 and y<=@y2)
    end

    #Find out if a point is located in the tile, *not* including the edges of the tile
    def xTile(x,y)
      return (x>@x1 and x<@x2 and y>@y1 and y<@y2)
    end
    
    #Iterates over all of the encompased by the tile
    def each 
      @x1.upto(@x2) { |x|
        @y1.upto(@y2) { |y|
          yield x,y
        }
      }
    end
    
    #Iterates over all of the points on the edges of the tile
    def eachBorder(xindent=0,yindent=0)
      (@x1+xindent).upto(@x2-xindent) { |x|
        yield x, @y1+yindent
      }
      
      (@x1+xindent).upto(@x2-xindent) { |x|
        yield x, @y2+yindent
      }
      
      (@y1+xindent).upto(@y2-xindent) { |y|
        yield @x1+xindent, y
      }
      
      (@y1+xindent).upto(@y2-xindent) { |y|
        yield @x2+xindent, y
      }
    end
    
    public
    #See Tile::intersect?
    def intersect?(tile)
      return Tile::intersect?(self,tile)
    end
    
    #Find out if the given two tiles intersect. 
    def Tile.intersect?(tile1,tile2)
      return  ((tile2.x1 < tile1.x2) and (tile2.x2 > tile1.x1) and (tile2.y1 < tile1.y2) and (tile2.y2 > tile1.y1))
    end
    
    #Returns the tile with the given index
    def Tile.getById(id)
      if @@tiles[id]!=nil
        return @@tiles[id]
      else
        return false
      end
    end
    
    #Deletes the tile with the given index
    def Tile.deleteById(id)
      if @@tiles[id]!=nil
        @@tiles[id].del
        @@tiles.delete_at(id)
        return true
      else
        return false
      end
    end
    
    #Returns an array of all tiles
    def Tile.getAllInstances
      return @@tiles
    end
    
    #Override the internal array of tiles with a new one
    def Tile.setAllInstances(ntiles)
      @@tiles=ntiles
    end
    
    #Delete all tiles int the program. (Includes classes derived from tiles)
    def Tile.deleteAllInstances
      @@tiles=CArray.new
    end
    
    #Deletes the calling tile
    def del
      @@tiles.delete_at(@tileno)
      @x1,@y1,@x2,@y2,@inclusive,@id,@tileno=nil
    end
  end
  
  end #module GGLib