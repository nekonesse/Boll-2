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
		//file: "D:\\Projects\\GameMaker Projects\\LDtkParser\\datafiles\\LDtkTest.ldtk",
		//file: working_directory+"\LDtkTest.ldtk",
		file: working_directory+"\mods\\level\\Stage.ldtk",
		level_name: "Levelloader"
	})
}
else {
	LDtkConfig({
		//file: "D:\\Projects\\GameMaker Projects\\LDtkParser\\datafiles\\LDtkTest.ldtk",
		//file: "LDtkTest.ldtk",
		file: working_directory+"\mods\\level\\Stage.ldtk",
		level_name: "Levelloader"
	})
}



LDtkMappings({
	layers: {
		Entities: "Entities" // now "Tiles" layer in LDtk = "PlaceholderTiles" layer in GM
	},
	enums: {
		TestEnum: {
			//First: "First", // first is undefined, should just return the name
			Second: "This is second",
			Third: 3
		}
	},
	tilesets: {
		PlaceholderTiles: "tTiles"
	}
})