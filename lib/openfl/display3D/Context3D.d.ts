import EventDispatcher from "./../events/EventDispatcher";

declare namespace openfl.display3D {

export class Context3D extends EventDispatcher {

	constructor(stage3D:any, renderSession:any);
	backBufferHeight:any;
	backBufferWidth:any;
	driverInfo:any;
	enableErrorChecking:any;
	maxBackBufferHeight:any;
	maxBackBufferWidth:any;
	profile:any;
	totalGPUMemory:any;
	__backBufferAntiAlias:any;
	__backBufferEnableDepthAndStencil:any;
	__backBufferWantsBestResolution:any;
	
	
	__fragmentConstants:any;
	
	__frameCount:any;
	__maxAnisotropyCubeTexture:any;
	__maxAnisotropyTexture2D:any;
	__positionScale:any;
	__program:any;
	__renderSession:any;
	__renderToTexture:any;
	__rttDepthAndStencil:any;
	__samplerDirty:any;
	__samplerTextures:any;
	__samplerStates:any;
	__scissorRectangle:any;
	__stage3D:any;
	__stats:any;
	__statsCache:any;
	__stencilCompareMode:any;
	__stencilRef:any;
	__stencilReadMask:any;
	
	__supportsAnisotropicFiltering:any;
	__supportsPackedDepthStencil:any;
	__vertexConstants:any;
	clear(red?:any, green?:any, blue?:any, alpha?:any, depth?:any, stencil?:any, mask?:any):any;
	configureBackBuffer(width:any, height:any, antiAlias:any, enableDepthAndStencil?:any, wantsBestResolution?:any, wantsBestResolutionOnBrowserZoom?:any):any;
	createCubeTexture(size:any, format:any, optimizeForRenderToTexture:any, streamingLevels?:any):any;
	createIndexBuffer(numIndices:any, bufferUsage?:any):any;
	createProgram():any;
	createRectangleTexture(width:any, height:any, format:any, optimizeForRenderToTexture:any):any;
	createTexture(width:any, height:any, format:any, optimizeForRenderToTexture:any, streamingLevels?:any):any;
	createVertexBuffer(numVertices:any, data32PerVertex:any, bufferUsage?:any):any;
	createVideoTexture():any;
	dispose(recreate?:any):any;
	drawToBitmapData(destination:any):any;
	drawTriangles(indexBuffer:any, firstIndex?:any, numTriangles?:any):any;
	present():any;
	setBlendFactors(sourceFactor:any, destinationFactor:any):any;
	setColorMask(red:any, green:any, blue:any, alpha:any):any;
	setCulling(triangleFaceToCull:any):any;
	setDepthTest(depthMask:any, passCompareMode:any):any;
	setProgram(program:any):any;
	setProgramConstantsFromByteArray(programType:any, firstRegister:any, numRegisters:any, data:any, byteArrayOffset:any):any;
	setProgramConstantsFromMatrix(programType:any, firstRegister:any, matrix:any, transposedMatrix?:any):any;
	setProgramConstantsFromVector(programType:any, firstRegister:any, data:any, numRegisters?:any):any;
	setRenderToBackBuffer():any;
	setRenderToTexture(texture:any, enableDepthAndStencil?:any, antiAlias?:any, surfaceSelector?:any):any;
	setSamplerStateAt(sampler:any, wrap:any, filter:any, mipfilter:any):any;
	setScissorRectangle(rectangle:any):any;
	setStencilActions(triangleFace?:any, compareMode?:any, actionOnBothPass?:any, actionOnDepthFail?:any, actionOnDepthPassStencilFail?:any):any;
	setStencilReferenceValue(referenceValue:any, readMask?:any, writeMask?:any):any;
	setTextureAt(sampler:any, texture:any):any;
	setVertexBufferAt(index:any, buffer:any, bufferOffset?:any, format?:any):any;
	__updateBackbufferViewport():any;
	__updateBlendFactors():any;
	set_enableErrorChecking(value:any):any;
	static supportsVideoTexture:any;
	static MAX_SAMPLERS:any;
	static MAX_ATTRIBUTES:any;
	static MAX_PROGRAM_REGISTERS:any;
	static TEXTURE_MAX_ANISOTROPY_EXT:any;
	static DEPTH_STENCIL:any;
	static __stateCache:any;


}

}

export default openfl.display3D.Context3D;