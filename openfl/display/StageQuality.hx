package openfl.display; #if !flash


#if (haxe_ver > 3.100)

@:enum abstract StageQuality(String) {

	var BEST = "best";
	var HIGH = "high";
	var MEDIUM = "medium";
	var LOW = "low";
	
}

#else

enum StageQuality {
	
	BEST;
	HIGH;
	MEDIUM;
	LOW;
	
}

#end


#else
typedef StageQuality = flash.display.StageQuality;
#end