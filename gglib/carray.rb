module GGLib

#CArray is an Array which does not compact. CArrays place a priority on preserving the indices of each element in order to allow identification of elements thier indices.
#CArrays are used by the Window and Tile classes.

class CArray < Array
  public
  @intsize
  def initialize
    @intsize=0
    super
  end
  def push(item)
    self[@intsize]=item
    @intsize+=1
    return @intsize-1
  end
  def <<(item)
    self[@intsize]=item
    @intsize+=1
    return @intsize-1    
  end
  def each
    i=0
    while i<=@intsize
      if self[i] !=nil
        yield self[i]
      end
      i+=1
    end
  end
  def delete(obj)
    if obj!=nil
      i=0
      while i<=@intsize
        if self[i] == obj
          self[i]=nil
        end
        i+1
      end
    else
      return nil
    end
  end
  def delete_at(loc)
    if loc<@intsize
      self[loc]=nil
    end
    return self[loc+1]
  end
  def pp
    puts "CArray: "
    i=0
    while i<=@intsize
      if self[i] !=nil
        puts i.to_s+"\t"+self[i].to_s
      else
        puts i.to_s+"\tnil"   
      end
      i+=1
    end    
  end
  def compact
    return false
  end
  def compact!
    return false
  end
end

end #module GGLib