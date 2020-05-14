package openfl.display;

import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.display3D.Context3D;
import openfl.display3D._Context3D;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _ShaderInput<T> /*implements Dynamic*/
{
	public var channels(default, null):Int;
	public var filter:Context3DTextureFilter;
	public var height:Int;
	public var index(default, null):Dynamic;
	public var input:T;
	public var mipFilter:Context3DMipFilter;
	public var name:String;
	public var width:Int;
	public var wrap:Context3DWrapMode;

	public var isUniform:Bool;

	private var shaderInput:ShaderInput<T>;

	public function new(shaderInput:ShaderInput<T>)
	{
		this.shaderInput = shaderInput;

		channels = 0;
		filter = NEAREST;
		height = 0;
		index = 0;
		mipFilter = MIPNONE;
		width = 0;
		wrap = CLAMP;
	}

	public function disableGL(context:Context3D, id:Int):Void
	{
		var gl = (context._ : _Context3D).gl;
		context.setTextureAt(id, null);
	}

	public function updateGL(context:Context3D, id:Int, overrideInput:T = null, overrideFilter:Context3DTextureFilter = null,
			overrideMipFilter:Context3DMipFilter = null, overrideWrap:Context3DWrapMode = null):Void
	{
		var gl = (context._ : _Context3D).gl;
		var input = overrideInput != null ? overrideInput : shaderInput.input;
		var filter = overrideFilter != null ? overrideFilter : shaderInput.filter;
		var mipFilter = overrideMipFilter != null ? overrideMipFilter : shaderInput.mipFilter;
		var wrap = overrideWrap != null ? overrideWrap : shaderInput.wrap;

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
