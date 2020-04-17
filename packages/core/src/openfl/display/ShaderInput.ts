import BitmapData from "../display/BitmapData";
import Context3DMipFilter from "../display3D/Context3DMipFilter";
import Context3DTextureFilter from "../display3D/Context3DTextureFilter";
import Context3DWrapMode from "../display3D/Context3DWrapMode";
import Video from "../media/Video";

/**
	// TODO: Document GLSL Shaders
	A ShaderInput instance represents a single input image for a shader
	kernel. A kernel can be defined to accept zero, one, or more source images
	that are used in the kernel execution. A ShaderInput instance provides a
	mechanism for specifying the input image that is used when the shader
	executes. To specify a value for the input, create a BitmapData,
	ByteArray, or Vector.<Number> instance containing the image data and
	assign it to the `input` property.
	The ShaderInput instance representing a Shader instance's input image is
	accessed as a property of the Shader instance's `data` property. The
	ShaderInput property has the same name as the input's name in the shader
	code. For example, if a shader defines an input named `src`, the
	ShaderInput instance representing the `src` input is available as the
	`src` property, as this example shows:

	```haxe
	myShader.data.src.input = new BitmapData(50, 50, true, 0xFF990000);
	```

	For some uses of a Shader instance, you do not need to specify an input
	image, because it is automatically specified by the operation. You only
	need to specify an input when a Shader is used for the following:

	* Shader fill
	* ShaderFilter, only for the second or additional inputs if the shader is
	defined to use more than one input. (The object to which the filter is
	applied is automatically used as the first input.)
	* Shader blend mode, only for the third or additional inputs if the shader
	is defined to use more than two inputs. (The objects being blended are
	automatically used as the first and second inputs.)
	* ShaderJob background execution

	If the shader is being executed using a ShaderJob instance to process a
	ByteArray containing a linear array of data, set the ShaderInput
	instance's `height` to 1 and `width` to the number of 32-bit floating
	point values in the ByteArray. In that case, the input in the shader must
	be defined with the `image1` data type.

	Generally, developer code does not create a ShaderInput instance directly.
	A ShaderInput instance is created for each of a shader's inputs when the
	Shader instance is created.
**/
export default class ShaderInput<T = BitmapData | Video> /*implements Dynamic*/
{
	/**
		The texture filter to use when binding this shader input.

		This property is not available when targeting Flash.
	**/
	public filter: Context3DTextureFilter;

	/**
		The height of the shader input. This property is only used when the
		input data is a ByteArray or Vector.<Number> instance. When the input
		is a BitmapData instance the height is automatically determined.
	**/
	public height: number;

	/**
		The input data that is used when the shader executes. This property
		can be a BitmapData instance, a ByteArray instance, or a
		Vector.<Number> instance.
		If a ByteArray value is assigned to the `input` property, the
		following conditions must be met:

		* The `height` and `width` properties must be set.
		* The byte array's contents must only consist of 32-bit floating-point
		values. These values can be written using the `ByteArray.writeFloat()`
		method.
		* The total length in bytes of the ByteArray must be exactly `width`
		times `height` times `channels` times 4.
		* The byte array's `endian` property must be `Endian.LITTLE_ENDIAN`.

		If a Vector.<Number> instance is assigned to the `input` property, the
		length of the Vector must be equal to `width` times `height` times
		`channels`.
	**/
	public input: T;

	/**
		The mip filter to use when binding this shader input.

		This property is not available when targeting Flash.
	**/
	public mipFilter: Context3DMipFilter;

	/** @hidden */
	public name: string;

	/**
		The width of the shader input. This property is only used when the
		input data is a ByteArray or Vector.<Number> instance. When the input
		is a BitmapData instance the width is automatically determined.
	**/
	public width: number;

	/**
		The wrap mode to use when binding this shader input.

		This property is not available when targeting Flash.
	**/
	public wrap: Context3DWrapMode;

	protected __channels: number;
	protected __index: WebGLUniformLocation;

	/**
		Creates a ShaderInput instance. Developer code does not call the
		ShaderInput constructor directly. A ShaderInput instance is created
		for each of a shader's inputs when the Shader instance is created.
	**/
	public constructor()
	{
		this.__channels = 0;
		this.filter = Context3DTextureFilter.NEAREST;
		this.height = 0;
		this.__index = null;
		this.mipFilter = Context3DMipFilter.MIPNONE;
		this.width = 0;
		this.wrap = Context3DWrapMode.CLAMP;
	}

	// Get & Set Methods

	/**
		The number of channels that a shader input expects. This property must
		be accounted for when the input data is a ByteArray or Vector.<Number>
		instance.
	**/
	public get channels(): number
	{
		return this.__channels;
	}

	/**
		The zero-based index of the input in the shader, indicating the order
		of the input definitions in the shader.
	**/
	public get index(): WebGLUniformLocation | number
	{
		return this.__index;
	}
}
