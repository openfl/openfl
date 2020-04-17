import BitmapData from "../display/BitmapData";
import ShaderData from "../display/ShaderData";
import ShaderInput from "../display/ShaderInput";
import ShaderParameter from "../display/ShaderParameter";
import ShaderPrecision from "../display/ShaderPrecision";
import Context3D from "../display3D/Context3D";
import Program3D from "../display3D/Program3D";
import ByteArray from "../utils/ByteArray";

/**
	// TODO: Document GLSL Shaders
	A Shader instance represents a Pixel Bender shader kernel in ActionScript.
	To use a shader in your application, you create a Shader instance for it.
	You then use that Shader instance in the appropriate way according to the
	effect you want to create. For example, to use the shader as a filter, you
	assign the Shader instance to the `shader` property of a ShaderFilter
	object.
	A shader defines a that executes on all the pixels in an image,
	one pixel at a time. The result of each call to the is the output
	color at that pixel coordinate in the image. A shader can specify one or
	more input images, which are images whose content can be used in
	determining the output of the function. A shader can also specify one or
	more parameters, which are input values that can be used in calculating
	the output. In a single shader execution, the input and parameter
	values are constant. The only thing that varies is the coordinate of the
	pixel whose color is the result. Shader calls for
	multiple output pixel coordinates execute in parallel to improve shader
	execution performance.

	The shader bytecode can be loaded at run time using a URLLoader instance.
	The following example demonstrates loading a shader bytecode file at run
	time and linking it to a Shader instance.

	```as3
	var loader:URLLoader = new URLLoader();
	loader.dataFormat = URLLoaderDataFormat.BINARY;
	loader.addEventListener(Event.COMPLETE, onLoadComplete);
	loader.load(new URLRequest("myShader.pbj"));
	var shader:Shader;

	function onLoadComplete(event:Event):void {
		// Create a new shader and set the loaded data as its bytecode
		shader = new Shader();
		shader.byteCode = loader.data;

		// You can also pass the bytecode to the Shader() constructor like this:
		// shader = new Shader(loader.data);

		// do something with the shader
	}
	```

	You can also embed the shader into the SWF at compile time using the
	`[Embed]` metadata tag. The `[Embed]` metadata tag is only available if
	you use the Flex SDK to compile the SWF. The `[Embed]` tag's `source`
	parameter points to the shader file, and its `mimeType` parameter is
	`"application/octet-stream"`, as in this example:

	```as3
	[Embed(source="myShader.pbj", mimeType="application/octet-stream)] MyShaderClass:Class;

	// ...

	// create a new shader and set the embedded shader as its bytecode var
	shaderShader = new Shader();
	shader.byteCode = new MyShaderClass();

	// You can also pass the bytecode to the Shader() constructor like this:
	// shader:Shader = new Shader(new MyShaderClass());

	// do something with the shader
	```

	In either case, you link the raw shader (the `URLLoader.data` property or
	an instance of the `[Embed]` data class) to the Shader instance. As the
	previous examples demonstrate, you can do this in two ways. You can pass
	the shader bytecode as an argument to the `Shader()` constructor.
	Alternatively, you can set it as the Shader instance's `byteCode`
	property.

	Once a Shader instance is created, it can be used in one of several ways:

	* A shader fill: The output of the shader is used as a fill for content
	drawn with the drawing API. Pass the Shader instance as an argument to the
	`Graphics.beginShaderFill()` method.
	* A shader filter: The output of the shader is used as a graphic filter
	applied to a display object. Assign the Shader instance to the `shader`
	property of a ShaderFilter instance.
	* A blend mode: The output of the shader is rendered as the blending
	between two overlapping display objects. Assign the Shader instance to the
	`blendShader` property of the upper of the two display objects.
	* Background shader processing: The shader executes in the background,
	avoiding the possibility of freezing the display, and dispatches an event
	when processing is complete. Assign the Shader instance to the `shader`
	property of a ShaderJob instance.

	Shader fills, filters, and blends are not supported under GPU rendering.

	**Mobile Browser Support:** This feature is not supported in mobile
	browsers.

	_AIR profile support:_ This feature is supported on all desktop operating
	systems, but it is not supported on all mobile devices. It is not
	supported on AIR for TV devices. See <a
	href="http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html">
	AIR Profile Support</a> for more information regarding API support across
	multiple profiles.
**/
export default class Shader
{
	/**
		The raw shader bytecode for this Shader instance.
	**/
	public byteCode: ByteArray;

