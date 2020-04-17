/**
	The Telemetry class lets an application profile ActionScript code and register handlers
	for commands
**/
export default class Telemetry
{
	/**
		Returns a marker for use with `Telemetry.sendSpanMetric`
	**/
	public static readonly spanMarker = 0.0;

	/**
		Register a that can be called by issuing a command over a socket

		Returns `true` if the registration is successful. If registration fails, there is
		already a handler registered for the command used (or the command name starts with
		'.', which is reserved for player internal use) Already registered handlers may be
		unregistered using `unregisterCommandHandler` before registering another handler.

		The handler function's return value is sent as the result of the command
		(`tlm-response.result`). The handler can throw Error, if it wants to send
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
	public static registerCommandHandler(commandName: string, handler: Function): boolean
	{
		return false;
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
	public static sendMetric(metric: string, value: Object): void { }

	/**
		Requests a custom span metric from Telemetry

		Use `Telemetry.spanMarker` to get a marker at the start of to be profiled
		and call `Telemetry.sendSpanMetric` at the end of with the marker.
		Telemetry sends the name, starting marker, and duration of the plus the
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
	public static sendSpanMetric(metric: string, startSpanMarker: number, value: any = null): void { }

	/**
		@param	commandName
		@returns
	**/
	public static unregisterCommandHandler(commandName: string): boolean
	{
		return false;
	}

	protected static __advanceFrame(): void
	{
	}

	protected static __endTiming(name: string): void
	{
	}

	protected static __initialize(): void
	{

	}

	protected static __rewindStack(stack: string): void
	{

	}

	protected static __startTiming(name: string): void
	{
	}

	protected static __unwindStack(): string
	{
		return "";
	}

	// Get & Set Methods

	/**
		Indicates whether Telemetry is connected to a server
	**/
	public static get connected(): boolean
	{
		return false;
	}
}
