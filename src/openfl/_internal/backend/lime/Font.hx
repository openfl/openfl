package openfl._internal.backend.lime;

#if lime
typedef Font = lime.text.Font;
#else
typedef Font = Dynamic;
#end
