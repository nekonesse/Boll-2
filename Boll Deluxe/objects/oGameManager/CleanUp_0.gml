surface_free(HUDsurface)
var i=0;
repeat (array_length(playerPalettes)) {
	sprite_delete(playerPalettes[i]);
	i++;
}
instance_destroy(oBackgroundManager);
PlayerColl.Clear();
PlayerColl.Destroy();
delete PlayerColl;
CustomColl.Clear();
CustomColl.Destroy();
delete CustomColl;

audioExtSoundClear()
VinylMixVoicesStop("music")
VinylMixVoicesStop("sound effects")