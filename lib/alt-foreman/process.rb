require 'shellwords'

module Alt
  module Foreman
    class Process
      attr_reader :name, :cmd, :pid
      def initialize(name, cmd)
        @name, @cmd = name, cmd
      end
      def log(info, col = nil)
        Alt::Foreman.log(@name, info, col)
      end
      def run
        args = Shellwords.split(@cmd)
        args.each_with_index do |arg, index|
          if arg =~ /-p(\d+)/
            Foreman.kill_tcp_server!($1, @name)
          elsif arg == '-p' && args[index+1] =~ /\d+/
            Foreman.kill_tcp_server!(args[index+1], @name)
          end
        end

        IO.popen(@cmd, 'rb') do |io|
          @pid = io.pid
          while line = io.gets
            log(line)
          end
        end
      end
    end


    module_function
    def kill_tcp_server!(need_port, name)
      tries = 0
      loop do
        found = false

        `netstat -nWlp 2>/dev/null|grep '^tcp '`.each_line do |line|
          _, _, _, addr, _, what, program = line.strip.split(/\s+/)
          ip, port = addr.split(%r/:/)
          pid, process = program.split(%r:/:)

          if (port.to_i == need_port.to_i) && (pid.to_i > 0)
            found = true
            sig = (tries <= 5 ? 'TERM' : 'KILL')
            Alt::Foreman.log(name, "Found conflicting server process - sending #{sig} to #{pid} & sleeping for 2s", :red)
            ::Process.kill(sig, pid.to_i)
            sleep 2
            tries += 1
          end
        end

        return unless found

        if found && tries > 15
          STDERR.puts "Failed to kill existing process - continuing anyway."
          return
        end
      end
    end
  end
end
