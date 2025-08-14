#!/usr/bin/env ruby
require_relative 'lib/classes/guide.rb'
require_relative 'lib/classes/controller.rb'
require_relative 'lib/support/string_extender_helper'

APP_ROOT = File.expand_path(File.dirname(__FILE__))
#File.expand_path transform relative path in absolute path
#File.dirname(__FILE__) shows current directory
#__FILE__ this is a path to a this file

require_relative 'lib/classes/controller.rb'

begin
  guide = RFinder::Controller.new
  guide.launch!
rescue => e
  puts "An error occured"
  puts e.message
end
