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
		Foreground_Tiles_2: "Foreground_Tiles_2",
		Foreground_Tiles: "Foreground_Tiles",
		FG_Decor_Tiles: "FG_Decor_Tiles",
		Misc_Entities: "Misc_Entities",
		Ground_Tiles: "Ground_Tiles",
		Entities: "Entities",
		Tiles: "Misc_Tiles",
		BG_Decor_Tiles: "BG Decor_Tiles",
		Background_Tiles: "Background_Tiles",
		Background_Tiles_2: "Background_Tiles 2",
		Collision_Tiles: "CollisionLayer"
	},
	tilesets: {
		Tileset_Main: "TilesetMain",
		Tileset_Extra: "TilesetExtra",
		Tileset_Animated4: "TilesetAnimated4",
		Tileset_Animated8: "TilesetAnimated8",
		Assets_Main: "AssetsMain",
		Assets_Extra:"AssetsExtra",
		Assets_Animated4: "AssetsAnimated4",
		Assets_Animated8: "AssetsAnimated8"
	}
})