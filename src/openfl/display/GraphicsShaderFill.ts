import GraphicsDataType from "../_internal/renderer/GraphicsDataType";
import GraphicsFillType from "../_internal/renderer/GraphicsFillType";
import IGraphicsFill from "../display/IGraphicsFill";
import IGraphicsData from "../display/IGraphicsData";
import Shader from "../display/Shader";
import Matrix from "../geom/Matrix";

/**
	Defines a shader fill.
	Use a GraphicsShaderFill object with the `Graphics.drawGraphicsData()`
	method. Drawing a GraphicsShaderFill object is the equivalent of calling
	the `Graphics.beginShaderFill()` method.
**/
export default class GraphicsShaderFill implements IGraphicsData, IGraphicsFill
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
	public matrix: Matrix;

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
	public shader: Shader;

	protected __graphicsDataType: GraphicsDataType;
	protected __graphicsFillType: GraphicsFillType;

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
	public constructor(shader: Shader, matrix: Matrix = null)
	{
		this.shader = shader;
		this.matrix = matrix;

		this.__graphicsDataType = GraphicsDataType.SHADER;
		this.__graphicsFillType = GraphicsFillType.SHADER_FILL;
	}
}
