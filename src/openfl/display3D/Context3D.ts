import Context3DState from "../_internal/renderer/context3D/Context3DState";
import BitmapDataPool from "../_internal/renderer/BitmapDataPool";
import SamplerState from "../_internal/renderer/SamplerState";
import * as internal from "../_internal/utils/InternalAccess";
import CubeTexture from "../display3D/textures/CubeTexture";
import RectangleTexture from "../display3D/textures/RectangleTexture";
import TextureBase from "../display3D/textures/TextureBase";
import Texture from "../display3D/textures/Texture";
import VideoTexture from "../display3D/textures/VideoTexture";
import Context3DBlendFactor from "../display3D/Context3DBlendFactor";
import Context3DBufferUsage from "../display3D/Context3DBufferUsage";
import Context3DClearMask from "../display3D/Context3DClearMask";
import Context3DCompareMode from "../display3D/Context3DCompareMode";
import Context3DMipFilter from "../display3D/Context3DMipFilter";
import Context3DProfile from "../display3D/Context3DProfile";
import Context3DProgramFormat from "../display3D/Context3DProgramFormat";
import Context3DProgramType from "../display3D/Context3DProgramType";
import Context3DRenderMode from "../display3D/Context3DRenderMode";
import Context3DStencilAction from "../display3D/Context3DStencilAction";
import Context3DTextureFilter from "../display3D/Context3DTextureFilter";
import Context3DTextureFormat from "../display3D/Context3DTextureFormat";
import Context3DTriangleFace from "../display3D/Context3DTriangleFace";
import Context3DVertexBufferFormat from "../display3D/Context3DVertexBufferFormat";
import Context3DWrapMode from "../display3D/Context3DWrapMode";
import IndexBuffer3D from "../display3D/IndexBuffer3D";
import Program3D from "../display3D/Program3D";
import VertexBuffer3D from "../display3D/VertexBuffer3D";
import BitmapData from "../display/BitmapData";
import Stage from "../display/Stage";
import Stage3D from "../display/Stage3D";
import Error from "../errors/Error";
import EventDispatcher from "../events/EventDispatcher";
import Matrix3D from "../geom/Matrix3D";
import Point from "../geom/Point";
import Rectangle from "../geom/Rectangle";
import AGALMiniAssembler from "../utils/AGALMiniAssembler";
import ByteArray from "../utils/ByteArray";
import Vector from "../Vector";

/**
	The Context3D class provides a context for rendering geometrically defined graphics.
	A rendering context includes a drawing surface and its associated resources and
	this.__state. When possible, the rendering context uses the hardware graphics processing
	unit (GPU). Otherwise, the rendering context uses software. (If rendering through
	Context3D is not supported on a platform, the stage3Ds property of the Stage object
	contains an empty list.)

	The Context3D rendering context is a programmable pipeline that is very similar to
	OpenGL ES 2, but is abstracted so that it is compatible with a range of hardware and
	GPU interfaces. Although designed for 3D graphics, the rendering pipeline does not
	mandate that the rendering is three dimensional. Thus, you can create a 2D renderer
	by supplying the appropriate vertex and pixel fragment programs. In both the 3D and
	2D cases, the only geometric primitive supported is the triangle.

	Get an instance of the Context3D class by calling the requestContext3D() method of a
	Stage3D object. A limited number of Context3D objects can exist per stage; one for
	each Stage3D in the Stage.stage3Ds list. When the context is created, the Stage3D
	object dispatches a context3DCreate event. A rendering context can be destroyed and
	recreated at any time, such as when another application that uses the GPU gains
	focus. Your code should anticipate receiving multiple context3DCreate events.
	Position the rendering area on the stage using the x and y properties of the
	associated Stage3D instance.

	To render and display a scene (after getting a Context3D object), the following steps
	are typical:

	1. Configure the main display buffer attributes by calling `configureBackBuffer()`.
	2. Create and initialize your rendering resources, including:
	   * Vertex and index buffers defining the scene geometry
	   * Vertex and pixel programs (shaders) for rendering the scene
	   * Textures
	3. Render a frame:
	   * Set the render state as appropriate for an object or collection of objects in
	   the scene.
	   * Call the `drawTriangles()` method to render a set of triangles.
	   * Change the rendering state for the next group of objects.
	   * Call `drawTriangles()` to draw the triangles defining the objects.
	   * Repeat until the scene is entirely rendered.
	   * Call the `present()` method to display the rendered scene on the stage.

	The following limits apply to rendering:

	Resource limits:

	| Resource | Number allowed | Total memory |
	| --- | --- | --- |
	| Vertex buffers | 4096 | 256 MB |
	| Index buffers | 4096 | 128 MB |
	| Programs | 4096 | 16 MB |
	| Textures | 4096 | 128 MB |
	| Cube textures | 4096 | 256 MB |

	AGAL limits: 200 opcodes per program.

	Draw call limits: 32,768 `drawTriangles()` calls for each `present()` call.

	The following limits apply to textures:

	Texture limits for AIR 32 bit:

	| Texture | Maximum size | Total GPU memory |
	| --- | --- | --- |
	| Normal Texture (below Baseline extended) | 2048x2048 | 512 MB |
	| Normal Texture (Baseline extended and above) | 4096x4096 | 512 MB |
	| Rectangular Texture (below Baseline extended) | 2048x2048 | 512 MB |
	| Rectangular Texture (Baseline extended and above) | 4096x4096 | 512 MB |
	| Cube Texture | 1024x1024 | 256 MB |

	Texture limits for AIR 64 bit (Desktop):

	| Texture | Maximum size | Total GPU memory |
	| --- | --- | --- |
	| Normal Texture (below Baseline extended) | 2048x2048 | 512 MB |
	| Normal Texture (Baseline extended to Standard) | 4096x4096 | 512 MB |
	| Normal Texture (Standard extended and above) | 4096x4096 | 2048 MB |
	| Rectangular Texture (below Baseline extended) | 2048x2048 | 512 MB |
	| Rectangular Texture (Baseline extended to Standard) | 4096x4096 | 512 MB |
	| Rectangular Texture (Standard extended and above) | 4096x4096 | 2048 MB |
	| Cube Texture | 1024x1024 | 256 MB |

	512 MB is the absolute limit for textures, including the texture memory required
	for mipmaps. However, for Cube Textures, the memory limit is 256 MB.

	You cannot create Context3D objects with the Context3D constructor. It is
	constructed and available as a property of a Stage3D instance. The Context3D class
	can be used on both desktop and mobile platforms, both when running in Flash Player
	and AIR.
**/
export default class Context3D extends EventDispatcher
{
	protected static __supportsBGRA: null | boolean = null;
	protected static __supportsVideoTexture: boolean = true;

	protected __backBufferAntiAlias: number;
	protected __backBufferHeight: number = 0;
	protected __backBufferWidth: number = 0;
	protected __backBufferTexture: RectangleTexture;
	protected __backBufferWantsBestResolution: boolean;
	protected __backBufferWantsBestResolutionOnBrowserZoom: boolean;
	protected __bitmapDataPool: BitmapDataPool;
	protected __cleared: boolean;
	protected __contextState: Context3DState;
	protected __driverInfo: string = "OpenGL (Direct blitting)";
	protected __enableErrorChecking: boolean;
	protected __fragmentConstants: Float32Array;
	protected __frontBufferTexture: RectangleTexture;
	protected __maxBackBufferHeight: number;
	protected __maxBackBufferWidth: number;
	protected __present: boolean;
	protected __profile: Context3DProfile = Context3DProfile.STANDARD;
	protected __programs: Map<string, Program3D>;
	protected __quadIndexBuffer: IndexBuffer3D;
	protected __quadIndexBufferCount: number;
	protected __quadIndexBufferElements: number;
	protected __renderStage3DProgram: Program3D;
	protected __stage: Stage;
	protected __stage3D: Stage3D;
	protected __state: Context3DState;
	protected __vertexConstants: Float32Array;

