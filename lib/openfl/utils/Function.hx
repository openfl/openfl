package openfl.utils;

#if flash
typedef Function = Dynamic;
#else
typedef Function = haxe.Constraints.Function;
#end
