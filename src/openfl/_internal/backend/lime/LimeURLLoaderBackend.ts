namespace openfl._internal.backend.lime;

#if lime
import haxe.io.Bytes;
import lime.net.HTTPRequest;
import lime.net.HTTPRequestHeader;
import Event from "../events/Event";
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestHeader;
import ByteArray from "../utils/ByteArray";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class LimeURLLoaderBackend
{
	private httpRequest: #if (display || macro || doc_gen) Dynamic #else _IHTTPRequest #end; // TODO: Better (non-private) solution
private parent: URLLoader;

public constructor(parent: URLLoader)
{
	this.parent = parent;
}

public close(): void
	{
		if(httpRequest != null)
{
	httpRequest.cancel();
	httpRequest = null;
}
}

private dispatchStatus(): void
	{
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, httpRequest.responseStatus);
		event.responseURL = httpRequest.uri;

		var headers = new Array<URLRequestHeader>();

		#if(!display && !macro && !doc_gen)
if (httpRequest.enableResponseHeaders && httpRequest.responseHeaders != null)
{
	for (header in httpRequest.responseHeaders)
	{
		headers.push(new URLRequestHeader(header.name, header.value));
	}
}
		#end

event.responseHeaders = headers;
parent.dispatchEvent(event);
}

public load(request: URLRequest): void
	{
		#if!macro
	if(parent.dataFormat == BINARY)
	{
	var httpRequest = new HTTPRequest<ByteArray>();
	prepareRequest(httpRequest, request);

	httpRequest.load()
		.onProgress(httpRequest_onProgress)
		.onError(httpRequest_onError)
		.onComplete(function (data: ByteArray): void
		{
			dispatchStatus();
			parent.data = data;

			var event = new Event(Event.COMPLETE);
			parent.dispatchEvent(event);
		});
}
	else
{
	var httpRequest = new HTTPRequest<string>();
	prepareRequest(httpRequest, request);

	httpRequest.load()
		.onProgress(httpRequest_onProgress)
		.onError(httpRequest_onError)
		.onComplete(function (data: string): void
		{
			dispatchStatus();
			parent.data = data;

			var event = new Event(Event.COMPLETE);
			parent.dispatchEvent(event);
		});
}
		#end
}

private prepareRequest(httpRequest: #if(display || macro || doc_gen) Dynamic #else _IHTTPRequest #end, request: URLRequest): void
	{
		this.httpRequest = httpRequest;
		httpRequest.uri = request.url;
		httpRequest.method = request.method;

		if(request.data != null)
	{
	if (Type.typeof(request.data) == Type.ValueType.TObject)
	{
		var fields = Reflect.fields(request.data);

		for (field in fields)
		{
			httpRequest.formData.set(field, Reflect.field(request.data, field));
		}
	}
	else if (Std.is(request.data, Bytes))
	{
		httpRequest.data = request.data;
	}
	else
	{
		httpRequest.data = Bytes.ofString(String(request.data));
	}
}

httpRequest.contentType = request.contentType;

if (request.requestHeaders != null)
{
	for (header in request.requestHeaders)
	{
		httpRequest.headers.push(new HTTPRequestHeader(header.name, header.value));
	}
}

httpRequest.followRedirects = request.followRedirects;
httpRequest.timeout = Std.int(request.idleTimeout);
httpRequest.withCredentials = request.manageCookies;

// TODO: Better user agent?
var userAgent = request.userAgent;
if (userAgent == null) userAgent = "Mozilla/5.0 (Windows; U; en) AppleWebKit/420+ (KHTML, like Gecko) OpenFL/1.0";

httpRequest.userAgent = request.userAgent;
httpRequest.enableResponseHeaders = true;
}

	// Event Handlers
	protected httpRequest_onError(error: Dynamic): void
	{
		dispatchStatus();

	if(error == 403)
{
	var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
	event.text = String(error);
	parent.dispatchEvent(event);
}
	else
{
	var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
	event.text = String(error);
	parent.dispatchEvent(event);
}
}

	protected httpRequest_onProgress(bytesLoaded : number, bytesTotal : number): void
	{
		var event = new ProgressEvent(ProgressEvent.PROGRESS);
		event.bytesLoaded = bytesLoaded;
		event.bytesTotal = bytesTotal;
		parent.dispatchEvent(event);
	}
}
#end
