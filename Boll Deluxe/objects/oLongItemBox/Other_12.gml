///@description Empty Contents on bump
switch (content) {
	case "coin": 
	case "multicoins": {
		var i=instance_create_depth(x,y,0,pCoinCollected)
		i.vspeed=3*hit
		i.gravity=0.15*-sign(i.vspeed)
		VinylPlay(snd_itemcoin);
		global.coins_collected++;
	} break;
}
//extra coins
var i=instance_create_depth(x-16,y,0,pCoinCollected)
i.vspeed=3*hit
i.gravity=0.15*-sign(i.vspeed)
var i=instance_create_depth(x+16,y,0,pCoinCollected)
i.vspeed=3*hit
i.gravity=0.15*-sign(i.vspeed)
if content!="coin" && content!="multicoins" VinylPlay(snd_itemcoin); //prevent sound overlap
global.coins_collected+=2;