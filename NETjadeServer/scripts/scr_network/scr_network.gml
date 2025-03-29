function send_struct(_struct, _socket) {
	var buff = buffer_create(16384, buffer_grow, 1)
	buffer_seek(buff, buffer_seek_start, 0);
	buffer_write(buff, buffer_string, json_stringify(_struct));
	network_send_packet(_socket, buff, buffer_tell(buff));
	buffer_delete(buff)
}

function JADE_transer_save(_socket, ip) {
	var struct = {};
	var arrayObjects=[];
	var i;
	i=0;
	repeat(ds_list_size(object_layer_map)) {
	    array_push(arrayObjects, object_layer_map[| i])
		i++;
	}
	var arrayNodeObjects = [];
	i=0;
	repeat(ds_list_size(node_layer_map)) {
	    array_push(arrayNodeObjects, node_layer_map[| i])
		i++;
	}
	var arrayTiles=[];
	i=0;
	repeat(array_length(tile_layer_map)) {
		arrayTiles[i]=[];
		var j=0;
	    repeat(ds_list_size(tile_layer_map[i])) {
			array_push(arrayTiles[i], tile_layer_map[i][| j])
			j++;
		}
		i++;
	}
	var arrayTileLayers=[];
	i=0;
	repeat (array_length(layers)) {
	    array_push(arrayTileLayers, [layer_get_name(layers[i]), layer_get_depth(layers[i]), tileset_get_name(tilemap_get_tileset(tile_layer[i])), arrayTiles[i]])
		i++;
	}
	struct[$ "type"]="level_sync"
	struct[$ "time"]=oNetManager.action_timers[? ip]
	struct[$ "version"]=JADE_VERSION
	struct[$ "objects"]=arrayObjects
	struct[$ "node_objects"]=arrayNodeObjects
	struct[$ "tile_layers"]=arrayTileLayers
	var _json=json_stringify(struct); //compile all saved things
	var save_file = buffer_create(string_byte_length(_json), buffer_grow, 1);
	buffer_seek(save_file, buffer_seek_start, 0);
	buffer_write(save_file, buffer_string, _json); //save compilation into a buffer
	network_send_packet(_socket, save_file, buffer_tell(save_file));
	buffer_delete(save_file)
}

//The Horror
global.chatBannedWords = [
	"cock",
	"penis",
	"vagina",
	"masturbate",
	"masterbate",
	"goaste",
	"chink",
	"masterbating",
	"masturbating",
	"retard",
	"retarded",
	"tard",
	"tarded",
	"masturbation",
	"masterbation",
	"nigga",
	"niggar",
	"nigger",
	"masterbat",
	"fap",
	"r-tard",
	"rtard",
	"nagger",
	"retart",
	"fag",
	"faggot",
	"pussy",
	"jism",
	"jizm",
	"tits",
	"titties",
	"clit",
	"cunt",
	"dildo",
	"pussies",
	"wigger",
	"wigga",
	"gook",
	"jizz",
	"titty",
	"ngger",
	"nggr",
	"huntard",
	"retardin",
	"ritard",
	"wiitard",
	"tranny",
	"rape",
	"rapist"
]