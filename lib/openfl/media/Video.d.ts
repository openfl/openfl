import DisplayObject from "./../display/DisplayObject";

declare namespace openfl.media {

export class Video extends DisplayObject {

	constructor(width?:any, height?:any);
	deblocking:any;
	shader:any;
	smoothing:any;
	videoHeight:any;
	videoWidth:any;
	__active:any;
	
	__bufferAlpha:any;
	__bufferColorTransform:any;
	__bufferContext:any;
	__bufferData:any;
	__dirty:any;
	__height:any;
	__stream:any;
	
	__textureTime:any;
	__width:any;
	attachNetStream(netStream:any):any;
	clear():any;
	__enterFrame(deltaTime:any):any;
	__getBounds(rect:any, matrix:any):any;
	__getBuffer(gl:any, alpha:any, colorTransform:any):any;
	__getTexture(gl:any):any;
	__hitTest(x:any, y:any, shapeFlag:any, stack:any, interactiveOnly:any, hitObject:any):any;
	__hitTestMask(x:any, y:any):any;
	__renderCanvas(renderSession:any):any;
	__renderDOM(renderSession:any):any;
	__renderGL(renderSession:any):any;
	__renderGLMask(renderSession:any):any;
	get_height():any;
	set_height(value:any):any;
	get_videoHeight():any;
	get_videoWidth():any;
	get_width():any;
	set_width(value:any):any;
	static __bufferStride:any;


}

}

export default openfl.media.Video;