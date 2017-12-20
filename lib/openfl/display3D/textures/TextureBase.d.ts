import EventDispatcher from "./../../events/EventDispatcher";

declare namespace openfl.display3D.textures {

export class TextureBase extends EventDispatcher {

	constructor(context:any);
	__alphaTexture:any;
	__context:any;
	__format:any;
	__height:any;
	__internalFormat:any;
	__optimizeForRenderToTexture:any;
	__samplerState:any;
	__streamingLevels:any;
	
	
	__textureTarget:any;
	__width:any;
	dispose():any;
	__getImage(bitmapData:any):any;
	__getTexture():any;
	__setSamplerState(state:any):any;


}

}

export default openfl.display3D.textures.TextureBase;