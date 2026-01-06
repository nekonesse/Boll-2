if eject != 0 && (content == "multicoins") {
	eject = 0;
}

event_inherited();

if (hidden) {
	visible = 0;
	ceiling_only = 1
} else {
	ceiling_only = 0	
}

if (going) {
	if !(amount) {
		flash = max(flash-1,0)
		image_index = sign(flash)
	} else {
		image_index = 1
	}
} else image_index = 0

reduce_timer=max(reduce_timer-1,0)

if (content=="multicoins") && (reduce_timer) && (reduce_timer mod 10 >= 5) {
	amount=max(amount-1,times_hit+1)
	//when a multicoin block is counting after being hit, reduce amount by a little
}