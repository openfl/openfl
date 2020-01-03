package openfl._internal.bindings.typedarray;

#if lime
typedef UInt16Array = lime.utils.UInt16Array;
#elseif js
#if haxe4
typedef UInt16Array = js.lib.Uint16Array;
#else
typedef UInt16Array = js.html.Uint16Array;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef UInt16Array = Dynamic;
#end
