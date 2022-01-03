$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Roller
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("roller", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)      
		case cmd.root
		when "roll"
			if(cmd.switch_is?("t"))
				return Roll10Cmd
			elsif (cmd.switch_is?("n"))
				return Roll9Cmd
			elsif (cmd.switch_is?("e"))
				return Roll8Cmd
			elsif (cmd.switch_is?("s"))
				return Roll7Cmd
			else
				return RollCmd
			end
		end
		return nil
    end

  def self.get_web_request_handler(request)
      case request.cmd
      when "roll/t"
        return RollWebRequestHandler
      end
      nil
    end

  end
end
