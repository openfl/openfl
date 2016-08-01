package openfl.display3D;

import openfl._internal.stage3D.Context3DStateCache;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.Context3DProgramType;
import openfl.events.EventDispatcher;
import openfl.errors.IllegalOperationError;
import openfl.errors.Error;
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.utils.Float32Array;


import openfl.Vector;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;

#if telemetry
import openfl.profiler.Telemetry;
#end

//using _root;

// stats enumeration
// these will be used to send data to telemetry and are named such that they translate easily to telemetry names
class Stats {
	static public inline var DrawCalls = 0;
	static public inline var Count_IndexBuffer = 1;
	static public inline var Count_VertexBuffer = 2;
	static public inline var Count_Texture = 3;
	static public inline var Count_Texture_Compressed = 4;
	static public inline var Count_Program = 5;
	static public inline var Mem_IndexBuffer = 6;
	static public inline var Mem_VertexBuffer = 7;
	static public inline var Mem_Texture = 8;
	static public inline var Mem_Texture_Compressed = 9;
	static public inline var Mem_Program = 10;

	static public inline var Length = 11;
}

class Context3D extends EventDispatcher {

	// the field below is assigned but never used
	// stage3D that owns us
	private var mStage3D:Dynamic;

	// current program
	private var mProgram:Program3D ;

	// vertex and fragment constant values
	public var mVertexConstants:Float32Array = new Float32Array(4 * MaxProgramRegisters);
	public var mFragmentConstants:Float32Array = new Float32Array(4 * MaxProgramRegisters);

	// this is the post-transform scale applied to all positions coming out of the vertex shader
	private var mPositionScale:Float32Array = new Float32Array([1.0, 1.0, 1.0, 1.0]);

	// sampler settings
	private var mSamplerDirty:Int = 0;
	private var mSamplerTextures:Vector<TextureBase> = new Vector<TextureBase>(Context3D.MaxSamplers);

	// settings for backbuffer
	private var mDefaultFrameBufferId:GLFramebuffer;
	private var mBackBufferWidth:Int = 0;
	private var mBackBufferHeight:Int = 0;

	// the fields below are assigned but never used
	private var mDepthRenderBufferId:GLRenderbuffer;

	private var mBackBufferAntiAlias:Int = 0;
	private var mBackBufferEnableDepthAndStencil:Bool = true;
	private var mBackBufferWantsBestResolution:Bool = false;

	// settings for render to texture
	private var mRenderToTexture:TextureBase = null;

	private var mTextureDepthBufferId:GLRenderbuffer;

	private var mTextureFrameBufferId:GLFramebuffer;
	// various stats
	private var mFrameCount:Int = 0;
	private /*readonly*/ var mStats:Vector<Int> = new Vector<Int>(Stats.Length);
	private /*readonly*/ var mLastStats:Vector<Int> = new Vector<Int>(Stats.Length);
#if telemetry
	private var mStatsValues:Array<Telemetry.Value>;

	private /*readonly*/ var mSpanPresent:Telemetry.Span = new Telemetry.Span(".rend.molehill.present");
	private /*readonly*/ var mValueFrame:Telemetry.Value = new Telemetry.Value(".rend.molehill.frame");
#end


	//
	// Constants
	//

	// public static inline var MaxSamplers:Int = 16; // TODO: This is the correct setting for MONOTOUCH

	// public static inline var MaxSamplers:Int = 8; // TODO: This is the correct setting for MONODROID

	public static inline var MaxSamplers:Int = 8;

	public static inline var MaxAttributes:Int = 16;

	public static inline var MaxProgramRegisters:Int = 128;


	//
	// Properties
	//

	public var driverInfo:String ;

	public var enableErrorChecking:Bool;


	/// This method gets invoked whenever Present is called on the context
	public static var OnPresent:Context3D -> Void;


	// keeps track of the current state of the device and don't call GL if not strictly needed
	private static var StateCache:Context3DStateCache = new Context3DStateCache();

	//
	// Methods
	//


	// this is the default sampler state
	public static var DefaultSamplerState:SamplerState = new SamplerState(GL.LINEAR, GL.LINEAR, GL.REPEAT, GL.REPEAT).Intern();


