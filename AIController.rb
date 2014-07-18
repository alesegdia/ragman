
class AIController

  def initialize( entity, map, behaviour )
    @behaviour = behaviour
    @entity = entity
    @map = map
  end

  def poll_action
    return @behaviour.think
  end

end
