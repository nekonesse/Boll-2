buftimer=max(0,buftimer-1);
if !(buftimer) { //update tick
buftimer=5;

var list = ds_list_create();
collision_circle_list(x+32, y, 32, global.conductive_array, false, false, list, false);

for(var i = 0, len = ds_list_size(list); i < len; i++;) { 
    var obj = list[| i]
	array_push(connections, [x, y, obj.x, obj.y]);
    if !array_contains(connectedObjects, obj) {
        array_push(connectedObjects, obj);
        findConnectedObjects(obj);
    }
}

if array_equals(connectedObjectsBefore, connectedObjects) //check if any connections have changed, if so, continue calculating the lines
exit

for(var i = 0, len = array_length(connectedObjects); i < len; i++;) { 
    var connectObj = connectedObjects[i];
    ds_list_clear(list);
    with connectObj {
        collision_circle_list(x, y, other.radius, global.conductive_array, false, true, list, false);    
    }
    for(var n = 0, len2 = ds_list_size(list); n < len2; n++;) { 
        var obj = list[| n];
        var desiredConnection = [connectObj.x, connectObj.y, obj.x, obj.y];
        
        var alreadyConnected = false;
        for(var w = 0, len3 = array_length(connections); w < len3; w++;) { 
            if array_contains_ext(connections[w], desiredConnection, true) {
                alreadyConnected = true;
                break;
            }
        }
        if !alreadyConnected {
            array_push(connections, desiredConnection);
        }
    }
}
ds_list_destroy(list);

}

connectedObjectsBefore=connectedObjects