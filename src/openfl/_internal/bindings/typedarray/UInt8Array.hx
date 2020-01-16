package openfl._internal.bindings.typedarray;

#if lime
typedef UInt8Array = lime.utils.UInt8Array;
#elseif js
#if haxe4
typedef UInt8Array = js.lib.Uint8Array;
#else
typedef UInt8Array = js.html.Uint8Array;
#end
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef UInt8Array = Dynamic;
#end
