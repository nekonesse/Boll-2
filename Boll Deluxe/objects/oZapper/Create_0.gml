// Inherit the parent event
event_inherited();

node_init_vars()

buftimer=0;

connections = [];
connectedObjects = [];
connectedObjectsBefore = [];
radius = 64;

findConnectedObjects = function(obj) {
    var list = ds_list_create();
    with obj {
        collision_circle_list(x, y, other.radius, global.conductive_array, false, true, list, false);
    }
	var i=0;
	repeat(ds_list_size(list)) { 
        var obj2 = list[| i];
        if !array_contains(connectedObjects, obj2) {
            array_push(connectedObjects, obj2);
            findConnectedObjects(obj2);
        }
		i++;
	}
    ds_list_destroy(list);
}
fr=0;
onConducted=new Signal();

onConducted.Connect( self, function(conductor) {
	
});