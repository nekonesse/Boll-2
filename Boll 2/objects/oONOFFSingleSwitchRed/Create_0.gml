event_inherited();

on_sprite = spr_onoffsingleswitchon_red;
off_sprite = spr_onoffsingleswitchoff_red;
switch_state = false;

hitSwitch.Destroy();

hitSwitch.Connect( self, function() {
	if !(switch_state) {
		with(oGameManager) {
			event_user(14);
		}
		
		trigger_links(ontrigger_link);
		
		VinylPlay(snd_switch);
	}
});