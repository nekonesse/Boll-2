var underwaterMusic = false;
with(oPlayer) {
	if in_water() underwaterMusic = true;
}


if VinylIsPlaying(fgMusic) {
	if (underwaterMusic) {
		VinylSetGain(fgMusic, 0.05, 0.5)
		VinylSetGain(bgMusic, 0.15, 0.5)
	} else {
		VinylSetGain(fgMusic, 0.2, 0.5)
		VinylSetGain(bgMusic, 0.2, 0.5)
	}
}