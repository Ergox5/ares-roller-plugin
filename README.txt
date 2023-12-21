You need to add 2 lines of code to have the button show up in the dropdown menu:

In the live-scene-control.hbs located in ares-webportal\app\templates\components :

*Add the following in the dropdowmeenu with the id playMenu:
<li><a href="#" {{action (mut this.selectCustomRoll) true}} class="dropdown-item">Custom Roll</a></li>

*Add the following after the {{/if}} of that list:
<CustomRoller @scene={{this.scene}} @destinationType="scene" @selectCustomRoll={{this.selectCustomRoll}} /> 
    
There is a picture included to help show you where to add these lines of code.
         
Next:
add custom-roller.js to ares-webportal\app\components
add custom-roller.hbs to ares-webportal\app\templates\components
add the contents of the plugin folder to aresmush\plugins


Redeploy website from Admin -> Manage -> Redeploy website
type "load customroller" without quotations in ares webclient


Webclient commands:
roll/t		rolls d10's with explosions on 10
examples:
roll/t 5			rolls 5 d10's with explosions on 10 
roll/t 5 ReasonHere		rolls 5 d10's with explosions on 10 with the reason being "ReasonHere"

roll/tr				rolls d10's with explosions on 10 and Rote
examples:
roll/tr 5			rolls 5 d10's with explosions on 10 and Rote
roll/tr 5 GM asked		rolls 5 d10's with explosions on 10 and Rote with the reason being "GM asked"

the next four commands follow the same structure:
roll/n				rolls d10's with explosions on 10 and 9
roll/nr				rolls d10's with explosions on 10 and 9 with Rote
roll/e				rolls d10's with explosions on 10, 9 and 8
roll/er				rolls d10's with explosions on 10, 9 and 8 with Rote


roll/f 	
roll/f 10d10
roll/f 5d5

				