require './Behaviour.rb'

class SeekBehaviour < Behaviour
  def think
    if @x == @target_x and @y == @target_y
      @target = @aicore.pathfind(
        @x,@y,@keypoints[@ptr][:x],@keypoints[@ptr][:y])
      @ptr = @ptr + 1
	end
    @aicore.pathfind(@x,@y)
  end

end
