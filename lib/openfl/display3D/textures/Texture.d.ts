
declare namespace openfl.display3D.textures {

export class Texture {

	constructor(context:any, width:any, height:any, format:any, optimizeForRenderToTexture:any, streamingLevels:any);
	uploadCompressedTextureFromByteArray(data:any, byteArrayOffset:any, async?:any):any;
	uploadFromBitmapData(source:any, miplevel?:any, generateMipmap?:any):any;
	uploadFromByteArray(data:any, byteArrayOffset:any, miplevel?:any):any;
	uploadFromTypedArray(data:any, miplevel?:any):any;
	__setSamplerState(state:any):any;
	static __lowMemoryMode:any;


}

}

export default openfl.display3D.textures.Texture;