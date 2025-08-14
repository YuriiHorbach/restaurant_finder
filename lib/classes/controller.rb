require_relative 'guide'

module RFinder
  class Controller

    @@valid_actions = ['list', 'add', 'help', 'quit', 'find']

    def initialize
      @guide = RFinder::Guide.new
    end

    def launch!
      introduction

      loop do
        action, args = get_action
        break if action == 'quit'
        do_action(action, args)
      end

      conclusion
    end

    private

    def introduction
      puts "Welcome to the Restaurant finder"
      puts "This interface guide you thougs all process"
    end

    def conclusion
      puts "Bye bye"
    end

    def get_action
      action = nil

      until @@valid_actions.include? action
        puts "\nActions #{@@valid_actions}, "
        print ">"
        response = gets.chomp
        args = response.downcase.strip.split(' ')
        action = args.shift
      end
      [action, args]
    end

    def do_action(action, args = [])
      case action
      when 'help'
        @guide.help
      when 'list'
        @guide.list(args)
      when 'add'
        @guide.add
        @guide.list
      when 'find'
        keyword = args.shift || get_keyword
        @guide.find(keyword)
      else
        puts "I do not understand this command"
      end
    end

    def get_keyword
      puts 'Type your search phrase'
      gets.chomp
    end
  end
end
