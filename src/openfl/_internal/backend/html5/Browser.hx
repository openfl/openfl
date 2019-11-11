package openfl._internal.backend.html5;

#if openfl_html5
typedef Browser = js.Browser;
#else
typedef Browser = Dynamic;
#end
