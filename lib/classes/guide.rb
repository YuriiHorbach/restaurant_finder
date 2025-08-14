require 'byebug'
require 'csv'
require_relative 'controller'
require_relative 'restaurant'

module RFinder
  class Guide
    @@file_storage = 'restaurants.csv'
    @@total_width = 60

    def initialize
      initialize_storage_file
      self
    rescue => e
      puts e.message
    end


    def list(args=[])
      output_headers 'Hello'
      sort_order = extract_sort_order(args)
      restaurants = sort_restaurants(all_restaurants, sort_order)
      list_output restaurants
    end

    def find(keyword='')
      output_headers 'Item search'
      restaurants = filter_restaurants(all_restaurants, keyword)
      list_output restaurants
    end

    def add
      restaurant = RFinder::Restaurant.add_new_record
      array = [restaurant.name, restaurant.cuisine, restaurant.price]
      CSV.open(@storage_path, 'a') do |row|
        row << array
      end
    end

    def help
      output_headers('< Help guide >')
      puts "list: list all records"
      puts "sort by: name, cuisine, price"
      puts "Example: 'list cuisine'"
      puts
      puts "find: find a restaurant using a keyword"
      puts "Example: 'find mex' or 'find 25'"
      puts
      puts "add: add a new restaurant to the list"
      puts
    end

    private

    def initialize_storage_file
      @storage_path = File.join(APP_ROOT, @@file_storage)

      unless File.exist? @storage_path
        create_storage_file
      end

      unless strogare_file_usable?
        raise "Storage file is not usable."
      end
    end

    def create_storage_file
      headers = "#{['Name', 'Cuisine', 'Prices'].join(',')}\n"
      File.write(@storage_path, headers)
    end

    def strogare_file_usable?
      return false unless @storage_path
      return false unless File.exist? @storage_path
      return false unless File.readable? @storage_path
      return false unless File.writable? @storage_path
      return true
    end

    def all_restaurants
      restaurants = []
      CSV.foreach(@@file_storage, headers: true) do |row|
        restaurant = RFinder::Restaurant.new({
            name: row['Name'],
            cuisine: row['Cuisine'],
            price: row['Price']
          })
        restaurants << restaurant
      end
      restaurants
    end

    def output_headers(text)
      text_with_spaces = " #{text} "
      puts "\n#{text_with_spaces.upcase.center(@@total_width)}\n\n"
    end

    def list_output(restaurants = [])
      div = ' '
      col = [30, 15, 10]
      print div + 'Name'.ljust(col[0])
      print div + 'Cuisine'.ljust(col[1])
      print div + 'Price'.rjust(col[2])
      print "\n"
      print '-' * @@total_width + "\n"
      restaurants.each do |rest|
        print div + rest.name.titelize.ljust(col[0])
        print div + rest.cuisine.titelize.ljust(col[1])
        print div + rest.formated_price.rjust(col[2])
        print "\n"
      end
      puts "No restaurants found" if restaurants.empty?
      print '-' * @@total_width
    end

    def extract_sort_order(args = [])
      valid_sort_order = ['name', 'cuisine', 'price']
      order = args.shift
      order = args.shift if order == 'by'
      order = 'name' unless valid_sort_order.include? order
      order
    end

    def sort_restaurants(restaurants, sort_order='name')
      restaurants.sort do |r1, r2|
        case sort_order
        when 'name'
          r1.name.downcase <=> r2.name.downcase
        when 'cuisine'
          r1.cuisine.downcase <=> r2.cuisine.downcase
        when 'price'
          r1.price.downcase.to_i <=> r2.price.downcase.to_i
        end
      end
    end

    def filter_restaurants(restaurants, keyword)
      keyword = keyword.downcase
      restaurants.select do |record|
        record.name.downcase.include?(keyword) ||
        record.cuisine.downcase.include?(keyword) ||
        keyword.to_i <= record.price.to_i
      end
    end
  end
end
