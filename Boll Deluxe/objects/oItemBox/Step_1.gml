event_inherited();

if (going) {
	flash=max(flash-1,0)
	image_index=sign(flash)
}

reduce_timer=max(reduce_timer-1,0)

if (content=="multicoins") && (reduce_timer) && (reduce_timer mod 10 >= 5) {
	amount=max(amount-1,times_hit+1)
	//when a multicoin block is counting after being hit, reduce amount by a little
}