	public function new(?stage3D:Dynamic)
	{
		super();
		
		mStage3D = stage3D;

		GLUtils.CheckGLError();

		// compose driver info String
		var vendor = GL.getParameter(GL.VENDOR);
		GLUtils.CheckGLError();

		var version = GL.getParameter(GL.VERSION);
		GLUtils.CheckGLError();

		var renderer = GL.getParameter(GL.RENDERER);
		GLUtils.CheckGLError();

		var glslVersion = '<unknown>'; // GL.getParameter(GL.SHADING_LANGUAGE_VERSION);
		GLUtils.CheckGLError();

		driverInfo = "OpenGL" +
					 " Vendor=" + vendor +
					 " Version=" + version +
					 " Renderer=" + renderer +
					 " GLSL=" + glslVersion;

#if telemetry
		// write driver info to telemetry
		Telemetry.Session.WriteValue(".platform.3d.driverinfo", driverInfo);
#end


		// get default framebuffer for use when restoring rendering to backbuffer
		mDefaultFrameBufferId = GL.getParameter(GL.FRAMEBUFFER_BINDING);
		GLUtils.CheckGLError();

		// generate depth buffer for backbuffer
		mDepthRenderBufferId = GL.createRenderbuffer();
		GLUtils.CheckGLError();

		// generate framebuffer for render to texture
		mTextureFrameBufferId = GL.createFramebuffer();
		GLUtils.CheckGLError();

		// generate depth buffer for render to texture
		mTextureDepthBufferId = GL.createRenderbuffer();
		GLUtils.CheckGLError();

		// Initialize stats
		for (i in 0...mStats.length) {
			mStats[i] = 0;
		}

		// clear the settings cache
		StateCache.clearSettings();
	}

