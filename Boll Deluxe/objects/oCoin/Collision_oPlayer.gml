global.coins_collected++;
if !VinylIsPlaying(snd_itemcoin) VinylPlay(snd_itemcoin);
instance_create_depth(x,y,0,pCoinCollected);
instance_destroy();