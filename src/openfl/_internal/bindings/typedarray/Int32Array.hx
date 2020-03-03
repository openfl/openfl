package openfl._internal.bindings.typedarray;

#if lime
typedef Int32Array = lime.utils.Int32Array;
#elseif js
#if haxe4
typedef Int32Array = js.lib.Int32Array;
#else
typedef Int32Array = js.html.Int32Array;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef Int32Array = Dynamic;
#end
