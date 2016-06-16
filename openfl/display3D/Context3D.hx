package openfl.display3D;


import lime.app.Application;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLRenderbuffer;
import lime.utils.Float32Array;
import openfl.display.BitmapData;
import openfl.display.OpenGLView;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Lib;

@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)


@:final class Context3D {
	
	
	public static var supportsVideoTexture (default, null):Bool = false;
	
	private static var TEXTURE_MAX_ANISOTROPY_EXT = 0x84FE;
	private static var MAX_SAMPLERS = 8;
	private static var MAX_TEXTURE_MAX_ANISOTROPY_EXT = 0x84FF;
	
	private static var __anisotropySupportTested:Bool = false;
	private static var __maxSupportedAnisotropy:UInt = 256;
	private static var __supportsAnisotropy:Bool = false;
	
	public var backBufferHeight (default, null):Int;
	public var backBufferWidth (default, null):Int;
	public var driverInfo (default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking:Bool; // TODO (use GL.getError() and GL.validateProgram(program))
	public var maxBackBufferHeight:Int;
	public var maxBackBufferWidth:Int;
	public var profile (default, null):Context3DProfile = BASELINE;
	public var totalGPUMemory (default, null):Int = 0;
	
	private var __blendDestinationFactor:Context3DBlendFactor; // to mimic Stage3d behavior of keeping blending across frames:
	private var __blendEnabled:Bool; // to mimic Stage3d behavior of keeping blending across frames:
	private var __blendSourceFactor:Context3DBlendFactor; // to mimic Stage3d behavior of keeping blending across frames:
	private var __currentProgram:Program3D;
	private var __disposed:Bool;
	private var __drawing:Bool; // to mimic Stage3d behavior of not allowing calls to drawTriangles between present and clear
	private var __framebuffer:GLFramebuffer;
	private var __indexBuffersCreated:Array<IndexBuffer3D>; // to keep track of stuff to dispose when calling dispose
	private var __ogl:OpenGLView;
	private var __programsCreated:Array<Program3D>; // to keep track of stuff to dispose when calling dispose
	private var __renderbuffer:GLRenderbuffer;
	private var __samplerParameters:Array<SamplerState>; //TODO : use Tupple3
	private var __scrollRect:Rectangle;
	private var __stencilbuffer:GLRenderbuffer;
	private var __stencilCompareMode:Context3DCompareMode;
	private var __stencilRef:Int;
	private var __stencilReadMask:Int;
	private var __texturesCreated:Array<TextureBase>; // to keep track of stuff to dispose when calling dispose
	private var __vertexBuffersCreated:Array<VertexBuffer3D>; // to keep track of stuff to dispose when calling dispose
	private var __yFlip:Float;
	private var __backBufferDepthAndStencil:Bool;
	private var __rttDepthAndStencil:Bool;
	private var __scissorRectangle:Rectangle;
	private var __renderToTexture:Bool;
	private var __rttWidth:Int;
	private var __rttHeight:Int;
	
	
	private function new () {
		
		__disposed = false;
		
		__stencilCompareMode = Context3DCompareMode.ALWAYS;
		__stencilRef = 0;
		__stencilReadMask = 0xFF;
		
		__yFlip = 1;
		
		__vertexBuffersCreated = new Array ();
		__indexBuffersCreated = new Array ();
		__programsCreated = new Array ();
		__texturesCreated = new Array (); 
		__samplerParameters = new Array<SamplerState> ();
		
		for (i in 0...MAX_SAMPLERS) {
			
			__samplerParameters[i] = new SamplerState ();
			__samplerParameters[i].wrap = Context3DWrapMode.CLAMP;
			__samplerParameters[i].filter = Context3DTextureFilter.LINEAR;
			__samplerParameters[i].mipfilter =Context3DMipFilter.MIPNONE;
			
		}
		
		var stage = Lib.current.stage;
		
		__ogl = new OpenGLView ();
		__ogl.scrollRect = new Rectangle (0, 0, stage.stageWidth, stage.stageHeight);
		__scrollRect = __ogl.scrollRect.clone ();
		__ogl.width = stage.stageWidth;
		__ogl.height = stage.stageHeight;
		
		stage.addChildAt (__ogl, 0);
		
	}
	
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:Context3DClearMask = ALL):Void {
		
		if (!__drawing) {
			
		 	__updateBlendStatus ();
		 	__drawing = true;
		 	
		}
		
		#if (cpp || neko || nodejs)
		GL.depthMask (true);
		#end
		#if js
		if (__scissorRectangle != null) GL.disable (GL.SCISSOR_TEST);
		#end
		GL.clearColor (red, green, blue, alpha);
		GL.clearDepth (depth);
		GL.clearStencil (stencil);
		
		GL.clear (__getGLClearMask (mask));
		
		#if js
		if (__scissorRectangle != null) GL.enable (GL.SCISSOR_TEST);
		#end
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		__backBufferDepthAndStencil = enableDepthAndStencil;
		__updateDepthAndStencilState ();
		
		// TODO use antiAlias parameter
		__setBackBufferViewPort (null, null, width, height);
		__updateScissorRectangle ();
		
	}
	
	
	public function createCubeTexture (size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture {
		
		var texture = new CubeTexture (this, GL.createTexture (), size); // TODO use format, optimizeForRenderToTexture and streamingLevels?
		__texturesCreated.push (texture);
		return texture;
		
	}
	
	
	public function createIndexBuffer (numIndices:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):IndexBuffer3D {
		
		var indexBuffer = new IndexBuffer3D (this, GL.createBuffer(), numIndices, bufferUsage == Context3DBufferUsage.STATIC_DRAW ? GL.STATIC_DRAW : GL.DYNAMIC_DRAW);
		__indexBuffersCreated.push (indexBuffer);
		return indexBuffer;
		
	}
	
	
	public function createProgram ():Program3D {
		
		var program = new Program3D (this, GL.createProgram ());
		__programsCreated.push (program);
		return program;
		
	}
	
	
	public function createRectangleTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture {
		
		var texture = new RectangleTexture (this, GL.createTexture (), optimizeForRenderToTexture, width, height); // TODO use format, optimizeForRenderToTexture and streamingLevels?
		__texturesCreated.push (texture);
		return texture;
		
	}
	
	
	public function createTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture {
		
		var texture = new Texture (this, GL.createTexture (), optimizeForRenderToTexture, width, height); // TODO use format, optimizeForRenderToTexture and streamingLevels?
		__texturesCreated.push (texture);
		return texture;
		
	}
	
	
	public function createVertexBuffer (numVertices:Int, data32PerVertex:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):VertexBuffer3D {
		
		var vertexBuffer = new VertexBuffer3D (this, GL.createBuffer (), numVertices, data32PerVertex, bufferUsage == Context3DBufferUsage.STATIC_DRAW ? GL.STATIC_DRAW : GL.DYNAMIC_DRAW);
		__vertexBuffersCreated.push (vertexBuffer);
		return vertexBuffer;
		
	}
	
	
	public function dispose (recreate:Bool = true):Void {
		
		// TODO handle recreate
		// TODO simulate context loss by recreating a context3d and dispatch event on Stage3d(see Adobe Doc)
		// TODO add error on other method when context3d is disposed
		
		for (vertexBuffer in __vertexBuffersCreated) {
			
			vertexBuffer.dispose ();
			
		}
		
		__vertexBuffersCreated = null;
		
		for (indexBuffer in __indexBuffersCreated) {
			
			indexBuffer.dispose ();
			
		}
		
		__indexBuffersCreated = null;
		
		for (program in __programsCreated) {
			
			program.dispose ();
			
		}
		
		__programsCreated = null;
		__samplerParameters = null;
		
		for (texture in __texturesCreated) {
			
			texture.dispose ();
			
		}
		
		__texturesCreated = null;
		
		if (__framebuffer != null) {
			
			GL.deleteFramebuffer (__framebuffer);
			__framebuffer = null;
			
		}
		
		if (__renderbuffer != null) {
			
			GL.deleteRenderbuffer (__renderbuffer);
			__renderbuffer = null;
			
		}
		
		__disposed = true;
		
	}
	
	
	public function drawToBitmapData (destination:BitmapData):Void {
		
		// TODO
		
	}
	
	
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		var location = __currentProgram.__yFlipLoc ();
		GL.uniform1f (location, __yFlip);
		
		if (!__drawing) {
			
			throw new Error ("Need to clear before drawing if the buffer has not been cleared since the last present() call.");
			
		}
		
		var numIndices;
		
		if (numTriangles == -1) {
			
			numIndices = indexBuffer.__numIndices;
			
		} else {
			
			numIndices = numTriangles * 3;
			
		}
		
		var byteOffset = firstIndex * 2;
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, indexBuffer.__glBuffer);
		GL.drawElements (GL.TRIANGLES, numIndices, GL.UNSIGNED_SHORT, byteOffset);
		
	}
	
	
	public function present ():Void {
		
		__drawing = false;
		GL.useProgram (null);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.disable (GL.CULL_FACE);
		
		if (__framebuffer != null) {
			
			GL.bindFramebuffer (GL.FRAMEBUFFER, null);
			
		}
		
		if (__renderbuffer != null) {
			
			GL.bindRenderbuffer (GL.RENDERBUFFER, null);
			
		}
		
	}
	
	
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		__blendEnabled = true;
		__blendSourceFactor = sourceFactor;
		__blendDestinationFactor = destinationFactor;
		
		__updateBlendStatus ();
		
	}
	
	
	public function setColorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		GL.colorMask (red, green, blue, alpha);
		
	}
	
	
	public function setCulling (triangleFaceToCull:Context3DTriangleFace):Void {
		
		if (triangleFaceToCull == Context3DTriangleFace.NONE) {
			
			GL.disable (GL.CULL_FACE);
			
		} else {
			
			GL.enable (GL.CULL_FACE);
			
			switch (triangleFaceToCull) {
				
				case Context3DTriangleFace.FRONT: GL.cullFace (GL.BACK);
				case Context3DTriangleFace.BACK: GL.cullFace (GL.FRONT);
				case Context3DTriangleFace.FRONT_AND_BACK: GL.cullFace (GL.FRONT_AND_BACK);
				default: throw "Unknown Context3DTriangleFace type.";
				
			}
			
		}
		
		switch (triangleFaceToCull) {
			
			case Context3DTriangleFace.FRONT:
				
				__yFlip = -1;
			
			case Context3DTriangleFace.BACK:
				
				__yFlip = 1; // checked
			
			case Context3DTriangleFace.FRONT_AND_BACK:
				
				__yFlip = 1;
			
			case Context3DTriangleFace.NONE:
				
				__yFlip = 1; // checked
			
			default:
				
				throw "Unknown culling mode " + triangleFaceToCull + ".";
 			
 		}
		
	}
	
	
	public function setDepthTest (depthMask:Bool, passCompareMode:Context3DCompareMode):Void {
		
		GL.depthFunc (__getGLCompareMode (passCompareMode));
		GL.depthMask (depthMask);
		
	}
	
	
	public function setProgram (program3D:Program3D):Void {
		
		var glProgram = null;
		
		if (program3D != null) {
			
			glProgram = program3D.__glProgram;
			
		}
		
		GL.useProgram (glProgram);
		__currentProgram = program3D;
		//TODO reset bound textures, buffers... ?
		// Or maybe we should have arrays and map for each program so we can switch them while keeping the bounded texture and variable?
		
	}
	
	
	public function setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void {
		
		data.position = byteArrayOffset;
		
		for (i in 0...numRegisters) {
			
			var location = __currentProgram.__constUniformLocationFromAgal (programType, firstRegister + i);
			__setGLSLProgramConstantsFromByteArray (location, data);
			
		}
		
	}
	
	
	public function setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		// var locationName = __getUniformLocationNameFromAgalRegisterIndex (programType, firstRegister);
		// setProgramConstantsFromVector (programType, firstRegister, matrix.rawData, 16);
		
		var d = matrix.rawData;
		
		if (transposedMatrix) {
			
			setProgramConstantsFromVector(programType, firstRegister, [ d[0], d[4], d[8], d[12] ], 1);  
			setProgramConstantsFromVector(programType, firstRegister + 1, [ d[1], d[5], d[9], d[13] ], 1);
			setProgramConstantsFromVector(programType, firstRegister + 2, [ d[2], d[6], d[10], d[14] ], 1);
			setProgramConstantsFromVector(programType, firstRegister + 3, [ d[3], d[7], d[11], d[15] ], 1);
			
		} else {
			
			setProgramConstantsFromVector(programType, firstRegister, [ d[0], d[1], d[2], d[3] ], 1);
			setProgramConstantsFromVector(programType, firstRegister + 1, [ d[4], d[5], d[6], d[7] ], 1);
			setProgramConstantsFromVector(programType, firstRegister + 2, [ d[8], d[9], d[10], d[11] ], 1);
			setProgramConstantsFromVector(programType, firstRegister + 3, [ d[12], d[13], d[14], d[15] ], 1);
			
		}
		
	}
	
	
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = 1):Void {
		
		for (i in 0...numRegisters) {
			
			var currentIndex = i * 4;
			var location = __currentProgram.__constUniformLocationFromAgal (programType, firstRegister + i);
			__setGLSLProgramConstantsFromVector4 (location, data, currentIndex);
			
		}
		
	}
	
	
	public function setRenderToBackBuffer ():Void {
		
		GL.disable (GL.DEPTH_TEST);
		GL.disable (GL.STENCIL_TEST);
		GL.disable (GL.SCISSOR_TEST);
		GL.bindFramebuffer (GL.FRAMEBUFFER, null);
		
		if (__framebuffer != null) {
			
			GL.bindFramebuffer (GL.FRAMEBUFFER, null);
			
		}
		
		if (__renderbuffer != null) {
			
			GL.bindRenderbuffer (GL.RENDERBUFFER, null);
			
		}
		
		__renderToTexture = false;
		__updateBackBufferViewPort ();
		__updateScissorRectangle ();
		__updateDepthAndStencilState ();
		
	}
	
	
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0, colorOutputIndex:Int = 0):Void {      
		
		if (__framebuffer == null) {
			
			__framebuffer = GL.createFramebuffer ();
			
		}
		
		GL.bindFramebuffer (GL.FRAMEBUFFER, __framebuffer);
		
		if (__renderbuffer == null) {
			
			__renderbuffer = GL.createRenderbuffer ();
			
		}
		
		GL.bindRenderbuffer (GL.RENDERBUFFER, __renderbuffer);
		#if (ios || tvos)
		GL.renderbufferStorage (GL.RENDERBUFFER, 0x88F0, texture.width, texture.height);
		#elseif js
		if (enableDepthAndStencil) GL.renderbufferStorage (GL.RENDERBUFFER, GL.DEPTH_STENCIL, texture.__width, texture.__height);
		#else
		GL.renderbufferStorage (GL.RENDERBUFFER, GL.RGBA, texture.__width, texture.__height);
		#end
		
		if (enableDepthAndStencil) {
			
			// TODO : currently does not work
			
			GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.__glTexture, 0);
			
			GL.renderbufferStorage (GL.RENDERBUFFER, GL.DEPTH_STENCIL, texture.__width, texture.__height);
			GL.framebufferRenderbuffer (GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, __renderbuffer);
			
			GL.enable (GL.DEPTH_TEST);
			GL.enable (GL.STENCIL_TEST);
			
		}
		
		GL.bindTexture (GL.TEXTURE_2D, texture.__glTexture);
		GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, texture.__width, texture.__height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_NEAREST);
		GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.__glTexture, 0);
		
		GL.viewport (0, 0, texture.__width, texture.__height);
		
		__renderToTexture = true;
		__rttDepthAndStencil = enableDepthAndStencil;
		__rttWidth = texture.__width;
		__rttHeight = texture.__height;
		__updateScissorRectangle ();
		__updateDepthAndStencilState ();
		
	}
	
	
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		//TODO for flash < 11.6 : patch the AGAL (using specific opcodes) and rebuild the program? 
		
		if (0 <= sampler && sampler <  MAX_SAMPLERS) {
			
			__samplerParameters[sampler].wrap = wrap;
			__samplerParameters[sampler].filter = filter;
			__samplerParameters[sampler].mipfilter = mipfilter;
			
		} else {
			
			throw "Sampler is out of bounds.";
			
		}
		
	}
	
	
	public function setScissorRectangle (rectangle:Rectangle):Void {
		
		// TODO test it
		__scissorRectangle = rectangle;
		
		if (rectangle == null) {
			
			GL.disable (GL.SCISSOR_TEST);
			return;
			
		}
		
		GL.enable (GL.SCISSOR_TEST);
		__updateScissorRectangle ();
		
	}
	
	
	public function setStencilActions (triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		__stencilCompareMode = compareMode;
		GL.stencilOp (__getGLStencilAction (actionOnBothPass), __getGLStencilAction (actionOnDepthFail), __getGLStencilAction (actionOnDepthPassStencilFail));
		GL.stencilFunc (__getGLCompareMode (__stencilCompareMode), __stencilRef, __stencilReadMask);
		
	}
	
	
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		__stencilReadMask = readMask;
		__stencilRef = referenceValue;
		
		GL.stencilFunc (__getGLCompareMode (__stencilCompareMode), __stencilRef, __stencilReadMask);
		GL.stencilMask (writeMask);
		
	}
	
	
	public function setTextureAt (sampler:Int, texture:TextureBase):Void {
		
		var location = __currentProgram.__fsampUniformLocationFromAgal (sampler);
		__setGLSLTextureAt (location, texture, sampler);
		
	}
	
	
	public function setVertexBufferAt (index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void {
		
		var location = __currentProgram.__vaUniformLocationFromAgal (index);
		__setGLSLVertexBufferAt (location, buffer, bufferOffset, format);
		
	}
	
	
	private function __deleteIndexBuffer (buffer:IndexBuffer3D):Void {
		
		if (buffer.__glBuffer == null) {
			
			return;
			
		}
		
		__indexBuffersCreated.remove (buffer);
		GL.deleteBuffer (buffer.__glBuffer);
		buffer.__glBuffer = null;
		
	}
	
	
	private function __deleteProgram (program:Program3D):Void {
		
		if (program.__glProgram == null) {
			
			return;
			
		}
		
		__programsCreated.remove (program);
		GL.deleteProgram (program.__glProgram);
		program.__glProgram = null;
		
	}
	
	
	private function __deleteTexture (texture:TextureBase):Void {
		
		if (texture.__glTexture == null) {
			
			return;
			
		}
		
		__texturesCreated.remove (texture);
		GL.deleteTexture (texture.__glTexture);
		texture.__glTexture = null;
		
	}
	
	
	private function __deleteVertexBuffer (buffer:VertexBuffer3D):Void {
		
		if (buffer.__glBuffer == null) {
			
			return;
			
		}
		
		__vertexBuffersCreated.remove (buffer);
		GL.deleteBuffer (buffer.__glBuffer);
		buffer.__glBuffer = null;
		
	}
	
	
	private function __getGLBlend (blendMode:Context3DBlendFactor):Int {
		
		return switch (blendMode) {
			
			case DESTINATION_ALPHA: GL.DST_ALPHA;
			case DESTINATION_COLOR: GL.DST_COLOR;
			case ONE: GL.ONE;
			case ONE_MINUS_DESTINATION_ALPHA: GL.ONE_MINUS_DST_ALPHA;
			case ONE_MINUS_DESTINATION_COLOR: GL.ONE_MINUS_DST_COLOR;
			case ONE_MINUS_SOURCE_ALPHA: GL.ONE_MINUS_SRC_ALPHA;
			case ONE_MINUS_SOURCE_COLOR: GL.ONE_MINUS_SRC_COLOR;
			case SOURCE_ALPHA: GL.SRC_ALPHA;
			case SOURCE_COLOR: GL.SRC_COLOR;
			case ZERO: GL.ZERO;
			default: GL.ONE_MINUS_SRC_ALPHA;
			
		}
		
	}
	
	
	private function __getGLClearMask (clearMask:Context3DClearMask):Int {
		
		return switch (clearMask) {
			
			case ALL: GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT;
			case COLOR: GL.COLOR_BUFFER_BIT;
			case DEPTH: GL.DEPTH_BUFFER_BIT;
			case STENCIL: GL.STENCIL_BUFFER_BIT;
			default: GL.COLOR_BUFFER_BIT;
			
		}
		
	}
	
	
	private function __getGLCompareMode (compareMode:Context3DCompareMode):Int {
		
		return switch (compareMode) {
			
			case ALWAYS: GL.ALWAYS;
			case EQUAL: GL.EQUAL;
			case GREATER: GL.GREATER;
			case GREATER_EQUAL: GL.GEQUAL;
			case LESS: GL.LESS;
			case LESS_EQUAL: GL.LEQUAL; // TODO : wrong value
			case NEVER: GL.NEVER;
			case NOT_EQUAL: GL.NOTEQUAL;
			default: GL.EQUAL;
			
		}
		
	}
	
	
	private function __getGLStencilAction (stencilAction:Context3DStencilAction):Int {
		
		return switch (stencilAction) {
			
			case DECREMENT_SATURATE: GL.DECR;
			case DECREMENT_WRAP: GL.DECR_WRAP;
			case INCREMENT_SATURATE: GL.INCR;
			case INCREMENT_WRAP: GL.INCR_WRAP;
			case INVERT: GL.INVERT;
			case KEEP: GL.KEEP;
			case SET: GL.REPLACE;
			case ZERO: GL.ZERO;
			default: GL.KEEP;
			
		}
		
	}
	
	
	private function __getGLTriangleFace (triangleFace:Context3DTriangleFace):Int {
		
		return switch (triangleFace) {
			
			case BACK: GL.FRONT;
			case FRONT: GL.BACK;
			case FRONT_AND_BACK: GL.FRONT_AND_BACK;
			case NONE: 0;
			default: 0;
			
		}
		
	}
	
	
	private function __setBackBufferViewPort (?x:Int, ?y:Int, ?width:Int, ?height:Int) {
		
		if (x == null) x = Std.int (__scrollRect.x);
		if (y == null) y = Std.int (__scrollRect.y);
		if (width == null) width = Std.int (__scrollRect.width);
		if (height == null) height = Std.int (__scrollRect.height);
		
		__scrollRect.x = x;
		__scrollRect.y = y;
		__scrollRect.width = width;
		__scrollRect.height = height;
		__ogl.width = x + width;
		__ogl.height = y + height;
		
		__updateBackBufferViewPort ();
		
	}
	
	
	private function __setGLSLProgramConstantsFromByteArray (location:GLUniformLocation, data:ByteArray, byteArrayOffset:Int = 0):Void {
		
		data.position = byteArrayOffset;
		GL.uniform4f (location, data.readFloat (), data.readFloat (), data.readFloat (), data.readFloat ());
		
	}
	
	
	private function __setGLSLProgramConstantsFromMatrix (location:GLUniformLocation, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		GL.uniformMatrix4fv (location, !transposedMatrix, new Float32Array (matrix.rawData));
		
	}
	
	
	private function __setGLSLProgramConstantsFromVector4 (location:GLUniformLocation, data:Array<Float>, startIndex:Int = 0):Void {
		
		GL.uniform4f (location, data[startIndex], data[startIndex + 1], data[startIndex + 2], data[startIndex + 3]);
		
	}
	
	
	private function __setGLSLTextureAt (location:GLUniformLocation, texture:TextureBase, textureIndex:Int):Void {
		
		switch (textureIndex) {
			
			case 0 : GL.activeTexture (GL.TEXTURE0);
			case 1 : GL.activeTexture (GL.TEXTURE1);
			case 2 : GL.activeTexture (GL.TEXTURE2);
			case 3 : GL.activeTexture (GL.TEXTURE3);
			case 4 : GL.activeTexture (GL.TEXTURE4);
			case 5 : GL.activeTexture (GL.TEXTURE5);
			case 6 : GL.activeTexture (GL.TEXTURE6);
			case 7 : GL.activeTexture (GL.TEXTURE7);
			// TODO more?
			default: throw "Does not support texture8 or more";
			
		}
		
		if (texture == null) {
			
			GL.bindTexture (GL.TEXTURE_2D, null);
			GL.bindTexture (GL.TEXTURE_CUBE_MAP, null);
			return;
			
		}
		
		if (Std.is (texture, Texture)) {
			
			GL.bindTexture (GL.TEXTURE_2D, cast (texture, Texture).__glTexture);
			GL.uniform1i (location, textureIndex);
			
		} else if (Std.is (texture, RectangleTexture)) {
			
			GL.bindTexture (GL.TEXTURE_2D, cast (texture, RectangleTexture).__glTexture);
			GL.uniform1i (location, textureIndex);
			
		} else if (Std.is (texture, CubeTexture) ) {
			
			GL.bindTexture (GL.TEXTURE_CUBE_MAP, cast (texture, CubeTexture).__glTexture );
			GL.uniform1i (location, textureIndex);
			
		} else {
			
			throw "Texture of type " + Type.getClassName (Type.getClass (texture)) + " not supported yet";
			
		}
		
		var parameters = __samplerParameters[textureIndex];
		
		if (parameters != null) {
			
			__setTextureParameters (texture, parameters.wrap, parameters.filter, parameters.mipfilter);
			
		} else {
			
			__setTextureParameters (texture, Context3DWrapMode.CLAMP, Context3DTextureFilter.NEAREST, Context3DMipFilter.MIPNONE);
			
		}
		
	}
	
	
	private function __setGLSLVertexBufferAt (location:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, ?format:Context3DVertexBufferFormat):Void {
		
		if (buffer == null) {
			
			if (location > -1) {
				
				GL.disableVertexAttribArray (location);
				
			}
			
			return;
			
		}
		
		GL.bindBuffer (GL.ARRAY_BUFFER, buffer.__glBuffer);
		
		var dimension = 4;
		var type = GL.FLOAT;
		var normalized:Bool = false;
		
		if (format == Context3DVertexBufferFormat.BYTES_4) {
			
			dimension = 4;
			type = GL.UNSIGNED_BYTE;
			normalized = true;
			
		} else if (format == Context3DVertexBufferFormat.FLOAT_1) {
			
			dimension = 1;
			type = GL.FLOAT;
			
		} else if (format == Context3DVertexBufferFormat.FLOAT_2) {
			
			dimension = 2;
			type = GL.FLOAT;
			
		} else if (format == Context3DVertexBufferFormat.FLOAT_3) {
			
			dimension = 3;
			type = GL.FLOAT;
			
		} else if (format == Context3DVertexBufferFormat.FLOAT_4) {
			
			dimension = 4;
			type = GL.FLOAT;
			
		} else {
			
			throw "Buffer format " + format + " is not supported";
			
		}
		
		GL.enableVertexAttribArray (location);
		GL.vertexAttribPointer (location, dimension, type, normalized, buffer.__data32PerVertex * 4, bufferOffset * 4);
		
	}
	
	
	private function __setTextureParameters (texture:TextureBase, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		if (!__anisotropySupportTested) {
			
			#if !js
			
			__supportsAnisotropy = (GL.getSupportedExtensions ().indexOf ("GL_EXT_texture_filter_anisotropic") != -1);
			
			if (__supportsAnisotropy) {
				
				// GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT is not currently recongnised in Lime
				// If supported, max anisotropic filtering of 256 is assumed.
				// maxSupportedAnisotropy = GL.getTexParameter (GL.TEXTURE_2D, MAX_TEXTURE_MAX_ANISOTROPY_EXT);
				GL.texParameteri (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, __maxSupportedAnisotropy);
				
			}
			
			#else
			
			var ext:Dynamic = GL.getExtension ("EXT_texture_filter_anisotropic");
			if (ext == null || Reflect.field( ext, "MAX_TEXTURE_MAX_ANISOTROPY_EXT" ) == null) ext = GL.getExtension ("MOZ_EXT_texture_filter_anisotropic");
			if (ext == null || Reflect.field( ext, "MAX_TEXTURE_MAX_ANISOTROPY_EXT" ) == null) ext = GL.getExtension ("WEBKIT_EXT_texture_filter_anisotropic");
			__supportsAnisotropy = (ext != null);
			
			if (__supportsAnisotropy) {
				
				__maxSupportedAnisotropy = GL.getParameter (ext.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
				GL.texParameteri (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, __maxSupportedAnisotropy);
				
			}
			
			#end
			
			__anisotropySupportTested = true;
			
		}
		
		if (Std.is (texture, Texture)) {
			
			switch (wrap) {
				
				case Context3DWrapMode.CLAMP:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				
				case Context3DWrapMode.CLAMP_U_REPEAT_V:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				
				case Context3DWrapMode.REPEAT:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				
				case Context3DWrapMode.REPEAT_U_CLAMP_V:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				
			}
			
			// Currently using TEXTURE_MAX_ANISOTROPY_EXT instead of GL.TEXTURE_MAX_ANISOTROPY_EXT
			// until it is implemented.
			
			switch (filter) {
				
				case Context3DTextureFilter.LINEAR:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.NEAREST:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC2X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 2) ? __maxSupportedAnisotropy : 2);
						
					}
				 
				case Context3DTextureFilter.ANISOTROPIC4X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 4) ? __maxSupportedAnisotropy : 4);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC8X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 8) ? __maxSupportedAnisotropy : 8);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC16X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 16) ? __maxSupportedAnisotropy : 16);
						
					}
				
			}
			
			switch (mipfilter) {
				
				case Context3DMipFilter.MIPLINEAR:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
				
				case Context3DMipFilter.MIPNEAREST:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST_MIPMAP_NEAREST);
				
				case Context3DMipFilter.MIPNONE:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, filter == Context3DTextureFilter.NEAREST ? GL.NEAREST : GL.LINEAR);
				
			} 
			
			var tex:Texture = cast texture;
			
			if (mipfilter != Context3DMipFilter.MIPNONE && !tex.__mipmapsGenerated) {
				
				GL.generateMipmap (GL.TEXTURE_2D);
				tex.__mipmapsGenerated = true;
				
			}
			
		} else if (Std.is (texture, RectangleTexture)) {
			
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
			
			switch (filter) {
				
				case Context3DTextureFilter.LINEAR:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.NEAREST:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC2X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 2) ? __maxSupportedAnisotropy : 2);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC4X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 4) ? __maxSupportedAnisotropy : 4);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC8X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 8) ? __maxSupportedAnisotropy : 8);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC16X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_2D, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 16) ? __maxSupportedAnisotropy : 16);
						
					}
				
			}
			
			GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, filter == Context3DTextureFilter.NEAREST ? GL.NEAREST : GL.LINEAR);
			
		} else if (Std.is (texture, CubeTexture)) {
			
			switch (wrap) {
				
				case Context3DWrapMode.CLAMP:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				
				case Context3DWrapMode.CLAMP_U_REPEAT_V:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				
				case Context3DWrapMode.REPEAT:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				
				case Context3DWrapMode.REPEAT_U_CLAMP_V:
					
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
					GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
				
			}
			
			switch (filter) {
				
				case Context3DTextureFilter.LINEAR:
					
					GL.texParameteri (GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.NEAREST:
					
					GL.texParameteri (GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, 1);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC2X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 2) ? __maxSupportedAnisotropy : 2);
						
					}
				 
				case Context3DTextureFilter.ANISOTROPIC4X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 4) ? __maxSupportedAnisotropy : 4);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC8X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 8) ? __maxSupportedAnisotropy : 8);
						
					}
				
				case Context3DTextureFilter.ANISOTROPIC16X:
					
					if (__supportsAnisotropy) {
						
						GL.texParameterf (GL.TEXTURE_CUBE_MAP, TEXTURE_MAX_ANISOTROPY_EXT, (__maxSupportedAnisotropy < 16) ? __maxSupportedAnisotropy : 16);
						
					}
				
			}
			
			switch (mipfilter) {
				
				case Context3DMipFilter.MIPLINEAR:
					
					GL.texParameteri (GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, GL.LINEAR_MIPMAP_LINEAR);
				
				case Context3DMipFilter.MIPNEAREST:
					
					GL.texParameteri (GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, GL.NEAREST_MIPMAP_NEAREST);
				
				case Context3DMipFilter.MIPNONE:
					
					GL.texParameteri (GL.TEXTURE_CUBE_MAP, GL.TEXTURE_MIN_FILTER, filter == Context3DTextureFilter.NEAREST ? GL.NEAREST : GL.LINEAR);
				
			}
			
			var cubetex:CubeTexture = cast texture;
			
			if (mipfilter != Context3DMipFilter.MIPNONE && !cubetex.__mipmapsGenerated) {
				
				GL.generateMipmap (GL.TEXTURE_CUBE_MAP);
				cubetex.__mipmapsGenerated = true;
				
			}
			
		} else {
			
			throw "Texture of type " + Type.getClassName (Type.getClass (texture)) + " not supported yet";
			
		}
		
	}
	
	
	private function __updateBackBufferViewPort ():Void {
		
		if (!__renderToTexture) {
			
			GL.viewport (Std.int (__scrollRect.x), Std.int (__scrollRect.y), Std.int (__scrollRect.width), Std.int (__scrollRect.height));
			
		}
		
	}
	
	
	private function __updateBlendStatus ():Void {
		
		//TODO do the same for other states ?
		
		if (__blendEnabled) {
			
			GL.enable (GL.BLEND);
			GL.blendEquation (GL.FUNC_ADD);
			GL.blendFunc (__getGLBlend (__blendSourceFactor), __getGLBlend (__blendDestinationFactor));
			
		} else {
			
			GL.disable (GL.BLEND);
			
		}
		
	}
	
	
	private function __updateDepthAndStencilState ():Void {
		
		// used to enable masking
		var depthAndStencil = __renderToTexture ? __rttDepthAndStencil : __backBufferDepthAndStencil;
		
		if (depthAndStencil) {
			
			// TODO check whether this is kept across frame
			if (Application.current.window.config.depthBuffer) {
				
				GL.enable (GL.DEPTH_TEST);
				
			}
			
			if (Application.current.window.config.stencilBuffer) {
				
				GL.enable (GL.STENCIL_TEST);
				
			}
			
		} else {
			
			GL.disable (GL.DEPTH_TEST);
			GL.disable (GL.STENCIL_TEST);
			
		}
		
	}
	
	
	private function __updateScissorRectangle ():Void {
		
		if (__scissorRectangle == null) {
			
			return;
			
		}
		
		//var width:Int = renderToTexture ? rttWidth : scrollRect.width;
		var height:Int = __renderToTexture ? __rttHeight : Std.int (__scrollRect.height);
		
		GL.scissor (Std.int (__scissorRectangle.x),
			Std.int (height - Std.int (__scissorRectangle.y) - Std.int (__scissorRectangle.height)),
			Std.int (__scissorRectangle.width),
			Std.int (__scissorRectangle.height)
		);
		
	}
	
	
}


@:noCompletion @:dox(hide) private class SamplerState {
	
	
	public var wrap:Context3DWrapMode;
	public var filter:Context3DTextureFilter;
	public var mipfilter:Context3DMipFilter;
	
	
	public function new ():Void {
		
		
		
	}
	
	
}