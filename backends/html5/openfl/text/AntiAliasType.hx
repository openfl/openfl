package openfl.text;


#if (haxe_ver > 3.100)

@:enum abstract AntiAliasType(String) {
	
	var ADVANCED = "advanced";
	var NORMAL = "normal";
	
}

#else

enum AntiAliasType {
	
	ADVANCED;
	NORMAL;
	
}

#end