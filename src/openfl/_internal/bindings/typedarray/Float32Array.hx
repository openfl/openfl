package openfl._internal.bindings.typedarray;

#if lime
typedef Float32Array = lime.utils.Float32Array;
#elseif js
#if haxe4
typedef Float32Array = js.lib.Float32Array;
#else
typedef Float32Array = js.html.Float32Array;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef Float32Array = Dynamic;
#end
