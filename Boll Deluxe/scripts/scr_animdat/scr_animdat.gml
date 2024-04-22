function load_animdat(){
	AnimationData			=["Idle","Run","a","Fall","Drill","DrillLand","Styling","Squish","Dead","Partic","StyleFlash"];

//MODDED (all below)
MOD_PlayerSkins			=[];
MOD_SkinAnimSpeed		=[];
MOD_SkinAnimLoopPoint	=[];
MOD_SkinFrameCount		=[];
MOD_SkinDesc			=[];
MOD_SkinGSetts			=[];

var Frames		=0;
var OrgX		=0;
var OrgY		=0;
var AnimSpd		=0;
var LoopPnt		=0;
var StrArr		=[];
var SpdArr		=[];
var LoopArr		=[];
var FramesArr	=[];

//Make sure all directorys exist else make them
if (!directory_exists($"{working_directory}\\SEdata\\Skins\\")) directory_create($"{working_directory}\\SEdata\\Skins")

// Find first skin
var Skin_name  = file_find_first($"{working_directory}\\SEdata\\Skins\\*", fa_directory)
var Skin_index = 0

// Load all skins
if (Skin_name != "" && Skin_name != "<null>")
{
	while(Skin_name != "" && Skin_name != "<null>")
	{
		if !file_exists($"{working_directory}/SEdata/Skins/{Skin_name}/SkinSettings.txt") show_debug_message("NOT THERE")
		var File = file_text_open_read($"{working_directory}/SEdata/Skins/{Skin_name}/SkinSettings.txt");
		var Desc = SplitString(file_text_read_string(File),",");
		array_push(MOD_SkinDesc,Desc)
		file_text_readln(File); file_text_readln(File);
		var XYscale = SplitString(file_text_read_string(File),",");
		array_push(MOD_SkinGSetts,XYscale);
		file_text_readln(File); file_text_readln(File); file_text_readln(File);

		SpdArr		=[];
		LoopArr		=[];
		FramesArr	=[];
		var LengthOfAnims		=array_length(AnimationData);
		var OrgXarr	=[];
		var OrgYarr	=[];

		for (var i = 0; i < LengthOfAnims; ++i;)
		{
			var StrArr = SplitString(file_text_read_string(File),",");
			Frames=real(StrArr[0]); OrgX=StrArr[1]; OrgY=StrArr[2]; AnimSpd=real(StrArr[3])*0.01; LoopPnt=real(StrArr[4]);
			array_push(SpdArr,AnimSpd); array_push(LoopArr,LoopPnt); array_push(FramesArr,Frames);
			array_push(OrgXarr,StrArr[1]); array_push(OrgYarr,StrArr[2]);
			//show_debug_message(AnimationData[i]);
			//show_debug_message(Skin_name);
			//show_debug_message("s" + Skin_name + AnimationData[i]);
			//global.texPage.AddFile($"{working_directory}\\SEdata\\Skins\\{Skin_name}\\{AnimationData[i]}.png",$"s{Skin_name}{AnimationData[i]}",Frames,,,OrgX,OrgY);
			file_text_readln(File); file_text_readln(File);
		}

		array_push(MOD_SkinAnimSpeed,SpdArr);
		array_push(MOD_SkinAnimLoopPoint,LoopArr);
		array_push(MOD_SkinFrameCount,FramesArr);
		file_text_close(File);

		array_push(MOD_PlayerSkins,Skin_name);
		Skin_name  = file_find_next();
		Skin_index ++;
	}
}
}