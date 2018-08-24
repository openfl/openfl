package openfl.display3D; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.utils.Float32Array;
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
import openfl.geom.Rectangle;
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
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)


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
	@:noCompletion private var __backBufferDepthGLRenderbuffer:GLRenderbuffer;
	@:noCompletion private var __backBufferEnableDepthAndStencil:Bool;
	@:noCompletion private var __backBufferGLFramebuffer:GLFramebuffer;
	@:noCompletion private var __backBufferGLRenderbuffer:GLRenderbuffer;
	@:noCompletion private var __backBufferStencilGLRenderbuffer:GLRenderbuffer;
	@:noCompletion private var __backBufferTexture:RectangleTexture;
	@:noCompletion private var __backBufferWantsBestResolution:Bool;
	@:noCompletion private var __backBufferWantsBestResolutionOnBrowserZoom:Bool;
	@:noCompletion private var __context:RenderContext;
	@:noCompletion private var __contextState:Context3DState;
	@:noCompletion private var __enableErrorChecking:Bool;
	@:noCompletion private var __present:Bool;
	@:noCompletion private var __stage:Stage;
	@:noCompletion private var __stage3D:Stage3D;
	@:noCompletion private var __state:Context3DState;
	
	
	@:noCompletion private function new (stage:Stage, contextState:Context3DState = null, stage3D:Stage3D = null) {
		
		super ();
		
		__stage = stage;
		__contextState = contextState;
		__stage3D = stage3D;
		
		__context = stage.window.context;
		gl = __context.webgl;
		
		if (__contextState == null) __contextState = new Context3DState ();
		__state = new Context3DState ();
		
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
		
		if (__state.renderToTexture == null) {
			
			if (__stage3D == null && !__stage.__renderer.__cleared) __stage.__renderer.__cleared = true;
			
		}
		
		__flushGLFramebuffer ();
		
		var clearMask = 0;
		
		if (mask & Context3DClearMask.COLOR != 0) {
			
			clearMask |= gl.COLOR_BUFFER_BIT;
			gl.clearColor (red, green, blue, alpha);
			
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
		
		gl.clear (clearMask);
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		if (__stage3D == null) {
			
			backBufferWidth = width;
			backBufferHeight = height;
			
			__backBufferAntiAlias = antiAlias;
			__backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
			
		} else {
			
			if (__backBufferGLFramebuffer == null) {
				__backBufferGLFramebuffer = gl.createFramebuffer ();
			}
			
			if (__backBufferTexture == null || backBufferWidth != width || backBufferHeight != height) {
				// TODO: Create framebuffer when optimize for render-to-texture is true?
				__backBufferTexture = createRectangleTexture (width, height, BGRA, true);
				__bindGLFramebuffer (__backBufferGLFramebuffer);
				gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, __backBufferTexture.__textureID, 0);
			}
			
			if (enableDepthAndStencil) {
				
				if (GL_DEPTH_STENCIL != 0) {
					
					// TODO: Cache?
					
					if (__backBufferGLRenderbuffer == null) {
						__backBufferGLRenderbuffer = gl.createRenderbuffer ();
					}
					
					gl.bindRenderbuffer (gl.RENDERBUFFER, __backBufferGLRenderbuffer);
					gl.renderbufferStorage (gl.RENDERBUFFER, GL_DEPTH_STENCIL, width, height);
					gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, __backBufferGLRenderbuffer);
					
				} else {
					
					if (__backBufferDepthGLRenderbuffer == null) {
						__backBufferDepthGLRenderbuffer = gl.createRenderbuffer ();
					}
					
					if (__backBufferStencilGLRenderbuffer == null) {
						__backBufferStencilGLRenderbuffer = gl.createRenderbuffer ();
					}
					
					gl.bindRenderbuffer (gl.RENDERBUFFER, __backBufferDepthGLRenderbuffer);
					gl.renderbufferStorage (gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
					gl.bindRenderbuffer (gl.RENDERBUFFER, __backBufferStencilGLRenderbuffer);
					gl.renderbufferStorage (gl.RENDERBUFFER, gl.STENCIL_INDEX8, width, height);
					
					gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, __backBufferDepthGLRenderbuffer);
					gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, __backBufferStencilGLRenderbuffer);
					
				}
				
				gl.bindRenderbuffer (gl.RENDERBUFFER, null);
					
			}
			
			if (__enableErrorChecking) {
				
				var code = gl.checkFramebufferStatus (gl.FRAMEBUFFER);
				
				if (code != gl.FRAMEBUFFER_COMPLETE) {
					
					trace ('Error: Context3D.configureBackBuffer status:${code} width:${width} height:${height}');
					
				}
				
			}
			
			backBufferWidth = width;
			backBufferHeight = height;
			
			__backBufferAntiAlias = antiAlias;
			__backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
			__state.__primaryGLFramebuffer = __backBufferGLFramebuffer;
			
			// quick hack
			__stage3D.__bitmapData.__texture = __backBufferTexture;
			__stage3D.__bitmapData.width = width;
			__stage3D.__bitmapData.height = height;
			__stage3D.__bitmapData.__isValid = true;
			
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
	
	
	public function drawToBitmapData (destination:BitmapData):Void {
		
		if (destination == null) return;
		
		// GLContext3D.drawToBitmapData (this, destination);
		
	}
	
	
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		__flushGL ();
		
		if (__state.renderToTexture == null) {
			
			// TODO: Make sure state is correct for this?
			if (__stage3D == null && !__stage.__renderer.__cleared) __stage.__renderer.__clear ();
			
		}
		
		var count = (numTriangles == -1) ? indexBuffer.__numIndices : (numTriangles * 3);
		
		__bindGLElementArrayBuffer (indexBuffer.__id);
		gl.drawElements (gl.TRIANGLES, count, indexBuffer.__elementType, firstIndex);
		
	}
	
	
	
	public function present ():Void {
		
		__present = true;
		
	}
	
	
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		__state.blendSourceFactor = sourceFactor;
		__state.blendDestinationFactor = destinationFactor;
		
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
		
		if (__state.program.__format == GLSL) {
			
			// TODO
			
		} else {
			
			// if (numRegisters == -1) {
				
			// 	numRegisters = ((data.length >> 2) - byteArrayOffset);
				
			// }
			
			// var isVertex = (programType == Context3DProgramType.VERTEX);
			// var dest = isVertex ? __state.__programVertexConstants : __state.__programFragmentConstants;
			
			// var floatData = Float32Array.fromBytes (data, 0, data.length);
			// var outOffset = firstRegister * 4;
			// var inOffset = Std.int (byteArrayOffset / 4);
			
			// for (i in 0...(numRegisters * 4)) {
				
			// 	dest[outOffset + i] = floatData[inOffset + i];
				
			// }
			
			// __state.__program.__markDirty (isVertex, firstRegister, numRegisters);
			
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
			
			// var isVertex = (programType == Context3DProgramType.VERTEX);
			// var dest = isVertex ? __vertexConstants : __fragmentConstants;
			// var source = matrix.rawData;
			// var i = firstRegister * 4;
			
			// if (transposedMatrix) {
				
			// 	dest[i++] = source[0];
			// 	dest[i++] = source[4];
			// 	dest[i++] = source[8];
			// 	dest[i++] = source[12];
				
			// 	dest[i++] = source[1];
			// 	dest[i++] = source[5];
			// 	dest[i++] = source[9];
			// 	dest[i++] = source[13];
				
			// 	dest[i++] = source[2];
			// 	dest[i++] = source[6];
			// 	dest[i++] = source[10];
			// 	dest[i++] = source[14];
				
			// 	dest[i++] = source[3];
			// 	dest[i++] = source[7];
			// 	dest[i++] = source[11];
			// 	dest[i++] = source[15];
				
			// } else {
				
			// 	dest[i++] = source[0];
			// 	dest[i++] = source[1];
			// 	dest[i++] = source[2];
			// 	dest[i++] = source[3];
				
			// 	dest[i++] = source[4];
			// 	dest[i++] = source[5];
			// 	dest[i++] = source[6];
			// 	dest[i++] = source[7];
				
			// 	dest[i++] = source[8];
			// 	dest[i++] = source[9];
			// 	dest[i++] = source[10];
			// 	dest[i++] = source[11];
				
			// 	dest[i++] = source[12];
			// 	dest[i++] = source[13];
			// 	dest[i++] = source[14];
			// 	dest[i++] = source[15];
				
			// }
			
			// if (__program != null) {
				
			// 	__program.__markDirty (isVertex, firstRegister, 4);
				
			// }
			
		}
		
	}
	
	
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void {
		
		if (numRegisters == 0) return;
		
		// GLContext3D.setProgramConstantsFromVector (this, programType, firstRegister, data, numRegisters);
		
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
			__state.scissorRectangle.setTo (0, 0, 0, 0);
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
		
		gl.enableVertexAttribArray (index);
		__bindGLArrayBuffer (buffer.__id);
		
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
		
		if (__contextState.__currentGLArrayBuffer != buffer) {
			
			gl.bindBuffer (gl.ARRAY_BUFFER, buffer);
			__contextState.__currentGLArrayBuffer = buffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLElementArrayBuffer (buffer:GLBuffer):Void {
		
		if (__contextState.__currentGLElementArrayBuffer != buffer) {
			
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, buffer);
			__contextState.__currentGLElementArrayBuffer = buffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLFramebuffer (framebuffer:GLFramebuffer):Void {
		
		if (__contextState.__currentGLFramebuffer != framebuffer) {
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, framebuffer);
			__contextState.__currentGLFramebuffer = framebuffer;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLTexture2D (texture:GLTexture):Void {
		
		if (__contextState.__currentGLTexture2D != texture) {
			
			gl.bindTexture (gl.TEXTURE_2D, texture);
			__contextState.__currentGLTexture2D = texture;
			
		}
		
	}
	
	
	@:noCompletion private function __bindGLTextureCubeMap (texture:GLTexture):Void {
		
		if (__contextState.__currentGLTextureCubeMap != texture) {
			
			gl.bindTexture (gl.TEXTURE_CUBE_MAP, texture);
			__contextState.__currentGLTextureCubeMap = texture;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGL ():Void {
		
		__flushGLProgram ();
		__flushGLFramebuffer ();
		
		__flushGLBlend ();
		__flushGLColor ();
		__flushGLCulling ();
		__flushGLDepth ();
		__flushGLScissor ();
		__flushGLStencil ();
		__flushGLTextures ();
		__flushGLViewport ();
		
	}
	
	
	@:noCompletion private function __flushGLBlend ():Void {
		
		if (__contextState.blendDestinationFactor != __state.blendDestinationFactor || __contextState.blendSourceFactor != __state.blendSourceFactor) {
			
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
		
		if (__contextState.colorMaskRed != __state.colorMaskRed || __contextState.colorMaskGreen != __state.colorMaskGreen || __contextState.colorMaskBlue != __state.colorMaskBlue || __contextState.colorMaskAlpha != __state.colorMaskAlpha) {
			
			gl.colorMask (__state.colorMaskRed, __state.colorMaskGreen, __state.colorMaskBlue, __state.colorMaskAlpha);
			__contextState.colorMaskRed = __state.colorMaskRed;
			__contextState.colorMaskGreen = __state.colorMaskGreen;
			__contextState.colorMaskBlue = __state.colorMaskBlue;
			__contextState.colorMaskAlpha = __state.colorMaskAlpha;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLCulling ():Void {
		
		if (__contextState.culling != __state.culling) {
			
			if (__contextState.culling == NONE) {
				
				__setGLCullFace (true);
				
			}
			
			if (__state.culling == NONE) {
				
				__setGLCullFace (false);
				
			} else {
				
				switch (__state.culling) {
					
					case NONE: // skip
					case BACK: gl.cullFace (gl.FRONT);
					case FRONT: gl.cullFace (gl.BACK);
					case FRONT_AND_BACK: gl.cullFace (gl.FRONT_AND_BACK);
					default: throw new IllegalOperationError ();
					
				}
				
			}
			
			__contextState.culling = __state.culling;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLDepth ():Void {
		
		if (__contextState.depthMask != __state.depthMask) {
			
			gl.depthMask (__state.depthMask);
			__contextState.depthMask = __state.depthMask;
			
		}
		
		if (__contextState.depthCompareMode != __state.depthCompareMode) {
			
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
			
			if (__contextState.renderToTexture != __state.renderToTexture || __contextState.renderToTextureSurfaceSelector != __state.renderToTextureSurfaceSelector) {
				
				// TODO: Should there be multiple framebuffers for performance?
				
				if (__contextState.__rttGLFramebuffer == null) {
					__contextState.__rttGLFramebuffer = gl.createFramebuffer ();
				}
				
				__bindGLFramebuffer (__contextState.__rttGLFramebuffer);
				
				var width = 0, height = 0;
				
				// TODO: AntiAlias
				// TODO: Solution without Std.is?
				if (Std.is (__state.renderToTexture, Texture)) {
					
					var texture2D:Texture = cast __state.renderToTexture;
					width = texture2D.__width;
					height = texture2D.__height;
					
					gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture2D.__textureID, 0);
					
				} else if (Std.is (__state.renderToTexture, RectangleTexture)) {
					
					var rectTexture:RectangleTexture = cast __state.renderToTexture;
					width = rectTexture.__width;
					height = rectTexture.__height;
					
					gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, rectTexture.__textureID, 0);
					
				} else if (Std.is (__state.renderToTexture, CubeTexture)) {
					
					var cubeTexture:CubeTexture = cast __state.renderToTexture;
					width = cubeTexture.__size;
					height = cubeTexture.__size;
					
					var i = __state.renderToTextureSurfaceSelector;
					// for (i in 0...6) {
						
						gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_CUBE_MAP_POSITIVE_X + i, cubeTexture.__textureID, 0);
						
					// }
					
				} else {
					
					throw new Error ("Invalid texture");
					
				}
				
				if (__state.renderToTextureDepthStencil) {
					
					if (GL_DEPTH_STENCIL != 0) {
						
						// TODO: Cache?
						
						if (__contextState.__rttGLRenderbuffer == null) {
							__contextState.__rttGLRenderbuffer = gl.createRenderbuffer ();
						}
						
						gl.bindRenderbuffer (gl.RENDERBUFFER, __contextState.__rttGLRenderbuffer);
						gl.renderbufferStorage (gl.RENDERBUFFER, GL_DEPTH_STENCIL, width, height);
						gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_STENCIL_ATTACHMENT, gl.RENDERBUFFER, __contextState.__rttGLRenderbuffer);
						
					} else {
						
						if (__contextState.__rttDepthGLRenderbuffer == null) {
							__contextState.__rttDepthGLRenderbuffer = gl.createRenderbuffer ();
						}
						
						if (__contextState.__rttStencilGLRenderbuffer == null) {
							__contextState.__rttStencilGLRenderbuffer = gl.createRenderbuffer ();
						}
						
						gl.bindRenderbuffer (gl.RENDERBUFFER, __contextState.__rttDepthGLRenderbuffer);
						gl.renderbufferStorage (gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
						gl.bindRenderbuffer (gl.RENDERBUFFER, __contextState.__rttStencilGLRenderbuffer);
						gl.renderbufferStorage (gl.RENDERBUFFER, gl.STENCIL_INDEX8, width, height);
						
						gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.DEPTH_ATTACHMENT, gl.RENDERBUFFER, __contextState.__rttDepthGLRenderbuffer);
						gl.framebufferRenderbuffer (gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, __contextState.__rttStencilGLRenderbuffer);
						
					}
					
					gl.bindRenderbuffer (gl.RENDERBUFFER, null);
					
				}
				
				if (__enableErrorChecking) {
					
					var code = gl.checkFramebufferStatus (gl.FRAMEBUFFER);
					
					if (code != gl.FRAMEBUFFER_COMPLETE) {
						
						trace ('Error: Context3D.setRenderToTexture status:${code} width:${width} height:${height}');
						
					}
					
				}
				
				// TODO: Is this correct?
				gl.frontFace (gl.CW);
				
				__setGLDepthTest (__state.renderToTextureDepthStencil);
				__setGLStencilTest (__state.renderToTextureDepthStencil);
				
				__contextState.renderToTexture = __state.renderToTexture;
				__contextState.renderToTextureAntiAlias = __state.renderToTextureAntiAlias;
				__contextState.renderToTextureDepthStencil = __state.renderToTextureDepthStencil;
				__contextState.renderToTextureSurfaceSelector = __state.renderToTextureSurfaceSelector;
				
			}
			
			// context.__positionScale[1] = -1.0;
			
			// if (context.__program != null) {
				
			// 	context.__program.__setPositionScale (context.__positionScale);
				
			// }
			
		} else {
			
			if (backBufferWidth == 0 && backBufferHeight == 0) {
				
				throw new Error ("Context3D backbuffer has not been configured");
				
			}
			
			if (__contextState.renderToTexture != null || __contextState.__currentGLFramebuffer != __state.__primaryGLFramebuffer) {
				
				__bindGLFramebuffer (__state.__primaryGLFramebuffer);
				
				__setGLDepthTest (__backBufferEnableDepthAndStencil);
				__setGLStencilTest (__backBufferEnableDepthAndStencil);
				
				__contextState.renderToTexture = null;
				
				// TODO: Is this correct?
				gl.frontFace (gl.CCW);
				
				// context.__positionScale[1] = 1.0;
				
				// if (context.__program != null) {
					
				// 	context.__program.__setPositionScale (context.__positionScale);
					
				// }
				
			}
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLProgram ():Void {
		
		var program = __state.program;
		
		if (__contextState.program != program) {
			
			gl.useProgram (program.__programID);
			
			// if (program != null && program.__format == AGAL) {
				
			// 	program.__use ();
			// 	program.__setPositionScale (__positionScale);
				
			// }
			
			__contextState.program = program;
			
		}
		
	}
	
	
	@:noCompletion private function __flushGLScissor ():Void {
		
		if (!__contextState.scissorRectangle.equals (__state.scissorRectangle)) {
			
			if (__state.scissorRectangle.width <= 0 || __state.scissorRectangle.height <= 0) {
				
				gl.scissor (0, 0, 0, 0);
				
			} else {
				
				gl.scissor (Math.round (__state.scissorRectangle.x), Math.round (__state.scissorRectangle.y), Math.round (__state.scissorRectangle.width), Math.round (__state.scissorRectangle.height));
				
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
		
		if (__contextState.stencilTriangleFace != __state.stencilTriangleFace || __contextState.stencilPass != __state.stencilPass || __contextState.stencilDepthFail != __state.stencilDepthFail || __contextState.stencilFail != __state.stencilFail) {
			
			gl.stencilOpSeparate (getGLTriangleFace (__state.stencilTriangleFace), getGLStencilAction (__state.stencilFail), getGLStencilAction (__state.stencilDepthFail), getGLStencilAction (__state.stencilPass));
			__contextState.stencilTriangleFace = __state.stencilTriangleFace;
			__contextState.stencilPass = __state.stencilPass;
			__contextState.stencilDepthFail = __state.stencilDepthFail;
			__contextState.stencilFail = __state.stencilFail;
			
		}
		
		if (__contextState.stencilWriteMask != __state.stencilWriteMask) {
			
			gl.stencilMask (__state.stencilWriteMask);
			__contextState.stencilWriteMask = __state.stencilWriteMask;
			
		}
		
		if (__contextState.stencilCompareMode != __state.stencilCompareMode || __contextState.stencilReferenceValue != __state.stencilReferenceValue || __contextState.stencilReadMask != __state.stencilReadMask) {
			
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
			
			gl.activeTexture (gl.TEXTURE0 + sampler);
			
			if (texture != null) {
				
				if (texture != __contextState.textures[i]) {
					
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
					
				}
				
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
			
			// TODO: Cache viewport, handle Stage3D.x/y changes?
			
			var window = __stage.window;
			var x = __stage3D == null ? 0 : Std.int (__stage3D.x);
			var y = __stage3D == null ? 0 : Std.int ((window.height * window.scale) - backBufferHeight - __stage3D.y);
			if (x < 0) x = 0;
			if (y < 0) y = 0;
			
			gl.viewport (x, y, backBufferWidth, backBufferHeight);
			
		} else {
			
			// TODO
			
		}
		
	}
	
	
	@:noCompletion private function __setGLBlend (enable:Bool):Void {
		
		if (__contextState.__enableGLBlend != enable) {
			if (enable) {
				gl.enable (gl.BLEND);
			} else {
				gl.disable (gl.BLEND);
			}
		}
		
	}
	
	
	@:noCompletion private function __setGLCullFace (enable:Bool):Void {
		
		if (__contextState.__enableGLCullFace != enable) {
			if (enable) {
				gl.enable (gl.CULL_FACE);
			} else {
				gl.disable (gl.CULL_FACE);
			}
		}
		
	}
	
	
	@:noCompletion private function __setGLDepthTest (enable:Bool):Void {
		
		if (__contextState.__enableGLDepthTest != enable) {
			if (enable) {
				gl.enable (gl.DEPTH_TEST);
			} else {
				gl.disable (gl.DEPTH_TEST);
			}
		}
		
	}
	
	
	@:noCompletion private function __setGLScissorTest (enable:Bool):Void {
		
		if (__contextState.__enableGLScissorTest != enable) {
			if (enable) {
				gl.enable (gl.SCISSOR_TEST);
			} else {
				gl.disable (gl.SCISSOR_TEST);
			}
		}
		
	}
	
	
	@:noCompletion private function __setGLStencilTest (enable:Bool):Void {
		
		if (__contextState.__enableGLStencilTest != enable) {
			if (enable) {
				gl.enable (gl.STENCIL_TEST);
			} else {
				gl.disable (gl.STENCIL_TEST);
			}
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