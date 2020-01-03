package openfl._internal.bindings.typedarray;

#if lime
typedef ArrayBufferView = lime.utils.ArrayBufferView;
#elseif js
#if haxe4
typedef ArrayBufferView = js.lib.ArrayBufferView;
#else
typedef ArrayBufferView = js.html.ArrayBufferView;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef ArrayBufferView = Dynamic;
#end
