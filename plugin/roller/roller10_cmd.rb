module AresMUSH
  module Roller
    class Roll10Cmd
      include CommandHandler

		def parse_args
		end

		
		def handle
			diceRolled = trim_arg(cmd.args).to_i
			
			arr = Array.new
		
			for i in 0..(diceRolled-1) do
				looped = false
				temp = rand(10) + 1
				total = temp
				arr.push("[")
				while temp == 10
					looped = true
					arr.push(temp)
					arr.push("+")
					temp = rand(10) + 1
					total += temp
				end
				if (looped)
					arr.push(temp)
					arr.push("=")
				end
				arr.push(total)
				arr.push("]")
				arr.push(",")
			end
			message = enactor.name + " rolled " + diceRolled.to_s + " with explosions on 10 : " + arr.join
			
			Scenes.add_to_scene(enactor_room.scene, message, Game.master.system_character, false, true)
			enactor_room.emit message
			Scenes.emit_pose(Game.master.system_character, message, true, true)
				
				
		end
    end
  end
end