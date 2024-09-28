global.roomTimer=0
global.player_spritelists[0][0]="";
if room==rLDTKload||room==rGame {
	PlayerColl=new Collage("Players", 4096, 4096, false, 1, true)
	import_sheets();
}