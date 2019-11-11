package openfl._internal.backend.html5;

#if openfl_html5
typedef FileReader = js.html.FileReader;
#else
typedef FileReader = Dynamic;
#end
