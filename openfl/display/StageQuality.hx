package openfl.display; #if !flash


enum StageQuality {
	
	BEST;
	HIGH;
	MEDIUM;
	LOW;
	
}


#else
typedef StageQuality = flash.display.StageQuality;
#end