var msg=""
var i=0;
repeat (instance_count) {
	var o=instance_find(all,i);
	msg+=$"{object_get_name(o.object_index)}\n";
	i++;
}

show_debug_message(msg);