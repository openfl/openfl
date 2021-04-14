package openfl.events;

#if !flash
// import openfl.utils.ObjectPool;

/**
	A NetConnection, NetStream, or SharedObject object dispatches
	NetStatusEvent objects when a it reports its status. There is only one
	type of status event: `NetStatusEvent.NET_STATUS`.

**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NetStatusEvent extends Event
{
	/**
		Defines the value of the `type` property of a `netStatus` event
		object.
		This event has the following properties:

		| Property | Value |
		| --- | --- |
		| `bubbles` | `false` |
		| `cancelable` | `false`; there is no default behavior to cancel. |
		| `currentTarget` | The object that is actively processing the Event object with an event listener. |
		| `info` | An object with properties that describe the object's status or error condition. |
		| `target` | The NetConnection or NetStream object reporting its status. |
	**/
	public static inline var NET_STATUS:EventType<NetStatusEvent> = "netStatus";

	/**
		An object with properties that describe the object's status or error
		condition.
		The information object could have a `code` property containing a
		string that represents a specific event or a `level` property
		containing a string that is either `"status"` or `"error"`.

		The information object could also be something different. The `code`
		and `level` properties might not work for some implementations and
		some servers might send different objects.

		P2P connections send messages to a `NetConnection` with a `stream`
		parameter in the information object that indicates which `NetStream`
		the message pertains to.

		For example, Flex Data Services sends Message objects that cause
		coercion errors if you try to access the `code` or `level` property.

		The following table describes the possible string values of the `code`
		and `level` properties.

		| Code property | Level property | Meaning |
		| --- | --- | --- |
		| `"NetConnection.Call.BadVersion"` | `"error"` | Packet encoded in an unidentified format. |
		| `"NetConnection.Call.Failed"` | `"error"` | The `NetConnection.call()` method was not able to invoke the server-side method or command. |
		| `"NetConnection.Call.Prohibited"` | `"error"` | An Action Message Format (AMF) operation is prevented for security reasons. Either the AMF URL is not in the same domain as the file containing the code calling the `NetConnection.call()` method, or the AMF server does not have a policy file that trusts the domain of the the file containing the code calling the `NetConnection.call()` method. |
		| `"NetConnection.Connect.AppShutdown"` | `"error"` | The server-side application is shutting down. |
		| `"NetConnection.Connect.Closed"` | `"status"` | The connection was closed successfully. |
		| `"NetConnection.Connect.Failed"` | `"error"` | The connection attempt failed. |
		| `"NetConnection.Connect.IdleTimeout"` | `"status"` | Flash Media Server disconnected the client because the client was idle longer than the configured value for `<MaxIdleTime>`. On Flash Media Server, `<AutoCloseIdleClients>` is disabled by default. When enabled, the default timeout value is 3600 seconds (1 hour). For more information, see [Close idle connections](http://help.adobe.com/en_US/flashmediaserver/configadmin/WS5b3ccc516d4fbf351e63e3d119f2925e64-7ff0.html#WS5b3ccc516d4fbf351e63e3d119f2925e64-7fe9). |
		| `"NetConnection.Connect.InvalidApp"` | `"error"` | The application name specified in the call to `NetConnection.connect()` is invalid. |
		| `"NetConnection.Connect.NetworkChange"` | `"status"` |  Flash Player has detected a network change, for example, a dropped wireless connection, a successful wireless connection,or a network cable loss.<br>Use this event to check for a network interface change. Don't use this event to implement your NetConnection reconnect logic. Use `"NetConnection.Connect.Closed"` to implement your NetConnection reconnect logic. |
		| `"NetConnection.Connect.Rejected"` | `"error"` | The connection attempt did not have permission to access the application. |
		| `"NetConnection.Connect.Success"` | `"status"` | The connection attempt succeeded. |
		| `"NetGroup.Connect.Failed"` | `"error"` | The NetGroup connection attempt failed. The `info.group` property indicates which NetGroup failed. |
		| `"NetGroup.Connect.Rejected"` | `"error"` | The NetGroup is not authorized to function. The `info.group` property indicates which NetGroup was denied. |
		| `"NetGroup.Connect.Succcess"` | `"status"` | The NetGroup is successfully constructed and authorized to function. The `info.group` property indicates which NetGroup has succeeded. |
		| `"NetGroup.LocalCoverage.Notify"` | `"status"` | Sent when a portion of the group address space for which this node is responsible changes. |
		| `"NetGroup.MulticastStream.PublishNotify"` | `"status"` | Sent when a new named stream is detected in NetGroup's Group. The `info.name:String` property is the name of the detected stream. |
		| `"NetGroup.MulticastStream.UnpublishNotify"` | `"status"` | Sent when a named stream is no longer available in the Group. The `info.name:String` property is name of the stream which has disappeared. |
		| `"NetGroup.Neighbor.Connect"` | `"status"` | Sent when a neighbor connects to this node. The `info.neighbor:String` property is the group address of the neighbor. The `info.peerID:String` property is the peer ID of the neighbor. |
		| `"NetGroup.Neighbor.Disconnect"` | `"status"` | Sent when a neighbor disconnects from this node. The `info.neighbor:String` property is the group address of the neighbor. The `info.peerID:String` property is the peer ID of the neighbor. |
		| `"NetGroup.Posting.Notify"` | `"status"` | Sent when a new Group Posting is received. The `info.message:Object` property is the message. The `info.messageID:String` property is this message's messageID. |
		| `"NetGroup.Replication.Fetch.Failed"` | `"status"` | Sent when a fetch request for an object (previously announced with NetGroup.Replication.Fetch.SendNotify) fails or is denied. A new attempt for the object will be made if it is still wanted. The `info.index:Number` property is the index of the object that had been requested. |
		| `"NetGroup.Replication.Fetch.Result"` | `"status"` | Sent when a fetch request was satisfied by a neighbor. The `info.index:Number` property is the object index of this result. The `info.object:Object` property is the value of this object. This index will automatically be removed from the Want set. If the object is invalid, this index can be re-added to the Want set with `NetGroup.addWantObjects()`. |
		| `"NetGroup.Replication.Fetch.SendNotify"` | `"status"` | Sent when the Object Replication system is about to send a request for an object to a neighbor.The `info.index:Number` property is the index of the object that is being requested. |
		| `"NetGroup.Replication.Request"` | `"status"` | Sent when a neighbor has requested an object that this node has announced with `NetGroup.addHaveObjects()`. This request **must** eventually be answered with either `NetGroup.writeRequestedObject()` or `NetGroup.denyRequestedObject()`. Note that the answer may be asynchronous. The `info.index:Number` property is the index of the object that has been requested. The `info.requestID:int` property is the ID of this request, to be used by `NetGroup.writeRequestedObject()` or `NetGroup.denyRequestedObject()`. |
		| `"NetGroup.SendTo.Notify"` | `"status"` | Sent when a message directed to this node is received. The `info.message:Object` property is the message. The `info.from:String` property is the groupAddress from which the message was received. The `info.fromLocal:Boolean` property is `TRUE` if the message was sent by this node (meaning the local node is the nearest to the destination group address), and `FALSE` if the message was received from a different node. To implement recursive routing, the message must be resent with `NetGroup.sendToNearest()` if `info.fromLocal` is `FALSE`. |
		| `"NetStream.Buffer.Empty"` | `"status"` | Flash Player is not receiving data quickly enough to fill the buffer. Data flow is interrupted until the buffer refills, at which time a `NetStream.Buffer.Full` message is sent and the stream begins playing again. |
		| `"NetStream.Buffer.Flush"` | `"status"` | Data has finished streaming, and the remaining buffer is emptied. |
		| `"NetStream.Buffer.Full"` | `"status"` | The buffer is full and the stream begins playing. |
		| `"NetStream.Connect.Closed"` | `"status"` | The P2P connection was closed successfully. The `info.stream` property indicates which stream has closed. |
		| `"NetStream.Connect.Failed"` | `"error"` | The P2P connection attempt failed. The `info.stream` property indicates which stream has failed. |
		| `"NetStream.Connect.Rejected"` | `"error"` | The P2P connection attempt did not have permission to access the other peer. The `info.stream` property indicates which stream was rejected. |
		| `"NetStream.Connect.Success"` | `"status"` | The P2P connection attempt succeeded. The `info.stream` property indicates which stream has succeeded. |
		| `"NetStream.DRM.UpdateNeeded"` | `"status"` | A NetStream object is attempting to play protected content, but the required Flash Access module is either not present, not permitted by the effective content policy, or not compatible with the current player. To update the module or player, use the `update()` method of flash.system.SystemUpdater. |
		| `"NetStream.Failed"` | `"error"` | (Flash Media Server) An error has occurred for a reason other than those listed in other event codes. |
		| `"NetStream.MulticastStream.Reset"` | `"status"` | A multicast subscription has changed focus to a different stream published with the same name in the same group. Local overrides of multicast stream parameters are lost. Reapply the local overrides or the new stream's default parameters will be used. |
		| `"NetStream.Pause.Notify"` | `"status"` | The stream is paused. |
		| `"NetStream.Play.Failed"` | `"error"` | An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access. |
		| `"NetStream.Play.FileStructureInvalid"` | `"error"` | (AIR and Flash Player 9.0.115.0) The application detects an invalid file structure and will not try to play this type of file. |
		| `"NetStream.Play.InsufficientBW"` | `"warning"` | (Flash Media Server) The client does not have sufficient bandwidth to play the data at normal speed. |
		| `"NetStream.Play.NoSupportedTrackFound"` | `"error"` | (AIR and Flash Player 9.0.115.0) The application does not detect any supported tracks (video, audio or data) and will not try to play the file. |
		| `"NetStream.Play.PublishNotify"` | `"status"` | The initial publish to a stream is sent to all subscribers. |
		| `"NetStream.Play.Reset"` | `"status"` | Caused by a play list reset. |
		| `"NetStream.Play.Start"` | `"status"` | Playback has started. |
		| `"NetStream.Play.Stop"` | `"status"` | Playback has stopped. |
		| `"NetStream.Play.StreamNotFound"` | `"error"` | The file passed to the `NetStream.play()` method can't be found. |
		| `"NetStream.Play.Transition"` | `"status"` | (Flash Media Server 3.5) The server received the command to transition to another stream as a result of bitrate stream switching. This code indicates a success status event for the `NetStream.play2()` call to initiate a stream switch. If the switch does not succeed, the server sends a `NetStream.Play.Failed` event instead. When the stream switch occurs, an `onPlayStatus` event with a code of "NetStream.Play.TransitionComplete" is dispatched. For Flash Player 10 and later. |
		| `"NetStream.Play.UnpublishNotify"` | `"status"` | An unpublish from a stream is sent to all subscribers. |
		| `"NetStream.Publish.BadName"` | `"error"` | Attempt to publish a stream which is already being published by someone else. |
		| `"NetStream.Publish.Idle"` | `"status"` | The publisher of the stream is idle and not transmitting data. |
		| `"NetStream.Publish.Start"` | `"status"` | Publish was successful. |
		| `"NetStream.Record.AlreadyExists"` | `"status"` | The stream being recorded maps to a file that is already being recorded to by another stream. This can happen due to misconfigured virtual directories. |
		| `"NetStream.Record.Failed"` | `"error"` | An attempt to record a stream failed. |
		| `"NetStream.Record.NoAccess"` | `"error"` | Attempt to record a stream that is still playing or the client has no access right. |
		| `"NetStream.Record.Start"` | `"status"` | Recording has started. |
		| `"NetStream.Record.Stop"` | `"status"` | Recording stopped. |
		| `"NetStream.Seek.Failed"` | `"error"` | The seek fails, which happens if the stream is not seekable. |
		| `"NetStream.Seek.InvalidTime"` | `"error"` | For video downloaded progressively, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The `info.details` property of the event object contains a time code that indicates the last valid position to which the user can seek. |
		| `"NetStream.Seek.Notify"` | `"status"` | The seek operation is complete.<br>Sent when `NetStream.seek()` is called on a stream in AS3 NetStream Data Generation Mode. The info object is extended to include `info.seekPoint` which is the same value passed to `NetStream.seek()`. |
		| `"NetStream.Step.Notify"` | `"status"` | The step operation is complete. |
		| `"NetStream.Unpause.Notify"` | `"status"` | The stream is resumed. |
		| `"NetStream.Unpublish.Success"` | `"status"` | The unpublish operation was successfuul. |
		| `"SharedObject.BadPersistence"` | `"error"` | A request was made for a shared object with persistence flags, but the request cannot be granted because the object has already been created with different flags. |
		| `"SharedObject.Flush.Failed"` | `"error"` | The "pending" status is resolved, but the `SharedObject.flush()` failed. |
		| `"SharedObject.Flush.Success"` | `"status"` | The "pending" status is resolved and the `SharedObject.flush()` call succeeded. |
		| `"SharedObject.UriMismatch"` | `"error"` | An attempt was made to connect to a NetConnection object that has a different URI (URL) than the shared object. |

		If you consistently see errors regarding the buffer, try changing the
		buffer using the `NetStream.bufferTime` property.
	**/
	public var info:Dynamic;

	// @:noCompletion private static var __pool:ObjectPool<NetStatusEvent> = new ObjectPool<NetStatusEvent>(function() return new NetStatusEvent(null),
	// function(event) event.__init());

	/**
		Creates an Event object that contains information about `netStatus`
		events. Event objects are passed as parameters to event listeners.

		@param type       The type of the event. Event listeners can access
						  this information through the inherited `type`
						  property. There is only one type of status event:
						  `NetStatusEvent.NET_STATUS`.
		@param bubbles    Determines whether the Event object participates in
						  the bubbling stage of the event flow. Event
						  listeners can access this information through the
						  inherited `bubbles` property.
		@param cancelable Determines whether the Event object can be canceled.
						  Event listeners can access this information through
						  the inherited `cancelable` property.
		@param info       An object containing properties that describe the
						  object's status. Event listeners can access this
						  object through the `info` property.
	**/
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false, info:Dynamic = null):Void
	{
		this.info = info;

		super(type, bubbles, cancelable);
	}

	public override function clone():NetStatusEvent
	{
		var event = new NetStatusEvent(type, bubbles, cancelable, info);
		event.target = target;
		event.currentTarget = currentTarget;
		event.eventPhase = eventPhase;
		return event;
	}

	public override function toString():String
	{
		return __formatToString("NetStatusEvent", ["type", "bubbles", "cancelable", "info"]);
	}

	@:noCompletion private override function __init():Void
	{
		super.__init();
		info = null;
	}
}
#else
typedef NetStatusEvent = flash.events.NetStatusEvent;
#end
