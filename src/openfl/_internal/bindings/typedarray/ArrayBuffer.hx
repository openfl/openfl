package openfl._internal.bindings.typedarray;

#if lime
typedef ArrayBuffer = lime.utils.ArrayBuffer;
#elseif js
#if haxe4
typedef ArrayBuffer = js.lib.ArrayBuffer;
#else
typedef ArrayBuffer = js.html.ArrayBuffer;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef ArrayBuffer = Dynamic;
#end
