surface_free(HUDsurface)
for (var i = 0; i < array_length(playerPalettes); ++i) {
	sprite_delete(playerPalettes[i]);
}
instance_destroy(oBackgroundManager);
PlayerColl.Clear();
PlayerColl.Destroy();
delete PlayerColl;

VinylMixVoicesStop("music")
VinylMixVoicesStop("sound effects")