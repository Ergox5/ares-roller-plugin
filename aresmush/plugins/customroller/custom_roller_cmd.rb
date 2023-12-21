module AresMUSH
  module CustomRoller
    class CustomRollerCmd
      include CommandHandler

		def parse_args
		end

		
		def handle
		
			
			#client.emit_success cmd
			#client.emit_success cmd.switch
			
			args = list_arg(cmd.args)
			reason = args[1..].join(' ')
			headerMessage = ""
			
			if args[0].to_i > 30
				tooManyDice = " Do not exceed 30 dice when trying to roll please " 
				Scenes.add_to_scene(enactor_room.scene, tooManyDice)
				enactor_room.emit tooManyDice
				Scenes.emit_pose(Game.master.system_character, tooManyDice, true, true)
			end 

			
			
			
			successess = 0
			roteSuccesses = 0
			explodeRange = []
			textRange = ""
			if (cmd.switch_is?("t") || cmd.switch_is?("tr"))
				explodeRange = [10]
				textRange = " with explosions on 10 : "
			elsif (cmd.switch_is?("n") || cmd.switch_is?("nr"))
				explodeRange = [10,9]
				textRange = " with explosions on 10 and 9 : "
			elsif (cmd.switch_is?("e") || cmd.switch_is?("er"))
				explodeRange = [10,9,8]
				textRange = " with explosions on 10, 9 and 8 : "
			else 
				 textRange = " without explosions: "
			end
			
			roteValue = false
			roteLoop = 1
			
			if (cmd.switch_is?("tr") || cmd.switch_is?("nr") || cmd.switch_is?("er"))
				roteValue = true
				roteLoop = 2
			end
			
		
				
			if (reason != "")
				headerMessage = enactor.name + " rolling for reason: " + reason
			else 
				headerMessage = enactor.name + " rolling: "
			end
			
			if (cmd.switch_is?("f"))# Handle normal rolls
			
				strArr = args[0].split("d")
				diceNum =  Integer(strArr[0]) rescue return
				diceSide =  Integer(strArr[1]) rescue return
				if strArr.length() == 2 && diceNum && diceSide
									
						
						Scenes.add_to_scene(enactor_room.scene, headerMessage, Game.master.system_character, false, true)
						enactor_room.emit headerMessage
						Scenes.emit_pose(Game.master.system_character, headerMessage, true, true)
						
						message = Utils.roll_dice(enactor.name, diceNum, diceSide)
	  
						if (!message)
							return { error: t('dice.invalid_dice_string') }
						end
						Scenes.add_to_scene(enactor_room.scene, message)
						enactor_room.emit message
						Scenes.emit_pose(Game.master.system_character, message, true, true)

				else
					
					message = "Not Correct Format, report this to developer" + dice_str
					Scenes.add_to_scene(enactor_room.scene, message)
					enactor_room.emit message
					Scenes.emit_pose(Game.master.system_character, message, true, true)

				end
				
			
			else #Handle rolls with explosions

				Scenes.add_to_scene(enactor_room.scene, headerMessage, Game.master.system_character, false, true)
				enactor_room.emit headerMessage
				Scenes.emit_pose(Game.master.system_character, headerMessage, true, true)

				for loopCount in 1..roteLoop do 
					if  loopCount == 1
						diceRolled = args[0].to_i
					else
						diceRolled = args[0].to_i - successess
					end
					
					arr = Array.new
					for i in 0..(diceRolled-1) do
						looped = false
						temp = rand(10) + 1
						if (temp >= 8)
							if  loopCount == 1
								successess = successess + 1
							else
								roteSuccesses = roteSuccesses + 1
							end
						end
						total = temp
						arr.push("[")
						while explodeRange.include?(temp)
							looped = true
							arr.push(temp)
							arr.push("+")
							temp = rand(10) + 1
							if (temp >= 8)
								if  loopCount == 1
									successess = successess + 1
								else
									roteSuccesses = roteSuccesses + 1
								end
							end
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
					arr.pop();  # removes last comma
					if  loopCount == 1
						message = enactor.name + " rolled " + diceRolled.to_s + textRange + arr.join + " for " + successess.to_s + " successess"
						
						Scenes.add_to_scene(enactor_room.scene, message)
						enactor_room.emit message
						Scenes.emit_pose(Game.master.system_character, message, true, true)
					else
						roteMessage = enactor.name + " used Rote to reroll " + diceRolled.to_s + textRange + arr.join + " for " + roteSuccesses.to_s + " successes"
				
						Scenes.add_to_scene(enactor_room.scene, roteMessage)
						enactor_room.emit roteMessage
						Scenes.emit_pose(Game.master.system_character, roteMessage, true, true)
						
						successMessage = enactor.name + " earned " + (roteSuccesses + successess).to_s + " total successess"
						Scenes.add_to_scene(enactor_room.scene, successMessage)
						enactor_room.emit successMessage
						Scenes.emit_pose(Game.master.system_character, successMessage, true, true)
					end
					
				end
			
			end
		end
    end
  end
end