	public function clear(red:Float = 0.0, green:Float = 0.0, blue:Float = 0.0, alpha:Float = 1.0,
						  depth:Float = 1.0, ?stencil:UInt = 0, ?mask:UInt = 0xffffffff):Void
	{
//			if (mask != 0xffffffff)
//				System.Console.WriteLine("Context3D.clear() - Not implemented with mask=" + mask);

		// save old depth mask
		var oldDepthWriteMask:Bool ;
		// TODO: is getParameter right?
		oldDepthWriteMask = GL.getParameter(GL.DEPTH_WRITEMASK);
		GLUtils.CheckGLError();

		// depth writes must be enabled to clear the depth buffer!
		GL.depthMask(true);
		GLUtils.CheckGLError();

		GL.clearColor(red, green, blue, alpha);
		GLUtils.CheckGLError();

		GL.clearDepth(depth);
		GLUtils.CheckGLError();

		GL.clearStencil(stencil);
		GLUtils.CheckGLError();

		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
		GLUtils.CheckGLError();

		// restore depth mask
		GL.depthMask(oldDepthWriteMask);
		GLUtils.CheckGLError();
	}

	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int,
										enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false):Void
	{
		setViewport(0, 0, width, height);

		// TODO allow for resizing of frame buffer here
		mBackBufferWidth = width;
		mBackBufferHeight = height;
		mBackBufferAntiAlias = antiAlias;
		mBackBufferEnableDepthAndStencil = enableDepthAndStencil;
		mBackBufferWantsBestResolution = wantsBestResolution;

		// validate framebuffer status
		var status = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
		GLUtils.CheckGLError();

		if (status != GL.FRAMEBUFFER_COMPLETE) {
			trace("FrameBuffer configuration error: " + status);
		}

		// clear the settings cache
		StateCache.clearSettings();
	}

	public function createCubeTexture(size:Int, format:String, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture
	{
		return new CubeTexture(this, size, format, optimizeForRenderToTexture, streamingLevels);
	}

	public function createIndexBuffer(numIndices:Int, bufferUsage:String = "staticDraw"):IndexBuffer3D
	{
		return new IndexBuffer3D(this, numIndices, bufferUsage);
	}

	public function createProgram():Program3D
	{
		return new Program3D(this);
	}

	public function createRectangleTexture(width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool):RectangleTexture
	{
		return new RectangleTexture(this, width, height, format, optimizeForRenderToTexture);
	}

	public function createTexture(width:Int, height:Int, format:String,
								  optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture
	{
		return new Texture(this, width, height, format, optimizeForRenderToTexture, streamingLevels);
	}

	public function createVertexBuffer(numVertices:Int, data32PerVertex:Int, bufferUsage:String = "staticDraw"):VertexBuffer3D
	{
		return new VertexBuffer3D(this, numVertices, data32PerVertex, bufferUsage);
	}

	public function createVertexArray():Int
	{
		// TODO: MONOTOUCH stub.
		// not supported
		return -1;

	}

	public function bindVertexArray(id:Int):Void
	{
		// TODO: MONOTOUCH stub.
	}

	public function disposeVertexArray(id:Int):Void
	{
		// TODO: MONOTOUCH stub.
	}

	public function dispose():Void
	{
		throw new IllegalOperationError();
	}

	public function drawToBitmapData(destination:BitmapData):Void
	{
		throw new IllegalOperationError();
	}

	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void
	{
		if (mProgram == null)
			return;

		// flush sampler state before drawing
		flushSamplerState();
		// flush program state before drawing
		mProgram.Flush();

		var count:Int = (numTriangles == -1) ? indexBuffer.numIndices : (numTriangles * 3);

		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer.id);
		GLUtils.CheckGLError();

		GL.drawElements(GL.TRIANGLES, count, indexBuffer.elementType, firstIndex);
		GLUtils.CheckGLError();

		// increment draw call count
		statsIncrement(Stats.DrawCalls);
	}

	public function drawTrianglesVA(firstIndex:Int, numTriangles:Int, elementType:Int /*DrawElementsType*/):Void
	{
		if (mProgram == null)
			return;

		// flush sampler state before drawing
		flushSamplerState();
		// flush program state before drawing
		mProgram.Flush();
		GL.drawElements(GL.TRIANGLES, (numTriangles * 3), elementType, firstIndex);
		GLUtils.CheckGLError();

		// increment draw call count
		statsIncrement(Stats.DrawCalls);
	}

	public function present():Void
	{
		if (OnPresent != null)
			OnPresent(this);

		// send stats for frame
		statsSendToTelemetry();

		// begin and end span for present
		// note that this span must include the above stats call

#if telemetry
		mSpanPresent.End();
		mSpanPresent.Begin();
#end

		// clear draw call count
		statsClear(Stats.DrawCalls);

		// increment frame count
		mFrameCount++;
	}

	public function setBlendFactors(sourceFactor:String, destinationFactor:String):Void
	{
		var src:Int = GL.ONE;
		var dest:Int = GL.ONE_MINUS_SRC_ALPHA;
		var updateBlendFunction:Bool = false;

		if (StateCache.updateBlendSrcFactor(sourceFactor) || StateCache.updateBlendDestFactor(destinationFactor))
			updateBlendFunction = true;

		if (updateBlendFunction) {
			// translate Strings Into enums
			switch (sourceFactor) {
				case Context3DBlendFactor.ONE: src = GL.ONE;
				case Context3DBlendFactor.ZERO: src = GL.ZERO;
				case Context3DBlendFactor.SOURCE_ALPHA: src = GL.SRC_ALPHA;
				case Context3DBlendFactor.DESTINATION_ALPHA: src = GL.DST_ALPHA;
				case Context3DBlendFactor.DESTINATION_COLOR: src = GL.DST_COLOR;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: src = GL.ONE_MINUS_SRC_ALPHA;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: src = GL.ONE_MINUS_DST_ALPHA;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR: src = GL.ONE_MINUS_DST_COLOR;
				default:
					throw new IllegalOperationError();
			}

			// translate Strings Into enums
			switch (destinationFactor) {
				case Context3DBlendFactor.ONE: dest = GL.ONE;
				case Context3DBlendFactor.ZERO: dest = GL.ZERO;
				case Context3DBlendFactor.SOURCE_ALPHA: dest = GL.SRC_ALPHA;
				case Context3DBlendFactor.SOURCE_COLOR: dest = GL.SRC_COLOR;
				case Context3DBlendFactor.DESTINATION_ALPHA: dest = GL.DST_ALPHA;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: dest = GL.ONE_MINUS_SRC_ALPHA;
				case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR: dest = GL.ONE_MINUS_SRC_COLOR;
				case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: dest = GL.ONE_MINUS_DST_ALPHA;
				default:
					throw new IllegalOperationError();
			}

			GL.enable(GL.BLEND);
			GL.blendFunc(src, dest);
		}
	}

	public function setColorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void
	{
		GL.colorMask(red, green, blue, alpha);
	}

	public function setCulling(triangleFaceToCull:String):Void
	{
		if (StateCache.updateCullingMode(triangleFaceToCull)) {
			switch (triangleFaceToCull) {
				case Context3DTriangleFace.NONE:
					GL.disable(GL.CULL_FACE);

				case Context3DTriangleFace.BACK:
					GL.enable(GL.CULL_FACE);
					GL.cullFace(GL.FRONT); // oddly this is inverted

				case Context3DTriangleFace.FRONT:
					GL.enable(GL.CULL_FACE);
					GL.cullFace(GL.BACK); // oddly this is inverted

				case Context3DTriangleFace.FRONT_AND_BACK:
					GL.enable(GL.CULL_FACE);
					GL.cullFace(GL.FRONT_AND_BACK);

				default:
					throw new IllegalOperationError ();
			}
		}

	}

	public function setDepthTest(depthMask:Bool, passCompareMode:String, depthTestEnabled:Bool = true):Void
	{
		// If the backBuffer doesn't have a depth buffer, then disable depth testing.
		if (!mBackBufferEnableDepthAndStencil) {
			depthTestEnabled = false;
		}

		if (StateCache.updateDepthTestEnabled(depthTestEnabled)) {
			if (depthTestEnabled) {
				GL.enable(GL.DEPTH_TEST);
			} else {
				GL.disable(GL.DEPTH_TEST);
			}
		}

		if (StateCache.updateDepthTestMask(depthMask)) {
			GL.depthMask(depthMask);
		}

		if (StateCache.updateDepthCompareMode(passCompareMode)) {
			switch (passCompareMode) {
				case Context3DCompareMode.ALWAYS:
					GL.depthFunc(GL.ALWAYS);

				case Context3DCompareMode.EQUAL:
					GL.depthFunc(GL.EQUAL);

				case Context3DCompareMode.GREATER:
					GL.depthFunc(GL.GREATER);

				case Context3DCompareMode.GREATER_EQUAL:
					GL.depthFunc(GL.GEQUAL);

				case Context3DCompareMode.LESS:
					GL.depthFunc(GL.LESS);

				case Context3DCompareMode.LESS_EQUAL:
					GL.depthFunc(GL.LEQUAL);

				case Context3DCompareMode.NEVER:
					GL.depthFunc(GL.NEVER);

				case Context3DCompareMode.NOT_EQUAL:
					GL.depthFunc(GL.NOTEQUAL);

				default:
					throw new IllegalOperationError ();
			}
		}

	}

	public function setProgram(program:Program3D):Void
	{
		if (program == null)
			throw new IllegalOperationError ();

		if (StateCache.updateProgram3D(program)) {
			program.Use();
			program.SetPositionScale(mPositionScale);

			// store current program
			mProgram = program;

			// mark all samplers that this program uses as dirty
			mSamplerDirty |= mProgram.samplerUsageMask;
		}
	}

	public function setProgramConstantsFromByteArray(programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void
	{
		if (numRegisters == 0) return;

		if (numRegisters == -1) {
			numRegisters = ((data.length >> 2) - byteArrayOffset);
		}

		var isVertex:Bool = (programType == Context3DProgramType.VERTEX);
		var dest:Float32Array = isVertex ? mVertexConstants : mFragmentConstants;

		var floatData:Float32Array = Float32Array.fromBytes(data, 0, data.length);
		var outOffset:Int = firstRegister * 4;
		var inOffset:Int = Std.int(byteArrayOffset / 4);

		// copy Into constant buffer
		for (i in 0...(numRegisters * 4)) {
			dest[outOffset + i] = floatData[inOffset + i];
		}
		/*
			Buffer.BlockCopy(
				data.getRawArray(), byteArrayOffset, 
				dest, firstRegister * 4 * 4, //sizeof(Float), 
				numRegisters * 4 * 4 //sizeof(Float)
			);*/

		// mark registers as dirty
		if (mProgram != null) {
			mProgram.MarkDirty(isVertex, firstRegister, numRegisters);
		}
	}

	public function setViewport(originX:Int, originY:Int, width:Int, height:Int):Void
	{
		if (StateCache.updateViewport(originX, originY, width, height)) {
			GL.viewport(originX, originY, width, height);
			GLUtils.CheckGLError();
		}
	}

	public function setProgramConstantsFromMatrix(programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D,
												  transposedMatrix:Bool = false):Void
	{
		// GLES does not support transposed uniform setting so do it manually
		var isVertex:Bool = (programType == Context3DProgramType.VERTEX);
		var dest:Float32Array = isVertex ? mVertexConstants : mFragmentConstants;
		var source = matrix.rawData;
		var i:Int = firstRegister * 4;

		if (transposedMatrix) {
			//	0  1  2  3
			//	4  5  6  7
			//	8  9 10 11
			//   12 13 14 15
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

		// mark registers as dirty
		if (mProgram != null) {
			mProgram.MarkDirty(isVertex, firstRegister, 4);
		}
	}

	public function setProgramConstantsFromVector(programType:String, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void
	{
		if (numRegisters == 0) return;

		if (numRegisters == -1) {
			numRegisters = (data.length >> 2);
		}

		var isVertex:Bool = (programType == "vertex");
		var dest:Float32Array = isVertex ? mVertexConstants : mFragmentConstants;
		var source = data;

		// copy and convert registers from double -> Float
		var sourceIndex = 0;
		var destIndex = firstRegister * 4;
		for (i in 0...numRegisters) {
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
		}

		// mark registers as dirty
		if (mProgram != null) {
			mProgram.MarkDirty(isVertex, firstRegister, numRegisters);
		}
	}


	public function setRenderToBackBuffer():Void
	{

		// draw to backbuffer
		GL.bindFramebuffer(GL.FRAMEBUFFER, mDefaultFrameBufferId);
		GLUtils.CheckGLError();

		// setup viewport for render to backbuffer
		setViewport(0, 0, mBackBufferWidth, mBackBufferHeight);

		// normal scaling
		mPositionScale[1] = 1.0;
		if (mProgram != null) {
			mProgram.SetPositionScale(mPositionScale);
		}
		// clear render to texture
		mRenderToTexture = null;
	}

	public function setRenderToTexture(texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0,
									   surfaceSelector:Int = 0):Void
	{

		var texture2D:Texture = cast texture;
		if (texture2D == null)
			throw new Error("Invalid texture");


		if (!texture.allocated) {
			GL.bindTexture(GL.TEXTURE_2D, texture.textureId);
			texture.allocated = true;
		}

		GL.bindFramebuffer(GL.FRAMEBUFFER, mTextureFrameBufferId);
		GL.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.textureId, 0);
		GLUtils.CheckGLError();

		// setup viewport for render to texture
		setViewport(0, 0, texture2D.width, texture2D.height);

		// validate framebuffer status
		var code = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
		if (code != GL.FRAMEBUFFER_COMPLETE) {
			trace("Error: Context3D.setRenderToTexture status:${code} width:${texture2D.width} height:${texture2D.height}");
		}

		// invert the output y to flip the texture upside down when rendering
		mPositionScale[1] = -1.0;
		if (mProgram != null) {
			mProgram.SetPositionScale(mPositionScale);
		}

		// save texture we're rendering to
		mRenderToTexture = texture;
	}

	public function setSamplerStateAt(sampler:Int, wrap:String, filter:String, mipfilter:String):Void
	{
		throw new IllegalOperationError();
	}


	public function setScissorRectangle(rectangle:Rectangle):Void
	{
		if (rectangle != null) {
			GL.scissor(Std.int(rectangle.x), Std.int(rectangle.y), Std.int(rectangle.width), Std.int(rectangle.height));
		} else {
			GL.scissor(0, 0, mBackBufferWidth, mBackBufferHeight);
		}
	}

	public function setStencilActions(triangleFace:String = "frontAndBack", compareMode:String = "always", actionOnBothPass:String = "keep",
									  actionOnDepthFail:String = "keep", actionOnDepthPassStencilFail:String = "keep"):Void
	{
		throw new IllegalOperationError();
	}

	public function setStencilReferenceValue(referenceValue:UInt, readMask:UInt = 255, writeMask:UInt = 255):Void
	{
		throw new IllegalOperationError();
	}

	public function setTextureAt(sampler:Int, texture:TextureBase):Void
	{
		// see if texture changed
		if (mSamplerTextures[sampler] != texture) {
			// set sampler texture
			mSamplerTextures[sampler] = texture;

			// set flag indicating that this sampler is dirty
			mSamplerDirty |= (1 << sampler);
		}
	}

	public function setIndexBuffer(indexBuffer:IndexBuffer3D):Void
	{
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, indexBuffer.id);
		GLUtils.CheckGLError();
	}

	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void
	{
		if (buffer == null) {
			GL.disableVertexAttribArray(index);
			GLUtils.CheckGLError();

			// carloX not sure this is catually needed
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
			GLUtils.CheckGLError();

			return;
		}

		// enable vertex attribute array
		GL.enableVertexAttribArray(index);
		GLUtils.CheckGLError();

		GL.bindBuffer(GL.ARRAY_BUFFER, buffer.id);
		GLUtils.CheckGLError();

		var byteOffset:Int = bufferOffset * 4; // buffer offset is in 32-bit words

		// set attribute poInter within vertex buffer
		switch (format) {
			case FLOAT_4:
				GL.vertexAttribPointer(index, 4, GL.FLOAT, false, buffer.stride, byteOffset);
				GLUtils.CheckGLError();

			case FLOAT_3:
				GL.vertexAttribPointer(index, 3, GL.FLOAT, false, buffer.stride, byteOffset);
				GLUtils.CheckGLError();

			case FLOAT_2:
				GL.vertexAttribPointer(index, 2, GL.FLOAT, false, buffer.stride, byteOffset);
				GLUtils.CheckGLError();

			case FLOAT_1:
				GL.vertexAttribPointer(index, 1, GL.FLOAT, false, buffer.stride, byteOffset);
				GLUtils.CheckGLError();

			default:
				throw new IllegalOperationError();
		}
	}


	/// This method flushes all sampler state. Sampler state comes from two sources, the context.setTextureAt()
	/// and the Program3D's filtering parameters that are specified per tex instruction. Due to the way that GL works,
	/// the filtering parameters need to be associated with bound textures so that is performed here before drawing.

	private function flushSamplerState():Void
	{
		var sampler:Int = 0;
		// loop until all dirty samplers have been processed
		while (mSamplerDirty != 0) {

			// determine if sampler is dirty
			if ((mSamplerDirty & (1 << sampler)) != 0) {

				// activate texture unit for GL
				if (StateCache.updateActiveTextureSample(sampler)) {
					GL.activeTexture(GL.TEXTURE0 + sampler);
					GLUtils.CheckGLError();
				}

				// get texture for sampler
				var texture:TextureBase = mSamplerTextures[sampler];
				if (texture != null) {
					// bind texture
					var target = texture.textureTarget;

					GL.bindTexture(target, texture.textureId);
					GLUtils.CheckGLError();

					// TODO: support sampler state overrides through setSamplerAt(...)
					// get sampler state from program
					var state:SamplerState = mProgram.getSamplerState(sampler);
					if (state != null) {
						// apply sampler state to texture
						texture.setSamplerState(state);
					} else {
						// use default state if program has none
						texture.setSamplerState(Context3D.DefaultSamplerState);
					}

				} else {
					// texture is null so unbind texture
					GL.bindTexture(GL.TEXTURE_2D, null);
					GLUtils.CheckGLError();
				}

				// clear dirty bit
				mSamplerDirty &= ~(1 << sampler);
			}

			// next sampler
			sampler++;
		}
	}

	// functions for updating the rendering stats

	public function statsClear(stat:Int):Void
	{
		mStats[stat] = 0;
	}


	public function statsIncrement(stat:Int):Void
	{
		mStats[stat] += 1;
	}

	public function statsDecrement(stat:Int):Void
	{
		mStats[stat] -= 1;
	}


	public function statsAdd(stat:Int, value:Int):Int
	{
		mStats[stat] += value;
		return mStats [stat];
	}


	public function statsSubtract(stat:Int, value:Int):Int
	{
		mStats[stat] -= value;
		return mStats [stat];
	}

	// this function sends stats to telemetry

	private function statsSendToTelemetry():Void
	{
#if telemetry
		// write telemetry stats if we are connected
		if (!Telemetry.Session.Connected)
			return;

		// create telemetry values on demand
		if (mStatsValues == null) {
			mStatsValues = new Array<Telemetry.Value>(Stats.Length);
			for (i in 0...Stats.Length) {
				var name:String ;
				switch (i) {
					case Stats.DrawCalls:
						name = ".3d.resource.drawCalls";

					default:
						name = ".3d.resource." + i.ToString().toLowerCase().Replace('_', '.');
				}
				mStatsValues[i] = new Telemetry.Value(name);
			}
		}

		// write all telemetry values
		for (i in 0...Stats.Length) {
			if (mStats[i] != mLastStats[i]) {
				// write stat value if it changed
				mStatsValues[i].WriteValue(mStats[i]);
				mLastStats[i] = mStats[i];
			}
		}

		// write frame count after stats
		mValueFrame.WriteValue(mFrameCount);
#end
	}

/* Stubs
	public function new(stage3D:Stage3D)
	{
		throw new IllegalOperationError();
	}

	private function setupShaders():Void
	{
		throw new IllegalOperationError();
	}

	public function clear(red:Float = 0.0, green:Float = 0.0, blue:Float = 0.0, alpha:Float = 1.0,
						  depth:Float = 1.0, stencil:UInt = 0, mask:UInt = 0xffffffff):Void
	{
		throw new IllegalOperationError();
	}

	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int,
										enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false):Void
	{
		throw new IllegalOperationError();
	}

	public function createCubeTexture(size:Int, format:String, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture
	{
		throw new IllegalOperationError();
	}

	public function createIndexBuffer(numIndices:Int):IndexBuffer3D
	{
		throw new IllegalOperationError();
	}

	public function createProgram():Program3D
	{
		throw new IllegalOperationError();
	}

	public function createTexture(width:Int, height:Int, format:String,
								  optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture
	{
		throw new IllegalOperationError();
	}

	public function createVertexBuffer(numVertices:Int, data32PerVertex:Int):VertexBuffer3D
	{
		throw new IllegalOperationError();
	}

	public function dispose():Void
	{
		throw new IllegalOperationError();
	}

	public function drawToBitmapData(destination:BitmapData):Void
	{
		throw new IllegalOperationError();
	}

	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void
	{
		throw new IllegalOperationError();
	}

	public function present():Void
	{
		throw new IllegalOperationError();
	}

	public function setBlendFactors(sourceFactor:String, destinationFactor:String):Void
	{
	}

	public function setColorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void
	{
	}

	public function setCulling(triangleFaceToCull:String):Void
	{
		throw new IllegalOperationError();
	}

	public function setDepthTest(depthMask:Bool, passCompareMode:String):Void
	{
		throw new IllegalOperationError();
	}

	public function setProgram(program:Program3D):Void
	{
		throw new IllegalOperationError();
	}

	public function setProgramConstantsFromByteArray(programType:String, firstRegister:Int,
													 numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void
	{
		throw new IllegalOperationError();
	}

	public function setProgramConstantsFromMatrix(programType:String, firstRegister:Int, matrix:Matrix3D,
												  transposedMatrix:Bool = false):Void
	{
		throw new IllegalOperationError();
	}

	public function setProgramConstantsFromVector(programType:String, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void
	{
		throw new IllegalOperationError();
	}

	public function setRenderToBackBuffer():Void
	{
		throw new IllegalOperationError();
	}

	public function setRenderToTexture(texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0,
									   surfaceSelector:Int = 0):Void
	{
		throw new IllegalOperationError();
	}


	public function setScissorRectangle(rectangle:Rectangle):Void
	{
		throw new IllegalOperationError();
	}

	public function setStencilActions(triangleFace:String = "frontAndBack", compareMode:String = "always", actionOnBothPass:String = "keep",
									  actionOnDepthFail:String = "keep", actionOnDepthPassStencilFail:String = "keep"):Void0
	{
		throw new IllegalOperationError();
	}

	public function setStencilReferenceValue(referenceValue:UInt, readMask:UInt = 255, writeMask:UInt = 255):Void
	{
		throw new IllegalOperationError();
	}

	public function setTextureAt(sampler:Int, texture:TextureBase):Void
	{
		throw new IllegalOperationError();
	}

	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:String = "Float4"):Void
	{
		throw new IllegalOperationError();
	}

*/

}

