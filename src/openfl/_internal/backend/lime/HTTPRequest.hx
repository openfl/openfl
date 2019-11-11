package openfl._internal.backend.lime;

#if (lime && !macro)
typedef HTTPRequest<F> = lime.net.HTTPRequest<F>;
typedef _IHTTPRequest = lime.net.HTTPRequest._IHTTPRequest;
#else
typedef HTTPRequest<T> = Dynamic;
typedef _IHTTPRequest = Dynamic;
#end