	protected constructor(stage: Stage, contextState: Context3DState = null, stage3D: Stage3D = null)
	{
		super();

		this.__stage = stage;
		this.__contextState = contextState;
		this.__stage3D = stage3D;

		if (this.__contextState == null) this.__contextState = new Context3DState();
		this.__state = new Context3DState();

		// TODO: Dummy impl?
		this.__vertexConstants = new Float32Array(4 * 128);
		this.__fragmentConstants = new Float32Array(4 * 128);

		this.__programs = new Map<string, Program3D>();

		// this.__backend = new Context3DBackend(this);

		this.__bitmapDataPool = new BitmapDataPool(30, this);

		this.__quadIndexBufferElements = Math.floor(0xFFFF / 4);
		this.__quadIndexBufferCount = this.__quadIndexBufferElements * 6;

		// TODO: Dummy impl?
		var data = new Uint16Array(this.__quadIndexBufferCount);

		var index: number = 0;
		var vertex: number = 0;

		for (let i = 0; i < this.__quadIndexBufferElements; i++)
		{
			data[index] = vertex;
			data[index + 1] = vertex + 1;
			data[index + 2] = vertex + 2;
			data[index + 3] = vertex + 2;
			data[index + 4] = vertex + 1;
			data[index + 5] = vertex + 3;

			index += 6;
			vertex += 4;
		}

		this.__quadIndexBuffer = this.createIndexBuffer(this.__quadIndexBufferCount);
		this.__quadIndexBuffer.uploadFromTypedArray(data);
	}

	/**
		Clears the color, depth, and stencil buffers associated with this Context3D
		object and fills them with the specified values.

		Set the `mask` parameter to specify which buffers to clear. Use the constants
		defined in the Context3DClearMask class to set the `mask` parameter. Use the
		bitwise OR operator, "|", to add multiple buffers to the mask (or use
		Context3DClearMask.ALL). When rendering to the back buffer, the
		`configureBackBuffer()` method must be called before any `clear()` calls.

		**Note:** If you specify a parameter value outside the allowed range, Numeric
		parameter values are silently clamped to the range zero to one. Likewise, if
		stencil is greater than 0xff it is set to 0xff.

		@param	red	the red component of the color with which to clear the color buffer,
		in the range zero to one.
		@param	green	the green component of the color with which to clear the color
		buffer, in the range zero to one.
		@param	blue	the blue component of the color with which to clear the color
		buffer, in the range zero to one.
		@param	alpha	the alpha component of the color with which to clear the color
		buffer, in the range zero to one. The alpha component is not used for blending.
		It is written to the buffer alpha directly.
		@param	depth	the value with which to clear the depth buffer, in the range
		zero to one.
		@param	stencil	the 8-bit value with which to clear the stencil buffer, in a
		range of 0x00 to 0xff.
		@param	mask	specifies which buffers to clear.
		@throws	Error	Object Disposed: If this Context3D object has been disposed by a calling
		dispose() or because the underlying rendering hardware has been lost.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public clear(red: number = 0, green: number = 0, blue: number = 0, alpha: number = 1, depth: number = 1, stencil: number = 0,
		mask: number = Context3DClearMask.ALL): void
	{
		// this.__backend.clear(red, green, blue, alpha, depth, stencil, mask);
	}

	/**
		Sets the viewport dimensions and other attributes of the rendering buffer.

		Rendering is double-buffered. The back buffer is swapped with the visible,
		front buffer when the `present()` method is called. The minimum size of the
		buffer is 32x32 pixels. The maximum size of the back buffer is limited by the
		device capabilities and can also be set by the user through the properties
		`maxBackBufferWidth` and `maxBackBufferHeight`. Configuring the buffer is a
		slow operation. Avoid changing the buffer size or attributes during normal
		rendering operations.

		@param	width	width in pixels of the buffer.
		@param	height	height in pixels of the buffer.
		@param	antiAlias	an integer value specifying the requested antialiasing
		quality. The value correlates to the number of subsamples used when
		antialiasing. Using more subsamples requires more calculations to be performed,
		although the relative performance impact depends on the specific rendering
		hardware. The type of antialiasing and whether antialiasing is performed at all is
		dependent on the device and rendering mode. Antialiasing is not supported at all by
		the software rendering context.
		| --- | --- |
		| 0 | No antialiasing |
		| 2 | Minimal antialiasing |
		| 4 | High-quality antialiasing |
		| 16 | Very high-quality antialiasing |
		@param	enableDepthAndStencil	`false` indicates no depth or stencil buffer is
		created, `true` creates a depth and a stencil buffer. For an AIR 3.2 or later
		application compiled with SWF version 15 or higher, if the `renderMode` element in
		the application descriptor file is `direct`, then the `depthAndStencil` element in
		the application descriptor file must have the same value as this argument. By
		default, the value of the `depthAndStencil` element is `false`.
		@param	wantsBestResolution	`true` indicates that if the device supports HiDPI
		screens it will attempt to allocate a larger back buffer than indicated with the
		`width` and `height` parameters. Since this add more pixels and potentially changes
		the result of shader operations this is turned off by default. Use
		`Stage.contentsScaleFactor` to determine by how much the native back buffer was
		scaled up.
		@param	wantsBestResolutionOnBrowserZoom	`true` indicates that the size of the
		back buffer should increase in proportion to the increase in the browser zoom
		factor. The setting of this value is persistent across multiple browser zooms.
		The default value of the parameter is `false`. Set `maxBackBufferWidth` and
		`maxBackBufferHeight` properties to limit the back buffer size increase. Use
		`backBufferWidth` and `backBufferHeight` to determine the current size of the
		back buffer.
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	Bad Input Size: The `width` or `height` parameter is either less
		than the minimum back buffer allowed size or greater than the maximum back buffer
		size allowed.
		@throws	Error	3709: The `depthAndStencil` flag in the application descriptor
		must match the `enableDepthAndStencil` Boolean passed to `configureBackBuffer()`
		on the Context3D object.
	**/
	public configureBackBuffer(width: number, height: number, antiAlias: number, enableDepthAndStencil: boolean = true, wantsBestResolution: boolean = false,
		wantsBestResolutionOnBrowserZoom: boolean = false): void
	{
		// this.__backend.configureBackBuffer(width, height, antiAlias, enableDepthAndStencil, wantsBestResolution, wantsBestResolutionOnBrowserZoom);
	}

	/**
		Creates a CubeTexture object.

		Use a CubeTexture object to upload cube texture bitmaps to the rendering context
		and to reference a cube texture during rendering. A cube texture consists of six
		equal-sized, square textures arranged in a cubic topology and are useful for
		describing environment maps.

		You cannot create CubeTexture objects with a CubeTexture constructor; use this
		method instead. After creating a CubeTexture object, upload the texture bitmap
		data using the CubeTexture `uploadFromBitmapData()`, `uploadFromByteArray()`, or
		`uploadCompressedTextureFromByteArray()` methods.

		@param size	The texture edge length in texels.
		@param format	The texel format, of the Context3DTextureFormat enumerated list.
		Texture compression lets you store texture images in compressed format directly on
		the GPU, which saves GPU memory and memory bandwidth. Typically, compressed
		textures are compressed offline and uploaded to the GPU in compressed form
		using the `Texture.uploadCompressedTextureFromByteArray` method. Flash Player 11.4
		and AIR 3.4 on desktop platforms added support for runtime texture compression,
		which may be useful in certain situations, such as when rendering dynamic
		textures from vector art. Note that this feature is not currently available on
		mobile platforms and an ArgumentError (Texture Format Mismatch) will be thrown
		instead. To use runtime texture compression, perform the following steps:
		1. Create the texture object by calling the `Context3D.createCubeTexture()`
		method, passing either `openfl.display3D.Context3DTextureFormat.COMPRESSED` or
		`openfl.display3D.Context3DTextureFormat.COMPRESSED_ALPHA` as the format
		parameter.
		2. Using the openfl.display3D.textures.Texture instance returned by
		`createCubeTexture()`, call either
		`openfl.display3D.textures.CubeTexture.uploadFromBitmapData()` or
		`openfl.display3D.textures.CubeTexture.uploadFromByteArray()` to upload and
		compress the texture in one step.
		@param optimizeForRenderToTexture	Set to true if the texture is likely to be
		used as a render target.
		@param streamingLevels	The MIP map level that must be loaded before the image
		is rendered. Texture streaming offers the ability to load and display the
		smallest mip levels first, progressively displaying higher quality images as the
		textures are loaded. End users can view lower-quality images in an application
		while the higher quality images load.

		By default, streamingLevels is 0, meaning that the highest quality image in the
		MIP map must be loaded before the image is rendered. This parameter was added in
		Flash Player 11.3 and AIR 3.3. Using the default value maintains the behavior of
		the previous versions of Flash Player and AIR.

		Set streamingLevels to a value between 1 and the number of images in the MIP map
		to enable texture streaming. For example, you have a MIP map that includes at the
		highest quality a main image at 64x64 pixels. Lower quality images in the MIP map
		are 32x32, 16x16, 8x8, 4x4, 2x2, and 1x1 pixels, for 7 images in total, or 7
		levels. Level 0 is the highest quality image. The maximum value of this property
		is log2(min(width,height)). Therefore, for a main image that is 64x64 pixels, the
		maximum value of streamingLevels is 7. Set this property to 3 to render the image
		after the 8x8 pixel image loads.

		**Note:** Setting this property to a value > 0 can impact memory usage and
		performance.

		@return	A new CubeTexture object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many Texture objects are created
		or the amount of memory allocated to textures is exceeded.
		@throws	ArgumentError	Depth Texture Not Implemented: if you attempt to create
		a depth texture.
		@throws	ArgumentError	Texture Size Is Zero: if the size parameter is not greater
		than zero.
		@throws	ArgumentError	Texture Not Power Of Two: if the size parameter is not a
		power of two.
		@throws	ArgumentError	Texture Too Big: if the size parameter is greater than
		1024.
		@throws	Error	Texture Creation Failed: if the CubeTexture object could not be
		created by the rendering context (but information about the reason is not
		available).
		@throws	ArgumentError	Invalid streaming level: if streamingLevels is greater or
		equal to `log2(size)`.
	**/
	public createCubeTexture(size: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean, streamingLevels: number = 0): CubeTexture
	{
		return new (<internal.CubeTexture><any>CubeTexture)(this, size, format, optimizeForRenderToTexture, streamingLevels);
	}

