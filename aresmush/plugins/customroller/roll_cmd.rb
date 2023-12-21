module AresMUSH
  module CustomRoller
    class RollCmd
      include CommandHandler

		def parse_args

		end

		
		def handle
		
			#client.emit_success cmd.args
			diceRolled = trim_arg(cmd.args)
			args = cmd.args.split(" ")
			argN = args.length
			#client.emit_success argN
			if (argN == 1)
				onlyNumbers = true;
				if diceRolled !~ /\D/
					onlyNumbers = true;
				else
					onlyNumbers = false;
				end
				arr = Array.new	
				message = ""
				if (onlyNumbers)
					for i in 0..(diceRolled.to_i-1) do
						arr.push("[")
						arr.push(rand(10) + 1)
						arr.push("]")
						arr.push(",")
					end
					arr.pop();  # removes last comma
					message = enactor.name + " rolled " + diceRolled.to_s + " with no explosions: " + arr.join
					Scenes.add_to_scene(enactor_room.scene, message, Game.master.system_character, false, true)
					enactor_room.emit message
					Scenes.emit_pose(Game.master.system_character, message, true, true)
					
				else
					strArr = diceRolled.split("d")
					for i in 0..(strArr[0].to_i-1) do
						arr.push("[")
						arr.push(rand(strArr[1].to_i) + 1)
						arr.push("]")
						arr.push(",")
					end
					message = enactor.name + " rolled " + strArr[0]+"d"+strArr[1] + " and got: " + arr.join
					Scenes.add_to_scene(enactor_room.scene, message, Game.master.system_character, false, true)
					enactor_room.emit message
					Scenes.emit_pose(Game.master.system_character, message, true, true)
				end
			else 
				#client.emit_success "WE HERE NOW"
				onlyNumbers = true;

				arr = Array.new	
				message = ""

				for i in 0..(diceRolled.to_i-1) do
					arr.push("[")
					arr.push(rand(10) + 1)
					arr.push("]")
					arr.push(",")
				end
				arr.pop();  # removes last comma
				message = enactor.name + " rolled " + args[1..].join(" ") + " " + args[0] + " with no explosions: " + arr.join 
				Scenes.add_to_scene(enactor_room.scene, message, Game.master.system_character, false, true)
				enactor_room.emit message
				Scenes.emit_pose(Game.master.system_character, message, true, true)

			end
		end
    end
  end
end