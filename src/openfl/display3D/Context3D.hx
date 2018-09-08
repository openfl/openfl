package openfl.display3D; #if !flash


import haxe.io.Bytes;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.math.Rectangle as LimeRectangle;
import lime.math.Vector2;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl._internal.renderer.Context3DState;
import openfl._internal.renderer.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.VideoTexture;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.Context3DState)
@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Bitmap)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)


@:final class Context3D extends EventDispatcher {
	
	
	public static var supportsVideoTexture (default, null):Bool = #if (js && html5) true #else false #end;
	
	@:noCompletion private static var GL_DEPTH_STENCIL:Int = -1;
	@:noCompletion private static var GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT:Int = -1;
	@:noCompletion private static var GL_MAX_VIEWPORT_DIMS:Int = -1;
	@:noCompletion private static var GL_TEXTURE_MAX_ANISOTROPY_EXT:Int = -1;
	
	@:noCompletion private static var __driverInfo:String;
	
	public var backBufferHeight (default, null):Int = 0;
	public var backBufferWidth (default, null):Int = 0;
	public var driverInfo (default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking (get, set):Bool;
	public var maxBackBufferHeight (default, null):Int;
	public var maxBackBufferWidth (default, null):Int;
	public var profile (default, null):Context3DProfile = STANDARD;
	public var totalGPUMemory (default, null):Int = 0;
	
	@:noCompletion private var gl:WebGLRenderContext;
	
	@:noCompletion private var __backBufferAntiAlias:Int;
	@:noCompletion private var __backBufferTexture:RectangleTexture;
	@:noCompletion private var __backBufferWantsBestResolution:Bool;
	@:noCompletion private var __backBufferWantsBestResolutionOnBrowserZoom:Bool;
	@:noCompletion private var __context:RenderContext;
	@:noCompletion private var __contextState:Context3DState;
	@:noCompletion private var __renderStage3DProgram:Program3D;
	@:noCompletion private var __enableErrorChecking:Bool;
	@:noCompletion private var __fragmentConstants:Float32Array;
	@:noCompletion private var __frontBufferTexture:RectangleTexture;
	@:noCompletion private var __positionScale:Float32Array; // TODO: Better approach?
	@:noCompletion private var __present:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __stage3D:Stage3D;
	@:noCompletion private var __state:Context3DState;
	@:noCompletion private var __vertexConstants:Float32Array;
	
	
	@:noCompletion private function new (stage:Stage, contextState:Context3DState = null, stage3D:Stage3D = null) {
		
		super ();
		
		__stage = stage;
		__contextState = contextState;
		__stage3D = stage3D;
		
		__context = stage.window.context;
		gl = __context.webgl;
		
		if (__contextState == null) __contextState = new Context3DState ();
		__state = new Context3DState ();
		
		__vertexConstants = new Float32Array (4 * 128);
		__fragmentConstants = new Float32Array (4 * 128);
		__positionScale = new Float32Array ([ 1.0, 1.0, 1.0, 1.0 ]);
		
		if (GL_MAX_VIEWPORT_DIMS == -1) {
			
			#if (js && html5)
			GL_MAX_VIEWPORT_DIMS = gl.getParameter (gl.MAX_VIEWPORT_DIMS);
			#else
			GL_MAX_VIEWPORT_DIMS = 16384;
			#end
			
		}
		
		maxBackBufferWidth = GL_MAX_VIEWPORT_DIMS;
		maxBackBufferHeight = GL_MAX_VIEWPORT_DIMS;
		
		if (GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT == -1) {
			
			var extension:Dynamic = gl.getExtension ("EXT_texture_filter_anisotropic");
			
			#if (js && html5)
			if (extension == null || !Reflect.hasField (extension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
				extension = gl.getExtension ("MOZ_EXT_texture_filter_anisotropic");
			if (extension == null || !Reflect.hasField (extension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
				extension = gl.getExtension ("WEBKIT_EXT_texture_filter_anisotropic");
			#end
			
			if (extension != null) {
				
				GL_TEXTURE_MAX_ANISOTROPY_EXT = extension.TEXTURE_MAX_ANISOTROPY_EXT;
				GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = gl.getParameter (extension.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
				
			} else {
				
				GL_TEXTURE_MAX_ANISOTROPY_EXT = 0;
				GL_MAX_TEXTURE_MAX_ANISOTROPY_EXT = 0;
				
			}
			
		}
		
		if (GL_DEPTH_STENCIL == -1) {
			
			#if (js && html5)
			GL_DEPTH_STENCIL = gl.DEPTH_STENCIL;
			#else
			if (__context.type == OPENGLES && Std.parseFloat (__context.version) >= 3) {
				GL_DEPTH_STENCIL = __context.gles3.DEPTH24_STENCIL8;
			} else {
				var extension = gl.getExtension ("OES_packed_depth_stencil");
				if (extension != null) {
					GL_DEPTH_STENCIL = extension.DEPTH24_STENCIL8_OES;
				} else {
					extension = gl.getExtension ("EXT_packed_depth_stencil");
					if (extension != null) {
						GL_DEPTH_STENCIL = extension.DEPTH24_STENCIL8_EXT;
					} else {
						GL_DEPTH_STENCIL = 0;
					}
				}
			}
			#end
			
		}
		
		if (__driverInfo == null) {
			
			var vendor = gl.getParameter (gl.VENDOR);
			var version = gl.getParameter (gl.VERSION);
			var renderer = gl.getParameter (gl.RENDERER);
			var glslVersion = gl.getParameter (gl.SHADING_LANGUAGE_VERSION);
			
			__driverInfo = "OpenGL Vendor=" + vendor + " Version=" + version + " Renderer=" + renderer + " GLSL=" + glslVersion;
			
		}
		
		driverInfo = __driverInfo;
		
	}
	
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = Context3DClearMask.ALL):Void {
		
		__flushGLFramebuffer ();
		__flushGLViewport ();
		
		var clearMask = 0;
		
		if (mask & Context3DClearMask.COLOR != 0) {
			
			if (__state.renderToTexture == null) {
				
				if (__stage.context3D == this && !__stage.__renderer.__cleared) __stage.__renderer.__cleared = true;
				
			}
			
			clearMask |= gl.COLOR_BUFFER_BIT;
			gl.clearColor (red, green, blue, alpha);
			gl.colorMask (true, true, true, true);
			__contextState.colorMaskRed = true;
			__contextState.colorMaskGreen = true;
			__contextState.colorMaskBlue = true;
			__contextState.colorMaskAlpha = true;
			
		}
		
		if (mask & Context3DClearMask.DEPTH != 0) {
			
			clearMask |= gl.DEPTH_BUFFER_BIT;
			gl.depthMask (true);
			gl.clearDepth (depth);
			__contextState.depthMask = true;
			
		}
		
		if (mask & Context3DClearMask.STENCIL != 0) {
			
			clearMask |= gl.STENCIL_BUFFER_BIT;
			gl.clearStencil (stencil);
			
		}
		
		if (clearMask == 0) return;
		
		__setGLScissorTest (false);
		gl.clear (clearMask);
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		if (__stage3D == null) {
			
			backBufferWidth = width;
			backBufferHeight = height;
			
			__backBufferAntiAlias = antiAlias;
			__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
			
		} else {
			
			if (__backBufferTexture == null || backBufferWidth != width || backBufferHeight != height) {
				
				__backBufferTexture = createRectangleTexture (width, height, BGRA, true);
				__frontBufferTexture = createRectangleTexture (width, height, BGRA, true);
				
				if (__stage3D.__vertexBuffer == null) {
					__stage3D.__vertexBuffer = createVertexBuffer (4, 5);
				}
				
				var vertexData = new Vector<Float> ([
					width, height, 0, 1, 1,
					0, height, 0, 0, 1,
					width, 0, 0, 1, 0,
					0, 0, 0, 0, 0.0
				]);
				
				__stage3D.__vertexBuffer.uploadFromVector (vertexData, 0, 20);
				
				if (__stage3D.__indexBuffer == null) {
					
					__stage3D.__indexBuffer = createIndexBuffer (6);
					
					var indexData = new Vector<UInt> ([
						0, 1, 2,
						2, 1, 3
					]);
					
					__stage3D.__indexBuffer.uploadFromVector (indexData, 0, 6);
					
				}
				
			}
			
			backBufferWidth = width;
			backBufferHeight = height;
			
			__backBufferAntiAlias = antiAlias;
			__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
			__state.__primaryGLFramebuffer = __backBufferTexture.__getGLFramebuffer (enableDepthAndStencil, antiAlias, 0);
			__frontBufferTexture.__getGLFramebuffer (enableDepthAndStencil, antiAlias, 0);
			
		}
		
	}
	
	
	public function createCubeTexture (size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture {
		
		return new CubeTexture (this, size, format, optimizeForRenderToTexture, streamingLevels);
		
	}
	
	
	public function createIndexBuffer (numIndices:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):IndexBuffer3D {
		
		return new IndexBuffer3D (this, numIndices, bufferUsage);
		
	}
	
	
	public function createProgram (format:Context3DProgramFormat = AGAL):Program3D {
		
		return new Program3D (this, format);
		
	}
	
	
	public function createRectangleTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture {
		
		return new RectangleTexture (this, width, height, format, optimizeForRenderToTexture);
		
	}
	
	
	public function createTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture {
		
		return new Texture (this, width, height, format, optimizeForRenderToTexture, streamingLevels);
		
	}
	
	
	public function createVertexBuffer (numVertices:Int, data32PerVertex:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):VertexBuffer3D {
		
		return new VertexBuffer3D (this, numVertices, data32PerVertex, bufferUsage);
		
	}
	
	
	public function createVideoTexture ():VideoTexture {
		
		#if (js && html5)
		return new VideoTexture (this);
		#else
		throw new Error ("Video textures are not supported on this platform");
		return null;
		#end
		
	}
	
	
	public function dispose (recreate:Bool = true):Void {
		
		// GLContext3D.dispose (this, recreate);
		
	}
	
	
	public function drawToBitmapData (destination:BitmapData, srcRect:Rectangle = null, destPoint:Point = null):Void {
		
		if (destination == null) return;
		
		var sourceRect = srcRect != null ? srcRect.__toLimeRectangle () : new LimeRectangle (0, 0, backBufferWidth, backBufferHeight);
		var destVector = destPoint != null ? destPoint.__toLimeVector2 () : new Vector2 ();
		
		if (__stage.context3D == this) {
			
			if (__stage.window != null) {
				
				if (__stage3D != null) {
					destVector.setTo (Std.int (-__stage3D.x), Std.int (-__stage3D.y));
				}
				
				var image = __stage.window.readPixels ();
				destination.image.copyPixels (image, sourceRect, destVector);
				
			}
			
		} else if (__backBufferTexture != null) {
			
			var cacheRenderToTexture = __state.renderToTexture;
			setRenderToBackBuffer ();
			
			__flushGLFramebuffer ();
			__flushGLViewport ();
			
			// TODO: Read less pixels if srcRect is smaller
			
			var data = new UInt8Array (backBufferWidth * backBufferHeight * 4);
			gl.readPixels (0, 0, backBufferWidth, backBufferHeight, __backBufferTexture.__format, gl.UNSIGNED_BYTE, data);
			
			var image = new Image (new ImageBuffer (data, backBufferWidth, backBufferHeight, 32, BGRA32));
			destination.image.copyPixels (image, sourceRect, destVector);
			
			if (cacheRenderToTexture != null) {
				setRenderToTexture (cacheRenderToTexture, __state.renderToTextureDepthStencil, __state.renderToTextureAntiAlias, __state.renderToTextureSurfaceSelector);
			}
			
		}
		
	}
	
	
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		#if !openfl_disable_display_render
		if (__state.renderToTexture == null) {
			
			// TODO: Make sure state is correct for this?
			if (__stage.context3D == this && !__stage.__renderer.__cleared) __stage.__renderer.__clear ();
			
		}
		
		__flushGL ();
		
		#end
		
		if (__state.program != null && __state.program.__format == AGAL) {
			__state.program.__flush ();
		}
		
		var count = (numTriangles == -1) ? indexBuffer.__numIndices : (numTriangles * 3);
		
		__bindGLElementArrayBuffer (indexBuffer.__id);
		gl.drawElements (gl.TRIANGLES, count, indexBuffer.__elementType, firstIndex);
		
	}
	
	
	
	public function present ():Void {
		
		setRenderToBackBuffer ();
		
		if (__stage3D != null) {
			
			var cacheBuffer = __backBufferTexture;
			__backBufferTexture = __frontBufferTexture;
			__frontBufferTexture = cacheBuffer;
			
			__state.__primaryGLFramebuffer = __backBufferTexture.__getGLFramebuffer (__state.backBufferEnableDepthAndStencil, __backBufferAntiAlias, 0);
			
		}
		
		__present = true;
		
	}
	
	
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		__state.blendSourceFactor = sourceFactor;
		__state.blendDestinationFactor = destinationFactor;
		
		// TODO: Better way to handle this?
		__setGLBlendEquation (gl.FUNC_ADD);
		
	}
	
	
	public function setColorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		__state.colorMaskRed = red;
		__state.colorMaskGreen = green;
		__state.colorMaskBlue = blue;
		__state.colorMaskAlpha = alpha;
		
	}
	
	
	public function setCulling (triangleFaceToCull:Context3DTriangleFace):Void {
		
		__state.culling = triangleFaceToCull;
		
	}
	
	
	public function setDepthTest (depthMask:Bool, passCompareMode:Context3DCompareMode):Void {
		
		__state.depthMask = depthMask;
		__state.depthCompareMode = passCompareMode;
		
	}
	
	
	public function setProgram (program:Program3D):Void {
		
		__state.program = program;
		
		for (i in 0...program.__samplerStates.length) {
			if (__state.samplerStates[i] == null) {
				__state.samplerStates[i] = program.__samplerStates[i].clone ();
			} else {
				__state.samplerStates[i].copyFrom (program.__samplerStates[i]);
			}
		}
		
	}
	
	
	public function setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void {
		
		if (numRegisters == 0 || __state.program == null) return;
		
		if (__state.program != null && __state.program.__format == GLSL) {
			
			// TODO
			
		} else {
			
			// TODO: Cleanup?
			
			if (numRegisters == -1) {
				
				numRegisters = ((data.length >> 2) - byteArrayOffset);
				
			}
			
			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;
			
			var floatData = Float32Array.fromBytes (data, 0, data.length);
			var outOffset = firstRegister * 4;
			var inOffset = Std.int (byteArrayOffset / 4);
			
			for (i in 0...(numRegisters * 4)) {
				
				dest[outOffset + i] = floatData[inOffset + i];
				
			}
			
			if (__state.program != null) {
				
				__state.program.__markDirty (isVertex, firstRegister, numRegisters);
				
			}
			
		}
		
		
		
	}
	
	
	public function setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		if (__state.program != null && __state.program.__format == GLSL) {
			
			__flushGLProgram ();
			
			// TODO: Cache value, prevent need to copy
			var data = new Float32Array (16);
			for (i in 0...16) {
				data[i] = matrix.rawData[i];
			}
			
			gl.uniformMatrix4fv (cast firstRegister, transposedMatrix, data);
			
		} else {
			
			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;
			var source = matrix.rawData;
			var i = firstRegister * 4;
			
			if (transposedMatrix) {
				
				dest[i++] = source[0];
				dest[i++] = source[4];
				dest[i++] = source[8];
				dest[i++] = source[12];
				
				dest[i++] = source[1];
				dest[i++] = source[5];
				dest[i++] = source[9];
				dest[i++] = source[13];
				
				dest[i++] = source[2];
				dest[i++] = source[6];
				dest[i++] = source[10];
				dest[i++] = source[14];
				
				dest[i++] = source[3];
				dest[i++] = source[7];
				dest[i++] = source[11];
				dest[i++] = source[15];
				
			} else {
				
				dest[i++] = source[0];
				dest[i++] = source[1];
				dest[i++] = source[2];
				dest[i++] = source[3];
				
				dest[i++] = source[4];
				dest[i++] = source[5];
				dest[i++] = source[6];
				dest[i++] = source[7];
				
				dest[i++] = source[8];
				dest[i++] = source[9];
				dest[i++] = source[10];
				dest[i++] = source[11];
				
				dest[i++] = source[12];
				dest[i++] = source[13];
				dest[i++] = source[14];
				dest[i++] = source[15];
				
			}
			
			if (__state.program != null) {
				
				__state.program.__markDirty (isVertex, firstRegister, 4);
				
			}
			
		}
		
	}
	
	
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void {
		
		if (numRegisters == 0) return;
		
		if (__state.program != null && __state.program.__format == GLSL) {
			
			
			
		} else {
			
			if (numRegisters == -1) {
				
				numRegisters = (data.length >> 2);
				
			}
			
			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;
			var source = data;
			
			var sourceIndex = 0;
			var destIndex = firstRegister * 4;
			
			for (i in 0...numRegisters) {
				
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				
			}
			
			if (__state.program != null) {
				
				__state.program.__markDirty (isVertex, firstRegister, numRegisters);
				
			}
			
		}
		
	}
	
	
	public function setRenderToBackBuffer ():Void {
		
		__state.renderToTexture = null;
		
	}
	
	
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void {
		
		__state.renderToTexture = texture;
		__state.renderToTextureDepthStencil = enableDepthAndStencil;
		__state.renderToTextureAntiAlias = antiAlias;
		__state.renderToTextureSurfaceSelector = surfaceSelector;
		
	}
	
	
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {
			
		// 	throw new Error ("sampler out of range");
			
		// }
		
		if (__state.samplerStates[sampler] == null) {
			__state.samplerStates[sampler] = new SamplerState ();
		}
		
		var state = __state.samplerStates[sampler];
		state.wrap = wrap;
		state.filter = filter;
		state.mipfilter = mipfilter;
		
	}
	
	
	public function setScissorRectangle (rectangle:Rectangle):Void {
		
		if (rectangle != null) {
			__state.scissorRectangle.copyFrom (rectangle);
		} else {
			__state.scissorRectangle.setEmpty ();
		}
		
	}
	
	
	public function setStencilActions (triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		__state.stencilTriangleFace = triangleFace;
		__state.stencilCompareMode = compareMode;
		__state.stencilPass = actionOnBothPass;
		__state.stencilDepthFail = actionOnDepthFail;
		__state.stencilFail = actionOnDepthPassStencilFail;
		
	}
	
	
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		__state.stencilReferenceValue = referenceValue;
		__state.stencilReadMask = readMask;
		__state.stencilWriteMask = writeMask;
		
	}
	
	
	public function setTextureAt (sampler:Int, texture:TextureBase):Void {
		
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {
			
		// 	throw new Error ("sampler out of range");
			
		// }
		
		__state.textures[sampler] = texture;
		
	}
	
	
	public function setVertexBufferAt (index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void {
		
		if (buffer == null) {
			
			gl.disableVertexAttribArray (index);
			__bindGLArrayBuffer (null);
			return;
			
		}
		
		__bindGLArrayBuffer (buffer.__id);
		gl.enableVertexAttribArray (index);
		
		var byteOffset = bufferOffset * 4;
		
		switch (format) {
			
			case BYTES_4:
				
				gl.vertexAttribPointer (index, 4, gl.UNSIGNED_BYTE, true, buffer.__stride, byteOffset);
				
			case FLOAT_4:
				
				gl.vertexAttribPointer (index, 4, gl.FLOAT, false, buffer.__stride, byteOffset);
			
			case FLOAT_3:
				
				gl.vertexAttribPointer (index, 3, gl.FLOAT, false, buffer.__stride, byteOffset);
			
			case FLOAT_2:
				
				gl.vertexAttribPointer (index, 2, gl.FLOAT, false, buffer.__stride, byteOffset);
			
			case FLOAT_1:
				
				gl.vertexAttribPointer (index, 1, gl.FLOAT, false, buffer.__stride, byteOffset);
			
			default:
				
				throw new IllegalOperationError ();
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLArrayBuffer (buffer:GLBuffer):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLArrayBuffer != buffer #end) {
			
			gl.bindBuffer (gl.ARRAY_BUFFER, buffer);
			__contextState.__currentGLArrayBuffer = buffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLElementArrayBuffer (buffer:GLBuffer):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLElementArrayBuffer != buffer #end) {
			
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, buffer);
			__contextState.__currentGLElementArrayBuffer = buffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLFramebuffer (framebuffer:GLFramebuffer):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLFramebuffer != framebuffer #end) {
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, framebuffer);
			__contextState.__currentGLFramebuffer = framebuffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLTexture2D (texture:GLTexture):Void {
		
		// TODO: Need to consider activeTexture ID
		
		// if (#if openfl_disable_context_cache true #else __contextState.__currentGLTexture2D != texture #end) {
			
			gl.bindTexture (gl.TEXTURE_2D, texture);
			__contextState.__currentGLTexture2D = texture;
			
		// }
		
	}
	
	
	@:noCompletion private function __bindGLTextureCubeMap (texture:GLTexture):Void {
		
		// TODO: Need to consider activeTexture ID
		
		// if (#if openfl_disable_context_cache true #else __contextState.__currentGLTextureCubeMap != texture #end) {
			
			gl.bindTexture (gl.TEXTURE_CUBE_MAP, texture);
			__contextState.__currentGLTextureCubeMap = texture;
			
		// }
		
	}
	
	
	@:noCompletion private function __flushGL ():Void {
		
		__flushGLProgram ();
		__flushGLFramebuffer ();
		__flushGLViewport ();
		
		__flushGLBlend ();
		__flushGLColor ();
		__flushGLCulling ();
		__flushGLDepth ();
		__flushGLScissor ();
		__flushGLStencil ();
		__flushGLTextures ();
		
	}
	
	
	@:noCompletion private function __flushGLBlend ():Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.blendDestinationFactor != __state.blendDestinationFactor || __contextState.blendSourceFactor != __state.blendSourceFactor #end) {
			
			var src = gl.ONE;
			var dest = gl.ZERO;
			
			switch (__state.blendSourceFactor) {
				case DESTINATION_ALPHA: src = gl.DST_ALPHA;
				case DESTINATION_COLOR: src = gl.DST_COLOR;
				case ONE: src = gl.ONE;
				case ONE_MINUS_DESTINATION_ALPHA: src = gl.ONE_MINUS_DST_ALPHA;
				case ONE_MINUS_DESTINATION_COLOR: src = gl.ONE_MINUS_DST_COLOR;
				case ONE_MINUS_SOURCE_ALPHA: src = gl.ONE_MINUS_SRC_ALPHA;
				case ONE_MINUS_SOURCE_COLOR: src = gl.ONE_MINUS_SRC_COLOR;
				case SOURCE_ALPHA: src = gl.SRC_ALPHA;
				case SOURCE_COLOR: src = gl.SRC_COLOR;
				case ZERO: src = gl.ZERO;
				default: throw new IllegalOperationError ();
			}
			
			switch (__state.blendDestinationFactor) {
				case DESTINATION_ALPHA: dest = gl.DST_ALPHA;
				case DESTINATION_COLOR: dest = gl.DST_COLOR;
				case ONE: dest = gl.ONE;
				case ONE_MINUS_DESTINATION_ALPHA: dest = gl.ONE_MINUS_DST_ALPHA;
				case ONE_MINUS_DESTINATION_COLOR: dest = gl.ONE_MINUS_DST_COLOR;
				case ONE_MINUS_SOURCE_ALPHA: dest = gl.ONE_MINUS_SRC_ALPHA;
				case ONE_MINUS_SOURCE_COLOR: dest = gl.ONE_MINUS_SRC_COLOR;
				case SOURCE_ALPHA: dest = gl.SRC_ALPHA;
				case SOURCE_COLOR: dest = gl.SRC_COLOR;
				case ZERO: dest = gl.ZERO;
				default: throw new IllegalOperationError ();
			}
			
			__setGLBlend (true);
			gl.blendFunc (src, dest);
			__contextState.blendDestinationFactor = __state.blendDestinationFactor;
			__contextState.blendSourceFactor = __state.blendSourceFactor;
			
		}
		
	}
	
	
	@:noCompletion private inline function __flushGLColor ():Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.colorMaskRed != __state.colorMaskRed || __contextState.colorMaskGreen != __state.colorMaskGreen || __contextState.colorMaskBlue != __state.colorMaskBlue || __contextState.colorMaskAlpha != __state.colorMaskAlpha #end) {
			
			gl.colorMask (__state.colorMaskRed, __state.colorMaskGreen, __state.colorMaskBlue, __state.colorMaskAlpha);
			__contextState.colorMaskRed = __state.colorMaskRed;
			__contextState.colorMaskGreen = __state.colorMaskGreen;
			__contextState.colorMaskBlue = __state.colorMaskBlue;
			__contextState.colorMaskAlpha = __state.colorMaskAlpha;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLCulling ():Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.culling != __state.culling #end) {
			
			if (__state.culling == NONE) {
				
				__setGLCullFace (false);
				
			} else {
				
				__setGLCullFace (true);
				
				switch (__state.culling) {
					
					case NONE: // skip
					case BACK: gl.cullFace (gl.BACK);
					case FRONT: gl.cullFace (gl.FRONT);
					case FRONT_AND_BACK: gl.cullFace (gl.FRONT_AND_BACK);
					default: throw new IllegalOperationError ();
					
				}
				
			}
			
			__contextState.culling = __state.culling;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLDepth ():Void {
		
		var depthMask = (__state.depthMask && (__state.renderToTexture != null ? __state.renderToTextureDepthStencil : __state.backBufferEnableDepthAndStencil));
		
		if (#if openfl_disable_context_cache true #else __contextState.depthMask != depthMask #end) {
			
			gl.depthMask (depthMask);
			__contextState.depthMask = depthMask;
			
		}
		
		if (#if openfl_disable_context_cache true #else __contextState.depthCompareMode != __state.depthCompareMode #end) {
			
			switch (__state.depthCompareMode) {
				case ALWAYS: gl.depthFunc (gl.ALWAYS);
				case EQUAL: gl.depthFunc (gl.EQUAL);
				case GREATER: gl.depthFunc (gl.GREATER);
				case GREATER_EQUAL: gl.depthFunc (gl.GEQUAL);
				case LESS: gl.depthFunc (gl.LESS);
				case LESS_EQUAL: gl.depthFunc (gl.LEQUAL);
				case NEVER: gl.depthFunc (gl.NEVER);
				case NOT_EQUAL: gl.depthFunc (gl.NOTEQUAL);
				default: throw new IllegalOperationError ();
			}
			
			__contextState.depthCompareMode = __state.depthCompareMode;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLFramebuffer ():Void {
		
		if (__state.renderToTexture != null) {
			
			if (#if openfl_disable_context_cache true #else __contextState.renderToTexture != __state.renderToTexture || __contextState.renderToTextureSurfaceSelector != __state.renderToTextureSurfaceSelector #end) {
				
				var framebuffer = __state.renderToTexture.__getGLFramebuffer (__state.renderToTextureDepthStencil, __state.renderToTextureAntiAlias, __state.renderToTextureSurfaceSelector);
				__bindGLFramebuffer (framebuffer);
				
				__contextState.renderToTexture = __state.renderToTexture;
				__contextState.renderToTextureAntiAlias = __state.renderToTextureAntiAlias;
				__contextState.renderToTextureDepthStencil = __state.renderToTextureDepthStencil;
				__contextState.renderToTextureSurfaceSelector = __state.renderToTextureSurfaceSelector;
				
			}
			
			__setGLDepthTest (__state.renderToTextureDepthStencil);
			__setGLStencilTest (__state.renderToTextureDepthStencil);
			
			__setGLFrontFace (true);
			
		} else {
			
			if (backBufferWidth == 0 && backBufferHeight == 0) {
				
				throw new Error ("Context3D backbuffer has not been configured");
				
			}
			
			if (#if openfl_disable_context_cache true #else __contextState.renderToTexture != null || __contextState.__currentGLFramebuffer != __state.__primaryGLFramebuffer || __contextState.backBufferEnableDepthAndStencil != __state.backBufferEnableDepthAndStencil #end) {
				
				__bindGLFramebuffer (__state.__primaryGLFramebuffer);
				
				__contextState.renderToTexture = null;
				__contextState.backBufferEnableDepthAndStencil = __state.backBufferEnableDepthAndStencil;
				
			}
			
			__setGLDepthTest (__state.backBufferEnableDepthAndStencil);
			__setGLStencilTest (__state.backBufferEnableDepthAndStencil);
			
			__setGLFrontFace (__stage.context3D != this);
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLProgram ():Void {
		
		var program = __state.program;
		
		if (#if openfl_disable_context_cache true #else __contextState.program != program #end) {
			
			if (program != null && program.__format == AGAL) {
				
				program.__use ();
				
			} else {
				
				gl.useProgram (program.__programID);
				
			}
			
			__contextState.program = program;
			
		}
		
		if (program != null && program.__format == AGAL) {
			__positionScale[1] = (__stage.context3D == this && __state.renderToTexture == null) ? 1.0 : -1.0;
			program.__setPositionScale (__positionScale);
		}
		
	}
	
	
	@:noCompletion private function __flushGLScissor ():Void {
		
		if (#if openfl_disable_context_cache true #else !__contextState.scissorRectangle.equals (__state.scissorRectangle) #end) {
			
			if (__state.scissorRectangle.width <= 0 || __state.scissorRectangle.height <= 0) {
				
				__setGLScissorTest (false);
				
			} else {
				
				__setGLScissorTest (true);
				
				var height = 0;
				var offsetX = 0;
				var offsetY = 0;
				
				if (__state.renderToTexture != null) {
				
					// TODO: Avoid use of Std.is
					if (Std.is (__state.renderToTexture, Texture)) {
					
						var texture2D:Texture = cast __state.renderToTexture;
						height = texture2D.__height;
					
					} else if (Std.is (__state.renderToTexture, RectangleTexture)) {
						
						var rectTexture:RectangleTexture = cast __state.renderToTexture;
						height = rectTexture.__height;
						
					}
					
				} else {
					
					height = backBufferHeight;
					
					if (__stage.context3D == this) {
						
						offsetX = __stage3D != null ? Std.int (__stage3D.x) : 0;
						offsetY = Std.int (__stage.window.height * __stage.window.scale) - height - (__stage3D != null ? Std.int (__stage3D.y) : 0);
						
					}
					
				}
				
				gl.scissor (Std.int (__state.scissorRectangle.x) + offsetX, height - Std.int (__state.scissorRectangle.y) - Std.int (__state.scissorRectangle.height) + offsetY, Std.int (__state.scissorRectangle.width), Std.int (__state.scissorRectangle.height));
				
			}
			
			__contextState.scissorRectangle.copyFrom (__state.scissorRectangle);
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLStencil ():Void {
		
		function getGLCompareMode (mode:Context3DCompareMode):Int {
			return switch (mode) {
				case ALWAYS: gl.ALWAYS;
				case EQUAL: gl.EQUAL;
				case GREATER: gl.GREATER;
				case GREATER_EQUAL: gl.GEQUAL;
				case LESS: gl.LESS;
				case LESS_EQUAL: gl.LEQUAL; // TODO : wrong value
				case NEVER: gl.NEVER;
				case NOT_EQUAL: gl.NOTEQUAL;
				default: gl.EQUAL;
			}
		}
		
		function getGLTriangleFace (face:Context3DTriangleFace):Int {
			return switch (face) {
				case FRONT: gl.FRONT;
				case BACK: gl.BACK;
				case FRONT_AND_BACK: gl.FRONT_AND_BACK;
				case NONE: gl.NONE;
				default: gl.FRONT_AND_BACK;
			}
		}
		
		function getGLStencilAction (action:Context3DStencilAction):Int {
			return switch (action) {
				case DECREMENT_SATURATE: gl.DECR;
				case DECREMENT_WRAP: gl.DECR_WRAP;
				case INCREMENT_SATURATE: gl.INCR;
				case INCREMENT_WRAP: gl.INCR_WRAP;
				case INVERT: gl.INVERT;
				case KEEP: gl.KEEP;
				case SET: gl.REPLACE;
				case ZERO: gl.ZERO;
				default: gl.KEEP;
			}
		}
		
		if (#if openfl_disable_context_cache true #else __contextState.stencilTriangleFace != __state.stencilTriangleFace || __contextState.stencilPass != __state.stencilPass || __contextState.stencilDepthFail != __state.stencilDepthFail || __contextState.stencilFail != __state.stencilFail #end) {
			
			gl.stencilOpSeparate (getGLTriangleFace (__state.stencilTriangleFace), getGLStencilAction (__state.stencilFail), getGLStencilAction (__state.stencilDepthFail), getGLStencilAction (__state.stencilPass));
			__contextState.stencilTriangleFace = __state.stencilTriangleFace;
			__contextState.stencilPass = __state.stencilPass;
			__contextState.stencilDepthFail = __state.stencilDepthFail;
			__contextState.stencilFail = __state.stencilFail;
			
		}
		
		if (#if openfl_disable_context_cache true #else __contextState.stencilWriteMask != __state.stencilWriteMask #end) {
			
			gl.stencilMask (__state.stencilWriteMask);
			__contextState.stencilWriteMask = __state.stencilWriteMask;
			
		}
		
		if (#if openfl_disable_context_cache true #else __contextState.stencilCompareMode != __state.stencilCompareMode || __contextState.stencilReferenceValue != __state.stencilReferenceValue || __contextState.stencilReadMask != __state.stencilReadMask #end) {
			
			gl.stencilFunc (getGLCompareMode (__state.stencilCompareMode), __state.stencilReferenceValue, __state.stencilReadMask);
			__contextState.stencilCompareMode = __state.stencilCompareMode;
			__contextState.stencilReferenceValue = __state.stencilReferenceValue;
			__contextState.stencilReadMask = __state.stencilReadMask;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLTextures ():Void {
		
		var sampler = 0;
		var texture, samplerState;
		
		for (i in 0...__state.textures.length) {
			
			texture = __state.textures[i];
			samplerState = __state.samplerStates[i];
			if (samplerState == null) {
				__state.samplerStates[i] = new SamplerState ();
				samplerState = __state.samplerStates[i];
			}
			
			gl.activeTexture (gl.TEXTURE0 + sampler);
			
			if (texture != null) {
				
				// if (#if openfl_disable_context_cache true #else texture != __contextState.textures[i] #end) {
					
					// TODO: Cleaner approach?
					if (texture.__textureTarget == gl.TEXTURE_2D) {
						__bindGLTexture2D (texture.__textureID);
					} else {
						__bindGLTextureCubeMap (texture.__textureID);
					}
					
					#if desktop
					// TODO: Cache?
					gl.enable (gl.TEXTURE_2D);
					#end
					
					__contextState.textures[i] = texture;
					
				// }
				
				texture.__setSamplerState (samplerState);
				
			} else {
				
				__bindGLTexture2D (null);
				
			}
			
			if (__state.program != null && samplerState.textureAlpha) {
				
				gl.activeTexture (gl.TEXTURE0 + sampler + 4);
				
				if (texture != null && texture.__alphaTexture != null) {
					
					if (texture.__alphaTexture.__textureTarget == gl.TEXTURE_2D) {
						__bindGLTexture2D (texture.__alphaTexture.__getTexture ());
					} else {
						__bindGLTextureCubeMap (texture.__alphaTexture.__getTexture ());
					}
					
					texture.__alphaTexture.__setSamplerState (samplerState);
					gl.uniform1i (__state.program.__alphaSamplerEnabled[sampler].location, 1);
					
					#if desktop
					// TODO: Cache?
					gl.enable (gl.TEXTURE_2D);
					#end
					
				} else {
					
					__bindGLTexture2D (null);
					gl.uniform1i (__state.program.__alphaSamplerEnabled[sampler].location, 0);
					
				}
				
			}
			
			sampler++;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLViewport ():Void {
		
		if (__state.renderToTexture == null) {
			
			if (__stage.context3D == this) {
				
				var x = __stage3D == null ? 0 : Std.int (__stage3D.x);
				var y = Std.int ((__stage.window.height * __stage.window.scale) - backBufferHeight - (__stage3D == null ? 0 : __stage3D.y));
				gl.viewport (x, y, backBufferWidth, backBufferHeight);
				
			} else {
				
				gl.viewport (0, 0, backBufferWidth, backBufferHeight);
				
			}
			
		} else {
			
			var width = 0, height = 0;
			
			// TODO: Avoid use of Std.is
			if (Std.is (__state.renderToTexture, Texture)) {
				
				var texture2D:Texture = cast __state.renderToTexture;
				width = texture2D.__width;
				height = texture2D.__height;
				
			} else if (Std.is (__state.renderToTexture, RectangleTexture)) {
				
				var rectTexture:RectangleTexture = cast __state.renderToTexture;
				width = rectTexture.__width;
				height = rectTexture.__height;
				
			} else if (Std.is (__state.renderToTexture, CubeTexture)) {
				
				var cubeTexture:CubeTexture = cast __state.renderToTexture;
				width = cubeTexture.__size;
				height = cubeTexture.__size;
				
			}
			
			gl.viewport (0, 0, width, height);
			
		}
		
	}
	
	
	@:noCompletion private function __renderStage3D (stage3D:Stage3D):Void {
		
		// Assume this is the primary Context3D
		
		var context = stage3D.context3D;
		
		if (context != null && context != this && context.__frontBufferTexture != null && stage3D.visible) {
			
			if (!__stage.__renderer.__cleared) clear (0, 0, 0, __stage.__transparent ? 0 : 1, 1, 0, Context3DClearMask.COLOR);
			__stage.__renderer.__cleared = true;
			
			if (__renderStage3DProgram == null) {
				
				var vertexAssembler = new AGALMiniAssembler ();
				vertexAssembler.assemble (Context3DProgramType.VERTEX,
					"m44 op, va0, vc0\n" +
					"mov v0, va1"
				);
				
				var fragmentAssembler = new AGALMiniAssembler ();
				fragmentAssembler.assemble (Context3DProgramType.FRAGMENT,
					"tex ft1, v0, fs0 <2d,nearest,nomip>\n" +
					"mov oc, ft1"
				);
				
				__renderStage3DProgram = createProgram ();
				__renderStage3DProgram.upload (vertexAssembler.agalcode, fragmentAssembler.agalcode);
				
			}
			
			setProgram (__renderStage3DProgram);
			setBlendFactors (ONE, ONE_MINUS_SOURCE_ALPHA);
			setTextureAt (0, context.__frontBufferTexture);
			setVertexBufferAt (0, stage3D.__vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			setVertexBufferAt (1, stage3D.__vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			setProgramConstantsFromMatrix (Context3DProgramType.VERTEX, 0, stage3D.__renderTransform, true);
			drawTriangles (stage3D.__indexBuffer);
			
			__present = true;
			
		}
		
	}
	
	
	@:noCompletion private function __setGLBlend (enable:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLBlend != enable #end) {
			if (enable) {
				gl.enable (gl.BLEND);
			} else {
				gl.disable (gl.BLEND);
			}
			__contextState.__enableGLBlend = enable;
		}
		
	}
	
	
	@:noCompletion private function __setGLBlendEquation (value:Int):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__glBlendEquation != value #end) {
			gl.blendEquation (value);
			__contextState.__glBlendEquation = value;
		}
		
	}
	
	
	@:noCompletion private function __setGLCullFace (enable:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLCullFace != enable #end) {
			if (enable) {
				gl.enable (gl.CULL_FACE);
			} else {
				gl.disable (gl.CULL_FACE);
			}
			__contextState.__enableGLCullFace = enable;
		}
		
	}
	
	
	@:noCompletion private function __setGLDepthTest (enable:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLDepthTest != enable #end) {
			if (enable) {
				gl.enable (gl.DEPTH_TEST);
			} else {
				gl.disable (gl.DEPTH_TEST);
			}
			__contextState.__enableGLDepthTest = enable;
		}
		
	}
	
	
	@:noCompletion private function __setGLFrontFace (counterClockWise:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__frontFaceGLCCW != counterClockWise #end) {
			gl.frontFace (counterClockWise ? gl.CCW : gl.CW);
			__contextState.__frontFaceGLCCW = counterClockWise;
		}
		
	}
	
	
	@:noCompletion private function __setGLScissorTest (enable:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLScissorTest != enable #end) {
			if (enable) {
				gl.enable (gl.SCISSOR_TEST);
			} else {
				gl.disable (gl.SCISSOR_TEST);
			}
			__contextState.__enableGLScissorTest = enable;
		}
		
	}
	
	
	@:noCompletion private function __setGLStencilTest (enable:Bool):Void {
		
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLStencilTest != enable #end) {
			if (enable) {
				gl.enable (gl.STENCIL_TEST);
			} else {
				gl.disable (gl.STENCIL_TEST);
			}
			__contextState.__enableGLStencilTest = enable;
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_enableErrorChecking ():Bool {
		
		return __enableErrorChecking;
		
	}
	
	
	@:noCompletion private function set_enableErrorChecking (value:Bool):Bool {
		
		return __enableErrorChecking = value;
		
	}
	
	
}


#else
typedef Context3D = flash.display3D.Context3D;
#end