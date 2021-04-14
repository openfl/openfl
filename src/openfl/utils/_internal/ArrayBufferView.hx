package openfl.utils._internal;

#if lime
typedef ArrayBufferView = lime.utils.ArrayBufferView;
#elseif js
typedef ArrayBufferView = js.lib.ArrayBufferView;
#else
typedef ArrayBufferView = Dynamic;
#end
