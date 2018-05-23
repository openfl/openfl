import TextureBase from "./TextureBase";
import BitmapData from "./../../display/BitmapData";
import ByteArray from "./../../utils/ByteArray";


declare namespace openfl.display3D.textures {
	
	
	/*@:final*/ export class Texture extends TextureBase {
		
		
		public uploadCompressedTextureFromByteArray (data:ByteArray, byteArrayOffset:number, async?:boolean):void;
		public uploadFromBitmapData (source:BitmapData, miplevel?:number):void;
		public uploadFromByteArray (data:ByteArray, byteArrayOffset:number, miplevel?:number):void;
		
		
	}
	
	
}


export default openfl.display3D.textures.Texture;