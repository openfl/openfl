package openfl.net;

#if !flash
import haxe.Timer;
import openfl.events.EventDispatcher;
import openfl.events.NetStatusEvent;
import openfl.media.SoundMixer;
import openfl.media.SoundTransform;
#if (js && html5)
import js.html.VideoElement;
import js.Browser;
#end

/**
	The NetStream class opens a one-way streaming channel over a
	NetConnection.
	Use the NetStream class to do the following:

	* Call `NetStream.play()` to play a media file from a local disk, a web
	server, or Flash Media Server.
	* Call `NetStream.publish()` to publish a video, audio, and data stream to
	Flash Media Server.
	* Call `NetStream.send()` to send data messages to all subscribed clients.
	* Call `NetStream.send()` to add metadata to a live stream.
	* Call `NetStream.appendBytes()` to pass ByteArray data into the
	NetStream.

	**Note:**You cannot play and publish a stream over the same NetStream
	object.

	Adobe AIR and Flash Player 9.0.115.0 and later versions support files
	derived from the standard MPEG-4 container format. These files include
	F4V, MP4, M4A, MOV, MP4V, 3GP, and 3G2 if they contain H.264 video, HEAAC
	v2 encoded audio, or both. H.264 delivers higher quality video at lower
	bit rates when compared to the same encoding profile in Sorenson or On2.
	AAC is a standard audio format defined in the MPEG-4 video standard.
	HE-AAC v2 is an extension of AAC that uses Spectral Band Replication (SBR)
	and Parametric Stereo (PS) techniques to increase coding efficiency at low
	bit rates.

	For information about supported codecs and file formats, see the
	following:

	* <a href="http://www.adobe.com/go/learn_fms_fileformats_en"
	scope="external">Flash Media Server documentation</a>
	* <a href="http://www.adobe.com/go/hardware_scaling_en"
	scope="external">Exploring Flash Player support for high-definition H.264
	video and AAC audio</a>
	* <a href="http://www.adobe.com/go/video_file_format"
	scope="external">FLV/F4V open specification documents</a>

	**Receiving data from a Flash Media Server stream, progressive F4V file,
	or progressive FLV file**

	Flash Media Server, F4V files, and FLV files can send event objects
	containing data at specific data points during streaming or playback. You
	can handle data from a stream or FLV file during playback in two ways:

	*  Associate a client property with an event handler to receive the data
	object. Use the `NetStream.client` property to assign an object to call
	specific data handling functions. The object assigned to the
	`NetStream.client` property can listen for the following data points:
	`onCuePoint()`, `onImageData()`, `onMetaData()`, `onPlayStatus()`,
	`onSeekPoint()`, `onTextData()`, and `onXMPData()`. Write procedures
	within those functions to handle the data object returned from the stream
	during playback. See the `NetStream.client` property for more information.

	*  Associate a client property with a subclass of the NetStream class,
	then write an event handler to receive the data object. NetStream is a
	sealed class, which means that properties or methods cannot be added to a
	NetStream object at runtime. However, you can create a subclass of
	NetStream and define your event handler in the subclass. You can also make
	the subclass dynamic and add the event handler to an instance of the
	subclass.

	Wait to receive a `NetGroup.Neighbor.Connect` event before you use the
	object replication, direct routing, or posting APIs.

	**Note:** To send data through an audio file, like an mp3 file, use the
	Sound class to associate the audio file with a Sound object. Then, use the
	`Sound.id3` property to read metadata from the sound file.

	@event asyncError       Dispatched when an exception is thrown
							asynchronously נthat is, from native
							asynchronous code. This event is dispatched when a
							server calls a method on the client that is not
							defined.
	@event drmAuthenticate  Dispatched when a NetStream object tries to play a
							digital rights management (DRM) encrypted content
							that requires a user credential for authentication
							before playing.
							Use the ` setDRMAuthenticationCredentials()`
							method of the NetStream object to authenticate the
							user. If user authentication failed, the
							application retries authentication and dispatches
							a new DRMAuthenticateEvent event for the NetStream
							object.
	@event drmError         Dispatched when a NetStream object, trying to play
							a digital rights management (DRM) encrypted file,
							encounters a DRM-related error. For example, a
							DRMErrorEvent object is dispatched when the user
							authorization fails. This may be because the user
							has not purchased the rights to view the content
							or because the content provider does not support
							the viewing application.
	@event drmStatus        Dispatched when the digital rights management
							(DRM) encrypted content begins playing (when the
							user is authenticated and authorized to play the
							content).
							DRMStatusEvent object contains information related
							to the voucher, such as whether the content is
							available offline or when the voucher expires and
							users can no longer view the content.
	@event ioError          Dispatched when an input or output error occurs
							that causes a network operation to fail.
	@event mediaTypeData    Dispatched when playing video content and certain
							type of messages are processed.
							A NetDataEvent is dispatched for the following
							messages:

							* onCuePoint
							* onImageData
							* onMetaData
							* onPlayStatus (for code NetStream.Play.Complete)
							* onTextData
							* onXMPData

							**Note:** This event is not dispatched by content
							running in Flash Player in the browser on Android
							or Blackberry Tablet OS or by content running in
							AIR on iOS.
	@event netStatus        Dispatched when a NetStream object is reporting
							its status or error condition. The `netStatus`
							event contains an `info` property, which is an
							information object that contains specific
							information about the event, such as if a
							connection attempt succeeded or failed.
	@event onCuePoint       Establishes a listener to respond when an embedded
							cue point is reached while playing a video file.
							You can use the listener to trigger actions in
							your code when the video reaches a specific cue
							point, which lets you synchronize other actions in
							your application with video playback events. For
							information about video file formats supported by
							Flash Media Server, see the <a
							href="http://www.adobe.com/go/learn_fms_fileformats_en"
							scope="external">www.adobe.com/go/learn_fms_fileformats_en</a>.

							`onCuePoint` is actually a property of the
							`NetStream.client` object. IThe property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description. You cannot use the
							`addEventListener()` method, or any other
							EventDispatcher methods, to listen for, or process
							`onCuePoint` as an event. Define a callback
							function and attach it to one of the following
							objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. Create a subclass of NetStream and define
							your event handler in the subclass. You can also
							make the subclass dynamic and add the event
							handler function to an instance of the subclass.

							The associated event listener is triggered after a
							call to the `NetStream.play()` method, but before
							the video playhead has advanced.

							You can embed the following types of cue points in
							a video file:

							* A navigation cue point specifies a keyframe
							within the video file and the cue point's `time`
							property corresponds to that exact keyframe.
							Navigation cue points are often used as bookmarks
							or entry points to let users navigate through the
							video file.
							* An event cue point specifies a time. The time
							may or may not correspond to a specific keyframe.
							An event cue point usually represents a time in
							the video when something happens that could be
							used to trigger other application events.

							The `onCuePoint` event object has the following
							properties:

							| Property | Description |
							| --- | --- |
							| `name` | The name given to the cue point when it was embedded in the video file. |
							|`parameters` | An associative array of name and value pair strings specified for this cue point. Any valid string can be used for the parameter name or value. |
							|`time` | The time in seconds at which the cue point occurred in the video file during playback. |
							|`type` | The type of cue point that was reached, either navigation or event. |

							You can define cue points in a video file when you
							first encode the file, or when you import a video
							clip in the Flash authoring tool by using the
							Video Import wizard.

							The `onMetaData` event also retrieves information
							about the cue points in a video file. However the
							`onMetaData` event gets information about all of
							the cue points before the video begins playing.
							The `onCuePoint` event receives information about
							a single cue point at the time specified for that
							cue point during playback.

							Generally, to have your code respond to a specific
							cue point at the time it occurs, use the
							`onCuePoint` event to trigger some action in your
							code.

							You can use the list of cue points provided to the
							`onMetaData` event to let the user start playing
							the video at predefined points along the video
							stream. Pass the value of the cue point's `time`
							property to the `NetStream.seek()` method to play
							the video from that cue point.
	@event onDRMContentData Establishes a listener to respond when AIR
							extracts DRM content metadata embedded in a media
							file.
							A DRMContentData object contains the information
							needed to obtain a voucher required to play a
							DRM-protected media file. Use the DRMManager class
							to download the voucher with this information.

							`onDRMContentData` is a property of the
							`NetStream.client` object. This property is listed
							in the Events section because it responds to a
							data event when preloading embedded data from a
							local media file. For more information, see the
							NetStream class description. You cannot use the
							`addEventListener()` method, or any other
							EventDispatcher methods, to listen for, or process
							`onDRMContentData` as an event. Rather, you must
							define a single callback function and attach it
							directly to one of the following objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. However, you can create a subclass of
							NetStream and define your event handler in the
							subclass or make the subclass dynamic and add the
							event handler function to an instance of the
							subclass.
	@event onImageData      Establishes a listener to respond when Flash
							Player receives image data as a byte array
							embedded in a media file that is playing. The
							image data can produce either JPEG, PNG, or GIF
							content. Use the
							`openfl.display.Loader.loadBytes()` method to load
							the byte array into a display object.
							`onImageData` is actually a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description. You cannot use the
							`addEventListener()` method, or any other
							EventDispatcher methods, to listen for, or process
							`onImageData` as an event. Define a single
							callback function and attach it to one of the
							following objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. Create a subclass of NetStream and define
							your event handler in the subclass. You can also
							make the subclass dynamic and add the event
							handler function to an instance of the subclass.

							The associated event listener is triggered after a
							call to the `NetStream.play()` method, but before
							the video playhead has advanced.

							The onImageData event object contains the image
							data as a byte array sent through an AMF0 data
							channel.
	@event onMetaData       Establishes a listener to respond when Flash
							Player receives descriptive information embedded
							in the video being played. For information about
							video file formats supported by Flash Media
							Server, see the <a
							href="http://www.adobe.com/go/learn_fms_fileformats_en"
							scope="external">www.adobe.com/go/learn_fms_fileformats_en</a>.

							`onMetaData` is actually a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description and the `NetStream.client` property.
							You cannot use the `addEventListener()` method, or
							any other EventDispatcher methods, to listen for
							or process `onMetaData` as an event. Define a
							single callback function and attach it to one of
							the following objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. You can create a subclass of NetStream
							and define your event handler in the subclass. You
							can also make the subclass dynamic and add the
							event handler function to an instance of the
							subclass.

							The Flash Video Exporter utility (version 1.1 or
							later) embeds a video's duration, creation date,
							data rates, and other information into the video
							file itself. Different video encoders embed
							different sets of meta data.

							The associated event listener is triggered after a
							call to the `NetStream.play()` method, but before
							the video playhead has advanced.

							In many cases, the duration value embedded in
							stream metadata approximates the actual duration
							but is not exact. In other words, it does not
							always match the value of the `NetStream.time`
							property when the playhead is at the end of the
							video stream.

							The event object passed to the onMetaData event
							handler contains one property for each piece of
							data.
	@event onPlayStatus     Establishes a listener to respond when a NetStream
							object has completely played a stream. The
							associated event object provides information in
							addition to what's returned by the `netStatus`
							event. You can use this property to trigger
							actions in your code when a NetStream object has
							switched from one stream to another stream in a
							playlist (as indicated by the information object
							`NetStream.Play.Switch`) or when a NetStream
							object has played to the end (as indicated by the
							information object `NetStream.Play.Complete`).
							`onPlayStaus` is actually a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description. You cannot use the
							`addEventListener()` method, or any other
							EventDispatcher methods, to listen for, or process
							`onPlayStatus` as an event. Define a callback
							function and attach it to one of the following
							objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. Create a subclass of NetStream and define
							your event handler in the subclass. You can also
							make the subclass dynamic and add the event
							handler function to an instance of the subclass.

							This event can return an information object with
							the following properties:

							| Code property | Level property | Meaning |
							| --- | --- | --- |
							| `NetStream.Play.Switch` | `"status"` | The subscriber is switching from one stream to another in a playlist. |
							| `NetStream.Play.Complete` | `"status"` | Playback has completed. |
							| `NetStream.Play.TransitionComplete` | `"status"` | The subscriber is switching to a new stream as a result of stream bit-rate switching |
	@event onSeekPoint      Called synchronously from `appendBytes()` when the
							append bytes parser encounters a point that it
							believes is a seekable point (for example, a video
							key frame). Use this event to construct a seek
							point table. The `byteCount` corresponds to the
							`byteCount` at the first byte of the parseable
							message for that seek point, and is reset to zero
							as described above. To seek, at the event
							`NetStream.Seek.Notify`, find the bytes that start
							at a seekable point and call `appendBytes(bytes)`.
							If the `bytes` argument is a `ByteArray`
							consisting of bytes starting at the seekable
							point, the video plays at that seek point.
							**Note:** Calls to `appendBytes()` from within
							this callback are ignored.

							The `onSeekPoint` property is a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to data
							coming into the `appendBytes()` method. For more
							information, see the NetStream class description
							and the `NetStream.client` property. You cannot
							use the `addEventListener()` method, or any other
							EventDispatcher methods, to listen for or process
							`onSeekPoint` as an event. To use `onSeekPoint`,
							define a callback function and attach it to one of
							the following objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. However, you can create a subclass of
							NetStream and define your event handler in the
							subclass. You can also make the subclass dynamic
							and add the event handler function to an instance
							of the subclass.
	@event onTextData       Establishes a listener to respond when Flash
							Player receives text data embedded in a media file
							that is playing. The text data is in UTF-8 format
							and can contain information about formatting based
							on the 3GP timed text specification.
							`onTextData` is actually a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description. You cannot use the
							`addEventListener()` method, or any other
							EventDispatcher methods, to listen for, or process
							`onTextData` as an event. Define a callback
							function and attach it to one of the following
							objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. Create a subclass of NetStream and define
							your event handler in the subclass. You can also
							make the subclass dynamic and add the event
							handler function to an instance of the subclass.

							The associated event listener is triggered after a
							call to the `NetStream.play()` method, but before
							the video playhead has advanced.

							The onTextData event object contains one property
							for each piece of text data.
	@event onXMPData        Establishes a listener to respond when Flash
							Player receives information specific to Adobe
							Extensible Metadata Platform (XMP) embedded in the
							video being played. For information about video
							file formats supported by Flash Media Server, see
							the <a
							href="http://www.adobe.com/go/learn_fms_fileformats_en"
							scope="external">www.adobe.com/go/learn_fms_fileformats_en</a>.

							`onXMPData` is actually a property of the
							`NetStream.client` object. The property is listed
							in the Events section because it responds to a
							data event, either when streaming media using
							Flash Media Server or during FLV file playback.
							For more information, see the NetStream class
							description and the `NetStream.client` property.
							You cannot use the `addEventListener()` method, or
							any other EventDispatcher methods, to listen for
							or process `onMetaData` as an event. Define a
							callback function and attach it to one of the
							following objects:

							* The object that the `client` property of a
							NetStream instance references.
							* An instance of a NetStream subclass. NetStream
							is a sealed class, which means that properties or
							methods cannot be added to a NetStream object at
							runtime. However, you can create a subclass of
							NetStream and define your event handler in the
							subclass. You can also make the subclass dynamic
							and add the event handler function to an instance
							of the subclass.

							The associated event listener is triggered after a
							call to the `NetStream.play()` method, but before
							the video playhead has advanced.

							The object passed to the `onXMPData()` event
							handling function has one `data` property, which
							is a string. The string is generated from a
							top-level UUID box. (The 128-bit UUID of the top
							level box is
							`BE7ACFCB-97A9-42E8-9C71-999491E3AFAC`.) This
							top-level UUID box contains exactly one XML
							document represented as a null-terminated UTF-8
							string.
	@event status           Dispatched when the application attempts to play
							content encrypted with digital rights management
							(DRM), by invoking the `NetStream.play()` method.
							The value of the status code property will be
							`"DRM.encryptedFLV"`.
**/
@:access(openfl.media.SoundMixer)
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NetStream extends EventDispatcher
{
	#if false
	/**
		A static object used as a parameter to the constructor for a NetStream
		instance. It is the default value of the second parameter in the
		NetStream constructor; it is not used by the application for
		progressive media playback. When used, this parameter causes the
		constructor to make a connection to a Flash Media Server instance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public static var CONNECT_TO_FMS:String;
	#end

	#if false
	/**
		Creates a peer-to-peer publisher connection. Pass this string for the
		second (optional) parameter to the constructor for a NetStream
		instance. With this string, an application can create a NetStream
		connection for the purposes of publishing audio and video to clients.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public static var DIRECT_CONNECTIONS:String;
	#end
	@:dox(hide) @:noCompletion @SuppressWarnings("checkstyle:FieldDocComment")
	public var audioCodec(default, null):Int;

	#if false
	/**
		For RTMFP connections, specifies whether audio is sent with full
		reliability. When TRUE, all audio transmitted over this NetStream is
		fully reliable. When FALSE, the audio transmitted is not fully
		reliable, but instead is retransmitted for a limited time and then
		dropped. You can use the FALSE value to reduce latency at the expense
		of audio quality.
		If you try to set this property to FALSE on a network protocol that
		does not support partial reliability, the attempt is ignored and the
		property is set to TRUE.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioReliable:Bool;
	#end

	#if false
	/**
		For RTMFP connections, specifies whether peer-to-peer subscribers on
		this NetStream are allowed to capture the audio stream. When FALSE,
		subscriber attempts to capture the audio stream show permission
		errors.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioSampleAccess:Bool;
	#end

	#if false
	/**
		The number of seconds of previously displayed data that currently
		cached for rewinding and playback.
		This property is available only when data is streaming from Flash
		Media Server 3.5.3 or higher; for more information on Flash Media
		Server, see the class description.

		To specify how much previously displayed data is cached, use the
		`Netstream.backBufferTime` property.

		To prevent data from being cached, set the `Netstream.inBufferSeek`
		property to FALSE.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferLength (default, null):Float;
	#end

	#if false
	/**
		Specifies how much previously displayed data Flash Player tries to
		cache for rewinding and playback, in seconds. The default value is 30
		seconds for desktop applications and 3 seconds for mobile
		applications.
		This property is available only when data is streaming from Flash
		Media Server version 3.5.3 or later; for more information on Flash
		Media Server, see the class description.

		Using this property improves performance for rewind operations, as
		data that has already been displayed isn't retrieved from the server
		again. Instead, the stream begins replaying from the buffer. During
		playback, data continues streaming from the server until the buffer is
		full.

		If the rewind position is farther back than the data in the cache, the
		buffer is flushed; the data then starts streaming from the server at
		the requested position.

		To use this property set the `Netstream.inBufferSeek` property to
		TRUE.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferTime:Float;
	#end

	/**
		The number of seconds of data currently in the buffer. You can use
		this property with the `bufferTime` property to estimate how close the
		buffer is to being full נfor example, to display feedback to a user
		who is waiting for data to be loaded into the buffer.
	**/
	public var bufferLength(default, null):Float;

	/**
		Specifies how long to buffer messages before starting to display the
		stream.
		The default value is 0.1 (one-tenth of a second). To determine the
		number of seconds currently in the buffer, use the `bufferLength`
		property.

		To play a server-side playlist, set `bufferTime` to at least 1 second.
		If you experience playback issues, increase the length of
		`bufferTime`.

		**Recorded content** To avoid distortion when streaming pre-recorded
		(not live) content, do not set the value of `Netstream.bufferTime` to
		0. By default, the application uses an input buffer for pre-recorded
		content that queues the media data and plays the media properly. For
		pre-recorded content, use the default setting or increase the buffer
		time.

		**Live content** When streaming live content, set the `bufferTime`
		property to 0.

		Starting with Flash Player 9.0.115.0, Flash Player no longer clears
		the buffer when `NetStream.pause()` is called. Before Flash Player
		9.0.115.0, Flash Player waited for the buffer to fill up before
		resuming playback, which often caused a delay.

		For a single pause, the `NetStream.bufferLength` property has a limit
		of either 60 seconds or twice the value of `NetStream.bufferTime`,
		whichever value is higher. For example, if `bufferTime` is 20 seconds,
		Flash Player buffers until `NetStream.bufferLength` is the higher
		value of either 20*2 (40), or 60. In this case it buffers until
		`bufferLength` is 60. If `bufferTime` is 40 seconds, Flash Player
		buffers until `bufferLength` is the higher value of 40*2 (80), or 60.
		In this case it buffers until `bufferLength` is 80 seconds.

		The `bufferLength` property also has an absolute limit. If any call to
		`pause()` causes `bufferLength` to increase more than 600 seconds or
		the value of `bufferTime`* 2, whichever is higher, Flash Player
		flushes the buffer and resets `bufferLength` to 0. For example, if
		`bufferTime` is 120 seconds, Flash Player flushes the buffer if
		`bufferLength` reaches 600 seconds; if `bufferTime` is 360 seconds,
		Flash Player flushes the buffer if `bufferLength` reaches 720 seconds.

		**Tip**: You can use `NetStream.pause()` in code to buffer data while
		viewers are watching a commercial, for example, and then unpause when
		the main video starts.

		For more information about the new pause behavior, see <a
		href="http://www.adobe.com/go/learn_fms_smartpause_en"
		scope="external">http://www.adobe.com/go/learn_fms_smartpause_en</a>.

		**Flash Media Server**. The buffer behavior depends on whether the
		buffer time is set on a publishing stream or a subscribing stream. For
		a publishing stream, `bufferTime` specifies how long the outgoing
		buffer can grow before the application starts dropping frames. On a
		high-speed connection, buffer time is not a concern; data is sent
		almost as quickly as the application can buffer it. On a slow
		connection, however, there can be a significant difference between how
		fast the application buffers the data and how fast it is sent to the
		client.

		For a subscribing stream, `bufferTime` specifies how long to buffer
		incoming data before starting to display the stream.

		When a recorded stream is played, if `bufferTime` is 0, Flash sets it
		to a small value (approximately 10 milliseconds). If live streams are
		later played (for example, from a playlist), this buffer time
		persists. That is, `bufferTime` remains nonzero for the stream.
	**/
	public var bufferTime:Float;

	#if false
	/**
		Specifies a maximum buffer length for live streaming content, in
		seconds. The default value is 0. Buffer length can grow over time due
		to networking and device issues (such as clock drift between sender
		and receiver). Set this property to cap the buffer length for live
		applications such as meetings and surveillance.
		When `bufferTimeMax > 0` and `bufferLength >= bufferTimeMax`, audio
		plays faster until `bufferLength` reaches `bufferTime`. If a live
		stream is video-only, video plays faster until `bufferLength` reaches
		`bufferTime`.

		Depending on how much playback is lagging (the difference between
		`bufferLength` and `bufferTime`), Flash Player controls the rate of
		catch-up between 1.5% and 6.25%. If the stream contains audio, faster
		playback is achieved by frequency domain downsampling which minimizes
		audible distortion.

		Set the `bufferTimeMax` property to enable live buffered stream
		catch-up in the following cases:

		* Streaming live media from Flash Media Server.
		* Streaming live media in Data Generation Mode
		(`NetStream.appendBytes()`).
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var bufferTimeMax:Float;
	#end

	/**
		The number of bytes of data that have been loaded into the
		application. You can use this property with the `bytesTotal` property
		to estimate how close the buffer is to being full נfor example, to
		display feedback to a user who is waiting for data to be loaded into
		the buffer.
	**/
	public var bytesLoaded(default, null):Int;

	/**
		The total size in bytes of the file being loaded into the application.
	**/
	public var bytesTotal(default, null):Int;

	/**
		Specifies whether the application tries to download a cross-domain
		policy file from the loaded video file's server before beginning to
		load the video file. Use this property for progressive video download,
		and to load files that are outside the calling SWF file's own domain.
		This property is ignored when you are using RTMP.
		Set this property to `true` to call `BitmapData.draw()` on a video
		file loaded from a domain outside that of the calling SWF. The
		`BitmapData.draw()` method provides pixel-level access to the video.
		If you call `BitmapData.draw()` without setting the `checkPolicyFile`
		property to `true` at loading time, you can get a `SecurityError`
		exception because the required policy file was not downloaded.

		Do not set this property to true unless you want pixel-level access to
		the video you are loading. Checking for a policy file consumes network
		bandwidth and can delay the start of your download.

		When you call the `NetStream.play()` method with `checkPolicyFile` set
		to `true`, Flash Player or the AIR runtime must either successfully
		download a relevant cross-domain policy file or determine that no such
		policy file exists before it begins downloading. To verify the
		existence of a policy file, Flash Player or the AIR runtime performs
		the following actions, in this order:

		1. The application considers policy files that have already been
		downloaded.
		2. The application tries to download any pending policy files specified
		in calls to the `Security.loadPolicyFile()` method.
		3. The application tries to download a policy file from the default
		location that corresponds to the URL you passed to `NetStream.play()`,
		which is `/crossdomain.xml` on the same server as that URL.

		In all cases, Flash Player or Adobe AIR requires that an appropriate
		policy file exist on the video's server, that it provide access to the
		object at the URL you passed to `play()` based on the policy file's
		location, and that it allow the domain of the calling code's file to
		access the video, through one or more `<allow-access-from>` tags.

		If you set `checkPolicyFile` to `true`, the application waits until
		the policy file is verified before downloading the video. Wait to
		perform any pixel-level operations on the video data, such as calling
		`BitmapData.draw()`, until you receive `onMetaData` or `NetStatus`
		events from your NetStream object.

		If you set `checkPolicyFile` to `true` but no relevant policy file is
		found, you won't receive an error until you perform an operation that
		requires a policy file, and then the application throws a
		SecurityError exception.

		Be careful with `checkPolicyFile` if you are downloading a file from a
		URL that uses server-side HTTP redirects. The application tries to
		retrieve policy files that correspond to the initial URL that you
		specify in `NetStream.play()`. If the final file comes from a
		different URL because of HTTP redirects, the initially downloaded
		policy files might not be applicable to the file's final URL, which is
		the URL that matters in security decisions.

		For more information on policy files, see "Website controls (policy
		files)" in the _ActionScript 3.0 Developer's Guide_ and the Flash
		Player Developer Center Topic: <a
		href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.
	**/
	public var checkPolicyFile:Bool;

	/**
		Specifies the object on which callback methods are invoked to handle
		streaming or F4V/FLV file data. The default object is `this`, the
		NetStream object being created. If you set the `client` property to
		another object, callback methods are invoked on that other object. The
		`NetStream.client ` object can call the following functions and
		receive an associated data object: `onCuePoint()`, `onImageData()`,
		`onMetaData()`, `onPlayStatus()`, `onSeekPoint()`, `onTextData()`, and
		`onXMPData()`.
		**To associate the `client` property with an event handler:**

		1. Create an object and assign it to the `client` property of the
		NetStream object:
		```as3
		var customClient = new Object();
		my_netstream.client = customClient;
		```
		2. Assign a handler function for the desired data event as a property
		of the client object:
		```haxe
		customClient.onImageData = onImageDataHandler;
		```
		3. Write the handler function to receive the data event object, such
		as:
		```as3
		public function onImageDataHandler(imageData:Object):void {
			trace("imageData length: " + imageData.data.length);
		}
		```

		When data is passed through the stream or during playback, the data
		event object (in this case the `imageData` object) is populated with
		the data. See the `onImageData` description, which includes a full
		example of an object assigned to the `client` property.

		**To associate the `client` property with a subclass:**

		1. Create a subclass with a handler function to receive the data event
		object:
		```as3
		class CustomClient {
			public function onMetaData(info:Object):void {
				trace("metadata: duration=" + info.duration + " framerate=" + info.framerate);
			}
		```
		2. Assign an instance of the subclass to the `client` property of the
		NetStream object:
		```as3
		my_netstream.client = new CustomClient();
		```

		When data is passed through the stream or during playback, the data
		event object (in this case the `info` object) is populated with the
		data. See the class example at the end of the NetStream class, which
		shows the assignment of a subclass instance to the `client` property.

		@throws TypeError The `client` property must be set to a non-null
						  object.
	**/
	public var client:Dynamic;

	/**
		The number of frames per second being displayed. If you are exporting
		video files to be played back on a number of systems, you can check
		this value during testing to help you determine how much compression
		to apply when exporting the file.
	**/
	public var currentFPS(default, null):Float;

	#if false
	/**
		For RTMFP connections, specifies whether `NetStream.send()` calls are
		sent with full reliability. When TRUE, `NetStream.send()` calls that
		are transmitted over this NetStream are fully reliable. When FALSE,
		`NetStream.send()` calls are not transmitted with full reliability,
		but instead are retransmitted for a limited time and then dropped. You
		can set this value to FALSE to reduce latency at the expense of data
		quality.
		If you try to set this property to FALSE on a network protocol that
		does not support partial reliability, the attempt is ignored and the
		property is set to TRUE.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var dataReliable:Bool;
	#end
	@:dox(hide) @:noCompletion @SuppressWarnings("checkstyle:FieldDocComment")
	public var decodedFrames(default, null):Int;

	#if false
	/**
		For RTMFP connections, the identifier of the far end that is connected
		to this NetStream instance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
	#end

	#if false
	/**
		For RTMFP and RTMPE connections, a value chosen substantially by the
		other end of this stream, unique to this connection. This value
		appears to the other end of the stream as its `nearNonce` value.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
	#end

	#if false
	/**
		Specifies whether displayed data is cached for smart seeking (`TRUE`),
		or not (`FALSE`). The default value is FALSE.
		Flash Media Server 3.5.3 and Flash Player 10.1 work together to
		support smart seeking. Smart seeking uses back and forward buffers to
		seek without requesting data from the server. Standard seeking flushes
		buffered data and asks the server to send new data based on the seek
		time.

		Call `NetStream.step()` to step forward and backward a specified
		number of frames. Call `NetStream.seek()` to seek forward and backward
		a specified number of seconds.

		Smart seeking reduces server load and improves seeking performance.
		Set `inBufferSeek=true` and call `step()` and `seek()` to create:

		* Client-side DVR functionality. Seek within the client-side buffer
		instead of going to the server for delivery of new video.
		* Trick modes. Create players that step through frames, fast-forward,
		fast-rewind, and advance in slow-motion.

		When `inBufferSeek=true` and a call to `NetStream.seek()` is
		successful, the NetStatusEvent `info.description` property contains
		the string `"client-inBufferSeek"`.

		When a call to `NetStream.step()` is successful, the NetStatusEvent
		`info.code` property contains the string `"NetStream.Step.Notify"`.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var inBufferSeek:Bool;
	#end

	#if false
	/**
		Returns a NetStreamInfo object whose properties contain statistics
		about the quality of service. The object is a snapshot of the current
		state.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var info (default, null):openfl.net.NetStreamInfo;
	#end

	/**
		The number of seconds of data in the subscribing stream's buffer in
		live (unbuffered) mode. This property specifies the current network
		transmission delay (lag time).
		This property is intended primarily for use with a server such as
		Flash Media Server; for more information, see the class description.

		You can get the value of this property to roughly gauge the
		transmission quality of the stream and communicate it to the user.
	**/
	public var liveDelay(default, null):Float;

	#if false
	/**
		Specifies how long to buffer messages during pause mode, in seconds.
		This property can be used to limit how much buffering is done during
		pause mode. As soon as the value of `NetStream.bufferLength` reaches
		this limit, it stops buffering.
		If this value is not set, it defaults the limit to 60 seconds or twice
		the value of `NetStream.bufferTime` on each pause, whichever is
		higher.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var maxPauseBufferTime:Float;
	#end

	#if false
	/**
		For RTMFP connections, specifies whether peer-to-peer multicast
		fragment availability messages are sent to all peers or to just one
		peer. A value of TRUE specifies that the messages are sent to all
		peers once per specified interval. A value of FALSE specifies that the
		messages are sent to just one peer per specified interval. The
		interval is determined by the `multicastAvailabilityUpdatePeriod`
		property.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilitySendToAll:Bool;
	#end

	#if false
	/**
		For RTMFP connections, specifies the interval in seconds between
		messages sent to peers informing them that the local node has new
		peer-to-peer multicast media fragments available. Larger values can
		increase batching efficiency and reduce control overhead, but they can
		lower quality on the receiving end by reducing the amount of time
		available to retrieve fragments before they are out-of-window. Lower
		values can reduce latency and improve quality, but they increase
		control overhead.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilityUpdatePeriod:Float;
	#end

	#if false
	/**
		For RTMFP connections, specifies the time in seconds between when the
		local node learns that a peer-to-peer multicast media fragment is
		available and when it tries to fetch it from a peer. This value gives
		an opportunity for the fragment to be proactively pushed to the local
		node before a fetch from a peer is attempted. It also allows for more
		than one peer to announce availability of the fragment, so the fetch
		load can be spread among multiple peers.
		Larger values can improve load balancing and fairness in the
		peer-to-peer mesh, but reduce the available `multicastWindowDuration`
		and increase latency. Smaller values can reduce latency when fetching
		is required, but might increase duplicate data reception and reduce
		peer-to-peer mesh load balance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastFetchPeriod:Float;
	#end

	#if false
	/**
		For RTMFP connections, returns a NetStreamMulticastInfo object whose
		properties contain statistics about the quality of service. The object
		is a snapshot of the current state.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastInfo (default, null):openfl.net.NetStreamMulticastInfo;
	#end

	#if false
	/**
		For RTMFP connections, specifies the maximum number of peers to which
		to proactively push multicast media.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastPushNeighborLimit:Float;
	#end

	#if false
	/**
		For RTMFP connections, specifies the duration in seconds that
		peer-to-peer multicast data remains available to send to peers that
		request it beyond a specified duration. The duration is specified by
		the `multicastWindowDuration` property.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastRelayMarginDuration:Float;
	#end

	#if false
	/**
		For RTMFP connections, specifies the duration in seconds of the
		peer-to-peer multicast reassembly window. Shorter values reduce
		latency but may reduce quality by not allowing enough time to obtain
		all of the fragments. Conversely, larger values may increase quality
		by providing more time to obtain all of the fragments, with a
		corresponding increase in latency.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastWindowDuration:Float;
	#end

	#if false
	/**
		For RTMFP and RTMPE connections, a value chosen substantially by this
		end of the stream, unique to this connection. This value appears to
		the other end of the stream as its `farNonce` value.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
	#end

	/**
		The object encoding (AMF version) for this NetStream object. The
		NetStream object inherits its `objectEncoding` value from the
		associated NetConnection object. It's important to understand this
		property if your ActionScript 3.0 SWF file needs to communicate with
		servers released prior to Flash Player 9. For more information, see
		the `objectEncoding` property description in the NetConnection class.
		The value of this property depends on whether the stream is local or
		remote. Local streams, where `null` was passed to the
		`NetConnection.connect()` method, return the value of
		`NetConnection.defaultObjectEncoding`. Remote streams, where you are
		connecting to a server, return the object encoding of the connection
		to the server.

		If you try to read this property when not connected, or if you try to
		change this property, the application throws an exception.
	**/
	public var objectEncoding(default, null):ObjectEncoding;

	#if false
	/**
		An object that holds all of the subscribing NetStream instances that
		are listening to this publishing NetStream instance.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public var peerStreams (default, null):Array<Dynamic>;
	#end

	/**
		Controls sound in this NetStream object. For more information, see the
		SoundTransform class.
	**/
	public var soundTransform(get, set):SoundTransform;

	@:dox(hide) @:noCompletion @SuppressWarnings("checkstyle:FieldDocComment")
	public var speed(get, set):Float;

	/**
		The position of the playhead, in seconds.
		**Flash Media Server** For a subscribing stream, the number of seconds
		the stream has been playing. For a publishing stream, the number of
		seconds the stream has been publishing. This number is accurate to the
		thousandths decimal place; multiply by 1000 to get the number of
		milliseconds the stream has been playing.

		For a subscribing stream, if the server stops sending data but the
		stream remains open, the value of the `time` property stops advancing.
		When the server begins sending data again, the value continues to
		advance from the point at which it stopped (when the server stopped
		sending data).

		The value of `time` continues to advance when the stream switches from
		one playlist element to another. This property is set to 0 when
		`NetStream.play()` is called with `reset` set to `1` or `true`, or
		when `NetStream.close()` is called.
	**/
	public var time(default, null):Float;

	// @:noCompletion @:dox(hide) @:require(flash11) public var useHardwareDecoder:Bool;
	// @:noCompletion @:dox(hide) @:require(flash11_3) public var useJitterBuffer:Bool;
	public var videoCode(default, null):Int;

	#if false
	/**
		For RTMFP connections, specifies whether video is sent with full
		reliability. When TRUE, all video transmitted over this NetStream is
		fully reliable. When FALSE, the video transmitted is not fully
		reliable, but instead is retransmitted for a limited time and then
		dropped. You can use the FALSE value to reduce latency at the expense
		of video quality.
		If you try to set this property to FALSE on a network protocol that
		does not support partial reliability, the attempt is ignored and the
		property is set to TRUE.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoReliable:Bool;
	#end

	#if false
	/**
		For RTMFP connections, specifies whether peer-to-peer subscribers on
		this NetStream are allowed to capture the video stream. When FALSE,
		subscriber attempts to capture the video stream show permission
		errors.
	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoSampleAccess:Bool;
	#end
	// @:noCompletion @:dox(hide) @:require(flash11) public var videoStreamSettings:openfl.media.VideoStreamSettings;
	@:noCompletion private var __closed:Bool;
	@:noCompletion private var __connection:NetConnection;
	@:noCompletion private var __soundTransform:SoundTransform;
	@:noCompletion private var __timer:Timer;
	#if (js && html5)
	@:noCompletion private var __video(default, null):VideoElement;
	#end

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(NetStream.prototype, {
			"soundTransform": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_soundTransform (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_soundTransform (v); }")
			},
			"speed": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_speed (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_speed (v); }")
			},
		});
	}
	#end

	/**
		Creates a stream that you can use to play media files and send data
		over a NetConnection object.

		@param connection A NetConnection object.
		@param peerID     This optional parameter is available in Flash Player
						  10 and later, for use with RTMFP connections. (If
						  the value of the `NetConnection.protocol` property
						  is not `"rtmfp"`, this parameter is ignored.) Use
						  one of the following values:
						  * To connect to Flash Media Server, specify
						  `NetStream.CONNECT_TO_FMS`.
						  * To publish directly to peers, specify
						  `NetStream.DIRECT_CONNECTIONS`.
						  * To play directly from a specific peer, specify
						  that peer's identity (see `NetConnection.nearID` and
						  `NetStream.farID`).
						  * (Flash Player 10.1 or AIR 2 or later) To publish
						  or play a stream in a peer-to-peer multicast group,
						  specify a `groupspec` string (see the GroupSpecifier
						  class).

						  In most cases, a `groupspec` has the potential to
						  use the network uplink on the local system. In this
						  case, the user is asked for permission to use the
						  computer's network resources. If the user allows
						  this use, a `NetStream.Connect.Success`
						  NetStatusEvent is sent to the NetConnection's event
						  listener. If the user denies permission, a
						  `NetStream.Connect.Rejected` event is sent. When
						  specifying a `groupspec`, until a
						  `NetStream.Connect.Success` event is received, it is
						  an error to use any method of the NetStream object,
						  and an exception is raised.

						  If you include this parameter in your constructor
						  statement but pass a value of `null`, the value is
						  set to `"connectToFMS"`.
		@throws ArgumentError The NetConnection instance is not connected.
	**/
	public function new(connection:NetConnection, peerID:String = null):Void
	{
		super();

		__connection = connection;
		__soundTransform = new SoundTransform();

		#if (js && html5)
		__video = cast Browser.document.createElement("video");

		__video.setAttribute("playsinline", "");
		__video.setAttribute("webkit-playsinline", "");
		__video.setAttribute("crossorigin", "anonymous");

		__video.addEventListener("error", video_onError, false);
		__video.addEventListener("waiting", video_onWaiting, false);
		__video.addEventListener("ended", video_onEnd, false);
		__video.addEventListener("pause", video_onPause, false);
		__video.addEventListener("seeking", video_onSeeking, false);
		__video.addEventListener("playing", video_onPlaying, false);
		__video.addEventListener("timeupdate", video_onTimeUpdate, false);
		__video.addEventListener("loadstart", video_onLoadStart, false);
		__video.addEventListener("stalled", video_onStalled, false);
		__video.addEventListener("durationchanged", video_onDurationChanged, false);
		__video.addEventListener("canplay", video_onCanPlay, false);
		__video.addEventListener("canplaythrough", video_onCanPlayThrough, false);
		__video.addEventListener("loadedmetadata", video_onLoadMetaData, false);
		#end
	}

	#if false
	/**
		Passes a ByteArray into a NetStream for playout. Call this method on a
		NetStream in "Data Generation Mode". To put a NetStream into Data
		Generation Mode, call `NetStream.play(null)` on a NetStream created on
		a NetConnection connected to `null`. Calling `appendBytes()` on a
		NetStream that isn't in Data Generation Mode is an error and raises an
		exception.
		The byte parser understands an FLV file with a header. After the
		header is parsed, `appendBytes()` expects all future calls to be
		continuations of the same real or virtual file. Another header is not
		expected unless
		`appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN)` is called.

		A NetStream object has two buffers: the FIFO from `appendBytes()` to
		the NetStream, and the playout buffer. The FIFO is the partial-FLV-tag
		reassembly buffer and contains no more than one incomplete FLV tag.
		Calls to `NetStream.seek()` flush both buffers. After a call to
		`seek()`, call `appendBytesAction()` to reset the timescale to begin
		at the timestamp of the next appended message.

		Each call to `appendBytes()` adds bytes into the FIFO until an FLV tag
		is complete. When an FLV tag is complete, it moves to the playout
		buffer. A call to `appendBytes()` can write multiple FLV tags. The
		first bytes complete an existing FLV tag (which moves to the playout
		buffer). Complete FLV tags move to the playout buffer. Remaining bytes
		that donӴ form a complete FLV tag go into the FIFO. Bytes in the
		FIFO are either completed by a call to `appendBytes()` or flushed by a
		call to `appendBytesAction()` with the `RESET_SEEK` or `RESET_BEGIN`
		argument.

		**Note:** The byte parser may not be able to completely decode a call
		to `appendBytes()` until a subsequent call to `appendBytes()` is made.

	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytes (bytes:ByteArray):Void;
	#end

	#if false
	/**
		Indicates a timescale discontinuity, flushes the FIFO, and tells the
		byte parser to expect a file header or the beginning of an FLV tag.
		Calls to `NetStream.seek()` flush the NetStream buffers. The byte
		parser remains in flushing mode until you call `appendBytesAction()`
		and pass the `RESET_BEGIN` or `RESET_SEEK` argument. Capture the
		`"NetStream.Seek.Notify"` event to call `appendBytesAction()` after a
		seek. A new file header can support playlists and seeking without
		calling `NetStream.seek()`.

		You can also call this method to reset the byte counter for the
		`onSeekPoint()`) callback.

	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytesAction (netStreamAppendBytesAction:String):Void;
	#end

	#if false
	/**
		Attaches a stream to a new NetConnection object. Call this method to
		attach a NetStream to a new NetConnection object after a connection
		has dropped and been reconnected. Flash Player and AIR resume
		streaming from the playback point when the connection was lost.You can
		also use this method to implement load balancing.
		This method requires Flash Media Server version 3.5.3 or later.

		To use this method to implement **stream reconnection**, see the <a
		href="http://www.adobe.com/go/learn_fms_docs_en"
		scope="external">Flash Media Server 3.5.3 documentation</a>.

		To use this method to implement **load balancing**, do the following:

		1.  Attach a connected stream to a NetConnection object on another
		server.
		2. After the stream is successfully attached to the new connection,
		call `NetConnection.close()` on the prior connection to prevent data
		leaks.
		3. Call `NetStream.play2()` and set the value of
		`NetStreamPlayOptions.transition` to RESUME. Set the rest of the
		NetStreamPlayOptions properties to the same values you used when you
		originally called `NetStream.play()` or `NetStream.play2()` to start
		the stream.
	**/
	// @:noCompletion@:dox(hide) @:require(flash10_1) public function attach(connection:NetConnection):Void;
	#end

	#if false
	/**
		Attaches an audio stream to a NetStream object from a Microphone
		object passed as the source. This method is available only to the
		publisher of the specified stream.
		Use this method with Flash Media Server to send live audio to the
		server. Call this method before or after you call the `publish()`
		method.

		Set the `Microphone.rate` property to match the rate of the sound
		capture device. Call `setSilenceLevel()` to set the silence level
		threshold. To control the sound properties (volume and panning) of the
		audio stream, use the `Microphone.soundTransform` property.

		```haxe
		var nc = new NetConnection();
		nc.connect("rtmp://server.domain.com/app");
		var ns = new NetStream(nc);
		var live_mic = Microphone.get();
		live_mic.rate = 8;
		live_mic.setSilenceLevel(20,200);
		var soundTrans = new SoundTransform();
		soundTrans.volume = 6;
		live_mic.soundTransform = soundTrans;
		ns.attachAudio(live_mic);
		ns.publish("mic_stream","live");
		```

		To hear the audio, call the `NetStream.play()` method and call
		`DisplayObjectContainer.addChild()` to route the audio to an object on
		the display list.

		@param microphone The source of the audio stream to be transmitted.
	**/
	// @:noCompletion @:dox(hide) public function attachAudio (microphone:openfl.media.Microphone):Void;
	#end

	#if false
	/**
		Starts capturing video from a camera, or stops capturing if
		`theCamera` is set to `null`. This method is available only to the
		publisher of the specified stream.
		This method is intended for use with Flash Media Server; for more
		information, see the class description.

		After attaching the video source, you must call `NetStream.publish()`
		to begin transmitting. Subscribers who want to display the video must
		call the `NetStream.play()` and `Video.attachCamera()` methods to
		display the video on the stage.

		You can use `snapshotMilliseconds` to send a single snapshot (by
		providing a value of 0) or a series of snapshots נin effect,
		time-lapse footage נby providing a positive number that adds a
		trailer of the specified number of milliseconds to the video feed. The
		trailer extends the display time of the video message. By repeatedly
		calling `attachCamera()` with a positive value for
		`snapshotMilliseconds`, the sequence of alternating snapshots and
		trailers creates time-lapse footage. For example, you could capture
		one frame per day and append it to a video file. When a subscriber
		plays the file, each frame remains onscreen for the specified number
		of milliseconds and then the next frame is displayed.

		The purpose of the `snapshotMilliseconds` parameter is different from
		the `fps` parameter you can set with `Camera.setMode()`. When you
		specify `snapshotMilliseconds`, you control how much time elapses
		between recorded frames. When you specify `fps` using
		`Camera.setMode()`, you are controlling how much time elapses during
		recording and playback.

		For example, suppose you want to take a snapshot every 5 minutes for a
		total of 100 snapshots. You can do this in two ways:

		* You can issue a `NetStream.attachCamera(myCamera, 500)` command 100
		times, once every 5 minutes. This takes 500 minutes to record, but the
		resulting file will play back in 50 seconds (100 frames with 500
		milliseconds between frames).
		* You can issue a `Camera.setMode()` command with an `fps` value of
		1/300 (one per 300 seconds, or one every 5 minutes), and then issue a
		`NetStream.attachCamera(source)` command, letting the camera capture
		continuously for 500 minutes. The resulting file will play back in 500
		minutes נthe same length of time that it took to record נwith
		each frame being displayed for 5 minutes.

		Both techniques capture the same 500 frames, and both approaches are
		useful; the approach to use depends primarily on your playback
		requirements. For example, in the second case, you could be recording
		audio the entire time. Also, both files would be approximately the
		same size.

		@param theCamera The source of the video transmission. Valid values
						 are a Camera object (which starts capturing video)
						 and `null`. If you pass `null`, the application stops
						 capturing video, and any additional parameters you
						 send are ignored.
	**/
	// @:noCompletion @:dox(hide) public function attachCamera (theCamera:openfl.media.Camera, snapshotMilliseconds:Int = -1):Void;
	#end

	/**
		Stops playing all data on the stream, sets the `time` property to 0,
		and makes the stream available for another use. This method also
		deletes the local copy of a video file that was downloaded through
		HTTP. Although the application deletes the local copy of the file that
		it creates, a copy might persist in the cache directory. If you must
		completely prevent caching or local storage of the video file, use
		Flash Media Server.
		When using Flash Media Server, this method is invoked implicitly when
		you call `NetStream.play()` from a publishing stream or
		`NetStream.publish()` from a subscribing stream. Please note that:

		*  If `close()` is called from a publishing stream, the stream stops
		publishing and the publisher can now use the stream for another
		purpose. Subscribers no longer receive anything that was being
		published on the stream, because the stream has stopped publishing.
		*  If `close()` is called from a subscribing stream, the stream stops
		playing for the subscriber, and the subscriber can use the stream for
		another purpose. Other subscribers are not affected.
		*  You can stop a subscribing stream from playing, without closing the
		stream or changing the stream type by using
		`openfl.net.NetStream.play(false)`.

	**/
	public function close():Void
	{
		#if (js && html5)
		if (__video == null) return;

		__closed = true;
		__video.pause();
		__video.src = "";
		time = 0;
		#end
	}

	/**
		Releases all the resources held by the NetStream object.

		The `dispose()` method is similar to the `close` method. The main difference
		between the two methods is that `dispose()` releases the memory used to display
		the current video frame. If that frame is currently displayed on screen, the
		display will go blank. The `close()` method does not blank the display because it
		does not release this memory.
	**/
	public function dispose():Void
	{
		#if (js && html5)
		close();
		__video = null;
		#end
	}

	#if false
	/**
		Invoked when a peer-publishing stream matches a peer-subscribing
		stream. Before the subscriber is connected to the publisher, call this
		method to allow the ActionScript code fine access control for
		peer-to-peer publishing. The following code shows an example of how to
		create a callback function for this method:

		```as3
		var c:Object = new Object;
		c.onPeerConnect = function(subscriber:NetStream):Boolean {
			if (accept) return true;
			else return false;
		};
		m_netStream.client = c;
		```

		If a peer-publisher does not implement this method, all peers are
		allowed to play any published content.

	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public function onPeerConnect (subscriber:NetStream):Bool;
	#end

	/**
		Pauses playback of a video stream. Calling this method does nothing if
		the video is already paused. To resume play after pausing a video,
		call `resume()`. To toggle between pause and play (first pausing the
		video, then resuming), call `togglePause()`.
		Starting with Flash Player 9.0.115.0, Flash Player no longer clears
		the buffer when `NetStream.pause()` is called. This behavior is called
		"smart pause". Before Flash Player 9.0.115.0, Flash Player waited for
		the buffer to fill up before resuming playback, which often caused a
		delay.

		**Note:** For backwards compatibility, the `"NetStream.Buffer.Flush"`
		event (see the `NetStatusEvent.info` property) still fires, although
		the server does not flush the buffer.

		For a single pause, the `NetStream.bufferLength` property has a limit
		of either 60 seconds or twice the value of `NetStream.bufferTime`,
		whichever value is higher. For example, if `bufferTime` is 20 seconds,
		Flash Player buffers until `NetStream.bufferLength` is the higher
		value of either 20~~2 (40), or 60, so in this case it buffers until
		`bufferLength` is 60. If `bufferTime` is 40 seconds, Flash Player
		buffers until `bufferLength` is the higher value of 40~~2 (80), or 60,
		so in this case it buffers until `bufferLength` is 80 seconds.

		The `bufferLength` property also has an absolute limit. If any call to
		`pause()` causes `bufferLength` to increase more than 600 seconds or
		the value of `bufferTime` ~~ 2, whichever is higher, Flash Player
		flushes the buffer and resets `bufferLength` to 0. For example, if
		`bufferTime` is 120 seconds, Flash Player flushes the buffer if
		`bufferLength` reaches 600 seconds; if `bufferTime` is 360 seconds,
		Flash Player flushes the buffer if `bufferLength` reaches 720 seconds.

		**Tip**: You can use `NetStream.pause()` in code to buffer data while
		viewers are watching a commercial, for example, and then unpause when
		the main video starts.

	**/
	public function pause():Void
	{
		#if (js && html5)
		if (__video != null) __video.pause();
		#end
	}

	/**
		Plays a media file from a local directory or a web server; plays a
		media file or a live stream from Flash Media Server. Dispatches a
		`NetStatusEvent` object to report status and error messages.
		For information about supported codecs and file formats, see the
		following:

		* <a href="http://www.adobe.com/go/learn_fms_fileformats_en"
		scope="external">Flash Media Server documentation</a>
		* <a href="http://www.adobe.com/go/hardware_scaling_en"
		scope="external">Exploring Flash Player support for high-definition
		H.264 video and AAC audio</a>
		* <a href="http://www.adobe.com/go/video_file_format"
		scope="external">FLV/F4V open specification documents</a>

		**Workflow for playing a file or live stream**

		1. Create a NetConnection object and call `NetConnection.connect()`.
		To play a file from a local directory or web server, pass null.

		To play a recorded file or live stream from Flash Media Server, pass
		the URI of a Flash Media Server application.
		2. Call `NetConnection.addEventListener(NetStatusEvent.NET_STATUS,
		netStatusHandler)` to listen for NetStatusEvent events.
		3. On `"NetConnection.Connect.Success"`, create a NetStream object and
		pass the NetConnection object to the constructor.
		4. Create a Video object and call `Video.attachNetStream()` and pass
		the NetStream object.
		5. Call `NetStream.play()`.
		To play a live stream, pass the stream name passed to the
		`NetStream.publish()` method.

		To play a recorded file, pass the file name.
		6. Call `addChild()` and pass the Video object to display the video.

		**Note:**To see sample code, scroll to the example at the bottom of
		this page.

		**Enable Data Generation Mode**

		Call `play(null)` to enable "Data Generation Mode". In this mode, call
		the `appendBytes()` method to deliver data to the NetStream. Use Data
		Generation Mode to stream content over HTTP from the Adobe HTTP
		Dynamic Streaming Origin Module on an Apache HTTP Server. HTTP Dynamic
		Streaming lets clients seek quickly to any point in a file. The Open
		Source Media Framework (OSMF) supports HTTP Dynamic Streaming for vod
		and live streams. For examples of how to use NetStream Data Generation
		Mode, download the <a href="http://www.opensourcemediaframework.com"
		scope="external">OSMF</a> source. For more information about HTTP
		Dynamic Streaming, see <a
		href="http://www.adobe.com/go/learn_fms_http_en" scope="external">HTTP
		Dynamic Streaming</a>.

		When you use this method without Flash Media Server, there are
		security considerations. A file in the local-trusted or
		local-with-networking sandbox can load and play a video file from the
		remote sandbox, but cannot access the remote file's data without
		explicit permission in the form of a URL policy file. Also, you can
		prevent a SWF file running in Flash Player from using this method by
		setting the `allowNetworking` parameter of the the `object` and
		`embed` tags in the HTML page that contains the SWF content. For more
		information related to security, see the Flash Player Developer Center
		Topic: <a href="http://www.adobe.com/go/devnet_security_en"
		scope="external">Security</a>.

		@throws ArgumentError At least one parameter must be specified.
		@throws Error         The NetStream Object is invalid. This may be due
							  to a failed NetConnection.
		@throws SecurityError Local untrusted SWF files cannot communicate
							  with the Internet. You can work around this
							  restriction by reclassifying this SWF file as
							  local-with-networking or trusted.
		@event status Dispatched when attempting to play content encrypted
					  with digital rights management (DRM). The value of the
					  `code` property is `"DRM.encryptedFLV"`.
	**/
	public function play(url:#if (openfl_html5 && !openfl_doc_gen) Dynamic #else String #end, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null):Void
	{
		#if (js && html5)
		if (__video == null) return;

		__video.volume = SoundMixer.__soundTransform.volume * __soundTransform.volume;
		if ((url is String))
		{
			__video.src = url;
		}
		else
		{
			__video.srcObject = cast url;
		}
		__video.play();
		#end
	}

	#if false
	/**
		Switches seamlessly between files with multiple bit rates and allows a
		NetStream to resume when a connection is dropped and reconnected.
		This method is an enhanced version of `NetStream.play()`. Like the
		`play()` method, the `play2()` method begins playback of a media file
		or queues up media files to create a playlist. When used with Flash
		Media Server, it can also request that the server switch to a
		different media file. The transition occurs seamlessly in the client
		application. The following features use `play2()` stream switching:

		**Dynamic streaming**

		Dynamic streaming (supported in Flash Media Server 3.5 and later) lets
		you serve a stream encoded at multiple bit rates. As a viewer's
		network conditions change, they receive the bitrate that provides the
		best viewing experience. Use the `NetStreamInfo` class to monitor
		network conditions and switch streams based on the data. You can also
		switch streams for clients with different capabilities. For more
		information, see <a
		href="http://www.adobe.com/go/learn_fms_dynstream_en"
		scope="external">"Dynamic streaming"</a> in the "Adobe Flash Media
		Server Developer Guide".

		Adobe built a custom ActionScript class called DynamicStream that
		extends the NetStream class. You can use the DynamicStream class to
		implement dynamic streaming in an application instead of writing your
		own code to detect network conditions. Even if you choose to write
		your own dynamic streaming code, use the DynamicStream class as a
		reference implementation. Download the class and the class
		documentation at the <a href="http://www.adobe.com/go/fms_tools"
		scope="external">Flash Media Server tools and downloads</a> page.

		**Stream reconnecting**

		Stream reconnecting (supported in Flash Media Server 3.5.3 and later)
		lets users to experience media uninterrupted even when they lose their
		connection. The media uses the buffer to play while your ActionScript
		logic reconnects to Flash Media Server. After reconnection, call
		`NetStream.attach()` to use the same NetStream object with the new
		NetConnection. Use the `NetStream.attach()`,
		`NetStreamPlayTransitions.RESUME`, and
		`NetStreamPlayTrasitions.APPEND_AND_WAIT` APIs to reconnect a stream.
		For more information, see the <a
		href="http://www.adobe.com/go/learn_fms_docs_en"
		scope="external">Flash Media Server 3.5.3 documentation</a>.

	**/
	// @:noCompletion @:dox(hide) @:require(flash10) public function play2 (param:openfl.net.NetStreamPlayOptions):Void;
	#end

	#if false
	/**
		Sends streaming audio, video, and data messages from a client to Flash
		Media Server, optionally recording the stream during transmission.
		This method dispatches a NetStatusEvent object with information about
		the stream. Before you call `NetStream.publish()`, capture the
		`"NetConnection.Connect.Success"` event to verify that the application
		has successfully connected to Flash Media Server.
		While publishing, you can record files in FLV or F4V format. If you
		record a file in F4V format, use a flattener tool to edit or play the
		file in another application. To download the tool, see <a
		href="http://www.adobe.com/go/fms_tools"
		scope="external">www.adobe.com/go/fms_tools</a>.

		**Note:**Do not use this method to play a stream. To play a stream,
		call the `NetStream.play()` method.

		Workflow for publishing a stream

		1. Create a NetConnection object and call `NetConnection.connect()`.
		2. Call `NetConnection.addEventListener()` to listen for NetStatusEvent
		events.
		3. On the `"NetConnection.Connect.Success"` event, create a NetStream
		object and pass the NetConnection object to the constructor.
		4. To capture audio and video, call the `NetStream.attachAudio()`method
		and the `NetStream.attachCamera()` method.
		5. To publish a stream, call the `NetStream.publish()` method. You can
		record the data as you publish it so that users can play it back
		later.

		**Note:** A NetStream can either publish a stream or play a stream, it
		cannot do both. To publish a stream and view the playback from the
		server, create two NetStream objects. You can send multiple NetStream
		objects over one NetConnection object.

		When Flash Media Server records a stream it creates a file. By
		default, the server creates a directory with the application instance
		name passed to `NetConnection.connect()` and stores the file in the
		directory. For example, the following code connects to the default
		instance of the "lectureseries" application and records a stream
		called "lecture". The file "lecture.flv" is recorded in the
		applications/lectureseries/streams/_definst_ directory:

		```as3
		var nc:NetConnection = new NetConnection();
		nc.connect("rtmp://fms.example.com/lectureseries");
		nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);

		function netStatusHandler(event:NetStatusEvent):void{
			if (event.info.code == "NetConnection.Connect.Success"){
				var ns:NetStream = new NetStream(nc);
				ns.publish("lecture", "record");
			}
		}
		```

		The following example connects to the "monday" instance of the same
		application. The file "lecture.flv" is recorded in the directory
		/applications/lectureseries/streams/monday:

		```as3
		var nc:NetConnection = new NetConnection();
		nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		nc.connect("rtmp://fms.example.com/lectureseries/monday");

		function netStatusHandler(event:NetStatusEvent):void{
			if (event.info.code == "NetConnection.Connect.Success"){
				var ns:NetStream = new NetStream(nc);
				ns.publish("lecture", "record");
			}
		}
		```

		@param name A string that identifies the stream. Clients that
					subscribe to this stream pass this name when they call
					`NetStream.play()`. Don't follow the stream name with a
					"/". For example, don't use the stream name `"bolero/"`.
					You can record files in the formats described in the
					following table (you cannot use `publish()` for MP3 format
					files). The syntax differs depending on the file format.

					| File format | Syntax | Example |
					| --- | --- | --- |
					| FLV | Specify the stream name as a string without a filename extension. | `ns.publish("myflvstream");` |
					| MPEG-4-based files (such as F4V or MP4) | Specify the stream name as a string with the prefix `mp4:` with or without the filename extension. Flash Player doesn't encode using H.264, but Flash Media Server can record any codec in the F4V container. Flash Media Live Encoder can encode using H.264. | `ns.publish("mp4:myvideo.f4v")` `ns.publish("mp4:myvideo");` |
					| RAW | Specify the stream name as a string with the prefix `raw:` | `ns.publish("raw:myvideo");` |
		@param type A string that specifies how to publish the stream. Valid
					values are "`record`", "`append`", "`appendWithGap`", and
					"`live`". The default value is "`live`".
					* If you pass "`record`", the server publishes and records
					live data, saving the recorded data to a new file with a
					name matching the value passed to the `name` parameter. If
					the file exists, it is overwritten.
					* If you pass "`append`", the server publishes and records
					live data, appending the recorded data to a file with a
					name that matches the value passed to the `name`
					parameter. If no file matching the `name` parameter is
					found, it is created.
					* If you pass "`appendWithGap`", additional information
					about time coordination is passed to help the server
					determine the correct transition point when dynamic
					streaming.
					* If you omit this parameter or pass "`live`", the server
					publishes live data without recording it. If a file with a
					name that matches the value passed to the `name` parameter
					exists, it is deleted.
	**/
	// @:noCompletion @:dox(hide) public function publish (?name:String, ?type:String):Void;
	#end

	#if false
	/**
		Specifies whether incoming audio plays on the stream. This method is
		available only to clients subscribed to the specified stream. It is
		not available to the publisher of the stream. Call this method before
		or after you call the `NetStream.play()` method. For example, attach
		this method to a button to allow users to mute and unmute the audio.
		Use this method only on unicast streams that are played back from
		Flash Media Server. This method doesn't work on RTMFP multicast
		streams or when using the `NetStream.appendBytes()` method.

		@param flag Specifies whether incoming audio plays on the stream
					(`true`) or not (`false`). The default value is `true`. If
					the specified stream contains only audio data,
					`NetStream.time` stops incrementing when you pass `false`.
	**/
	// @:noCompletion @:dox(hide) public function receiveAudio (flag:Bool):Void;
	#end

	#if false
	/**
		Specifies whether incoming video plays on the stream. This method is
		available only to clients subscribed to the specified stream. It is
		not available to the publisher of the stream. Call this method before
		or after you call the `NetStream.play()` method. For example, attach
		this method to a button to allow users to show and hide the video. Use
		this method only on unicast streams that are played back from Flash
		Media Server. This method doesn't work on RTMFP multicast streams or
		when using `the NetStream.appendBytes()` method.

		@param flag Specifies whether incoming video plays on this stream
					(`true`) or not (`false`). The default value is `true`. If
					the specified stream contains only video data,
					`NetStream.time` stops incrementing when you pass `false`.
	**/
	// @:noCompletion @:dox(hide) public function receiveVideo (flag:Bool):Void;
	#end

	#if false
	/**
		Specifies the frame rate for incoming video. This method is available
		only to clients subscribed to the specified stream. It is not
		available to the publisher of the stream. Call this method before or
		after you call the `NetStream.play()` method. For example, call this
		method to allow users to set the video frame rate. To determine the
		current frame rate, use `NetStream.currentFPS`. To stop receiving
		video, pass `0`.
		When you pass a value to the FPS parameter to limit the frame rate of
		the video, Flash Media Server attempts to reduce the frame rate while
		preserving the integrity of the video. Between every two keyframes,
		the server sends the minimum number of frames needed to satisfy the
		desired rate. Please note that I-frames (or intermediate frames) must
		be sent contiguously, otherwise the video is corrupted. Therefore, the
		desired number of frames is sent immediately and contiguously
		following a keyframe. Since the frames are not evenly distributed, the
		motion appears smooth in segments punctuated by stalls.

		Use this method only on unicast streams that are played back from
		Flash Media Server. This method doesn't work on RTMFP multicast
		streams or when using the `NetStream.appendBytes()` method.

		@param FPS Specifies the frame rate per second at which the incoming
				   video plays.
	**/
	// @:noCompletion @:dox(hide) public function receiveVideoFPS (FPS:Float):Void;
	#end

	#if false
	/**
		Deletes all locally cached digital rights management (DRM) voucher
		data.
		The application must re-download any required vouchers from the media
		rights server for the user to be able to access protected content.
		Calling this function is equivalent to calling the
		`resetDRMVouchers()` function of the DRMManager object.

		@throws IOError The voucher data cannot be deleted.
	**/
	// @:noCompletion @:dox(hide) public static function resetDRMVouchers ():Void;
	#end
	@:dox(hide) @:noCompletion @SuppressWarnings("checkstyle:FieldDocComment")
	public function requestVideoStatus():Void
	{
		#if (js && html5)
		if (__video == null) return;

		if (__timer == null)
		{
			__timer = new Timer(1);
		}

		__timer.run = function()
		{
			if (__video.paused)
			{
				__playStatus("NetStream.Play.pause");
			}
			else
			{
				__playStatus("NetStream.Play.playing");
			}

			__timer.stop();
		};
		#end
	}

	/**
		Resumes playback of a video stream that is paused. If the video is
		already playing, calling this method does nothing.

	**/
	public function resume():Void
	{
		#if (js && html5)
		if (__video != null) __video.play();
		#end
	}

	/**
		Seeks the keyframe (also called an I-frame in the video industry)
		closest to the specified location. The keyframe is placed at an
		offset, in seconds, from the beginning of the stream.
		Video streams are usually encoded with two types of frames, keyframes
		(or I-frames) and P-frames. A keyframe contains an entire image, while
		a P-frame is an interim frame that provides additional video
		information between keyframes. A video stream typically has a keyframe
		every 10-50 frames.

		Flash Media Server has several types of seek behavior: enhanced
		seeking and smart seeking.

		**Enhanced seeking**

		Enhanced seeking is enabled by default. To disable enhanced seeking,
		on Flash Media Server set the `EnhancedSeek` element in the
		`Application.xml` configuration file to `false`.

		If enhanced seeking is enabled, the server generates a new keyframe at
		`offset` based on the previous keyframe and any intervening P-frames.
		However, generating keyframes creates a high processing load on the
		server and distortion might occur in the generated keyframe. If the
		video codec is On2, the keyframe before the seek point and any
		P-frames between the keyframe and the seek point are sent to the
		client.

		If enhanced seeking is disabled, the server starts streaming from the
		nearest keyframe. For example, suppose a video has keyframes at 0
		seconds and 10 seconds. A seek to 4 seconds causes playback to start
		at 4 seconds using the keyframe at 0 seconds. The video stays frozen
		until it reaches the next keyframe at 10 seconds. To get a better
		seeking experience, you need to reduce the keyframe interval. In
		normal seek mode, you cannot start the video at a point between the
		keyframes.

		**Smart seeking**

		To enable smart seeking, set `NetStream.inBufferSeek` to `true`.

		Smart seeking allows Flash Player to seek within an existing back
		buffer and forward buffer. When smart seeking is disabled, each time
		`seek()` is called Flash Player flushes the buffer and requests data
		from the server. For more information, see `NetStream.inBufferSeek`.

		**Seeking in Data Generation Mode**

		When you call `seek()` on a NetStream in Data Generation Mode, all
		bytes passed to `appendBytes()` are discarded (not placed in the
		buffer, accumulated in the partial message FIFO, or parsed for seek
		points) until you call
		`appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN)` or
		`appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK)` to reset
		the parser. For information about Data Generation Mode, see
		`NetStream.play()`.

		@param offset The approximate time value, in seconds, to move to in a
					  video file. With Flash Media Server, if `<EnhancedSeek>`
					  is set to `true` in the Application.xml configuration
					  file (which it is by default), the server generates a
					  keyframe at `offset`.
					  * To return to the beginning of the stream, pass 0 for
					  `offset`.
					  * To seek forward from the beginning of the stream, pass
					  the number of seconds to advance. For example, to
					  position the playhead at 15 seconds from the beginning
					  (or the keyframe before 15 seconds), use
					  `myStream.seek(15)`.
					  * To seek relative to the current position, pass
					  `NetStream.time + n` or `NetStream.time - n` to seek `n`
					  seconds forward or backward, respectively, from the
					  current position. For example, to rewind 20 seconds from
					  the current position, use `NetStream.seek(NetStream.time
					  - 20).`
	**/
	public function seek(time:Float):Void
	{
		#if (js && html5)
		if (__video == null) return;

		if (time < 0)
		{
			time = 0;
		}
		else if (time > __video.duration)
		{
			time = __video.duration;
		}

		__dispatchStatus("NetStream.SeekStart.Notify");
		__video.currentTime = time;
		#end
	}

	#if false
	/**
		Sends a message on a published stream to all subscribing clients. This
		method is available only to the publisher of the specified stream.
		This method is available for use with Flash Media Server only. To
		process and respond to this message, create a handler on the
		`NetStream` object, for example, `ns.HandlerName`.
		Flash Player or AIR does not serialize methods or their data, object
		prototype variables, or non-enumerable variables. For display objects,
		Flash Player or AIR serializes the path but none of the data.

		You can call the `send()` method to add data keyframes to a live
		stream published to Flash Media Server. A data keyframe is a message a
		publisher adds to a live stream. Data keyframes are typically used to
		add metadata to a live stream before data is captured for the stream
		from camera and microphone. A publisher can add a data keyframe at any
		time while the live stream is being published. The data keyframe is
		saved in the server's memory as long as the publisher is connected to
		the server.

		Clients who are subscribed to the live stream before a data keyframe
		is added receive the keyframe as soon as it is added. Clients who
		subscribe to the live stream after the data keyframe is added receive
		the keyframe when they subscribe.

		To add a keyframe of metadata to a live stream sent to Flash Media
		Server, use `@setDataFrame` as the handler name, followed by two
		additional arguments, for example:

		```as3
		var ns:NetStream = new NetStream(nc);
		ns.send("@setDataFrame", "onMetaData", metaData);
		```

		The `@setDataFrame` argument refers to a special handler built in to
		Flash Media Server. The `onMetaData` argument is the name of a
		callback function in your client application that listens for the
		`onMetaData` event and retrieves the metadata. The third item,
		`metaData`, is an instance of `Object` or `Array` with properties that
		define the metadata values.

		Use `@clearDataFrame` to clear a keyframe of metadata that has already
		been set in the stream:

		```as3
		ns.send("@clearDataFrame", "onMetaData");
		```

		@param handlerName The message to send; also the name of the
						   ActionScript handler to receive the message. The
						   handler name can be only one level deep (that is,
						   it can't be of the form parent/child) and is
						   relative to the stream object. Do not use a
						   reserved term for a handler name. For example,
						   using "`close`" as a handler name causes the method
						   to fail. With Flash Media Server, use
						   `@setDataFrame` to add a keyframe of metadata to a
						   live stream or `@clearDataFrame` to remove a
						   keyframe.
	**/
	// @:noCompletion @:dox(hide) public function send (handlerName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	#end

	#if false
	/**
		Steps forward or back the specified number of frames, relative to the
		currently displayed frame. Specify a positive number to step forward
		and a negative number to step in reverse. Call this method to create
		accurate fast forward or rewind functionality.
		This method is available only when data is streaming from Flash Media
		Server 3.5.3 or higher and when `NetStream.inBufferSeek` is `true`.
		Also, the target frame must be in the buffer. For example, if the
		currently displayed frame is frame number 120 and you specify a value
		of 1000, the method fails if frame number 1120 is not in the buffer.

		This method is intended to be used with the `pause()` or
		`togglePause()` methods. If you step 10 frames forward or backward
		during playback without pausing, you may not notice the steps or
		they'll look like a glitch. Also, when you call `pause()` or
		`togglePause` the audio is suppressed.

		If the call to `NetStream.step()` is successful, a NetStatusEvent is
		sent with "NetStream.Step.Notify" as the value of the info object's
		`code` property.

	**/
	// @:noCompletion @:dox(hide) @:require(flash10_1) public function step (frames:Int):Void;
	#end

	/**
		Pauses or resumes playback of a stream. The first time you call this
		method, it pauses play; the next time, it resumes play. You could use
		this method to let users pause or resume playback by pressing a single
		button.

	**/
	public function togglePause():Void
	{
		#if (js && html5)
		if (__video == null) return;

		if (__video.paused)
		{
			__video.play();
		}
		else
		{
			__video.pause();
		}
		#end
	}

	@:noCompletion private function __dispatchStatus(code:String):Void
	{
		var event = new NetStatusEvent(NetStatusEvent.NET_STATUS, false, false, {code: code});
		__connection.dispatchEvent(event);
		dispatchEvent(event);
	}

	@:noCompletion private function __playStatus(code:String):Void
	{
		#if (js && html5)
		if (__video == null) return;

		if (client != null)
		{
			try
			{
				var handler = client.onPlayStatus;
				handler({
					code: code,
					duration: __video.duration,
					position: __video.currentTime,
					speed: __video.playbackRate,
					start: untyped __video.startTime
				});
			}
			catch (e:Dynamic) {}
		}
		#end
	}

	// Event Handlers
	@:noCompletion private function video_onCanPlay(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.canplay");
	}

	@:noCompletion private function video_onCanPlayThrough(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.canplaythrough");
	}

	@:noCompletion private function video_onDurationChanged(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.durationchanged");
	}

	@:noCompletion private function video_onEnd(event:Dynamic):Void
	{
		__dispatchStatus("NetStream.Play.Stop");
		__dispatchStatus("NetStream.Play.Complete");
		__playStatus("NetStream.Play.Complete");
	}

	@:noCompletion private function video_onError(event:Dynamic):Void
	{
		__dispatchStatus("NetStream.Play.Stop");
		__playStatus("NetStream.Play.error");
	}

	@:noCompletion private function video_onLoadMetaData(event:Dynamic):Void
	{
		#if (js && html5)
		if (__video == null) return;

		if (client != null)
		{
			try
			{
				var handler = client.onMetaData;
				handler({
					width: __video.videoWidth,
					height: __video.videoHeight,
					duration: __video.duration
				});
			}
			catch (e:Dynamic) {}
		}
		#end
	}

	@:noCompletion private function video_onLoadStart(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.loadstart");
	}

	@:noCompletion private function video_onPause(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.pause");
	}

	@:noCompletion private function video_onPlaying(event:Dynamic):Void
	{
		__dispatchStatus("NetStream.Play.Start");
		__playStatus("NetStream.Play.playing");
	}

	@:noCompletion private function video_onSeeking(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.seeking");

		__dispatchStatus("NetStream.Seek.Complete");
	}

	@:noCompletion private function video_onStalled(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.stalled");
	}

	@:noCompletion private function video_onTimeUpdate(event:Dynamic):Void
	{
		#if (js && html5)
		if (__video == null) return;

		time = __video.currentTime;
		#end

		__playStatus("NetStream.Play.timeupdate");
	}

	@:noCompletion private function video_onWaiting(event:Dynamic):Void
	{
		__playStatus("NetStream.Play.waiting");
	}

	// Get & Set Methods
	@:noCompletion private function get_soundTransform():SoundTransform
	{
		return __soundTransform.clone();
	}

	@:noCompletion private function set_soundTransform(value:SoundTransform):SoundTransform
	{
		if (value != null)
		{
			__soundTransform.pan = value.pan;
			__soundTransform.volume = value.volume;

			#if html5
			if (__video != null)
			{
				__video.volume = SoundMixer.__soundTransform.volume * __soundTransform.volume;
			}
			#end
		}

		return value;
	}

	@:noCompletion private function get_speed():Float
	{
		#if (js && html5)
		return __video != null ? __video.playbackRate : 1;
		#else
		return 1;
		#end
	}

	@:noCompletion private function set_speed(value:Float):Float
	{
		#if (js && html5)
		return __video != null ? __video.playbackRate = value : value;
		#else
		return value;
		#end
	}
}
#else
typedef NetStream = flash.net.NetStream;
#end
