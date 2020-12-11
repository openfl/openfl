package openfl.display;

#if !flash
import openfl.display._internal.GraphicsDataType;
import openfl.display._internal.GraphicsFillType;
import openfl.geom.Matrix;

/**
	Defines a shader fill.
	Use a GraphicsShaderFill object with the `Graphics.drawGraphicsData()`
	method. Drawing a GraphicsShaderFill object is the equivalent of calling
	the `Graphics.beginShaderFill()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsShaderFill implements IGraphicsData implements IGraphicsFill
{
	/**
		A matrix object (of the openfl.geom.Matrix class), which you can use to
		define transformations on the shader. For example, you can use the
		following matrix to rotate a shader by 45 degrees (pi/4 radians):

		```haxe
		var matrix = new openfl.geom.Matrix();
		matrix.rotate(Math.PI / 4);
		```

		The coordinates received in the shader are based on the matrix that is
		specified for the `matrix` parameter. For a default (`null`) matrix,
		the coordinates in the shader are local pixel coordinates which can be
		used to sample an input.
	**/
	public var matrix:Matrix;

	/**
		The shader to use for the fill. This Shader instance is not required
		to specify an image input. However, if an image input is specified in
		the shader, the input must be provided manually by setting the `input`
		property of the corresponding ShaderInput property of the
		`Shader.data` property.
		When you pass a Shader instance as an argument the shader is copied
		internally and the drawing fill operation uses that internal copy, not
		a reference to the original shader. Any changes made to the shader,
		such as changing a parameter value, input, or bytecode, are not
		applied to the copied shader that's used for the fill.
	**/
	public var shader:Shader;

	@:noCompletion private var __graphicsDataType(default, null):GraphicsDataType;
	@:noCompletion private var __graphicsFillType(default, null):GraphicsFillType;

	/**
		Creates a new GraphicsShaderFill object.

		@param shader The shader to use for the fill. This Shader instance is
					  not required to specify an image input. However, if an
					  image input is specified in the shader, the input must
					  be provided manually by setting the `input` property of
					  the corresponding ShaderInput property of the
					  `Shader.data` property.
		@param matrix A matrix object (of the openfl.geom.Matrix class), which
					  you can use to define transformations on the shader.
	**/
	public function new(shader:Shader, matrix:Matrix = null)
	{
		this.shader = shader;
		this.matrix = matrix;

		this.__graphicsDataType = SHADER;
		this.__graphicsFillType = SHADER_FILL;
	}
}
#else
typedef GraphicsShaderFill = flash.display.GraphicsShaderFill;
#end
