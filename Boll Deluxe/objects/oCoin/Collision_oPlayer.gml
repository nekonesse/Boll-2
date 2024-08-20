global.coins_collected++;
VinylPlay(snd_itemcoin);
instance_create_depth(x,y,0,pCoinCollected);
instance_destroy();