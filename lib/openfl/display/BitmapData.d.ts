declare namespace openfl.display {

export class BitmapData {

	constructor(width:any, height:any, transparent?:any, fillColor?:any);
	height:any;
	image:any;
	readable:any;
	rect:any;
	transparent:any;
	width:any;
	__blendMode:any;
	
	__bufferColorTransform:any;
	
	__bufferAlpha:any;
	__bufferData:any;
	
	
	__isMask:any;
	__isValid:any;
	__renderable:any;
	__surface:any;
	
	
	__textureVersion:any;
	__transform:any;
	__worldAlpha:any;
	__worldColorTransform:any;
	__worldTransform:any;
	applyFilter(sourceBitmapData:any, sourceRect:any, destPoint:any, filter:any):any;
	clone():any;
	colorTransform(rect:any, colorTransform:any):any;
	compare(otherBitmapData:any):any;
	copyChannel(sourceBitmapData:any, sourceRect:any, destPoint:any, sourceChannel:any, destChannel:any):any;
	copyPixels(sourceBitmapData:any, sourceRect:any, destPoint:any, alphaBitmapData?:any, alphaPoint?:any, mergeAlpha?:any):any;
	dispose():any;
	disposeImage():any;
	draw(source:any, matrix?:any, colorTransform?:any, blendMode?:any, clipRect?:any, smoothing?:any):any;
	drawWithQuality(source:any, matrix?:any, colorTransform?:any, blendMode?:any, clipRect?:any, smoothing?:any, quality?:any):any;
	encode(rect:any, compressor:any, byteArray?:any):any;
	fillRect(rect:any, color:any):any;
	floodFill(x:any, y:any, color:any):any;
	generateFilterRect(sourceRect:any, filter:any):any;
	getBuffer(gl:any, alpha:any, colorTransform:any):any;
	getColorBoundsRect(mask:any, color:any, findColor?:any):any;
	getPixel(x:any, y:any):any;
	getPixel32(x:any, y:any):any;
	getPixels(rect:any):any;
	getSurface():any;
	getTexture(gl:any):any;
	getVector(rect:any):any;
	histogram(hRect?:any):any;
	hitTest(firstPoint:any, firstAlphaThreshold:any, secondObject:any, secondBitmapDataPoint?:any, secondAlphaThreshold?:any):any;
	lock():any;
	merge(sourceBitmapData:any, sourceRect:any, destPoint:any, redMultiplier:any, greenMultiplier:any, blueMultiplier:any, alphaMultiplier:any):any;
	noise(randomSeed:any, low?:any, high?:any, channelOptions?:any, grayScale?:any):any;
	paletteMap(sourceBitmapData:any, sourceRect:any, destPoint:any, redArray?:any, greenArray?:any, blueArray?:any, alphaArray?:any):any;
	perlinNoise(baseX:any, baseY:any, numOctaves:any, randomSeed:any, stitch:any, fractalNoise:any, channelOptions?:any, grayScale?:any, offsets?:any):any;
	scroll(x:any, y:any):any;
	setPixel(x:any, y:any, color:any):any;
	setPixel32(x:any, y:any, color:any):any;
	setPixels(rect:any, byteArray:any):any;
	setVector(rect:any, inputVector:any):any;
	threshold(sourceBitmapData:any, sourceRect:any, destPoint:any, operation:any, threshold:any, color?:any, mask?:any, copySource?:any):any;
	unlock(changeRect?:any):any;
	__applyAlpha(alpha:any):any;
	__draw(source:any, matrix?:any, colorTransform?:any, blendMode?:any, clipRect?:any, smoothing?:any):any;
	__fromBase64(base64:any, type:any):any;
	__fromBytes(bytes:any, rawAlpha?:any):any;
	__fromFile(path:any):any;
	__fromImage(image:any):any;
	__getBounds(rect:any, matrix:any):any;
	__getFramebuffer(gl:any):any;
	__loadFromBase64(base64:any, type:any):any;
	__loadFromBytes(bytes:any, rawAlpha?:any):any;
	__loadFromFile(path:any):any;
	__renderCairo(renderSession:any):any;
	__renderCairoMask(renderSession:any):any;
	__renderCanvas(renderSession:any):any;
	__renderCanvasMask(renderSession:any):any;
	__renderGL(renderSession:any):any;
	__renderGLMask(renderSession:any):any;
	__resize(width:any, height:any):any;
	__sync():any;
	__updateChildren(transformOnly:any):any;
	__updateMask(maskGraphics:any):any;
	__updateTransforms(overrideTransform?:any):any;
	static __bufferStride:any;
	
	static __tempVector:any;
	static __textureFormat:any;
	static __textureInternalFormat:any;
	static fromBase64(base64:any, type:any):any;
	static fromBytes(bytes:any, rawAlpha?:any):any;
	static fromCanvas(canvas:any, transparent?:any):any;
	static fromFile(path:any):any;
	static fromImage(image:any, transparent?:any):any;
	static fromTexture(texture:any):any;
	static loadFromBase64(base64:any, type:any):any;
	static loadFromBytes(bytes:any, rawAlpha?:any):any;
	static loadFromFile(path:any):any;


}

}

export default openfl.display.BitmapData;