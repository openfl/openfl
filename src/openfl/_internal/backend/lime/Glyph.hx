package openfl._internal.backend.lime;

#if lime
typedef Glyph = lime.text.Glyph;
#else
typedef Glyph = Dynamic;
#end
