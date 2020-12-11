package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;

/**
	The ShaderFilter class applies a filter by executing a shader on the
	object being filtered. The filtered object is used as an input to the
	shader, and the shader output becomes the filter result.
	To create a new filter, use the constructor `new ShaderFilter()`. The use
	of filters depends on the object to which you apply the filter:

	* To apply filters to movie clips, text fields, buttons, and video, use
	the `filters` property (inherited from DisplayObject). Setting the
	`filters` property of an object does not modify the object, and you can
	remove the filter by clearing the `filters` property.
	* To apply filters to BitmapData objects, use the
	`BitmapData.applyFilter()` method. Calling `applyFilter()` on a BitmapData
	object takes the source BitmapData object and the filter object and
	generates a filtered image as a result.

	If you apply a filter to a display object, the value of the
	`cacheAsBitmap` property of the object is set to true. If you remove all
	filters, the original value of `cacheAsBitmap` is restored.

	This filter supports stage scaling. However, it does not support general
	scaling, rotation, and skewing. If the object itself is scaled (if the
	`scaleX` and `scaleY` properties are not set to 100%), the filter is not
	scaled. It is scaled only when the user zooms in on the stage.

	A filter is not applied if the resulting image exceeds the maximum
	dimensions. In AIR 1.5 and Flash Player 10, the maximum is 8,191 pixels in
	width or height, and the total number of pixels cannot exceed 16,777,215
	pixels. (So, if an image is 8,191 pixels wide, it can only be 2,048 pixels
	high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the
	limitation is 2,880 pixels in height and 2,880 pixels in width. If, for
	example, you zoom in on a large movie clip with a filter applied, the
	filter is turned off if the resulting image exceeds the maximum
	dimensions.

	To specify the Shader instance to use with the filter, pass the Shader
	instance as an argument to the `ShaderFilter()` constructor, or set it as
	the value of the `shader` property.

	To allow the shader output to extend beyond the bounds of the filtered
	object, use the `leftExtension`, `rightExtension`, `topExtension`, and
	`bottomExtension` properties.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ShaderFilter extends BitmapFilter
{
	@:dox(hide) @:noCompletion @:beta @SuppressWarnings("checkstyle:FieldDocComment")
	public var blendMode:BlendMode;

	/**
		The growth in pixels on the bottom side of the target object.
		The growth is the area beyond the bounds of the target object that is
		passed to the shader during execution. At execution time Flash Player
		or AIR computes the normal bounds of a movie clip and extends the
		bounds based on the `leftExtension`, `rightExtension`, `topExtension`,
		and `bottomExtension` values.

		@default 0
	**/
	public var bottomExtension:Int;

	/**
		The growth in pixels on the left side of the target object.
		The growth is the area beyond the bounds of the target object that is
		passed to the shader during execution. At execution time Flash Player
		or AIR computes the normal bounds of a movie clip and extends the
		bounds based on the `leftExtension`, `rightExtension`, `topExtension`,
		and `bottomExtension` values.

		@default 0
	**/
	public var leftExtension:Int;

	/**
		The growth in pixels on the right side of the target object.
		The growth is the area beyond the bounds of the target object that is
		passed to the shader during execution. At execution time Flash Player
		or AIR computes the normal bounds of a movie clip and extends the
		bounds based on the `leftExtension`, `rightExtension`, `topExtension`,
		and `bottomExtension` values.

		@default 0
	**/
	public var rightExtension:Int;

	/**
		The shader to use for this filter.
		The Shader assigned to the `shader` property must specify at least one
		`image4` input. The input **does not** need to be specified in code
		using the associated ShaderInput object's `input` property. Instead,
		the object to which the filter is applied is automatically used as the
		first input (the input with `index` 0). A shader used as a filter can
		specify more than one input, in which case any additional input must
		be specified by setting its ShaderInput instance's `input` property.

		When you assign a Shader instance to this property the shader is
		copied internally and the filter operation uses that internal copy,
		not a reference to the original shader. Any changes made to the
		shader, such as changing a parameter value, input, or bytecode, are
		not applied to the copied shader that's used for the filter. To make
		it so that shader changes are taken into account in the filter output,
		you must reassign the Shader instance to the `shader` property. As
		with all filters, you must also reassign the ShaderFilter instance to
		the display object's `filters` property in order to apply filter
		changes.
	**/
	public var shader:Shader;

	/**
		The growth in pixels on the top side of the target object.
		The growth is the area beyond the bounds of the target object that is
		passed to the shader during execution. At execution time Flash Player
		or AIR computes the normal bounds of a movie clip and extends the
		bounds based on the `leftExtension`, `rightExtension`, `topExtension`,
		and `bottomExtension` values.

		@default 0
	**/
	public var topExtension:Int;

	/**
		Creates a new shader filter.

		@param shader The Shader to use for this filter. For details and
					  limitations that the shader must conform to, see the
					  description for the `shader` property.
	**/
	public function new(shader:Shader)
	{
		super();

		this.shader = shader;

		__numShaderPasses = 1;
	}

	public override function clone():BitmapFilter
	{
		var filter = new ShaderFilter(shader);
		filter.bottomExtension = bottomExtension;
		filter.leftExtension = leftExtension;
		filter.rightExtension = rightExtension;
		filter.topExtension = topExtension;
		return filter;
	}

	public function invalidate():Void
	{
		__renderDirty = true;
	}

	@:noCompletion private override function __initShader(renderer:DisplayObjectRenderer, pass:Int, sourceBitmapData:BitmapData):Shader
	{
		__shaderBlendMode = blendMode;
		return shader;
	}
}
#else
typedef ShaderFilter = flash.filters.ShaderFilter;
#end
