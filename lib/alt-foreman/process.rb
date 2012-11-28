module Alt
  module Foreman
    class Process
      attr_reader :name, :cmd
      def initialize(name, cmd)
        @name, @cmd = name, cmd
      end
      def run
        IO.popen(@cmd, 'rb') do |io|
          while line = io.gets
            Alt::Foreman.log(@name, line)
          end
        end
      end
    end
  end
end