	/**
		Creates an IndexBuffer3D object.

		Use an IndexBuffer3D object to upload a set of triangle indices to the rendering
		context and to reference that set of indices for rendering. Each index in the
		index buffer references a corresponding vertex in a vertex buffer. Each set of
		three indices identifies a triangle. Pass the IndexBuffer3D object to the
		`drawTriangles()` method to render one or more triangles defined in the index
		buffer.

		You cannot create IndexBuffer3D objects with the IndexBuffer3D class constructor;
		use this method instead. After creating a IndexBuffer3D object, upload the
		indices using the IndexBuffer3D `uploadFromVector()` or `uploadFromByteArray()`
		methods.

		@param	numIndices	the number of vertices to be stored in the buffer.
		@param	bufferUsage	the expected buffer usage. Use one of the constants defined
		in Context3DBufferUsage. The hardware driver can do appropriate optimization
		when you set it correctly. This parameter is only available after Flash 12/AIR 4.
		@return	A new IndexBuffer3D object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many index buffers are created
		or the amount of memory allocated to index buffers is exceeded.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	ArgumentError	Buffer Too Big: when `numIndices` is greater than or equal
		to 0xf0000.
	**/
	public createIndexBuffer(numIndices: number, bufferUsage: Context3DBufferUsage = Context3DBufferUsage.STATIC_DRAW): IndexBuffer3D
	{
		return new (<internal.IndexBuffer3D><any>IndexBuffer3D)(this, numIndices, bufferUsage);
	}

	/**
		Creates a Program3D object.

		Use a Program3D object to upload shader programs to the rendering context and
		to reference uploaded programs during rendering. A Program3D object stores
		two programs, a vertex program and a fragment program (also known as a pixel
		program). The programs are written in a binary shader assembly language.

		You cannot create Program3D objects with a Program3D constructor; use this method
		instead. After creating a Program3D object, upload the programs using the
		Program3D `upload()` method.

		@param	format	(Experimental) Set the format of this Program3D instance to AGAL
		(default) or to GLSL for use on GL-based renderers
		@return	A new Program3D object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	The number of programs exceeds 4096 or the total memory size
		exceeds 16MB (use dispose to free Program3D resources).
	**/
	public createProgram(format: Context3DProgramFormat = Context3DProgramFormat.AGAL): Program3D
	{
		return new (<internal.Program3D><any>Program3D)(this, format);
	}

	/**
		Creates a Rectangle Texture object.

		Use a RectangleTexture object to upload texture bitmaps to the rendering context
		and to reference a texture during rendering.

		You cannot create RectangleTexture objects with a RectangleTexture constructor;
		use this method instead. After creating a RectangleTexture object, upload the
		texture bitmaps using the Texture `uploadFromBitmapData()` or
		`uploadFromByteArray()` methods.

		Note that 32-bit integer textures are stored in a packed BGRA format to match
		the OpenFL BitmapData format. Floating point textures use a conventional RGBA
		format.

		Rectangle textures are different from regular 2D textures in that their width and
		height do not have to be powers of two. Also, they do not contain mip maps.
		They are most useful for use in render to texture cases. If a rectangle texture
		is used with a sampler that uses mip map filtering or repeat wrapping the
		drawTriangles call will fail. Rectangle texture also do not allow streaming. The
		only texture formats supported by Rectangle textures are BGRA, BGR_PACKED,
		BGRA_PACKED. The compressed texture formats are not supported by Rectangle
		Textures.

		@param	width	The texture width in texels.
		@param	height	The texture height in texels.
		@param	format	The texel format, of the Context3DTextureFormat enumerated list.
		@param	optimizeForRenderToTexture	Set to true if the texture is likely to be
		used as a render target.
		@return	A new RectangleTexture object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling dispose() or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many Texture objects are created
		or the amount of memory allocated to textures is exceeded.
		@throws	ArgumentError	Texture Size Is Zero: if both the width or height
		parameters are not greater than zero.
		@throws	ArgumentError	Texture Too Big: if either the width or the height
		parameter is greater than 2048.
		@throws	Error	Texture Creation Failed: if the Texture object could not be
		created by the rendering context (but information about the reason is not
		available).
		@throws	Error	Requires Baseline Profile Or Above: if rectangular texture is
		created with baseline constrained profile.
	**/
	public createRectangleTexture(width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean): RectangleTexture
	{
		return new (<internal.RectangleTexture><any>RectangleTexture)(this, width, height, format, optimizeForRenderToTexture);
	}

	/**
		Creates a Texture object.

		Use a Texture object to upload texture bitmaps to the rendering context and to
		reference a texture during rendering.

		You cannot create Texture objects with a Texture constructor; use this method
		instead. After creating a Texture object, upload the texture bitmaps using the
		Texture `uploadFromBitmapData()`, `uploadFromByteArray()`, or
		`uploadCompressedTextureFromByteArray()` methods.

		Note that 32-bit integer textures are stored in a packed BGRA format to match
		the OpenFL BitmapData format. Floating point textures use a conventional RGBA
		format.

		@param	width	The texture width in texels.
		@param	height	The texture height in texels.
		@param	format	The texel format, of the Context3DTextureFormat enumerated list.
		Texture compression lets you store texture images in compressed format directly
		on the GPU, which saves GPU memory and memory bandwidth. Typically, compressed
		textures are compressed offline and uploaded to the GPU in compressed form using
		the Texture.uploadCompressedTextureFromByteArray method. Flash Player 11.4 and
		AIR 3.4 on desktop platforms added support for runtime texture compression, which
		may be useful in certain situations, such as when rendering dynamic textures from
		vector art. Note that this feature is not currently available on mobile platforms
		and an ArgumentError (Texture Format Mismatch) will be thrown instead. To use
		runtime texture compression, perform the following steps:
		1. Create the texture object by calling the `Context3D.createTexture()` method,
		passing either `openfl.display3D.Context3DTextureFormat.COMPRESSED` or
		`openfl.display3D.Context3DTextureFormat.COMPRESSED_ALPHA` as the format
		parameter.
		2. Using the openfl.display3D.textures.Texture instance returned by
		`createTexture()`, call either
		`openfl.display3D.textures.Texture.uploadFromBitmapData()` or
		`openfl.display3D.textures.Texture.uploadFromByteArray()` to upload and compress
		the texture in one step.
		@param	optimizeForRenderToTexture	Set to true if the texture is likely to be
		used as a render target.
		@param	streamingLevels	The MIP map level that must be loaded before the image is
		rendered. Texture streaming offers the ability to load and display the smallest
		mip levels first, progressively displaying higher quality images as the textures
		are loaded. End users can view lower-quality images in an application while the
		higher quality images load.

		By default, streamingLevels is 0, meaning that the highest quality image in the
		MIP map must be loaded before the image is rendered. This parameter was added in
		Flash Player 11.3 and AIR 3.3. Using the default value maintains the behavior of
		the previous versions of Flash Player and AIR.

		Set `streamingLevels` to a value between 1 and the number of images in the MIP map
		to enable texture streaming. For example, you have a MIP map that includes at
		the highest quality a main image at 64x64 pixels. Lower quality images in the
		MIP map are 32x32, 16x16, 8x8, 4x4, 2x2, and 1x1 pixels, for 7 images in total,
		or 7 levels. Level 0 is the highest quality image. The maximum value of this
		property is log2(min(width,height)). Therefore, for a main image that is
		64x64 pixels, the maximum value of streamingLevels is 7. Set this property to
		3 to render the image after the 8x8 pixel image loads.

		**Note:** Setting this property to a value > 0 can impact memory usage and
		performance.

		@return	A new Texture object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a calling dispose() or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many Texture objects are created or the amount of memory allocated to textures is exceeded.
		@throws	ArgumentError	Depth Texture Not Implemented: if you attempt to create a depth texture.
		@throws	ArgumentError	Texture Size Is Zero: if both the width or height parameters are not greater than zero.
		@throws	ArgumentError	Texture Not Power Of Two: if both the width and height parameters are not a power of two.
		@throws	ArgumentError	Texture Too Big: if either the width or the height parameter is greater than 2048 for baseline and baseline constrained profile or if either the width or the height parameter is greater than 4096 for profile baseline extended and above.
		@throws	Error	Texture Creation Failed: if the Texture object could not be created by the rendering context (but information about the reason is not available).
		@throws	ArgumentError	Invalid streaming level: if streamingLevels is greater or equal to log2(min(width,height)).
	**/
	public createTexture(width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean, streamingLevels: number = 0): Texture
	{
		return new (<internal.Texture><any>Texture)(this, width, height, format, optimizeForRenderToTexture, streamingLevels);
	}

