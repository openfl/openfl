package openfl.display; #if !flash

#if (haxe > 3.100)

@:enum abstract LineScaleMode(String) to String {

	var HORIZONTAL = "horizontal";
	var NONE = "none";
	var NORMAL = "normal";
	var VERTICAL = "vertical";

}

#else
enum LineScaleMode {
	
	HORIZONTAL;
	NONE;
	NORMAL;
	VERTICAL;
	
}
#end


#else
typedef LineScaleMode = flash.display.LineScaleMode;
#end