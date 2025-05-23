with(player) {
	switch(other.itemfr) {
		case 0: //mushroom
		sig.Emit("mushroom");
		break;
		
		case 1: //10 coin
		global.coins_collected += 10;
		VinylPlay(snd_itemcoin);
		break;
		
		case 2: //fire flower
		sig.Emit("fireflower");
		break;
		
		case 4: //thunder flower
		sig.Emit("thunderflower");
		break;
		
		case 5: //star
		sig.Emit("star");
		break;
		
		case 9: //1up
		sig.Emit("1up");
		break;
		
		case 10: //3up
		sig.Emit("3up");
		break;
		
		case 12: //poison
		sig.Emit("poison");
		break;
	}
}

instance_destroy();