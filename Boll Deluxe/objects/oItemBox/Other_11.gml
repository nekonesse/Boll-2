///@description Empty Contents on finish
switch (content) {
	case "mushroom": {
		var i=instance_create_depth(x,y,0,oMushroom)
		i.going=hit
		i.parentblock=id
		VinylPlay(snd_itemappear);
	} break;
}