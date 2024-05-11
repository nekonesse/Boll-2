/// @description Insert description here
// You can write your code in this editor



pl=instance_place(x,y-2-abs(y_diff),oPlayer);

if (pl) && (pl.grounded) {
	pl.x += x_diff;
	pl.y += y_diff;
}