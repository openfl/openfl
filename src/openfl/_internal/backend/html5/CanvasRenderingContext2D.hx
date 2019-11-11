package openfl._internal.backend.html5;

#if openfl_html5
typedef CanvasRenderingContext2D = js.html.CanvasRenderingContext2D;
#else
typedef CanvasRenderingContext2D = Dynamic;
#end
