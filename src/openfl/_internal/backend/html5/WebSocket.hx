package openfl._internal.backend.html5;

#if openfl_html5
typedef WebSocket = js.html.WebSocket;
#else
typedef WebSocket = Dynamic;
#end