	/**
		Creates a VertexBuffer3D object.

		Use a VertexBuffer3D object to upload a set of vertex data to the rendering
		context. A vertex buffer contains the data needed to render each point in the
		scene geometry. The data attributes associated with each vertex typically
		includes position, color, and texture coordinates and serve as the input to
		the vertex shader program. Identify the data values that correspond to one of
		the inputs of the vertex program using the `setVertexBufferAt()` method. You can
		specify up to sixty-four 32-bit values for each vertex.

		You cannot create VertexBuffer3D objects with a VertexBuffer3D constructor; use
		this method instead. After creating a VertexBuffer3D object, upload the vertex
		data using the VertexBuffer3D `uploadFromVector()` or `uploadFromByteArray()`
		methods.

		@param	numVertices	the number of vertices to be stored in the buffer. The
		maximum number of vertices in a single buffer is 65535.
		@param	data32PerVertex	the number of 32-bit(4-byte) data values associated
		with each vertex. The maximum number of 32-bit data elements per vertex is 64
		(or 256 bytes). Note that only eight attribute registers are accessible by a
		vertex shader program at any given time. Use `setVertextBufferAt()` to select
		attributes from within a vertex buffer.
		@param	bufferUsage	the expected buffer usage. Use one of the constants defined
		in Context3DBufferUsage. The hardware driver can do appropriate optimization when
		you set it correctly. This parameter is only available after Flash 12/AIR 4
		@return	A new VertexBuffer3D object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many vertex buffer objects are
		created or the amount of memory alloted to vertex buffers is exceeded.
		@throws	ArgumentError	Buffer Too Big: when `numVertices` is greater than 0x10000
		or `data32PerVertex` is greater than 64.
		@throws	ArgumentError	Buffer Has Zero Size: when `numVertices` is zero or
		`data32PerVertex` is zero.
		@throws	ArgumentError	Buffer Creation Failed: if the VertexBuffer3D object
		could not be created by the rendering context (but additional information about
		the reason is not available).
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public createVertexBuffer(numVertices: number, data32PerVertex: number, bufferUsage: Context3DBufferUsage = Context3DBufferUsage.STATIC_DRAW): VertexBuffer3D
	{
		return new (<internal.VertexBuffer3D><any>VertexBuffer3D)(this, numVertices, data32PerVertex, bufferUsage);
	}

	/**
		Creates a VideoTexture object.

		Use a VideoTexture object to obtain video frames as texture from NetStream object
		or Camera object and to upload the video frames to the rendering context.

		The VideoTexture object cannot be created with the VideoTexture constructor; use
		this method instead. After creating a VideoTexture object, attach NetStream
		object or Camera Object to get the video frames with the VideoTexture
		`attachNetStream()` or `attachCamera()` methods.

		Note that this method returns null if the system doesn't support this feature.

		VideoTexture does not contain mipmaps. If VideoTexture is used with a sampler
		that uses mip map filtering or repeat wrapping, the drawTriangles call will fail.
		VideoTexture can be treated as BGRA texture by the shaders. The attempt to
		instantiate the VideoTexture Object will fail if the Context3D was requested
		with sotfware rendering mode.

		A maximum of 4 VideoTexture objects are available per Context3D instance. On
		mobile the actual number of supported VideoTexture objects may be less than 4
		due to platform limitations.

		@return	A new VideoTexture object
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	Resource Limit Exceeded: if too many Texture objects are created
		or the amount of memory allocated to textures is exceeded.
		@throws	Error	Texture Creation Failed: if the Texture object could not be
		created by the rendering context (but information about the reason is not
		available).
	**/
	public createVideoTexture(): VideoTexture
	{
		if (Context3D.supportsVideoTexture)
		{
			return new (<internal.VideoTexture><any>VideoTexture)(this);
		}
		else
		{
			throw new Error("Video textures are not currently supported");
			return null;
		}
	}

	/**
		Frees all resources and internal storage associated with this Context3D.

		All index buffers, vertex buffers, textures, and programs that were created
		through this Context3D are disposed just as if calling `dispose()` on each of
		them individually. In addition, the Context3D itself is disposed freeing all
		temporary buffers and the back buffer. If you call `configureBackBuffer()`,
		`clear()`, `drawTriangles()`, `createCubeTexture()`, `createTexture()`,
		`createProgram()`, `createIndexBuffer()`, `createVertexBuffer()`, or
		`drawToBitmapData()` after calling `dispose()`, the runtime throws an exception.

		Warning: calling `dispose()` on a Context3D while there is still a event
		listener for `Events.CONTEXT3D_CREATE` set on the asociated Stage3D object the
		`dispose()` call will simulate a device loss. It will create a new Context3D on
		the Stage3D and issue the `Events.CONTEXT3D_CREATE` event again. If this is not
		desired remove the event listener from the Stage3D object before calling
		`dispose()` or set the `recreate` parameter to `false`.

		@param	recreate	Whether to allow this Stage3D object to create itself again
	**/
	public dispose(recreate: boolean = true): void
	{
		// this.__backend.dispose(recreate);

		this.__renderStage3DProgram = null;
		this.__frontBufferTexture = null;
		this.__present = false;
		this.__backBufferTexture = null;
		this.__fragmentConstants = null;
		this.__quadIndexBuffer = null;
		this.__stage = null;
		this.__vertexConstants = null;
	}

	/**
		Draws the current render buffer to a bitmap.

		The current contents of the back render buffer are copied to a BitmapData
		object. This is potentially a very slow operation that can take up to a second.
		Use with care. Note that this does not copy the front render buffer
		(the one shown on stage), but the buffer being drawn to. To capture the rendered
		image as it appears on the stage, call `drawToBitmapData()` immediately before you
		calling `present()`.

		Beginning with AIR 25, two new parameters have been introduced in the API
		`drawToBitmapData()`. This API now takes three parameters. The first one is the
		existing parameter `destination:BitmapData`. The second parameter is
		`srcRect:Rectangle`, which is target rectangle on Stage3D. The third parameter is
		`destPoint:Point`, which is the coordinate on the destination bitmap. The
		parameters `srcRect` and `destPoint` are optional and default to
		`(0,0,bitmapWidth,bitmapHeight)` and `(0,0)`, respectively.

		When the image is drawn, it is not scaled to fit the bitmap. Instead, the
		contents are clipped to the size of the destination bitmap.

		OpenFL BitmapData objects store colors already multiplied by the alpha component.
		For example, if the "pure" rgb color components of a pixel are (0x0A, 0x12, 0xBB)
		and the alpha component is 0x7F (.5), then the pixel is stored in the
		BitmapData object with the rgba values: (0x05, 0x09, 0x5D, 0x7F). You can set the
		blend factors so that the colors rendered to the buffer are multiplied by alpha
		or perform the operation in the fragment shader. The rendering context does not
		validate that the colors are stored in premultiplied format.

		@param	destination	The target BitmapData for this drawing operation
		@param	srcRect	The source rectangle in the current Stage3D context
		@param	destPoint A destination point to write to in the target BitmapData
		@throws	Error	Object Disposed: if this Context3D object has been disposed by
		a calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	Error	3802: If either one of the parameters `destPoint:Point` or
		`srcRect:Rectangle` is outside the bitmap/stage3D coordinate bound, or if
		non-numeric(NaN) values are passed as input.
	**/
	public drawToBitmapData(destination: BitmapData, srcRect: Rectangle = null, destPoint: Point = null): void
	{
		// this.__backend.drawToBitmapData(destination, srcRect, destPoint);
	}

