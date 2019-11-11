package openfl._internal.backend.harfbuzz;

#if lime
typedef HBLanguage = lime.text.harfbuzz.HBLanguage;
#else
typedef HBLanguage = Dynamic;
#end
