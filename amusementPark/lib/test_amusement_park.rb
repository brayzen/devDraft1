include MiniTest::Assertions
require_relative 'Attraction_node.rb'
require_relative 'amusement_chain.rb'

response = []

puts "Enter the number of Attractions in the Park: "
num_attractions = gets.chomp.to_i
puts "Enter the sequence of numbers for minutes taken to walk from 0 to n-th attractions: "
arry_of_distances = gets.split(' ').map{ |x| x.chomp.to_i }
amuse_park_1 = AmusementPark.new(num_attractions, arry_of_distances)
puts "Enter the amount of Queries would you like to make: "
num_query = gets.chomp.to_i

num_query.times do |n|
  puts "How many attractions would customer_#{n + 1} like to see?"  # these are irrelavant
  num_attr_to_see = gets.chomp.to_i
  puts "Enter attraction numbers ( space seperated please ): "
  destinations_arr = gets.split(' ').map{ |x| x.to_i }
  response << amuse_park_1.min_dist(destinations_arr) #this min_dist method will take any attraction number, walk through in sequence from one to another return the min distance
end
puts response
response





# puts "How Many Attractions, follow by how many @HOURS OPEN: "
# string = gets.chomp
# # string = '5 3'
# new_string = string.chars.reject { |attr_num| attr_num == ' ' }

# attractions = new_string.first.to_i
# hours_open = new_string.last.to_i

# theme_park = []
# attractions.times do
#   string = gets.chomp
#   theme_park << string.split(' ')
# end
# p theme_park
theme_park = [[30, 60, 75], [30, 15, 30], [30, 45, 60], [60, 45, 15], [99, 62, 99]]

answer_array = []
num_of_queries = gets.chomp.to_i
num_of_queries.times do
  arrival_time = gets.chomp.to_i
  num_to_see = gets.chomp.to_i
  str_arr = gets.chomp
  attractions_to_see = str_arr.chars.reject {|str| str == ',' || str == ' '}.map {|str| str.to_i }
  puts arrival_time
  p attractions_to_see
  p theme_park
  customer_q = CustomerQuery.new(arrival_time, attractions_to_see, theme_park)
  answer_array << customer_q.minimum_duration
end

puts answer_array
