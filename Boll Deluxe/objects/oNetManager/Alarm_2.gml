if !doing_ping {
	var network_struct = {
		type: "ping"	
	}	
	send_struct(network_struct, global.socket)
	doing_ping = true
	ping_time = 0
} 
alarm[2]=60;