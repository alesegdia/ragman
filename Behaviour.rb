require 'rubygems'
require 'gosu'
require './Map.rb'
require './Entity.rb'
require './Direction.rb'


def pickup_dir
  return [Direction::Up,
          Direction::Down,
          Direction::Left,
          Direction::Right].sample
end

class Behaviour
  def initialize(sprite, map)
    @sprite = sprite
    @map = map
    @action = Direction::Up
  end

  def think
    if @sprite.is_free(@sprite.direction) then
      @action = @sprite.direction
    else
      @sprite.direction = pickup_dir
      @action = Direction::None
    end
    return @action
  end

end
