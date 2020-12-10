package openfl.filters;

#if !flash
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObjectRenderer;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class ShaderFilter extends BitmapFilter
{
	@:dox(hide) @:noCompletion @:beta @SuppressWarnings("checkstyle:FieldDocComment")
	public var blendMode:BlendMode;
	public var bottomExtension:Int;
	public var leftExtension:Int;
	public var rightExtension:Int;
	public var shader:Shader;
	public var topExtension:Int;

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
