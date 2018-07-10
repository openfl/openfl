import TextureBase from "./TextureBase";
import BitmapData from "./../../display/BitmapData";
import ByteArray from "./../../utils/ByteArray";


declare namespace openfl.display3D.textures {
	
	
	/*@:final*/ export class RectangleTexture extends TextureBase {
		
		
		public uploadFromBitmapData (source:BitmapData):void;
		public uploadFromByteArray (data:ByteArray, byteArrayOffset:number):void;
		
		
	}
	
	
}


export default openfl.display3D.textures.RectangleTexture;