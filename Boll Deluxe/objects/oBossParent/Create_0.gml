var col;
if (global.roomTimer & 1) {
	hit_type = "sonic"
	tint = #0000FF
} else {
	hit_type = "mario"
	tint = #FF0000
}
hp = 3
vsp = 0
hsp = 0
grounded = false
invincible = false

col=instance_place(x,y,oCollider)
var i=0
while (col >= 0 && i < 16) {
	y = col.y - floor(sprite_height / 2)
	col = instance_place(x,y,oCollider)
	i += 1
}