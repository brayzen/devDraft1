require_relative 'Attraction_node.rb'

class AmusementPark
  # this class is built with the Attraction Nodes, it needs the number of
  # attactions as the first argument followed by the 'array of distances'
  # which is the distance in one direction from attraction to attraction.
  attr_accessor :num_of_attractions, :array_of_distances, :last, :first

  def initialize(num_of_attractions, array_of_distances)
    @num_of_attractions = num_of_attractions
    @array_of_distances = array_of_distances
    @last = nil
    @first = nil
    chain_link
  end

  def chain_link
    @num_of_attractions.times do |n|
      current = Attraction.new(n,
                               nil,
                               nil,
                               @array_of_distances[n - 1],
                               @array_of_distances[n])
      if n == 0
        @last = current
        @first = current
      else
        current.left = @last
        @last.right = current
        @last = current
      end
    end
    @last.right = @first
    @first.left = @last
  end

  def find_obj(number)
    current = @first
    while current.number != number
      current = current.right
      nil if current.number == @first.number
    end
    current
  end

  def clockwise_dist(start, destination)
    current = find_obj(start)
    return nil if start == destination || current.nil?
    total_dist = 0
    while current.number != destination
      current = current.left
      total_dist += current.dist_to_right
    end
    total_dist
  end

  def counter_clockwise_dist(start, destination)
    current = find_obj(start)
    return nil if start == destination || current.nil?
    total_dist = 0
    while current.number != destination
      current = current.right
      total_dist += current.dist_to_left
    end
    total_dist
  end

  def min_dist(journey_arr)
    current = self
    dist = 0
    journey_arr.each_index do |i|
      if i < journey_arr.length - 1
        cw = current.clockwise_dist(journey_arr[i], journey_arr[i + 1])
        ccw = current.counter_clockwise_dist(journey_arr[i], journey_arr[i + 1])
        dist += cw < ccw ? cw : ccw
      end
    end
    dist
  end
end

# puts "Enter the number of Attractions in the Park: "
num_attractions = gets.chomp.to_i
# puts "Enter the sequence of numbers for minutes taken to walk from 0 to n-th attractions: "
arry_of_distances = gets.split(' ').map { |x| x.chomp.to_i }
amuse_park_1 = AmusementPark.new(num_attractions, arry_of_distances)
# puts "Enter the amount of Queries would you like to make: "
num_query = gets.chomp.to_i

response = []
num_query.times do
  # puts "How many attractions would customer_#{n + 1} like to see?"
  num_attr_to_see = gets.chomp.to_i
  # puts "Enter planned attraction journey in numbers ( space seperated please ): "
  journey_arr = gets.split(' ').map { |x| x.chomp.to_i }
  if num_attr_to_see == journey_arr.length
    response << amuse_park_1.min_dist(journey_arr)
  end
end
puts response
response
