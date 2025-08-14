require_relative '../support/number_helper'

module RFinder
  class Restaurant
    include NumberHelper

    attr_accessor :name, :cuisine, :price

    def self.add_new_record
      args = {}

      puts 'Enter restaurant name'
      args[:name] = gets.chomp

      puts 'Enter restaurants cuisine'
      args[:cuisine] = gets.chomp

      puts 'Enter price'
      args[:price] = gets.chomp.to_i

      self.new(args)
    end

    def initialize(args = {})
      @name = args[:name] || ''
      @cuisine = args[:cuisine] || ''
      @price = args[:price] || ''
    end

    def formated_price
      number_to_currency(@price)
    end
  end
end
