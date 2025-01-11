if (huge) {
	radius = 64
	sprite_index = spr_pHugeExplosion
	VinylPlay(snd_enemybigexplode);
	amount = floor(random_range(5,7.9));
	exit;
}

VinylPlay(snd_enemyexplode);