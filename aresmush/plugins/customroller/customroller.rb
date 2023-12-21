$:.unshift File.dirname(__FILE__)

module AresMUSH
    module CustomRoller

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      Global.read_config("shortcuts")
    end
	
	def self.get_web_request_handler(request)
      case request.cmd
      when "customroller"
        return RollWebRequestHandler
      end
      nil
    end
	
    def self.get_cmd_handler(client, cmd, enactor)      
		case cmd.root
		when "roll"
			if(cmd.switch_is?("t") || cmd.switch_is?("tr") || cmd.switch_is?("n") || cmd.switch_is?("nr") || cmd.switch_is?("e") || cmd.switch_is?("er") || cmd.switch_is?("f"))
				return CustomRollerCmd
			end
		end
		nil
    end

    def self.get_event_handler(event_name)
      nil
    end



  end
end
