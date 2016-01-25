package flash.net; #if (!display && flash)


import openfl.events.EventDispatcher;
import openfl.media.SoundTransform;
import openfl.utils.ByteArray;


extern class NetStream extends EventDispatcher {
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var CONNECT_TO_FMS (default, never):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public static var DIRECT_CONNECTIONS (default, never):String;
	#end
	
	public var audioCodec (default, null):Int;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var audioReliable:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var audioSampleAccess:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferLength (default, null):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferTime:Float;
	#end
	
	public var bufferLength (default, null):Float;
	public var bufferTime:Float;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var bufferTimeMax:Float;
	#end
	
	public var bytesLoaded (default, null):UInt;
	public var bytesTotal (default, null):UInt;
	public var checkPolicyFile:Bool;
	public var client:Dynamic;
	public var currentFPS (default, null):Float;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var dataReliable:Bool;
	#end
	
	public var decodedFrames (default, null):UInt;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var inBufferSeek:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var info (default, null):flash.net.NetStreamInfo;
	#end
	
	public var liveDelay (default, null):Float;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var maxPauseBufferTime:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilitySendToAll:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilityUpdatePeriod:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastFetchPeriod:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastInfo (default, null):flash.net.NetStreamMulticastInfo;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastPushNeighborLimit:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastRelayMarginDuration:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var multicastWindowDuration:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
	#end
	
	public var objectEncoding (default, null):UInt;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var peerStreams (default, null):Array<Dynamic>;
	#end
	
	public var soundTransform:SoundTransform;
	//public var speed (get, set):Float;
	public var time (default, null):Float;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var useHardwareDecoder:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_3) public var useJitterBuffer:Bool;
	#end
	
	public var videoCodec (default, null):UInt;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var videoReliable:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public var videoSampleAccess:Bool;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11) public var videoStreamSettings:flash.media.VideoStreamSettings;
	#end
	
	
	public function new (connection:NetConnection, ?peerID:String);
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytes (bytes:ByteArray):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytesAction (netStreamAppendBytesAction:String):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public function attach (connection:NetConnection):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function attachAudio (microphone:flash.media.Microphone):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function attachCamera (theCamera:flash.media.Camera, snapshotMilliseconds:Int = -1):Void;
	#end
	
	public function close ():Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_2) public function dispose ():Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function onPeerConnect (subscriber:NetStream):Bool;
	#end
	
	public function pause ():Void;
	public function play (?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function play2 (param:flash.net.NetStreamPlayOptions):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function publish (?name:String, ?type:String):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function receiveAudio (flag:Bool):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function receiveVideo (flag:Bool):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) public function receiveVideoFPS (FPS:Float):Void;
	#end
	
	//public function requestVideoStatus ():Void;
	
	#if flash
	@:noCompletion @:dox(hide) public static function resetDRMVouchers ():Void;
	#end
	
	public function resume ():Void;
	public function seek (offset:Float):Void;
	
	#if flash
	@:noCompletion @:dox(hide) public function send (handlerName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10_1) public function step (frames:Int):Void;
	#end
	
	public function togglePause ():Void;
	
	
}


#else
typedef NetStream = openfl.net.NetStream;
#end