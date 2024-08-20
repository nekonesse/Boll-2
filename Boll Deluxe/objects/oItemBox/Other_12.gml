///@description Empty Contents on bump
switch (content) {
	case "coin": 
	case "multicoins": {
		var i=instance_create_depth(x,y,0,pCoinCollected)
		i.vspeed=3*hit
		VinylPlay(snd_itemcoin);
		global.coins_collected++;
	} break;
}