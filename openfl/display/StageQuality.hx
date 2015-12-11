package openfl.display; #if !openfl_legacy


enum StageQuality {
	
	BEST;
	HIGH;
	MEDIUM;
	LOW;
	
}


#else
typedef StageQuality = openfl._legacy.display.StageQuality;
#end