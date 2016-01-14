class Attraction
  attr_accessor :number, :left, :right, :dist_to_left, :dist_to_right

  def initialize(number, left=nil, right=nil, dist_to_left=nil, dist_to_right=nil)
    @number = number
    @left = left
    @right = right
    @dist_to_left = dist_to_left
    @dist_to_right = dist_to_right
  end
end
