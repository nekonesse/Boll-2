/// @desc Configs

// REMEMBER TO TURN ON "disable file system sandbox" WHEN USING LIVE UPDATING
// ...and to set this macro to 0 when building the game!
#macro LDTK_LIVE 1

if (LDTK_LIVE) {
	LDtkConfig({
		file: working_directory+"\mods\\level\\"+global.nextlevel+"\\level.ldtk",
		
		level_name: "Level",
		escape_fields: true
	})
}
else {
	LDtkConfig({
		file: working_directory+"\mods\\level\\"+global.nextlevel+"\\level.ldtk",
		
		level_name: "Level",
		escape_fields: true
	})
}



LDtkMappings({
	layers: {
		Foreground_Tiles_2: "Foreground_Tiles_2",
		Foreground_Tiles: "Foreground_Tiles",
		FG_Decor_Tiles: "FG_Decor_Tiles",
		Misc_Entities: "Misc_Entities",
		Ground_Tiles: "Ground_Tiles",
		Entities: "Entities",
		Tiles: "Misc_Tiles",
		BG_Decor_Tiles: "BG_Decor_Tiles",
		Semisolid_Tiles: "Semisolid_Tiles",
		Semisolid_Tiles_2: "Semisolid Tiles_2",
		Background_Tiles: "Background_Tiles",
		Background_Tiles_2: "Background_Tiles_2",
		Collision_Layer: "CollisionLayer"
	},
	tilesets: {
		Tileset_Main: "tTilesetMain",
		Tileset_Extra: "tTilesetExtra",
		Tileset_Animated4: "tTilesetAnimated4",
		Tileset_Animated8: "tTilesetAnimated8",
		Assets_Main: "tAssetsMain",
		Assets_Extra:"tAssetsExtra",
		Assets_Animated4: "tAssetsAnimated4",
		Assets_Animated8: "tAssetsAnimated8"
	}
})