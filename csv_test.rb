require 'csv'
filename  = 'products.csv'

sub_total_array = [0]
rolling_total = 0
coffee_selection = nil
num_of_items = nil
quantity = {}

puts "Welcome to James' Coffee Emporium!"
  product_list = []
  rows = 1
    CSV.foreach(filename, headers: true) do |row|
      product_hash = {}
      product_hash[:sku] = row["SKU"].to_i
      product_hash[:name] = row["name"].to_s
      product_hash[:w_price] = row["wholesale_price"].to_f
      product_hash[:r_price] = row["retail_price"].to_f
      product_list << product_hash
      quantity["#{rows}"] = 0
      puts "#{rows}) Add item - $#{"%.2f" % product_list[rows-1][:r_price]} - #{product_list[rows-1][:name]}"
      rows += 1
    end
puts "#{rows}) Complete sale"

  while coffee_selection != "#{rows}"
    puts "Make a selection:"
    coffee_selection = gets.chomp
      if coffee_selection == "#{rows}"
        puts quantity
        puts "=======Sale Complete======="
          quantity.each {|key, value|
            if quantity[key] > 0
              total_item_cost = quantity[key] * product_list[key.to_i - 1][:r_price]
              puts "#{quantity[key]}x #{product_list[key.to_i - 1][:name]} - $#{"%.2f" % total_item_cost}"
                CSV.open("receipt.csv", "a") do |csv|
                csv << [quantity[key], product_list[key.to_i - 1][:sku]]
                end
            end
          }
        final = sub_total_array.inject(:+)
        puts "Total: $#{"%.2f" % final}"
        puts "====James says thanks!====="

        break
      end

    puts "How many?"
    num_of_items = gets.chomp.to_i
    quantity[coffee_selection.to_s] = quantity[coffee_selection.to_s] + num_of_items.to_i

    sub_total = num_of_items * product_list[coffee_selection.to_i - 1][:r_price].to_f
    rolling_total = sub_total + sub_total_array.inject(:+)

    puts "Subtotal: $#{"%.2f" % rolling_total}"
    sub_total_array << sub_total
  end