	/**
		The precision of math operations performed by the shader.
		The set of possible values for the `precisionHint` property is defined
		by the constants in the ShaderPrecision class.

		The default value is `ShaderPrecision.FULL`. Setting the precision to
		`ShaderPrecision.FAST` can speed up math operations at the expense of
		precision.

		Full precision mode (`ShaderPrecision.FULL`) computes all math
		operations to the full width of the IEEE 32-bit floating standard and
		provides consistent behavior on all platforms. In this mode, some math
		operations such as trigonometric and exponential functions can be
		slow.

		Fast precision mode (`ShaderPrecision.FAST`) is designed for maximum
		performance but does not work consistently on different platforms and
		individual CPU configurations. In many cases, this level of precision
		is sufficient to create graphic effects without visible artifacts.

		The precision mode selection affects the following shader operations.
		These operations are faster on an Intel processor with the SSE
		instruction set:

		* `sin(x)`
		* `cos(x)`
		* `tan(x)`
		* `asin(x)`
		* `acos(x)`
		* `atan(x)`
		* `atan(x, y)`
		* `exp(x)`
		* `exp2(x)`
		* `log(x)`
		* `log2(x)`
		* `pow(x, y)`
		* `reciprocal(x)`
		* `sqrt(x)`
	**/
	public precisionHint: ShaderPrecision;

	/**
		The compiled Program3D if available.

		This property is not available on the Flash target.
	**/
	public program: Program3D;

	protected __alpha: ShaderParameter<number>;
	protected __alphaTexture: ShaderInput<BitmapData>;
	protected __alphaTextureMatrix: ShaderParameter<number>;
	protected __bitmap: ShaderInput<BitmapData>;
	protected __colorMultiplier: ShaderParameter<number>;
	protected __colorOffset: ShaderParameter<number>;
	protected __data: ShaderData;
	protected __hasColorTransform: ShaderParameter<boolean>;
	protected __isGenerated: boolean;
	protected __glFragmentSource: string;
	protected __glProgram: WebGLProgram;
	protected __glSourceDirty: boolean;
	protected __glVertexSource: string;
	protected __matrix: ShaderParameter<number>;
	protected __position: ShaderParameter<number>;
	protected __textureCoord: ShaderParameter<number>;
	protected __texture: ShaderInput<BitmapData>;
	protected __textureSize: ShaderParameter<number>;

	protected __context: Context3D;
	protected __gl: WebGLRenderingContext;
	protected __inputBitmapData: Array<ShaderInput<BitmapData>>;
	protected __numPasses: number;
	protected __paramBool: Array<ShaderParameter<boolean>>;
	protected __paramFloat: Array<ShaderParameter<number>>;
	protected __paramInt: Array<ShaderParameter<number>>;

	/**
		Creates a new Shader instance.

		@param code The raw shader bytecode to link to the Shader.
	**/
	public constructor(code: ByteArray = null)
	{
		this.byteCode = code;
		this.precisionHint = ShaderPrecision.FULL;

		// __backend = new ShaderBackend(this);

		this.__glSourceDirty = true;
		// numPasses = 1;

		this.__data = new ShaderData(code);
	}

	protected __init(context3D: Context3D = null): void
	{
		// __backend.init(context3D);
	}

	protected __update(): void
	{
		// __backend.update();
	}

	// Get & Set Methods

	/**
		Provides access to parameters, input images, and metadata for the
		Shader instance. ShaderParameter objects representing parameters for
		the shader, ShaderInput objects representing the input images for the
		shader, and other values representing the shader's metadata are
		dynamically added as properties of the `data` property object when the
		Shader instance is created. Those properties can be used to introspect
		the shader and to set parameter and input values.
		For information about accessing and manipulating the dynamic
		properties of the `data` object, see the ShaderData class description.
	**/
	public get data(): ShaderData
	{
		if (this.__glSourceDirty || this.__data == null)
		{
			this.__init();
		}

		return this.__data;
	}

	public set data(value: ShaderData)
	{
		this.__data = value;
	}

	/**
		Get or set the fragment source used when compiling with GLSL.

		This property is not available on the Flash target.
	**/
	public get glFragmentSource(): string
	{
		return this.__glFragmentSource;
	}

	public set glFragmentSource(value: string)
	{
		if (value != this.__glFragmentSource)
		{
			this.__glSourceDirty = true;
		}

		this.__glFragmentSource = value;
	}


	/**
		The compiled GLProgram if available.

		This property is not available on the Flash target.
	**/
	public get glProgram(): WebGLProgram
	{
		return this.__glProgram;
	}

	/**
		Get or set the vertex source used when compiling with GLSL.

		This property is not available on the Flash target.
	**/
	public get glVertexSource(): string
	{
		return this.__glVertexSource;
	}

	public set glVertexSource(value: string)
	{
		if (value != this.__glVertexSource)
		{
			this.__glSourceDirty = true;
		}

		this.__glVertexSource = value;
	}
}
