require "alt-foreman/version"
require 'thread'
require 'term/ansicolor'

module Alt
  module Foreman
    @mutex = Mutex.new
    @senders = {}
    @colours = [:blue, :red, :yellow, :cyan, :green]
    def self.log(sender, line, line_colour = nil)
      @mutex.synchronize do
        colour = @senders[sender]
        unless colour
          colour = @senders[sender] = @colours[@senders.size % @colours.size]
        end
        line = line.chomp
        if line_colour
          line = Term::ANSIColor.send(line_colour, line)
        end
        puts Term::ANSIColor.send(colour, Term::ANSIColor.bold(sprintf '%s %15s | ', Time.now.strftime('%H:%M:%S'), sender) + line)
      end
    end
  end
end
