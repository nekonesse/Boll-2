node_path_movement();

buftimer=max(0,buftimer-1);

if !(buftimer) { //update tick
buftimer=max(4-pathspd,1);

var list = ds_list_create();
switch (dir) {
	case "left": collision_circle_list(x-32, y, 32, global.conductive_array, false, false, list, false); break;
	case "up": collision_circle_list(x, y-32, 32, global.conductive_array, false, false, list, false); break;
	case "down": collision_circle_list(x, y+32, 32, global.conductive_array, false, false, list, false); break;
	default: collision_circle_list(x+32, y, 32, global.conductive_array, false, false, list, false) break;
}

array_delete(connections,0,array_length(connections))

if !array_length(list) {
	array_delete(connectedObjects,0,array_length(connectedObjects))
	array_delete(connectedObjectsBefore,0,array_length(connectedObjectsBefore))
}

var i = 0;
var len = ds_list_size(list);
repeat(len) { 
    var obj = list[| i]
	with (obj) {
		onConducted.Emit();
	}
	array_push(connections, [x, y, obj.x, obj.y, obj.id]);
    if !array_contains(connectedObjects, obj) {
        array_push(connectedObjects, obj);
        findConnectedObjects(obj);
    }
	i++;
}

//if array_equals(connectedObjectsBefore, connectedObjects) //check if any connections have changed, if so, continue calculating the lines
//exit

var i=0;
var len=array_length(connectedObjects);
repeat(len) { 
    var connectObj = connectedObjects[i];
    ds_list_clear(list);
    with connectObj {
        collision_circle_list(x, y, radius, global.conductive_array, false, true, list, false);    
    }
	var n=0;
	var len2=ds_list_size(list);
    repeat(len2) { 
        var obj = list[| n];
        var desiredConnection = [connectObj.x, connectObj.y, obj.x, obj.y];
        
        var alreadyConnected = false;
		var w = 0;
		var len3=array_length(connections);
        repeat(len3) { 
            if array_contains_ext(connections[w], desiredConnection, true) {
                alreadyConnected = true;
                break;
            }
			w++;
        }
        if !alreadyConnected {
			array_push(desiredConnection, obj.id)
            array_push(connections, desiredConnection);
        }
		n++;
    }
	i++;
}

ds_list_destroy(list);
}

connectedObjectsBefore=connectedObjects