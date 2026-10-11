collect_timer = 0;
shardid = 0;
activated_by_link = false;
oncollect_link = [];

//lifted from github's issues
// Boll Shard Saving

onCollect = function() {
	if (collect_timer) exit;
	
	instance_create_depth(x,y,depth,pGlowRing);
	
	VinylPlay(snd_itemshard);
	
	/*with (instance_create(x,y,pScoreText)) {
		image_index = 4;
	}*/
	
	collect_timer = 1;
	
	oGameManager.collect_shard(shardid)
	
	trigger_links(oncollect_link);
	
	image_speed=10;
	
	vspeed=-2.5;
	gravity=0.15
}