module AresMUSH
  module CustomRoller
    class RollWebRequestHandler
      def handle(request)
        scene = Scene[request.args[:id]]
        enactor = request.enactor
		
        dice_str = request.args[:dice_string]
        hasRote = request.args[:hasRote]
        explode = request.args[:explode]
        reason = request.args[:reason]
		

        if (!scene)
          return { error: t('webportal.not_found') }
        end
        


        if (!Scenes.can_read_scene?(enactor, scene))
          return { error: t('scenes.access_not_allowed') }
        end
        
        if (scene.completed)
          return { error: t('scenes.scene_already_completed') }
        end
        
        if (!scene.room)
          raise "Trying to emit to a scene that doesn't have a room."
        end

		#Check the string passed in to see if there is a more than just numbers
		onlyNumbers = dice_str !~ /\D/ 
		
		
		if onlyNumbers && (dice_str.to_i > 30)
			return { error: t('Do not exceed 30 dice when trying to roll please') } 
		end
		
		
		if reason == ""
			headerMessage = enactor.name + " rolling: "
		else 
			headerMessage = enactor.name + " rolling for reason: " + reason
		end
		
		Scenes.add_to_scene(scene, headerMessage)
		scene.room.emit headerMessage
		Scenes.emit_pose(Game.master.system_character, headerMessage, true, true)
		
		if onlyNumbers	
			successess = 0
			roteSuccesses = 0
			explodeRange = []
			textRange = ""
			
	

			if explode == "t"	
				explodeRange = [10]
				textRange = " with explosions on 10 : "
			elsif explode == "n"
				explodeRange = [10,9]
				textRange = " with explosions on 10 and 9 : "
			elsif explode == "e"
				explodeRange = [10,9,8]
				textRange = " with explosions on 10, 9 and 8 : "
			else
				textRange = " without explosions: "
			end
			
			

			roteValue = false
			roteLoop = 1
			
			if hasRote == "true"
				roteValue = true
				roteLoop = 2
			end

			
			for loopCount in 1..roteLoop do 
				if  loopCount == 1
					diceRolled = dice_str.to_i
				else
					diceRolled = dice_str.to_i - successess
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
					Scenes.add_to_scene(scene, message)
					scene.room.emit message
					Scenes.emit_pose(Game.master.system_character, message, true, true)
				else
					roteMessage = enactor.name + " used Rote to reroll " + diceRolled.to_s + textRange + arr.join + " for " + roteSuccesses.to_s + " successes"
			
					Scenes.add_to_scene(scene, roteMessage)
					scene.room.emit roteMessage
					Scenes.emit_pose(Game.master.system_character, roteMessage, true, true)
					
					successMessage = enactor.name + " earned " + (roteSuccesses + successess).to_s + " total successess"
					Scenes.add_to_scene(scene, successMessage)
					scene.room.emit successMessage
					Scenes.emit_pose(Game.master.system_character, successMessage, true, true)
				end
				
			end
		else
		
			testString = dice_str.downcase
			testString = testString.split('d')
			if testString.length() == 2
			        message = Utils.roll_dice(enactor.name, testString[0].to_i, testString[1].to_i)
  
					if (!message)
						return { error: t('dice.invalid_dice_string') }
					end
					Scenes.add_to_scene(scene, message)
					scene.room.emit message
					Scenes.emit_pose(Game.master.system_character, message, true, true)
			else
				
				message = "Not Correct Format, report this to developer" + dice_str
				scene.room.emit_ooc message
				Scenes.add_to_scene(scene, message)
			end
			
		end
		
	
		


		
		
        {}
      end
    end
  end
end