package openfl.text; #if !flash


enum AntiAliasType {
	
	ADVANCED;
	NORMAL;
	
}


#else
typedef AntiAliasType = flash.text.AntiAliasType;
#end