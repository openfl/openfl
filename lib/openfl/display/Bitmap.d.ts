import DisplayObject from "./DisplayObject";

declare namespace openfl.display {

export class Bitmap extends DisplayObject {

	constructor(bitmapData?:any, pixelSnapping?:any, smoothing?:any);
	bitmapData:any;
	pixelSnapping:any;
	shader:any;
	smoothing:any;
	__image:any;
	__imageVersion:any;
	__enterFrame(deltaTime:any):any;
	__getBounds(rect:any, matrix:any):any;
	__hitTest(x:any, y:any, shapeFlag:any, stack:any, interactiveOnly:any, hitObject:any):any;
	__hitTestMask(x:any, y:any):any;
	__renderCairo(renderSession:any):any;
	__renderCairoMask(renderSession:any):any;
	__renderCanvas(renderSession:any):any;
	__renderCanvasMask(renderSession:any):any;
	__renderDOM(renderSession:any):any;
	__renderDOMClear(renderSession:any):any;
	__renderGL(renderSession:any):any;
	__renderGLMask(renderSession:any):any;
	__updateCacheBitmap(renderSession:any, force:any):any;
	__updateMask(maskGraphics:any):any;
	set_bitmapData(value:any):any;
	get_height():any;
	set_height(value:any):any;
	get_width():any;
	set_width(value:any):any;


}

}

export default openfl.display.Bitmap;