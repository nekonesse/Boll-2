event_inherited();

on_sprite = spr_onoffsingleswitchon_red;
off_sprite = spr_onoffsingleswitchoff_red;
switch_state = false;

hitSwitch.Destroy();

hitSwitch.Connect( self, function(_obj) {
	if !(switch_state) {
		with(oGameManager) {
			event_user(14);
		}
		
		if (_obj.object_index == oPlayer) || object_is_ancestor(_obj.object_index,oEnemy) && (image_angle == 0) {
			_obj.vsp=0;
		}
		
		trigger_links(ontrigger_link);
		
		VinylPlay(snd_switch);
	}
});