import TextureBase from "./TextureBase";
import BitmapData from "./../../display/BitmapData";
import ByteArray from "./../../utils/ByteArray";


declare namespace openfl.display3D.textures {
	
	
	/*@:final*/ export class CubeTexture extends TextureBase {
		
		
		public uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:number, async?:boolean):void;
		public uploadFromBitmapData (source:BitmapData, side:number, miplevel?:number):void;
		public uploadFromByteArray (data:ByteArray, byteArrayOffset:number, side:number, miplevel?:number):void;
		
		
	}
	
	
}


export default openfl.display3D.textures.CubeTexture;