import NetConnection from "./NetConnection";
import EventDispatcher from "./../events/EventDispatcher";
import SoundTransform from "./../media/SoundTransform";


declare namespace openfl.net {
	
	
	export class NetStream extends EventDispatcher {
	
	
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var CONNECT_TO_FMS:string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var DIRECT_CONNECTIONS:string;
		// #end
		
		
		public readonly audioCodec:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioReliable:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var audioSampleAccess:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferLength (default, null):number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var backBufferTime:number;
		// #end
		
		public readonly bufferLength:number;
		
		public bufferTime:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var bufferTimeMax:number;
		// #end
		
		public readonly bytesLoaded:number;
		
		public readonly bytesTotal:number;
		
		public checkPolicyFile:boolean;
		
		public client:any;
		
		public readonly currentFPS:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var dataReliable:boolean;
		// #end
		
		public readonly decodedFrames:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farID (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var farNonce (default, null):string;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var inBufferSeek:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var info (default, null):flash.net.NetStreamInfo;
		// #end
		
		public readonly liveDelay:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var maxPauseBufferTime:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilitySendToAll:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastAvailabilityUpdatePeriod:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastFetchPeriod:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastInfo (default, null):flash.net.NetStreamMulticastInfo;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastPushNeighborLimit:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastRelayMarginDuration:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var multicastWindowDuration:number;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var nearNonce (default, null):string;
		// #end
		
		public readonly objectEncoding:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var peerStreams (default, null):Array<Dynamic>;
		// #end
		
		public soundTransform:SoundTransform;
		
		//public var speed (get, set):number;
		
		public readonly time:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var useHardwareDecoder:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_3) public var useJitterBuffer:boolean;
		// #end
		
		public readonly videoCodec:number;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoReliable:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public var videoSampleAccess:boolean;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public var videoStreamSettings:flash.media.VideoStreamSettings;
		// #end
		
		
		public constructor (connection:NetConnection, peerID?:string);
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public appendBytes (bytes:ByteArray):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public appendBytesAction (netStreamAppendBytesAction:string):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public attach (connection:NetConnection):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public attachAudio (microphone:flash.media.Microphone):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public attachCamera (theCamera:flash.media.Camera, snapshotMilliseconds:number = -1):void;
		// #end
		
		
		public close ():void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_2) public dispose ():void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public onPeerConnect (subscriber:NetStream):boolean;
		// #end
		
		
		public pause ():void;
		
		
		public play (p1?:any, p2?:any, p3?:any, p4?:any, p5?:any):void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public play2 (param:flash.net.NetStreamPlayOptions):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public publish (?name:string, ?type:string):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public receiveAudio (flag:boolean):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public receiveVideo (flag:boolean):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public receiveVideoFPS (FPS:number):void;
		// #end
		
		
		//public requestVideoStatus ():void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public static resetDRMVouchers ():void;
		// #end
		
		
		public resume ():void;
		
		
		public seek (offset:number):void;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public send (handlerName:string, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):void;
		// #end
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public step (frames:number):void;
		// #end
		
		
		public togglePause ():void;
		
		
	}
	
	
}


export default openfl.net.NetStream;