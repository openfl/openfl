package openfl.net;

#if lime
import haxe.io.Bytes;
import lime.net.HTTPRequest;
import lime.net.HTTPRequestHeader;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLRequestHeader;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _URLLoader
{
	private var httpRequest:#if (display || macro || doc_gen) Dynamic #else _IHTTPRequest #end; // TODO: Better (non-private) solution
	private var parent:URLLoader;

	public function new(parent:URLLoader)
	{
		this.parent = parent;
	}

	public function close():Void
	{
		if (httpRequest != null)
		{
			httpRequest.cancel();
			httpRequest = null;
		}
	}

	private function dispatchStatus():Void
	{
		var event = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, httpRequest.responseStatus);
		event.responseURL = httpRequest.uri;

		var headers = new Array<URLRequestHeader>();

		#if (!display && !macro && !doc_gen)
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

	public function load(request:URLRequest):Void
	{
		#if !macro
		if (parent.dataFormat == BINARY)
		{
			var httpRequest = new HTTPRequest<ByteArray>();
			prepareRequest(httpRequest, request);

			httpRequest.load()
				.onProgress(httpRequest_onProgress)
				.onError(httpRequest_onError)
				.onComplete(function(data:ByteArray):Void
				{
					dispatchStatus();
					parent.data = data;

					var event = new Event(Event.COMPLETE);
					parent.dispatchEvent(event);
				});
		}
		else
		{
			var httpRequest = new HTTPRequest<String>();
			prepareRequest(httpRequest, request);

			httpRequest.load()
				.onProgress(httpRequest_onProgress)
				.onError(httpRequest_onError)
				.onComplete(function(data:String):Void
				{
					dispatchStatus();
					parent.data = data;

					var event = new Event(Event.COMPLETE);
					parent.dispatchEvent(event);
				});
		}
		#end
	}

	private function prepareRequest(httpRequest:#if (display || macro || doc_gen) Dynamic #else _IHTTPRequest #end, request:URLRequest):Void
	{
		this.httpRequest = httpRequest;
		httpRequest.uri = request.url;
		httpRequest.method = request.method;

		if (request.data != null)
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
				httpRequest.data = Bytes.ofString(Std.string(request.data));
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
	@:noCompletion private function httpRequest_onError(error:Dynamic):Void
	{
		dispatchStatus();

		if (error == 403)
		{
			var event = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
			event.text = Std.string(error);
			parent.dispatchEvent(event);
		}
		else
		{
			var event = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			event.text = Std.string(error);
			parent.dispatchEvent(event);
		}
	}

	@:noCompletion private function httpRequest_onProgress(bytesLoaded:Int, bytesTotal:Int):Void
	{
		var event = new ProgressEvent(ProgressEvent.PROGRESS);
		event.bytesLoaded = bytesLoaded;
		event.bytesTotal = bytesTotal;
		parent.dispatchEvent(event);
	}
}
#end
