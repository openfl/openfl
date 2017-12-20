
declare namespace openfl.display3D.textures {

export class CubeTexture {

	constructor(context:any, size:any, format:any, optimizeForRenderToTexture:any, streamingLevels:any);
	__size:any;
	__uploadedSides:any;
	uploadCompressedTextureFromByteArray(data:any, byteArrayOffset:any, async?:any):any;
	uploadFromBitmapData(source:any, side:any, miplevel?:any, generateMipmap?:any):any;
	uploadFromByteArray(data:any, byteArrayOffset:any, side:any, miplevel?:any):any;
	uploadFromTypedArray(data:any, side:any, miplevel?:any):any;
	__setSamplerState(state:any):any;


}

}

export default openfl.display3D.textures.CubeTexture;