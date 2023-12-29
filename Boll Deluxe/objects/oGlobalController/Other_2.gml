if file_exists("keybinds.ini")
{
        var opstruct = LoadJSONFromFile("keybinds.ini")
        if input_player_verify(opstruct) input_player_import(opstruct);
		else SaveStringToFile("keybinds.ini",input_player_export())
}
global.roomTimer=0