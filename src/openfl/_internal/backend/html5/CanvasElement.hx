package openfl._internal.backend.html5;

#if openfl_html5
typedef CanvasElement = js.html.CanvasElement;
#else
typedef CanvasElement = Dynamic;
#end
