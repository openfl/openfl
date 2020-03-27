namespace openfl._internal.backend.opengl;

#if openfl_gl
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import Context3D from "../display3D/Context3D";
import BitmapData from "../display/BitmapData";
import openfl.display.ShaderInput;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl._internal.backend.opengl)
@: access(openfl.display3D.Context3D)
#if(!js && !display)
@: generic
#end
class OpenGLShaderInputBackend<T> /*implements Dynamic*/
{
	private isUniform: boolean;
	private parent: ShaderInput<T>;

	public constructor(parent: ShaderInput<T>)
	{
		this.parent = parent;
	}

	private disableGL(context: Context3D, id: number): void
	{
		var gl = context.__backend.gl;
		context.setTextureAt(id, null);
	}

	private updateGL(context: Context3D, id: number, overrideInput: T = null, overrideFilter: Context3DTextureFilter = null,
		overrideMipFilter: Context3DMipFilter = null, overrideWrap: Context3DWrapMode = null): void
	{
		var gl = context.__backend.gl;
		var input = overrideInput != null ? overrideInput : parent.input;
		var filter = overrideFilter != null ? overrideFilter : parent.filter;
		var mipFilter = overrideMipFilter != null ? overrideMipFilter : parent.mipFilter;
		var wrap = overrideWrap != null ? overrideWrap : parent.wrap;

		if (input != null)
		{
			// TODO: Improve for other input types? Use an interface perhaps

			var bitmapData: BitmapData = cast input;
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
