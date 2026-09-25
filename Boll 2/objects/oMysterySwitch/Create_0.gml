event_inherited();

onreactivate_link = [];

on_sprite = spr_mysteryswitchon;
off_sprite = spr_mysteryswitchoff;
switch_state = false;

activateLink.Destroy();

activateLink.Connect(self, function(index, obj) {
	activated_by_link = true;
	switch(index) {
		case 0:
			hitSwitch.Emit();
		break;
		case 1:
			reactivateSwitch.Emit();
		break;
	}
});


hitSwitch.Destroy();

hitSwitch.Connect( self, function() {
	if !(switch_state) {
		trigger_links(ontrigger_link);
		
		switch_state = true;
		event_user(0);
		
		VinylPlay(snd_switch);
	}
});

reactivateSwitch = new Signal();

reactivateSwitch.Connect( self, function() {
	if (switch_state) {
		trigger_links(onreactivate_link);
		
		switch_state = false;
		event_user(0);
		
		VinylPlay(snd_switch);
	}
});