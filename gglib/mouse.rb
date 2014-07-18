module GGLib

  class Cursor
    attr_reader :img, :visible, :imgObj
    def initialize(img,visible=true)
      @img=img
      @visible=visible
      @imgObj=Gosu::Image.new($window,img,true)
      @forced=false
    end
    #If the cursor is currently invisible, makes it visible. If the cursor is currently visible, makes it invisible. Subject to the constraints of forceVisible.
    def toggleVisible
      if not @forced
        @visible=!@visible
      end
    end
    #Forces the cursor to adhere to the visibility specified by parameter visible. Subsequent calls to toggleVisible and visible= will have no effect. See also unforceVisible.
    def forceVisible(visible=true)
      @forced=true
      @visible=visible
    end
    #Allows the cursor to be made invisible via toggleVisible or visible=.
    def unforceVisible
      @forced=false
    end
    #Returns true if the cursor is currently visible, false otherwise.
    def visible?
      return visible
    end
    #Reverses the effects of forceVisible. Calls to toggleVisible and visible= will again have an effect.
    def visible=(visible)
      if not @forced
        @visible=visible
      end
    end
    #Restricts mouse movement along the x axis.
    def restrictX(restrict=true)
      @rx = restrict
      if @rx
        @ox = $window.mouse_x
      end
    end
    #Restricts mouse movement along the y axis.
    def restrictY(restrict=true)
      @ry = restrict
      if @ry
        @oy = $window.mouse_y
      end
    end
    #Stops restriction of mouse movement along the x axis.
    def unrestrictX
      @rx = false
    end
    #Stops restriction of mouse movement along the y axis.
    def unrestrictY
      @ry = false
    end
    #Returns true if movement along the x axis is currently restricted, false otherwise.
    def restrictX?
      return @rx
    end
    #Returns true if movement along the y axis is currently restricted, false otherwise.
    def restrictY?
      return @ry
    end
    #Returns the current x coordinate of the cursor.
    def x
      return $window.mouse_x
    end
    #Returns the current y coordinate of the cursor.
    def y
      return $window.mouse_y
    end
    #Sets the current x coordinate of the cursor.
    def x=(val)
      $window.mouse_x = val
    end
    #Sets the current y coordinate of the cursor.
    def y=(val)
      $window.mouse_y = val
    end
    #Sets the position of the cursor.
    def moveTo(xp, yp)
      $window.mouse_x = xp
      $window.mouse_y = yp
    end
    def draw
      if @rx
        $window.mouse_x = @x
      end
      if @ry
        $window.mouse_y = @oy
      end
      if @visible
        @imgObj.draw($window.mouse_x,$window.mouse_y,ZOrder::Cursor)
      end
    end
  end
  
  class DeltaCursor
    attr_reader :img, :visible, :imgObj
    def initialize(img,visible=true)
      @img=img
      @visible=visible
      @imgObj=Gosu::Image.new($window,img,true)
      @forced=false
      @centerx = ($window.width/2).floor
      @centery = ($window.height/2).floor
      @ax = 0
      @ay = 0
    end
    #If the cursor is currently invisible, makes it visible. If the cursor is currently visible, makes it invisible. Subject to the constraints of forceVisible.
    def toggleVisible
      if not @forced
        @visible=!@visible
      end
    end
    #Forces the cursor to remain visible until unforceVisible is called.
    def forceVisible(visible=true)
      @forced=true
      @visible=visible
    end
    #Allows the cursor to be made invisible via toggleVisible or visible=.
    def unforceVisible
      @forced=false
    end
    #Returns true if the cursor is currently visible, false otherwise.
    def visible?
      return visible
    end
    #Sets the visibility of the cursor. Subject to the constraints of forceVisible.
    def visible=(visible)
      @visible=visible if not @forced
    end  
    #Returns the x-axis distance shifted from the center since the last call to draw.
    def x
      @ax - @centerx
    end
    #Returns the y-axis distance shifted from the center since the last call to draw.
    def y
      @ay - @centery
    end
    def draw
      @ax = $window.mouse_x
      @ay = $window.mouse_y
      $window.mouse_x = @centerx
      $window.mouse_y = @centery
      if @visible
        @imgObj.draw(@centerx, @centery,ZOrder::Cursor)
      end
    end    
  end
  
  class MouseDragEvent
    attr_reader :start_x, :start_y, :end_x, :end_y, :inprogress, :starting
    def initialize
      @start_x, @start_y = 0
      @end_x, @end_y = 0
      @inprogress = false
      @starting = false
    end
    def start
      @start_x, @start_y = $window.mouse_x, $window.mouse_y
      @starting = true
    end
    def confirmStart
      @starting = false
      @inprogress = true
    end
    def end
      @end_x, @end_y = $window.mouse_x, $window.mouse_y
      @inprogress = false
    end
    def terminate
      @inprogress, @starting = false
    end
  end
  
end #module GGLib