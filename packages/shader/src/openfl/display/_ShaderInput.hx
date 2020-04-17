package openfl.display;

#if openfl_gl
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D) // TODO: Remove backend references
#if (!js && !display)
@:generic
#end
@:noCompletion
class _ShaderInput<T> /*implements Dynamic*/
{
	private var isUniform:Bool;
	private var parent:ShaderInput<T>;

	public function new(parent:ShaderInput<T>)
	{
		this.parent = parent;
	}

	private function disableGL(context:Context3D, id:Int):Void
	{
		var gl = context._.gl;
		context.setTextureAt(id, null);
	}

	private function updateGL(context:Context3D, id:Int, overrideInput:T = null, overrideFilter:Context3DTextureFilter = null,
			overrideMipFilter:Context3DMipFilter = null, overrideWrap:Context3DWrapMode = null):Void
	{
		var gl = context._.gl;
		var input = overrideInput != null ? overrideInput : parent.input;
		var filter = overrideFilter != null ? overrideFilter : parent.filter;
		var mipFilter = overrideMipFilter != null ? overrideMipFilter : parent.mipFilter;
		var wrap = overrideWrap != null ? overrideWrap : parent.wrap;

		if (input != null)
		{
			// TODO: Improve for other input types? Use an interface perhaps

			var bitmapData:BitmapData = cast input;
			context.setTextureAt(id, bitmapData.getTexture(context));
			context.setSamplerStateAt(id, wrap, filter, mipFilter);
		}
		else
		{
			context.setTextureAt(id, null);
		}
	}
}
#end
