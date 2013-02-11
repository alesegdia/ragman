module GGLib

class Animation
  @@animations = {}
  attr_reader :animObj,:name,:src,:speed, :width, :height, :loop
  def initialize(name,src,speed,width,height,loop=true)
    @animObj=Gosu::Image::load_tiles($window,src,width,height,false)
    @src=src
    @name=name
    @width=width
    @height=height
    @speed=speed
    @loop=loop
    @started=false
    @done=false
    @@animations[@name]=self
  end
  def del
    @@animations.delete_at(@name)
  end
  def Animation.get(at)
    if @@animations[at] !=nil
      return @@animations[at]
    else
      puts caller
      STDIN.gets
      raise "Animation resource '#{at}' does not exist."
    end
  end
  def data
    return @animObj
  end
  def done
    return true if @loop and (Gosu::milliseconds / @speed % @animObj.size)==@animObj.size-1
    return false if @loop
    return nil
  end
  def restart
    @started=false
    @done=false
  end
  def draw(x,y,z)
    if @loop
      @animObj[(Gosu::milliseconds / @speed % @animObj.size)].draw(x,y,z)  #looping mode
      return true #signifies that the animation is still playing
    else  
      if not @started
        start=(Gosu::milliseconds / @speed % @animObj.size)
        @started=true
        @map=[]
        i=0
        start.upto(@animObj.size-1) { |index|
          @map[index]=i
          i+=1
        }
        if start-1>=0
          0.upto(start-1) { |index|
            @map[index]=i
            i+=1
          }
        end
      end
      index=@map[(Gosu::milliseconds / @speed % @animObj.size)]
      if not @done and index < @animObj.size - 1 #single play mode
        @animObj[index].draw(x,y,z)
        return true #singifies that the animation is still playing
      else
        @done=true
        @animObj[@animObj.size - 1].draw(x,y,z)
        return false #signifies that the animation is done. The last frame will be played continueuosly. The caller can take further action 
      end
    end
  end
  def Animation.deleteAllAnimations
    @@animations={}
  end
end

class MapImage < Animation
  BuildingSpriteRoot="img/sprites/map/buildings/"
  ItemSpriteRoot="img/sprites/map/items/"
  TerrainSpriteRoot="img/sprites/map/terrain/"
  Animation=true
  Image=false
  def initialize(name,src,speed,width,height,loop=true)
    src=subVars(src)
    super
  end
  def initialize(name,src)
    src=subVars(src)
    @src=src
    @name=name
    @animObj=Gosu::Image.new($window,src,width,height,false)
    @type=Image
  end
  def draw(x,y,z)
    if Animation
      super
    else
      @animObj.draw(x,y,z)
    end
  end
  def MapImage.get(at)
    return Animation.get(at)
  end
end

class Image
  attr_reader :obj,:x,:y,:z,:id,:src,:descr
  def initialize(x,y,z,src,hardBorders=true,tracer="None",no=nil)
    @obj=Gosu::Image.new($window,src,hardBorders)
    @src=src
    @x=x
    @y=y
    @z=z
    @id=no
    @descr=tracer
  end
  def draw(x=@x,y=@y,z=@z)
    @obj.draw(x,y,z)
  end
  def setPos(x,y=@y,z=@z)
    @x=x
    @y=y
    @z=z
  end
  def del
    @obj,@x,@y,@z,@id=nil    
  end
end

class Texture < Image
  attr_reader :obj,:x1,:y1,:x2,:y2,:z,:id,:src,:descr
  def initialize(x1,y1,x2,y2,z,src,hardBorders=true,tracer="None",no=nil)
    @obj=Gosu::Image.new($window,src,hardBorders)
    @src=src.to_sym
    @x1=x1
    @y1=y1
    @x2=x2
    @y2=y2
    @z=z
    @id=no
    @descr=tracer
  end
  def x
    return @x1
  end
  def y 
    return @y1
  end
  def draw(x1=@x1,y1=@y1,x2=@x2,y2=@y2,z=@z)
    @obj.draw_as_quad(x1, y1, 0xffffffff, x2, y1, 0xffffffff, x1, y2, 0xffffffff, x2, y2, 0xffffffff, z)
  end
end

class ZOrder
  Bottom=0
  Background=1
  MapOverlay=2
  Tile=3
  Terrain=3
  BuildingTile=4
  Building=4
  Object=5
  UnclassifiedImage=6
  Default=6
  Character=7
  SceneOverlay=8
  Button=9
  Widget=9
  GUI=9
  Text=13
  Cursor=14
  Top=15
end

end #module GGLib