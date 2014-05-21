package openfl.display;


#if (haxe_ver > 3.100)

@:enum abstract CapsStyle(String) to String {
	
	var NONE = "butt";
	var ROUND = "round";
	var SQUARE = "square";
	
}

#else

enum CapsStyle {
	
	NONE;
	ROUND;
	SQUARE;
	
}

#end