package openfl.profiler;

#if !flash
/**
	The Telemetry class lets an application profile ActionScript code and register handlers
	for commands
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Telemetry
{
	/**
		Indicates whether Telemetry is connected to a server
	**/
	public static var connected(get, never):Bool;

	/**
		Returns a marker for use with `Telemetry.sendSpanMetric`
	**/
	public static var spanMarker(get, never):Float;

	/**
		Register a function that can be called by issuing a command over a socket

		Returns `true` if the registration is successful. If registration fails, there is
		already a handler registered for the command used (or the command name starts with
		'.', which is reserved for player internal use) Already registered handlers may be
		unregistered using `unregisterCommandHandler` before registering another handler.

		The handler function's return value is sent as the result of the command
		(`tlm-response.result`). The handler function can throw Error, if it wants to send
		an error response. In this case, `Error.message` and `Error.id` are sent as
		`tlm-response.tlm-error.message` and `tlm-response.tlm-error.code`, respectively.
		(`tlm-response.result` and `tlm-response.tlm-error.data` are sent as `null`)

		@param	commandName	String specifying a unique name (The command over the socket
		should specify this string as the method name). The guideline is to follow reverse
		DNS notation, which helps to avoid namespace collisions. Additionally, and names
		starting with . are reserved for native use.
		@param	handler	Function to be called when a command is received by Telemetry over
		the socket with the method name, as specified in `functionId` argument. The handler
		should accept only one argument of type Array (as defined by `tlm-method.params` in
		Telemetry Protocol), which has to be sent by Telemetry server along with method
		name.
		@returns
	**/
	public static function registerCommandHandler(commandName:String, handler:Dynamic):Bool
	{
		return _Telemetry.registerCommandHandler(commandName, handler);
	}

	/**
		Requests a custom metric from Telemetry. The metric name and object are sent as
		per the Telemetry protocol format.

		The guideline for custom metric namespaces is to follow reverse DNS notation,
		which helps to avoid namespace collisions.

		@param	metric	Metric name
		@param	value	Any primitive value/object containing the metric details
		@throws	ArgumentError	If metric uses reserved namespaces like flash native
		namespace (for example, if the metric name starts with '.')
	**/
	public static function sendMetric(metric:String, value:Dynamic):Void
	{
		return _Telemetry.sendMetric(metric, value);
	}

	/**
		Requests a custom span metric from Telemetry

		Use `Telemetry.spanMarker` to get a marker at the start of function to be profiled
		and call `Telemetry.sendSpanMetric` at the end of function with the marker.
		Telemetry sends the name, starting marker, and duration of the function plus the
		optional value as per the Telemetry protocol.

		The guideline for custom metric namespaces is to follow reverse DNS notation, which
		helps to avoid namespace collisions.

		Span metrics for durations less than a specified threshold, which could be
		controlled from the Telemetry Server using Telemetry Protocol, would be ignored by
		Telemetry (will not be sent to Telemetry Server).

		@param	metric	Metric name
		@param	startSpanMarker	Start marker.
		@param	value	Optional parameter. Any primitive value/object to be sent along with
		name, marker and duration
		@throws	ArgumentError	If metric uses reserved namespaces like flash native
		namespace (i.e. if metric name starts with '.')
	**/
	public static function sendSpanMetric(metric:String, startSpanMarker:Float, value:Dynamic = null):Void
	{
		return _Telemetry.sendSpanMetric(metric, startSpanMarker, value);
	}

	/**
		@param	commandName
		@returns
	**/
	public static function unregisterCommandHandler(commandName:String):Bool
	{
		return _Telemetry.unregisterCommandHandler(commandName);
	}

	// Get & Set Methods

	@:noCompletion private static function get_connected():Bool
	{
		return _Telemetry.connected;
	}

	@:noCompletion private static function get_spanMarker():Float
	{
		return _Telemetry.spanMarker;
	}
}
#else
typedef Telemetry = flash.profiler.Telemetry;
#end