	/**
		Render the specified triangles using the current buffers and state of this
		Context3D object.

		For each triangle, the triangle vertices are processed by the vertex shader
		program and the triangle surface is processed by the pixel shader program. The
		output color from the pixel program for each pixel is drawn to the render
		target depending on the stencil operations, depth test, source and destination
		alpha, and the current blend mode. The render destination can be the main render
		buffer or a texture.

		If culling is enabled, (with the `setCulling()` method), then triangles can be
		discarded from the scene before the pixel program is run. If stencil and depth
		testing are enabled, then output pixels from the pixel program can be discarded
		without updating the render destination. In addition, the pixel program can
		decide not to output a color for a pixel.

		The rendered triangles are not displayed in the viewport until you call the
		`present()` method. After each `present()` call, the `clear()` method must be
		called before the first `drawTriangles()` call or rendering fails.

		When `enableErrorChecking` is `false`, this returns immediately, does
		not wait for results, and throws exceptions only if this Context3D instance has
		been disposed or there are too many draw calls. If the rendering context state
		is invalid rendering fails silently. When the `enableErrorChecking` property is
		`true`, this returns after the triangles are drawn and throws exceptions
		for any drawing errors or invalid context this.__state.

		@param	indexBuffer:IndexBuffer3D — a set of vertex indices referencing the
		vertices to render.
		@param	firstIndex:int (default = 0) — the index of the first vertex index
		selected to render. Default 0.
		@param	numTriangles:int (default = -1) — the number of triangles to render.
		Each triangle consumes three indices. Pass -1 to draw all triangles in the index
		buffer. Default -1.
		@throws	Error — Object Disposed: if this Context3D object has been disposed by
		a calling `dispose()` or because the underlying rendering hardware has been lost.
		@throws	Error — If this method is called too many times between calls to
		`present()`. The maximum number of calls is 32,768.

		The following errors are only thrown when `enableErrorChecking` property is true:
		@throws	Error	Need To Clear Before Draw: If the buffer has not been cleared
		since the last `present()` call.
		@throws	Error	If a valid Program3D object is not set.
		@throws	Error	No Valid Index Buffer Set: If an IndexBuffer3D object is not set.
		@throws	Error	Sanity Check On Parameters Failed: when the number of triangles
		to be drawn or the `firstIndex` exceed allowed values.
		@throws	RangeError — Not Enough Indices In This Buffer: when there aren't enough
		indices in the buffer to define the number of triangles to be drawn.
		@throws	Error — Sample Binds Texture Also Bound To Render: when the render target
		is a texture and that texture assigned to a texture input of the current fragment
		program.
		@throws	Error — Sample Binds Invalid Texture: an invalid texture is specified as
		the input to the current fragment program.
		@throws	Error — Sampler Format Does Not Match Texture Format: when the texture
		assigned as the input to the current fragment program has a different format than
		that specified for the sampler register. For example, a 2D texture is assigned to
		a cube texture sampler.
		@throws	Error — Sample Binds Undefined Texture: The current fragment program
		accesses a texture register that has not been set (using `setTextureAt()`).
		@throws	Error — Same Texture Needs Same Sampler Params: If a texture is used for
		more than one sampler register, all of the samplers must have the same settings.
		For example, you cannot set one sampler to clamp and another to wrap.
		@throws	Error — Texture Bound But Not Used: A texture is set as a shader input,
		but it is not used.
		@throws	Error — Stream Is Not Used: A vertex buffer is assigned to a vertex
		attribute input, but the vertex program does not reference the corresponding
		register.
		@throws	Error — Stream Is Invalid: a VertexBuffer3D object assigned to a vertex
		program input is not a valid object.
		@throws	RangeError — Stream Does Not Have Enough Vertices: A vertex buffer
		supplying data for drawing the specified triangles does not have enough data.
		@throws	RangeError — Stream Vertex Offset Out Of Bounds: The offset specified in
		a `setVertexBufferAt()` call is negative or past the end of the buffer.
		@throws	Error — Stream Read But Not Set: A vertex attribute used by the current
		vertex program is not set (using `setVertexBufferAt()`).
	**/
	public drawTriangles(indexBuffer: IndexBuffer3D, firstIndex: number = 0, numTriangles: number = -1): void
	{
		// this.__backend.drawTriangles(indexBuffer, firstIndex, numTriangles);
	}

	/**
		Displays the back rendering buffer.

		Calling the `present()` method makes the results of all rendering operations
		since the last `present()` call visible and starts a new rendering cycle.
		After calling `present`, you must call `clear()` before making another
		`drawTriangles()` call. Otherwise, this will alternately clear the
		render buffer to yellow and green or, if `enableErrorChecking` has been set to
		`true`, an exception is thrown.

		Calling `present()` also resets the render target, just like calling
		`setRenderToBackBuffer()`.

		@throws	Error	Need To Clear Before Draw: If the `clear()` has not been called
		since the previous call to `present()`. (Two consecutive `present()` calls are
		not allowed without calling `clear()` in between.)
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public present(): void
	{
		// this.__backend.present();
	}

	/**
		Specifies the factors used to blend the output color of a drawing operation with
		the existing color.

		The output (source) color of the pixel shader program is combined with the
		existing (destination) color at that pixel according to the following formula:

		`result color = (source color * sourceFactor) + (destination color * destinationFactor)`

		The destination color is the current color in the render buffer for that pixel.
		Thus it is the result of the most recent `clear()` call and any intervening
		`drawTriangles()` calls.

		Use `setBlendFactors()` to set the factors used to multiply the source and
		destination colors before they are added together. The default blend factors
		are, `sourceFactor = Context3DBlendFactor.ONE`, and
		`destinationFactor = Context3DBlendFactor.ZERO`, which results in the source
		color overwriting the destination color (in other words, no blending of the
		two colors occurs). For normal alpha blending, use
		`sourceFactor = Context3DBlendFactor.SOURCE_ALPHA` and
		`destinationFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA`.

		Use the constants defined in the Context3DBlendFactor class to set the
		parameters of this function.

		@param	sourceFactor	The factor with which to multiply the source color.
		Defaults to `Context3DBlendFactor.ONE`.
		@param	destinationFactor	The factor with which to multiply the destination
		color. Defaults to `Context3DBlendFactor.ZERO`.
		@throws	Error — Invalid Enum: when `sourceFactor` or `destinationFactor` is
		not one of the recognized values, which are defined in the
		Context3DBlendFactor class.
	**/
	public setBlendFactors(sourceFactor: Context3DBlendFactor, destinationFactor: Context3DBlendFactor): void
	{
		this.setBlendFactorsSeparate(sourceFactor, destinationFactor, sourceFactor, destinationFactor);
	}

	protected setBlendFactorsSeparate(sourceRGBFactor: Context3DBlendFactor, destinationRGBFactor: Context3DBlendFactor,
		sourceAlphaFactor: Context3DBlendFactor, destinationAlphaFactor: Context3DBlendFactor): void
	{
		this.__state.blendSourceRGBFactor = sourceRGBFactor;
		this.__state.blendDestinationRGBFactor = destinationRGBFactor;
		this.__state.blendSourceAlphaFactor = sourceAlphaFactor;
		this.__state.blendDestinationAlphaFactor = destinationAlphaFactor;

		// TODO: Better way to handle this?
		// this.__backend.resetGLBlendEquation();
	}

	/**
		Sets the mask used when writing colors to the render buffer.

		Only color components for which the corresponding color mask parameter is `true`
		are updated when a color is written to the render buffer. For example, if
		you call: `setColorMask(true, false, false, false)`, only the red component
		of a color is written to the buffer until you change the color mask again. The
		color mask does not affect the behavior of the `clear()` method.

		@param	red	set false to block changes to the red channel.
		@param	green	set false to block changes to the green channel.
		@param	blue	set false to block changes to the blue channel.
		@param	alpha	set false to block changes to the alpha channel.
	**/
	public setColorMask(red: boolean, green: boolean, blue: boolean, alpha: boolean): void
	{
		this.__state.colorMaskRed = red;
		this.__state.colorMaskGreen = green;
		this.__state.colorMaskBlue = blue;
		this.__state.colorMaskAlpha = alpha;
	}

	/**
		Sets triangle culling mode.

		Triangles may be excluded from the scene early in the rendering pipeline based
		on their orientation relative to the view plane. Specify vertex order
		consistently (clockwise or counter-clockwise) as seen from the outside of the
		model to cull correctly.

		@param	triangleFaceToCull	the culling mode. Use one of the constants defined
		in the Context3DTriangleFace class.
		@throws	Error	Invalid Enum Error: when triangleFaceToCull is not one of the
		values defined in the Context3DTriangleFace class.
	**/
	public setCulling(triangleFaceToCull: Context3DTriangleFace): void
	{
		this.__state.culling = triangleFaceToCull;
	}

