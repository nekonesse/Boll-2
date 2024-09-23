// Inherit the parent event
event_inherited();

buftimer=0;

connections = [];
connectedObjects = [];
connectedObjectsBefore = [];
radius = 48;

findConnectedObjects = function(obj) {
    var list = ds_list_create();
    with obj {
        collision_circle_list(x, y, other.radius, global.conductive_array, false, true, list, false);
    }
    for(var i = 0, len = ds_list_size(list); i < len; i++;) { 
        var obj2 = list[| i];
        if !array_contains(connectedObjects, obj2) {
            array_push(connectedObjects, obj2);
            findConnectedObjects(obj2);
        }
    }

    ds_list_destroy(list);
}
fr=0;
onConducted=new Signal();

onConducted.Connect( self, function(conductor) {
	
});