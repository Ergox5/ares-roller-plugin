import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
    gameApi: service(),
    flashMessages: service(),
    tagName: '',
    selectCustomRoll: false,
	hasRote: false,
	explode: null,
	reason: null,
    rollString: null,
    destinationType: 'scene',

    didInsertElement: function() {
      this._super(...arguments);
      let defaultAbility = this.abilities ? this.abilities[0] : '';
      this.set('rollString', defaultAbility);
    },


    actions: { 
      
      addRoll() {
        let api = this.gameApi;
		
        // Needed because the onChange event doesn't get triggered when the list is 
        // first loaded, so the roll string is empty.
        let rollString = this.rollString;
        let hasRote = this.hasRote;
        let explode = this.explode;
        let reason = this.reason;
        
		if (!explode) {
          explode = "t";
        }
		
		
        var sender;
        if (this.scene) {
          sender = this.get('scene.poseChar.name');
        }
          
        if (!rollString) {
          this.flashMessages.danger("You haven't entered any dice to roll.");
          return;
        }
		          
        if (!rollString.match("^[A-Za-z0-9]+$")) {
          this.flashMessages.danger("Something is wrong with the format of your entry ");
          return;
        }
		
		if (!(/^\d+$/.test(rollString))){
			
			let testString =  rollString.toLowerCase();
			testString = testString.split('d');
			
			
			if (testString.length != 2){
				this.flashMessages.danger("Incorrect Syntax, too many or too few parameters");
				return;
			}
			
			if (!(/^\d+$/.test(testString[0]) || /^\d+$/.test(testString[1]))){
				this.flashMessages.danger("Incorrect Syntax, detected non-numbers");
				return;
			}
		}
		if ( parseInt(rollString) > 30){
			this.flashMessages.danger("Do not exceed 30 dice when trying to roll");
			return;
		}
		
      

        this.set('selectCustomRoll', false);
        this.set('rollString', null);
        this.set('hasRote', false);
        this.set('explode', null);
        this.set('reason', null);
		
        var destinationId, cmd;

        destinationId = this.get('scene.id');
        cmd = "customroller";
        api.requestOne(cmd, {id: destinationId,
			dice_string: rollString,
			hasRote: hasRote,
			explode: explode,
			reason: reason,
			sender: sender }, null)
        .then( (response) => {
          if (response.error) {
            return;
          }
        });
      },
    }
});
