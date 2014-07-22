
module Direction
  Up = 0
  Down = 1
  Left = 2
  Right = 3
  None = 4

  def to_str(dir)
    case dir
    when Direction::Up then return "UP"
    when Direction::Down then return "DOWN"
    when Direction::Left then return "LEFT"
    when Direction::Right then return "RIGHT"
    end
  end

end

