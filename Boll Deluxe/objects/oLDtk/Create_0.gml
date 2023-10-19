/// @desc Configs

// REMEMBER TO TURN ON "disable file system sandbox" WHEN USING LIVE UPDATING
// ...and to set this macro to 0 when building the game!
#macro LDTK_LIVE 1


if (LDTK_LIVE) {
	// live reload config
	LDtkConfig({
		// change this to your project directory
		file: "F:\\Boll-Deluxe\\Boll Deluxe\\mods\\level\\Stage.ldtk",
		level_name: "Levelloader"
	})
}
else {
	// release config
	LDtkConfig({
		file: "F:\\Boll-Deluxe\\Boll Deluxe\\mods\\level\\Stage.ldtk",
		level_name: "Levelloader"
	})
}



LDtkMappings({
	layers: {
        Entities: "Entities",
        CollisionTiles: "CollisionTiles",
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