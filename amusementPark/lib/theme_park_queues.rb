
class CustomerQuery
  attr_accessor :arrival_time, :time

  def initialize(arrival_time, attractions_to_see, theme_park)
    @theme_park = theme_park
    @arrival_time = arrival_time
    @attractions_to_see = attractions_to_see
    @time = @arrival_time
    @hour = @time/60
    @open_time = @theme_park.first.length * 60
    @duration = 0
  end

  def minimum_duration
    while @attractions_to_see && @hour <= @attractions_to_see.length
      @hour = @time/60
      dur_comp_arr = []
      attractions = @attractions_to_see.map { |attraction| @theme_park[attraction] }
      attractions.each do |attraction|
        this_hours_dur = attraction[@hour]
        next_hour_dur = attraction[@hour + 1]
        dur_comp_arr << [this_hours_dur, next_hour_dur]
      end
      best_choice = []
      dur_comp_arr.each do |ride_duration|
        index = dur_comp_arr.index(ride_duration)
        nxt_hr = ride_duration[1]
        wait_time = ((@hour + 1)*60) - @time + nxt_hr if nxt_hr
        if nxt_hr && wait_time < ride_duration[0]
          ride_duration[0] = wait_time
          ride_duration[1] = nil
          ride_duration[2] = index
        end
        if best_choice == [] || ride_duration[0] < best_choice[0]
          best_choice[0] = ride_duration[0]
          best_choice[1] = nxt_hr
          best_choice[2] = index
        elsif ride_duration[0] == best_choice[0]
          if nxt_hr && nxt_hr > best_choice[1]
            best_choice[0] = ride_duration[0]
            best_choice[1] = nxt_hr
            best_choice[2] = index
          end
        end
      end
      if best_choice[0]
        @duration += best_choice[0]
        @time = @duration + @arrival_time
        idx = best_choice[2]
        @attractions_to_see.delete_at(idx)
      end
    end
    if @arrival_time + @duration > @open_time
      return 'IMPOSSIBLE'
    else
      return @duration
    end
  end
end

string = gets.chomp
new_string = string.chars.reject { |attr_num| attr_num == ' ' }

attractions = new_string.first.to_i
hours_open = new_string.last.to_i

theme_park = []
attractions.times do
  theme_park << gets.chomp.split(' ').each { |attraction| attraction}.map { |x| x.to_i }
end

answer_array = []
num_of_queries = gets.chomp.to_i
num_of_queries.times do
  arrival_time = gets.chomp.to_i
  num_to_see = gets.chomp.to_i
  str_arr = gets.chomp
  attractions_to_see = str_arr.chars.reject {|str| str == ',' || str == ' '}.map {|str| str.to_i }
  customer_q = CustomerQuery.new(arrival_time, attractions_to_see, theme_park)
  answer_array << customer_q.minimum_duration
end

puts answer_array
