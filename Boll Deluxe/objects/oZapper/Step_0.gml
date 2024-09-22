ds_list_clear(connected_list);
var _connections=ds_list_create();
var _connum=collision_circle_list(x+24,y,24,global.conductive_array,true,true,_connections,true)

if (_connum > 0) {
	var queue=ds_queue_create();
	for (var j = 0; j < ds_list_size(_connections); ++j) {
		ds_queue_enqueue(queue,_connections[| j]);
		ds_list_add(connected_list, [x, y, _connections[| j].x, _connections[| j].y])
	}
	while (!ds_queue_empty(queue)) {
		var obj = ds_queue_dequeue(queue);
		if instance_exists(obj) {
			var coll_list=ds_list_create();
			var _num=collision_circle_list(obj.x,obj.y,40,global.conductive_array,true,true,coll_list,true)
			if (_num > 0)
			{
				for (var i = 0; i < _num; ++i;)
				{	
					if ds_list_find_index(_connections, coll_list[| i])==-1 && ds_list_find_index(connected_list, coll_list[| i])==-1 && !(coll_list[| i].conducted) && coll_list[| i]!=obj && coll_list[| i]!=id {
						ds_list_add(connected_list, [obj.x, obj.y, coll_list[| i].x, coll_list[| i].y])
						if (i==_num-1) && (_num > 2) { //if this connection is the last, and theres at least 3 connections, connect a loop
							ds_list_add(connected_list, [obj.x, obj.y, coll_list[| 0].x, coll_list[| 0].y])
						}
						ds_queue_enqueue(queue,coll_list[| i])
						with(coll_list[| i]) {
								onConducted.Emit(other.id);
						}
					}
				}
			}
			ds_list_destroy(coll_list);
		}
	}
	ds_queue_destroy(queue);
}
ds_list_destroy(_connections);