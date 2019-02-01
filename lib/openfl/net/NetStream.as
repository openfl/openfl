package openfl.net {
	
	
	import openfl.events.EventDispatcher;
	import openfl.media.SoundTransform;
	import openfl.utils.ByteArray;
	
	
	/**
	 * @externs
	 */
	public class NetStream extends EventDispatcher {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var CONNECT_TO_FMS:String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var DIRECT_CONNECTIONS:String;
		// #end
		
		
		public function get audioCodec ():int { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioReliable:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioSampleAccess:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferLength (default, null):Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferTime:Number;
		// #end
		
		public function get bufferLength ():Number { return 0; }
		
		public var bufferTime:Number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var bufferTimeMax:Number;
		// #end
		
		public function get bytesLoaded ():uint { return 0; }
		
		public function get bytesTotal ():uint { return 0; }
		
		public var checkPolicyFile:Boolean;
		
		public var client:Object;
		
		public function get currentFPS ():Number { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var dataReliable:Bool;
		// #end
		
		public function get decodedFrames ():uint { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):String;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var inBufferSeek:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var info (default, null):flash.net.NetStreamInfo;
		// #end
		
		public function get liveDelay ():Number { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var maxPauseBufferTime:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilitySendToAll:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilityUpdatePeriod:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastFetchPeriod:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastInfo (default, null):flash.net.NetStreamMulticastInfo;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastPushNeighborLimit:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastRelayMarginDuration:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastWindowDuration:Number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):String;
		// #end
		
		public function get objectEncoding ():uint { return null; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var peerStreams (default, null):Array<Dynamic>;
		// #end
		
		public var soundTransform:SoundTransform;
		
		//public var speed (get, set):Number;
		
		public function get time ():Number { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var useHardwareDecoder:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_3) public var useJitterBuffer:Bool;
		// #end
		
		public function get videoCodec ():uint { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoReliable:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoSampleAccess:Bool;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var videoStreamSettings:flash.media.VideoStreamSettings;
		// #end
		
		
		public function NetStream (connection:NetConnection, peerID:String = null) {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytes (bytes:ByteArray):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public function appendBytesAction (netStreamAppendBytesAction:String):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public function attach (connection:NetConnection):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function attachAudio (microphone:flash.media.Microphone):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function attachCamera (theCamera:flash.media.Camera, snapshotMilliseconds:Int = -1):void {}
		// #end
		
		
		public function close ():void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_2)
		// #end
		public function dispose ():void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public function onPeerConnect (subscriber:NetStream):Bool;
		// #end
		
		
		public function pause ():void {}
		
		
		public function play (p1:* = null, p2:* = null, p3:* = null, p4:* = null, p5:* = null):void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public function play2 (param:flash.net.NetStreamPlayOptions):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function publish (?name:String, ?type:String):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function receiveAudio (flag:Bool):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function receiveVideo (flag:Bool):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function receiveVideoFPS (FPS:Number):void {}
		// #end
		
		
		//public function requestVideoStatus ():void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static function resetDRMVouchers ():void {}
		// #end
		
		
		public function resume ():void {}
		
		
		public function seek (offset:Number):void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function send (handlerName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):void {}
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public function step (frames:Int):void {}
		// #end
		
		
		public function togglePause ():void {}
		
		
	}
	
	
}