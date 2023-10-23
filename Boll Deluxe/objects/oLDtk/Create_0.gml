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
		Ground_Tiles: "Ground_Tiles",
		Misc_Entities: "Misc_Entities",
		Entities: "Entities",
		Collision_Tiles: "CollisionLayer"
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