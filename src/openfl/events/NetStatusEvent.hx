package openfl.events;

#if !flash
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
		// TODO: Table <tgroup
		cols="2"><thead><row><entry>Property</entry><entry>Value</entry></row></thead><tbody><row><entry>`bubbles`</entry><entry>`false`</entry></row><row><entry>`cancelable`</entry><entry>`false`;
		there is no default behavior to
		cancel.</entry></row><row><entry>`currentTarget`</entry><entry>The
		object that is actively processing the Event object with an event
		listener.</entry></row><row><entry>`info`</entry><entry>An object with
		properties that describe the object's status or error
		condition.</entry></row><row><entry>`target`</entry><entry>The
		NetConnection or NetStream object reporting its status.
		</entry></row></tbody></tgroup>
	**/
	public static inline var NET_STATUS:String = "netStatus";

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
		// TODO: Table <tgroup cols="3"><thead><row><entry>Code
		property</entry><entry>Level
		property</entry><entry>Meaning</entry></row></thead><tbody><row><entry>`"NetConnection.Call.BadVersion"`</entry><entry>`"error"`</entry><entry>Packet
		encoded in an unidentified
		format.</entry></row><row><entry>`"NetConnection.Call.Failed"`</entry><entry>`"error"`</entry><entry>The
		`NetConnection.call()` method was not able to invoke the server-side
		method or
		command.</entry></row><row><entry>`"NetConnection.Call.Prohibited"`</entry><entry>`"error"`</entry><entry>An
		Action Message Format (AMF) operation is prevented for security
		reasons. Either the AMF URL is not in the same domain as the file
		containing the code calling the `NetConnection.call()` method, or the
		AMF server does not have a policy file that trusts the domain of the
		the file containing the code calling the `NetConnection.call()`
		method.
		</entry></row><row><entry>`"NetConnection.Connect.AppShutdown"`</entry><entry>`"error"`</entry><entry>The
		server-side application is shutting
		down.</entry></row><row><entry>`"NetConnection.Connect.Closed"`</entry><entry>`"status"`</entry><entry>The
		connection was closed
		successfully.</entry></row><row><entry>`"NetConnection.Connect.Failed"`</entry><entry>`"error"`</entry><entry>The
		connection attempt
		failed.</entry></row><row><entry>`"NetConnection.Connect.IdleTimeout"`</entry><entry>`"status"`</entry><entry>Flash
		Media Server disconnected the client because the client was idle
		longer than the configured value for `<MaxIdleTime>`. On Flash Media
		Server, `<AutoCloseIdleClients>` is disabled by default. When enabled,
		the default timeout value is 3600 seconds (1 hour). For more
		information, see <a
		href="http://help.adobe.com/en_US/flashmediaserver/configadmin/WS5b3ccc516d4fbf351e63e3d119f2925e64-7ff0.html#WS5b3ccc516d4fbf351e63e3d119f2925e64-7fe9"
		scope="external">Close idle connections</a>.
		</entry></row><row><entry>`"NetConnection.Connect.InvalidApp"`</entry><entry>`"error"`</entry><entry>The
		application name specified in the call to `NetConnection.connect()` is
		invalid.</entry></row><row><entry>`"NetConnection.Connect.NetworkChange"`</entry><entry>`"status"`</entry><entry>
		Flash Player has detected a network change, for example, a dropped
		wireless connection, a successful wireless connection,or a network
		cable loss.

		Use this event to check for a network interface change. Don't use this
		event to implement your NetConnection reconnect logic. Use
		`"NetConnection.Connect.Closed"` to implement your NetConnection
		reconnect logic.

		</entry></row><row><entry>`"NetConnection.Connect.Rejected"`</entry><entry>`"error"`</entry><entry>The
		connection attempt did not have permission to access the
		application.</entry></row><row><entry>`"NetConnection.Connect.Success"`</entry><entry>`"status"`</entry><entry>The
		connection attempt succeeded.</entry></row><row><entry><a
		name="code_NetGroup_Connect_Failed"
		id="code_NetGroup_Connect_Failed">`"NetGroup.Connect.Failed"`</a></entry><entry>`"error"`</entry><entry>The
		NetGroup connection attempt failed. The `info.group` property
		indicates which NetGroup failed.</entry></row><row><entry><a
		name="code_NetGroup_Connect_Rejected"
		id="code_NetGroup_Connect_Rejected">`"NetGroup.Connect.Rejected"`</a></entry><entry>`"error"`</entry><entry>The
		NetGroup is not authorized to function. The `info.group` property
		indicates which NetGroup was denied.</entry></row><row><entry><a
		name="code_NetGroup_Connect_Success">`"NetGroup.Connect.Succcess"`</a></entry><entry>`"status"`</entry><entry>The
		NetGroup is successfully constructed and authorized to function. The
		`info.group` property indicates which NetGroup has
		succeeded.</entry></row><row><entry><a
		name="code_NetGroup_LocalCoverage_Notify"
		id="code_NetGroup_LocalCoverage_Notify">`"NetGroup.LocalCoverage.Notify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a portion of the group address space for which this node is
		responsible changes.</entry></row><row><entry><a
		name="code_NetGroup_MulticastStream_PublishNotify"
		id="code_NetGroup_MulticastStream_PublishNotify">`"NetGroup.MulticastStream.PublishNotify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a new named stream is detected in NetGroup's Group. The
		`info.name:String` property is the name of the detected
		stream.</entry></row><row><entry><a
		name="code_NetGroup_MulticastStream_UnpublishNotify"
		id="code_NetGroup_MulticastStream_UnpublishNotify">`"NetGroup.MulticastStream.UnpublishNotify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a named stream is no longer available in the Group. The
		`info.name:String` property is name of the stream which has
		disappeared.</entry></row><row><entry><a
		name="code_NetGroup_Neighbor_Connect"
		id="code_NetGroup_Neighbor_Connect">`"NetGroup.Neighbor.Connect"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a neighbor connects to this node. The `info.neighbor:String`
		property is the group address of the neighbor. The
		`info.peerID:String` property is the peer ID of the
		neighbor.</entry></row><row><entry><a
		name="code_NetGroup_Neighbor_Disconnect"
		id="code_NetGroup_Neighbor_Disconnect">`"NetGroup.Neighbor.Disconnect"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a neighbor disconnects from this node. The `info.neighbor:String`
		property is the group address of the neighbor. The
		`info.peerID:String` property is the peer ID of the
		neighbor.</entry></row><row><entry><a
		name="code_NetGroup_Posting_Notify"
		id="code_NetGroup_Posting_Notify">`"NetGroup.Posting.Notify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a new Group Posting is received. The `info.message:Object`
		property is the message. The `info.messageID:String` property is this
		message's messageID.</entry></row><row><entry><a
		name="code_NetGroup_Replication_Fetch_Failed"
		id="code_NetGroup_Replication_Fetch_Failed">`"NetGroup.Replication.Fetch.Failed"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a fetch request for an object (previously announced with
		NetGroup.Replication.Fetch.SendNotify) fails or is denied. A new
		attempt for the object will be made if it is still wanted. The
		`info.index:Number` property is the index of the object that had been
		requested.</entry></row><row><entry><a
		name="code_NetGroup_Replication_Fetch_Result"
		id="code_NetGroup_Replication_Fetch_Result">`"NetGroup.Replication.Fetch.Result"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a fetch request was satisfied by a neighbor. The
		`info.index:Number` property is the object index of this result. The
		`info.object:Object` property is the value of this object. This index
		will automatically be removed from the Want set. If the object is
		invalid, this index can be re-added to the Want set with
		`NetGroup.addWantObjects()`.</entry></row><row><entry><a
		name="code_NetGroup_Replication_Fetch_SendNotify"
		id="code_NetGroup_Replication_Fetch_SendNotify">`"NetGroup.Replication.Fetch.SendNotify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when the Object Replication system is about to send a request for an
		object to a neighbor.The `info.index:Number` property is the index of
		the object that is being requested.</entry></row><row><entry><a
		name="code_NetGroup_Replication_Request"
		id="code_NetGroup_Replication_Request">`"NetGroup.Replication.Request"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a neighbor has requested an object that this node has announced
		with `NetGroup.addHaveObjects()`. This request **must** eventually be
		answered with either `NetGroup.writeRequestedObject()` or
		`NetGroup.denyRequestedObject()`. Note that the answer may be
		asynchronous. The `info.index:Number` property is the index of the
		object that has been requested. The `info.requestID:int` property is
		the ID of this request, to be used by
		`NetGroup.writeRequestedObject()` or
		`NetGroup.denyRequestedObject()`.</entry></row><row><entry><a
		name="code_NetGroup_SendTo_Notify">`"NetGroup.SendTo.Notify"`</a></entry><entry>`"status"`</entry><entry>Sent
		when a message directed to this node is received. The
		`info.message:Object` property is the message. The `info.from:String`
		property is the groupAddress from which the message was received. The
		`info.fromLocal:Boolean` property is `TRUE` if the message was sent by
		this node (meaning the local node is the nearest to the destination
		group address), and `FALSE` if the message was received from a
		different node. To implement recursive routing, the message must be
		resent with `NetGroup.sendToNearest()` if `info.fromLocal` is
		`FALSE`.</entry></row><row><entry>`"NetStream.Buffer.Empty"`</entry><entry>`"status"`</entry><entry>Flash
		Player is not receiving data quickly enough to fill the buffer. Data
		flow is interrupted until the buffer refills, at which time a
		`NetStream.Buffer.Full` message is sent and the stream begins playing
		again.</entry></row><row><entry>`"NetStream.Buffer.Flush"`</entry><entry>`"status"`</entry><entry>Data
		has finished streaming, and the remaining buffer is
		emptied.</entry></row><row><entry>`"NetStream.Buffer.Full"`</entry><entry>`"status"`</entry><entry>The
		buffer is full and the stream begins
		playing.</entry></row><row><entry>`"NetStream.Connect.Closed"`</entry><entry>`"status"`</entry><entry>The
		P2P connection was closed successfully. The `info.stream` property
		indicates which stream has
		closed.</entry></row><row><entry>`"NetStream.Connect.Failed"`</entry><entry>`"error"`</entry><entry>The
		P2P connection attempt failed. The `info.stream` property indicates
		which stream has failed.</entry></row><row><entry><a
		name="code_NetStream_Connect_Rejected"
		id="code_NetStream_Connect_Rejected">`"NetStream.Connect.Rejected"`</a></entry><entry>`"error"`</entry><entry>The
		P2P connection attempt did not have permission to access the other
		peer. The `info.stream` property indicates which stream was
		rejected.</entry></row><row><entry><a
		name="code_NetStream_Connect_Success"
		id="code_NetStream_Connect_Success">`"NetStream.Connect.Success"`</a></entry><entry>`"status"`</entry><entry>The
		P2P connection attempt succeeded. The `info.stream` property indicates
		which stream has
		succeeded.</entry></row><row><entry>`"NetStream.DRM.UpdateNeeded"`</entry><entry>`"status"`</entry><entry>A
		NetStream object is attempting to play protected content, but the
		required Flash Access module is either not present, not permitted by
		the effective content policy, or not compatible with the current
		player. To update the module or player, use the `update()` method of
		flash.system.SystemUpdater.
		</entry></row><row><entry>`"NetStream.Failed"`</entry><entry>`"error"`</entry><entry>(Flash
		Media Server) An error has occurred for a reason other than those
		listed in other event codes.
		</entry></row><row><entry>`"NetStream.MulticastStream.Reset"`</entry><entry>`"status"`</entry><entry>A
		multicast subscription has changed focus to a different stream
		published with the same name in the same group. Local overrides of
		multicast stream parameters are lost. Reapply the local overrides or
		the new stream's default parameters will be
		used.</entry></row><row><entry>`"NetStream.Pause.Notify"`</entry><entry>`"status"`</entry><entry>The
		stream is
		paused.</entry></row><row><entry>`"NetStream.Play.Failed"`</entry><entry>`"error"`</entry><entry>An
		error has occurred in playback for a reason other than those listed
		elsewhere in this table, such as the subscriber not having read
		access.</entry></row><row><entry>`"NetStream.Play.FileStructureInvalid"`</entry><entry>`"error"`</entry><entry>(AIR
		and Flash Player 9.0.115.0) The application detects an invalid file
		structure and will not try to play this type of file.
		</entry></row><row><entry>`"NetStream.Play.InsufficientBW"`</entry><entry>`"warning"`</entry><entry>(Flash
		Media Server) The client does not have sufficient bandwidth to play
		the data at normal speed.
		</entry></row><row><entry>`"NetStream.Play.NoSupportedTrackFound"`</entry><entry>`"error"`</entry><entry>(AIR
		and Flash Player 9.0.115.0) The application does not detect any
		supported tracks (video, audio or data) and will not try to play the
		file.</entry></row><row><entry>`"NetStream.Play.PublishNotify"`</entry><entry>`"status"`</entry><entry>The
		initial publish to a stream is sent to all
		subscribers.</entry></row><row><entry>`"NetStream.Play.Reset"`</entry><entry>`"status"`</entry><entry>Caused
		by a play list
		reset.</entry></row><row><entry>`"NetStream.Play.Start"`</entry><entry>`"status"`</entry><entry>Playback
		has
		started.</entry></row><row><entry>`"NetStream.Play.Stop"`</entry><entry>`"status"`</entry><entry>Playback
		has
		stopped.</entry></row><row><entry>`"NetStream.Play.StreamNotFound"`</entry><entry>`"error"`</entry><entry>The
		file passed to the `NetStream.play()` method can't be
		found.</entry></row><row><entry>`"NetStream.Play.Transition"`</entry><entry>`"status"`</entry><entry>(Flash
		Media Server 3.5) The server received the command to transition to
		another stream as a result of bitrate stream switching. This code
		indicates a success status event for the `NetStream.play2()` call to
		initiate a stream switch. If the switch does not succeed, the server
		sends a `NetStream.Play.Failed` event instead. When the stream switch
		occurs, an `onPlayStatus` event with a code of
		"NetStream.Play.TransitionComplete" is dispatched. For Flash Player 10
		and
		later.</entry></row><row><entry>`"NetStream.Play.UnpublishNotify"`</entry><entry>`"status"`</entry><entry>An
		unpublish from a stream is sent to all
		subscribers.</entry></row><row><entry>`"NetStream.Publish.BadName"`</entry><entry>`"error"`</entry><entry>Attempt
		to publish a stream which is already being published by someone
		else.</entry></row><row><entry>`"NetStream.Publish.Idle"`</entry><entry>`"status"`</entry><entry>The
		publisher of the stream is idle and not transmitting
		data.</entry></row><row><entry>`"NetStream.Publish.Start"`</entry><entry>`"status"`</entry><entry>Publish
		was
		successful.</entry></row><row><entry>`"NetStream.Record.AlreadyExists"`</entry><entry>`"status"`</entry><entry>The
		stream being recorded maps to a file that is already being recorded to
		by another stream. This can happen due to misconfigured virtual
		directories.</entry></row><row><entry>`"NetStream.Record.Failed"`</entry><entry>`"error"`</entry><entry>An
		attempt to record a stream
		failed.</entry></row><row><entry>`"NetStream.Record.NoAccess"`</entry><entry>`"error"`</entry><entry>Attempt
		to record a stream that is still playing or the client has no access
		right.</entry></row><row><entry>`"NetStream.Record.Start"`</entry><entry>`"status"`</entry><entry>Recording
		has
		started.</entry></row><row><entry>`"NetStream.Record.Stop"`</entry><entry>`"status"`</entry><entry>Recording
		stopped.</entry></row><row><entry>`"NetStream.Seek.Failed"`</entry><entry>`"error"`</entry><entry>The
		seek fails, which happens if the stream is not
		seekable.</entry></row><row><entry>`"NetStream.Seek.InvalidTime"`</entry><entry>`"error"`</entry><entry>For
		video downloaded progressively, the user has tried to seek or play
		past the end of the video data that has downloaded thus far, or past
		the end of the video once the entire file has downloaded. The
		`info.details` property of the event object contains a time code that
		indicates the last valid position to which the user can
		seek.</entry></row><row><entry>`"NetStream.Seek.Notify"`</entry><entry>`"status"`</entry><entry>
		The seek operation is complete.

		Sent when `NetStream.seek()` is called on a stream in AS3 NetStream
		Data Generation Mode. The info object is extended to include
		`info.seekPoint` which is the same value passed to `NetStream.seek()`.

		</entry></row><row><entry>`"NetStream.Step.Notify"`</entry><entry>`"status"`</entry><entry>The
		step operation is
		complete.</entry></row><row><entry>`"NetStream.Unpause.Notify"`</entry><entry>`"status"`</entry><entry>The
		stream is
		resumed.</entry></row><row><entry>`"NetStream.Unpublish.Success"`</entry><entry>`"status"`</entry><entry>The
		unpublish operation was
		successfuul.</entry></row><row><entry>`"SharedObject.BadPersistence"`</entry><entry>`"error"`</entry><entry>A
		request was made for a shared object with persistence flags, but the
		request cannot be granted because the object has already been created
		with different
		flags.</entry></row><row><entry>`"SharedObject.Flush.Failed"`</entry><entry>`"error"`</entry><entry>The
		"pending" status is resolved, but the `SharedObject.flush()`
		failed.</entry></row><row><entry>`"SharedObject.Flush.Success"`</entry><entry>`"status"`</entry><entry>The
		"pending" status is resolved and the `SharedObject.flush()` call
		succeeded.</entry></row><row><entry>`"SharedObject.UriMismatch"`</entry><entry>`"error"`</entry><entry>An
		attempt was made to connect to a NetConnection object that has a
		different URI (URL) than the shared
		object.</entry></row></tbody></tgroup>
		If you consistently see errors regarding the buffer, try changing the
		buffer using the `NetStream.bufferTime` property.
	**/
	public var info:Dynamic;

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

	public override function clone():Event
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
}
#else
typedef NetStatusEvent = flash.events.NetStatusEvent;
#end
