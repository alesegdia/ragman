
module GhostState
  Dead = 0
  Active = 1
  Fear = 2
  Base = 3
end

# This module lets a ghost only act when he can, and take
# control over it when game rules state it
class GhostController

  def initialize( entity, map, controller )
    @controller = controller
    @entity = entity
    @map = map
    @state = GhostState::Active # DEBERIA SER GhostState::Base
    @warmup = 1000
    @timer = 0
  end

  def poll_action
    case @state
    when GhostState::Dead
      @timer = @warmup
      # return to base
    when GhostState::Active, GhostState::Fear
      return @controller.poll_action
    when GhostState::Base
      # @timer = @timer - delta
      # @state = GhostState::Active if @timer <= 0 end
    end
  end

end