	/**
		Sets type of comparison used for depth testing.

		The depth of the source pixel output from the pixel shader program is compared
		to the current value in the depth buffer. If the comparison evaluates as `false`,
		then the source pixel is discarded. If `true`, then the source pixel is processed
		by the next step in the rendering pipeline, the stencil test. In addition, the
		depth buffer is updated with the depth of the source pixel, as long as the
		`depthMask` parameter is set to `true`.

		Sets the test used to compare depth values for source and destination pixels.
		The source pixel is composited with the destination pixel when the comparison is
		`true`. The comparison operator is applied as an infix operator between the
		source and destination pixel values, in that order.

		@param	depthMask	the destination depth value will be updated from the source
		pixel when `true`.
		@param	passCompareMode	the depth comparison test operation. One of the values
		of Context3DCompareMode.
	**/
	public setDepthTest(depthMask: boolean, passCompareMode: Context3DCompareMode): void
	{
		this.__state.depthMask = depthMask;
		this.__state.depthCompareMode = passCompareMode;
	}

	/**
		Sets vertex and fragment shader programs to use for subsequent rendering.

		@param	program	the Program3D object representing the vertex and fragment
		programs to use.
	**/
	public setProgram(program: Program3D): void
	{
		this.__state.program = program;
		this.__state.shader = null; // TODO: Merge this logic

		if (program != null)
		{
			for (let i = 0; i < (<internal.Program3D><any>program).__samplerStates.length; i++)
			{
				if (this.__state.samplerStates[i] == null)
				{
					this.__state.samplerStates[i] = (<internal.Program3D><any>program).__samplerStates[i].clone();
				}
				else
				{
					this.__state.samplerStates[i].copyFrom((<internal.Program3D><any>program).__samplerStates[i]);
				}
			}
		}
	}

	/**
		Set constants for use by shader programs using values stored in a ByteArray.

		Sets constants that can be accessed from the vertex or fragment program.

		@param	programType	one of Context3DProgramType.
		@param	firstRegister	the index of the first shader program constant to set.
		@param	numRegisters	the number of registers to set. Every register is read
		as four float values.
		@param	data	the source ByteArray object
		@param	byteArrayOffset	an offset into the ByteArray for reading
		@throws	TypeError	kNullPointerError when data is null.
		@throws	RangeError	kConstantRegisterOutOfBounds when attempting to set more than
		the maximum number of shader constants.
		@throws	RangeError	kBadInputSize if `byteArrayOffset` is greater than or equal to
		the length of data or no. of elements in `data - byteArrayOffset` is less than
		`numRegisters*16`
	**/
	public setProgramConstantsFromByteArray(programType: Context3DProgramType, firstRegister: number, numRegisters: number, data: ByteArray,
		byteArrayOffset: number): void
	{
		if (numRegisters == 0 || this.__state.program == null) return;

		if (this.__state.program != null && (<internal.Program3D><any>this.__state.program).__format == Context3DProgramFormat.GLSL)
		{
			// TODO
		}
		else
		{
			// TODO: Cleanup?

			if (numRegisters == -1)
			{
				numRegisters = ((data.length >> 2) - byteArrayOffset);
			}

			var isVertex = (programType == Context3DProgramType.VERTEX);
			var dest = isVertex ? this.__vertexConstants : this.__fragmentConstants;

			var floatData = new Float32Array((<internal.ByteArray><any>data).__buffer, 0, data.length);

			var outOffset = firstRegister * 4;
			var inOffset = Math.floor(byteArrayOffset / 4);

			for (let i = 0; i < (numRegisters * 4); i++)
			{
				dest[outOffset + i] = floatData[inOffset + i];
			}

			if (this.__state.program != null)
			{
				(<internal.Program3D><any>this.__state.program).__markDirty(isVertex, firstRegister, numRegisters);
			}
		}
	}

