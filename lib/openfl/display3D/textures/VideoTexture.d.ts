import TextureBase from "./TextureBase";
import NetStream from "./../../net/NetStream";


declare namespace openfl.display3D.textures {
	
	
	/*@:final*/ export class VideoTexture extends TextureBase {
		
		
		public readonly videoHeight:number;
		public readonly videoWidth:number;
		
		//public function attachCamera (theCamera:Camera):Void;
		public attachNetStream (netStream:NetStream):void;
		
		
	}
	
	
}


export default openfl.display3D.textures.VideoTexture;