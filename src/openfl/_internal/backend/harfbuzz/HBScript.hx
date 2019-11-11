package openfl._internal.backend.harfbuzz;

#if lime
typedef HBScript = lime.text.harfbuzz.HBScript;
#else
typedef HBScript = Dynamic;
#end
