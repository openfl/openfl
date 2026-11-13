package openfl.events;

#if !flash
import openfl.utils.ByteArray;

/**
	A WebSocket object dispatches a WebSocketEvent object when it receives a
	message. The `format` property tells whether the message is text
	(`WebSocket.fmtTEXT`) or binary (`WebSocket.fmtBINARY`).

	@see `openfl.net.WebSocket`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class WebSocketEvent extends Event
{
	/**
		Defines the value of the `type` property of a `websocketData` event
		object.

		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `data` | The message payload. |
		| `format` | `WebSocket.fmtTEXT` or `WebSocket.fmtBINARY`. |
		| `target` | The WebSocket object that received the message. |
	**/
	public static inline var DATA:EventType<WebSocketEvent> = "websocketData";

	/**
		The message payload. A text message holds its UTF-8 bytes.
	**/
	public var data(default, null):ByteArray;

	/**
		The format of the message: `WebSocket.fmtTEXT` or
		`WebSocket.fmtBINARY`.
	**/
	public var format(default, null):UInt;

	/**
		The payload of a text message, or `null` for a binary message.
	**/
	public var stringData(get, never):String;

	/**
		Creates an event object that contains a WebSocket message.

		@param type   The type of the event: `WebSocketEvent.DATA`.
		@param format The format of the message: `WebSocket.fmtTEXT` or
					  `WebSocket.fmtBINARY`.
		@param data   The message payload.
	**/
	public function new(type:String, format:UInt, data:ByteArray)
	{
		super(type, false, false);

		this.format = format;
		this.data = data;
	}

	public override function clone():WebSocketEvent
	{
		var event = new WebSocketEvent(type, format, data);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("WebSocketEvent", ["type", "format"]);
	}

	@:noCompletion private function get_stringData():String
	{
		if (format != 1 || data == null) return null;
		data.position = 0;
		var text = data.readUTFBytes(data.length);
		data.position = 0;
		return text;
	}
}
#elseif air
typedef WebSocketEvent = flash.events.WebSocketEvent;
#end