	/**
		Sets constants for use by shader programs using values stored in a Matrix3D.

		Use this to pass a matrix to a shader program. The sets 4
		constant registers used by the vertex or fragment program. The matrix is
		assigned to registers row by row. The first constant register is assigned the
		top row of the matrix. You can set 128 registers for a vertex program and 28
		for a fragment program.

		@param	programType	The type of shader program, either
		`Context3DProgramType.VERTEX` or `Context3DProgramType.FRAGMENT`.
		@param	firstRegister	the index of the first constant register to set. Since
		a Matrix3D has 16 values, four registers are set.
		@param	matrix	the matrix containing the constant values.
		@param	transposedMatrix	if `true` the matrix entries are copied to registers
		in transposed order. The default value is `false`.
		@throws	TypeError	Null Pointer Error: when matrix is `null`.
		@throws	RangeError	Constant Register Out Of Bounds: when attempting to set more
		than the maximum number of shader constant registers.
	**/
	public setProgramConstantsFromMatrix(programType: Context3DProgramType, firstRegister: number, matrix: Matrix3D, transposedMatrix: boolean = false): void
	{
		if (this.__state.program != null && (<internal.Program3D><any>this.__state.program).__format == Context3DProgramFormat.GLSL)
		{
			// this.__backend.setGLSLProgramConstantsFromMatrix(programType, firstRegister, matrix, transposedMatrix);
		}
		else
		{
			var isVertex = (programType == Context3DProgramType.VERTEX);
			var dest = isVertex ? this.__vertexConstants : this.__fragmentConstants;
			var source = matrix.rawData;
			var i = firstRegister * 4;

			if (transposedMatrix)
			{
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
			}
			else
			{
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

			if (this.__state.program != null)
			{
				(<internal.Program3D><any>this.__state.program).__markDirty(isVertex, firstRegister, 4);
			}
		}
	}

	/**
		Sets the constant inputs for the shader programs.

		Sets an array of constants to be accessed by a vertex or fragment shader
		program. Constants set in Program3D are accessed within the shader programs as
		constant registers. Each constant register is comprised of 4 floating point
		values (x, y, z, w). Therefore every register requires 4 entries in the data
		Vector. The number of registers that you can set for vertex program and
		fragment program depends on the Context3DProfile.

		@param	programType	The type of shader program, either
		`Context3DProgramType.VERTEX` or `Context3DProgramType.FRAGMENT`.
		@param	firstRegister	the index of the first constant register to set.
		@param	data	the floating point constant values. There must be at least
		`numRegisters` 4 elements in data.
		@param	numRegisters	the number of constants to set. Specify -1, the default
		value, to set enough registers to use all of the available data.
		@throws	TypeError	Null Pointer Error: when data is `null`.
		@throws	RangeError	Constant Register Out Of Bounds: when attempting to set more
		than the maximum number of shader constant registers.
		@throws	RangeError	Bad Input Size: When the number of elements in data is less
		than `numRegisters*4`
	**/
	public setProgramConstantsFromVector(programType: Context3DProgramType, firstRegister: number, data: Vector<number>, numRegisters: number = -1): void
	{
		if (numRegisters == 0) return;

		if (this.__state.program != null && (<internal.Program3D><any>this.__state.program).__format == Context3DProgramFormat.GLSL) { }
		else
		{
			if (numRegisters == -1)
			{
				numRegisters = (data.length >> 2);
			}

			var isVertex = (programType == Context3DProgramType.VERTEX);
			var dest = isVertex ? this.__vertexConstants : this.__fragmentConstants;
			var source = data;

			var sourceIndex = 0;
			var destIndex = firstRegister * 4;

			for (let i = 0; i < numRegisters; i++)
			{
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
			}

			if (this.__state.program != null)
			{
				(<internal.Program3D><any>this.__state.program).__markDirty(isVertex, firstRegister, numRegisters);
			}
		}
	}

	/**
		Sets the back rendering buffer as the render target. Subsequent calls to
		`drawTriangles()` and `clear()` methods result in updates to the back buffer.
		Use this method to resume normal rendering after using the
		`setRenderToTexture()` method.
	**/
	public setRenderToBackBuffer(): void
	{
		this.__state.renderToTexture = null;
	}

	/**
		Sets the specified texture as the rendering target.

		Subsequent calls to `drawTriangles()` and `clear()` methods update the
		specified texture instead of the back buffer. Mip maps are created
		automatically. Use the `setRenderToBackBuffer()` to resume normal rendering to
		the back buffer.

		No clear is needed before drawing. If there is no clear operation, the render
		content will be retained. depth buffer and stencil buffer will also not be
		cleared. But it is forced to clear when first drawing. Calling `present()`
		resets the target to the back buffer.

		@param	texture	the target texture to render into. Set to `null` to resume
		rendering to the back buffer (`setRenderToBackBuffer()` and `present` also reset
		the target to the back buffer).
		@param	enableDepthAndStencil	if `true`, depth and stencil testing are
		available. If `false`, all depth and stencil state is ignored for subsequent
		drawing operations.
		@param	antiAlias	the antialiasing quality. Use 0 to disable antialiasing;
		higher values improve antialiasing quality, but require more calculations. The
		value is currently ignored by mobile platform and software rendering context.
		@param	surfaceSelector	specifies which element of the texture to update.
		Texture objects have one surface, so you must specify 0, the default value.
		CubeTexture objects have six surfaces, so you can specify an integer from 0
		through 5.
		@param	colorOutputIndex	The output color register. Must be 0 for constrained
		or baseline mode. Otherwise specifies the output color register.
		@throws	ArgumentError	for a mismatched surfaceSelector parameter. The value
		must be 0 for 2D textures and 0..5 for cube maps.
		@throws	ArgumentError	texture is not derived from the TextureBase class
		(either Texture or CubeTexture classes).
		@throws	ArgumentError	colorOutputIndex must be an integer is from 0 through 3.
		@throws	ArgumentError	this call requires a Context3D that is created with the
		standard profile or above.
	**/
	public setRenderToTexture(texture: TextureBase, enableDepthAndStencil: boolean = false, antiAlias: number = 0, surfaceSelector: number = 0): void
	{
		this.__state.renderToTexture = texture;
		this.__state.renderToTextureDepthStencil = enableDepthAndStencil;
		this.__state.renderToTextureAntiAlias = antiAlias;
		this.__state.renderToTextureSurfaceSelector = surfaceSelector;
	}

	/**
		Manuallytexture sampler this.__state.

		Texture sampling state is typically set at the time setProgram is called.
		However, you cantexture sampler state with this function. If you do not
		want the program to change sampler state, set the `ignoresamnpler` bit in AGAL
		and use this function.

		@param	sampler	sampler The sampler register to use. Maps to the sampler register
		in AGAL.
		@param	wrap	Wrapping mode. Defined in Context3DWrapMode. The default is repeat.
		@param	filter	Texture filtering mode. Defined in Context3DTextureFilter. The
		default is nearest.
		@param	mipfilter	Mip map filter. Defined in Context3DMipFilter. The default
		is none.
		@throws	Error	sampler out of range
		@throws	Error	wrap, filter, mipfilter bad enum
		@throws	Error	Object Disposed: if this Context3D object has been disposed by a
		calling `dispose()` or because the underlying rendering hardware has been lost.
	**/
	public setSamplerStateAt(sampler: number, wrap: Context3DWrapMode, filter: Context3DTextureFilter, mipfilter: Context3DMipFilter): void
	{
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {

		// 	throw new Error ("sampler out of range");

		// }

		if (this.__state.samplerStates[sampler] == null)
		{
			this.__state.samplerStates[sampler] = new SamplerState();
		}

		var state = this.__state.samplerStates[sampler];
		state.wrap = wrap;
		state.filter = filter;
		state.mipfilter = mipfilter;
	}

	/**
		Sets a scissor rectangle, which is type of drawing mask. The renderer only draws
		to the area inside the scissor rectangle. Scissoring does not affect clear
		operations.

		Pass `null` to turn off scissoring.

		@param	rectangle	The rectangle in which to draw. Specify the rectangle
		position and dimensions in pixels. The coordinate system origin is the top left
		corner of the viewport, with positive values increasing down and to the right
		(the same as the normal OpenFL display coordinate system).
	**/
	public setScissorRectangle(rectangle: Rectangle): void
	{
		if (rectangle != null)
		{
			this.__state.scissorEnabled = true;
			this.__state.scissorRectangle.copyFrom(rectangle);
		}
		else
		{
			this.__state.scissorEnabled = false;
		}
	}

	/**
		Sets stencil mode and operation.

		An 8-bit stencil reference value can be associated with each draw call. During
		rendering, the reference value can be tested against values stored previously
		in the frame buffer. The result of the test can control the draw action and
		whether or how the stored stencil value is updated. In addition, depth testing
		controls whether stencil testing is performed. A failed depth test can also be
		used to control the action taken on the stencil buffer.

		In the pixel processing pipeline, depth testing is performed first. If the depth
		test fails, a stencil buffer update action can be taken, but no further evaluation
		of the stencil buffer value can be made. If the depth test passes, then the
		stencil test is performed. Alternate actions can be taken depending on the outcome
		of the stencil test.

		The stencil reference value is set using `setStencilReferenceValue()`.

		@param	triangleFace	the triangle orientations allowed to contribute to the
		stencil operation. One of Context3DTriangleFace.
		@param	compareMode	the test operator used to compare the current stencil
		reference value and the destination pixel stencil value. Destination pixel color
		and depth update is performed when the comparison is true. The stencil actions
		are performed as requested in the following action parameters. The comparison
		operator is applied as an infix operator between the current and destination
		reference values, in that order (in pseudocode:
		`if stencilReference OPERATOR stencilBuffer then pass`). Use one of the constants
		defined in the Context3DCompareMode class.
		@param	actionOnBothPass	action to be taken when both depth and stencil
		comparisons pass. Use one of the constants defined in the Context3DStencilAction
		class.
		@param	actionOnDepthFail	action to be taken when depth comparison fails. Use
		one of the constants defined in the Context3DStencilAction class.
		@param	actionOnDepthPassStencilFail	action to be taken when depth comparison
		passes and the stencil comparison fails. Use one of the constants defined in the
		Context3DStencilAction class.
		@throws	Error	Invalid Enum Error: when `triangleFace` is not one of the values
		defined in the Context3DTriangleFace class.
		@throws	Error	Invalid Enum Error: when `compareMode` is not one of the values
		defined in the Context3DCompareMode class.
		@throws	Error	Invalid Enum Error: when `actionOnBothPass`, `actionOnDepthFail`,
		or `actionOnDepthPassStencilFail` is not one of the values defined in the
		Context3DStencilAction class.
	**/
	public setStencilActions(triangleFace: Context3DTriangleFace = Context3DTriangleFace.FRONT_AND_BACK, compareMode: Context3DCompareMode = Context3DCompareMode.ALWAYS,
		actionOnBothPass: Context3DStencilAction = Context3DStencilAction.KEEP, actionOnDepthFail: Context3DStencilAction = Context3DStencilAction.KEEP,
		actionOnDepthPassStencilFail: Context3DStencilAction = Context3DStencilAction.KEEP): void
	{
		this.__state.stencilTriangleFace = triangleFace;
		this.__state.stencilCompareMode = compareMode;
		this.__state.stencilPass = actionOnBothPass;
		this.__state.stencilDepthFail = actionOnDepthFail;
		this.__state.stencilFail = actionOnDepthPassStencilFail;
	}

	/**
		Sets the stencil comparison value used for stencil tests.

		Only the lower 8 bits of the reference value are used. The stencil buffer value
		is also 8 bits in length. Use the `readMask` and `writeMask` to use the stencil
		buffer as a bit field.

		@param	referenceValue	an 8-bit reference value used in reference value
		comparison tests.
		@param	readMask	an 8-bit mask for applied to both the current stencil
		buffer value and the reference value before the comparison.
		@param	writeMask	an 8-bit mask applied to the reference value before updating
		the stencil buffer.
	**/
	public setStencilReferenceValue(referenceValue: number, readMask: number = 0xFF, writeMask: number = 0xFF): void
	{
		this.__state.stencilReferenceValue = referenceValue;
		this.__state.stencilReadMask = readMask;
		this.__state.stencilWriteMask = writeMask;
	}

	/**
		Specifies the texture to use for a texture input register of a fragment program.

		A fragment program can read information from up to eight texture objects. Use
		this to assign a Texture or CubeTexture object to one of the sampler
		registers used by the fragment program.

		**Note:** if you change the active fragment program (with setProgram) to a
		shader that uses fewer textures, set the unused registers to `null`:

		``haxe
		setTextureAt(7, null);
		```

		@param	sampler	the sampler register index, a value from 0 through 7.
		@param	texture	the texture object to make available, either a Texture or a
		CubeTexture instance.
	**/
	public setTextureAt(sampler: number, texture: TextureBase): void
	{
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {

		// 	throw new Error ("sampler out of range");

		// }

		this.__state.textures[sampler] = texture;
	}

	/**
		Specifies which vertex data components correspond to a single vertex shader
		program input.

		Use the setVertexBufferAt method to identify which components of the data
		defined for each vertex in a VertexBuffer3D buffer belong to which inputs to the
		vertex program. The developer of the vertex program determines how much data is
		needed per vertex. That data is mapped from 1 or more VertexBuffer3D stream(s) to
		the attribute registers of the vertex shader program.

		The smallest unit of data consumed by the vertex shader is a 32-bit data.
		Offsets into the vertex stream are specified in multiples of 32-bits.

		As an example, a programmer might define each vertex with the following data:

		```
		position:  x    float32
				   y    float32
				   z    float32
		color:     r    unsigned byte
				   g    unsigned byte
				   b    unsigned byte
				   a    unsigned byte
		```

		Assuming the vertex was defined in a VertexBuffer3D object named buffer, it
		would be assigned to a vertex shader with the following code:

		```haxe
		setVertexBufferAt(0, buffer, 0, Context3DVertexBufferFormat.FLOAT_3);   // attribute #0 will contain the position information
		setVertexBufferAt(1, buffer, 3, Context3DVertexBufferFormat.BYTES_4);    // attribute #1 will contain the color information
		```

		@param	index	the index of the attribute register in the vertex shader (0
		through 7).
		@param	buffer	the buffer that contains the source vertex data to be fed to the
		vertex shader.
		@param	bufferOffset	an offset from the start of the data for a single vertex
		at which to start reading this attribute. In the example above, the position data
		has an offset of 0 because it is the first attribute; color has an offset of 3
		because the color attribute follows the three 32-bit position values. The offset
		is specified in units of 32 bits.
		@param	format	a value from the Context3DVertexBufferFormat class specifying
		the data type of this attribute.
		@throws	Error	Invalid Enum: when format is not one of the values defined in
		the Context3DVertexBufferFormat class.
		@throws	RangeError	Attribute Register Out Of Bounds: when the index parameter
		is outside the range from 0 through 7. (A maximum of eight vertex attribute
		registers can be used by a shader.)
	**/
	public setVertexBufferAt(index: number | WebGLUniformLocation, buffer: VertexBuffer3D, bufferOffset: number = 0, format: Context3DVertexBufferFormat = Context3DVertexBufferFormat.FLOAT_4): void
	{
		// TODO: Don't flush immediately?
		// this.__backend.setVertexBufferAt(index, buffer, bufferOffset, format);
	}

	protected __renderStage3D(stage3D: Stage3D): void
	{
		// Assume this is the primary Context3D

		var context = stage3D.context3D;

		if (context != null
			&& context != this
			&& context.__frontBufferTexture != null
			&& stage3D.visible
			&& this.backBufferHeight > 0
			&& this.backBufferWidth > 0)
		{
			// if (!stage.renderer.cleared) stage.renderer.clear ();

			if (this.__renderStage3DProgram == null)
			{
				var vertexAssembler = new AGALMiniAssembler();
				vertexAssembler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\n" + "mov v0, va1");

				var fragmentAssembler = new AGALMiniAssembler();
				fragmentAssembler.assemble(Context3DProgramType.FRAGMENT, "tex ft1, v0, fs0 <2d,nearest,nomip>\n" + "mov oc, ft1");

				this.__renderStage3DProgram = this.createProgram();
				this.__renderStage3DProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);
			}

			this.setProgram(this.__renderStage3DProgram);

			this.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			this.setColorMask(true, true, true, true);
			this.setCulling(Context3DTriangleFace.NONE);
			this.setDepthTest(false, Context3DCompareMode.ALWAYS);
			this.setStencilActions();
			this.setStencilReferenceValue(0, 0, 0);
			this.setScissorRectangle(null);

			this.setTextureAt(0, (<internal.Context3D><any>context).__frontBufferTexture);
			this.setVertexBufferAt(0, (<internal.Stage3D><any>stage3D).__renderData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			this.setVertexBufferAt(1, (<internal.Stage3D><any>stage3D).__renderData.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			this.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, (<internal.Stage3D><any>stage3D).__renderTransform, true);
			this.drawTriangles((<internal.Stage3D><any>stage3D).__renderData.indexBuffer);

			this.__present = true;
		}
	}

	// Get & Set Methods

	/**
		Indicates if Context3D supports video texture.
	**/
	public static get supportsVideoTexture(): boolean
	{
		return Context3D.__supportsVideoTexture;
	}

	/**
		Specifies the height of the back buffer, which can be changed by a successful
		call to the `configureBackBuffer()` method. The height may be modified when the
		browser zoom factor changes if the `wantsBestResolutionOnBrowserZoom` parameter
		is set to `true` in the last successful call to the `configureBackBuffer()`
		method. The change in height can be detected by registering an event listener
		for the browser zoom change event.
	**/
	public get backBufferHeight(): number
	{
		return this.__backBufferHeight;
	}

	/**
		Specifies the width of the back buffer, which can be changed by a successful
		call to the `configureBackBuffer()` method. The width may be modified when the
		browser zoom factor changes if the `wantsBestResolutionOnBrowserZoom` parameter
		is set to `true` in the last successful call to the `configureBackBuffer()`
		method. The change in width can be detected by registering an event listener
		for the browser zoom change event.
	**/
	public get backBufferWidth(): number
	{
		return this.__backBufferWidth;
	}

	/**
		The type of graphics library driver used by this rendering context. Indicates
		whether the rendering is using software, a DirectX driver, or an OpenGL driver.
		Also indicates whether hardware rendering failed. If hardware rendering fails,
		Flash Player uses software rendering for Stage3D and `driverInfo` contains one
		of the following values:

		* "Software Hw_disabled=userDisabled" - The Enable hardware acceleration
		checkbox in the Adobe Flash Player Settings UI is not selected.
		* "Software Hw_disabled=oldDriver" - There are known problems with the
		hardware graphics driver. Updating the graphics driver may fix this problem.
		* "Software Hw_disabled=unavailable" - Known problems with the hardware
		graphics driver or hardware graphics initialization failure.
		* "Software Hw_disabled=explicit" - The content explicitly requested software
		rendering through requestContext3D.
		* "Software Hw_disabled=domainMemory" - The content uses domainMemory, which
		requires a license when used with Stage3D hardware rendering. Visit
		adobe.com/go/fpl.
	**/
	public get driverInfo(): string
	{
		return this.__driverInfo;
	}

	/**
		Specifies whether errors encountered by the renderer are reported to the
		application.

		When `enableErrorChecking` is `true`, the `clear()`, and `drawTriangles()`
		methods are synchronous and can throw errors. When `enableErrorChecking`
		is `false`, the default, the `clear()`, and `drawTriangles()` methods are
		asynchronous and errors are not reported. Enabling error checking reduces
		rendering performance. You should only enable error checking when debugging.
	**/
	public get enableErrorChecking(): boolean
	{
		return this.__enableErrorChecking;
	}

	public set enableErrorChecking(value: boolean)
	{
		this.__enableErrorChecking = value;
	}

	/**
		Specifies the maximum height of the back buffer. The inital value is the system
		limit in the platform. The property can be set to a value smaller than or equal
		to, but not greater than, the system limit. The property can be set to a value
		greater than or equal to, but not smaller than, the minimum limit. The minimum
		limit is a constant value, 32, when the back buffer is not configured. The
		minimum limit will be the value of the `height` parameter in the last successful
		call to the `configureBackBuffer()` method after the back buffer is configured.
	**/
	public get maxBackBufferHeight(): number
	{
		return this.__maxBackBufferHeight;
	}

	/**
		Specifies the maximum width of the back buffer. The inital value is the system
		limit in the platform. The property can be set to a value smaller than or equal
		to, but not greater than, the system limit. The property can be set to a value
		greater than or equal to, but not smaller than, the minimum limit. The minimum
		limit is a constant value, 32, when the back buffer is not configured. The
		minimum limit will be the value of the width parameter in the last successful
		call to the `configureBackBuffer()` method after the back buffer is configured.
	**/
	public get maxBackBufferWidth(): number
	{
		return this.__maxBackBufferWidth;
	}

	/**
		The feature-support profile in use by this Context3D object.
	**/
	public get profile(): Context3DProfile
	{
		return this.__profile;
	}

	/**
		Returns the total GPU memory allocated by Stage3D data structures of an
		application.

		Whenever a GPU resource object is created, memory utilized is stored in
		Context3D. This memory includes index buffers, vertex buffers,
		textures (excluding video texture), and programs that were created through this
		Context3D.

		API totalGPUMemory returns the total memory consumed by the above resources to
		the user. Default value returned is 0. The total GPU memory returned is in bytes.
		The information is only provided in Direct mode on mobile, and in Direct and
		GPU modes on desktop. (On desktop, using `<renderMode>gpu</renderMode>` will
		fall back to `<renderMode>direct</renderMode>`)

		This API can be used when the SWF version is 32 or later.
	**/
	public get totalGPUMemory(): number
	{
		// return this.__backend.getTotalGPUMemory();
		return 0;
	}
}
