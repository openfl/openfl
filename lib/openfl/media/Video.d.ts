import DisplayObject from "./../display/DisplayObject";
import NetStream from "./../net/NetStream";


declare namespace openfl.media {
	
	
	export class Video extends DisplayObject {
		
		
		public deblocking:number;
		public smoothing:boolean;
		public readonly videoHeight:number;
		public readonly videoWidth:number;
		
		
		public constructor (width?:number, height?:number);
		
		// #if flash
		// @:noCompletion @:dox(hide) public attachCamera (camera:flash.media.Camera):Void;
		// #end
		
		public attachNetStream (netStream:NetStream):void;
		public clear ():void;
		
		
	}
	
	
}


export default openfl.media.Video;