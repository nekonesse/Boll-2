/// @description Insert description here
// You can write your code in this editor
var player = oPlayer
if (player.grounded && place_meeting(x, y-3, oPlayer))
{
	player.x += x_diff;
	player.y = y-(player.bbox_bottom - player.bbox_top) -4
	
}