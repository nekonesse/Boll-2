/// @desc Configs

// REMEMBER TO TURN ON "disable file system sandbox" WHEN USING LIVE UPDATING
// ...and to set this macro to 0 when building the game!
#macro LDTK_LIVE 1

if (LDTK_LIVE) {
	LDtkConfig({
		// this will load the bundled version (live updating won't work)
		//file: "LDtkTest.ldtk",
		// so we need to load directly from the project folder
		
		// change this to your project directory
		//file: working_directory+"\mods\\level\\TEST.ldtk",
		file: working_directory+"\mods\\level\\"+global.nextlevel+"\\level.ldtk",
		
		level_name: "Level"
	})
}
else {
	LDtkConfig({
		//file: "D:\\Projects\\GameMaker Projects\\LDtkParser\\datafiles\\LDtkTest.ldtk",
		//file: "LDtkTest.ldtk",
		file: working_directory+"\mods\\level\\"+global.nextlevel+"\\level.ldtk",
		level_name: "Level"
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