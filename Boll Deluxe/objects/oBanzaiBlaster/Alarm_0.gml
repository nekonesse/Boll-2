var dir=sign(nearestplayer().x-x)
var coll = collision_rectangle(x+32-(48*dir),y,x+32-(32*dir),y+64,oCollider,false,true)
if !coll || (coll && coll.no_collide) || (coll && coll.semi) {
	var i=instance_create_depth(x+32,y+32,depth+2,oBanzaiBill);
	i.hsp=dir*2
	i.spawn_object=id
	xscale=1.33;
	yscale=1.33;
}
alarm[0]=120;