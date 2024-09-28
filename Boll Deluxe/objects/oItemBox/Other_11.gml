///@description Empty Contents on finish
switch (content) {
	case "mushroom": {
		var i=instance_create_depth(x,y,0,oMushroom)
		i.going=hit
		i.parentblock=id
		VinylPlay(snd_itemappear);
	} break;
	case "fireflower": {
		var i=instance_create_depth(x,y,0,oFireFlower)
		i.going=hit
		i.parentblock=id
		VinylPlay(snd_itemappear);
	} break;
	case "thunderflower": {
		var i=instance_create_depth(x,y,0,oThunderFlower)
		i.going=hit
		i.parentblock=id
		VinylPlay(snd_itemappear);
	} break;
}