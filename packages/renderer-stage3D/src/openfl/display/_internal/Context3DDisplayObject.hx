package openfl.display._internal;

#if openfl_gl
import openfl.display3D.Context3DClearMask;
import openfl.display._Context3DRenderer;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
#if !lime
import openfl._internal.backend.lime_standalone.ARGB;
#else
import lime.math.ARGB;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DDisplayObject
{
	public static inline function render(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.opaqueBackground == null && (displayObject._ : _DisplayObject).__graphics == null) return;
		if (!(displayObject._ : _DisplayObject).__renderable || (displayObject._ : _DisplayObject).__worldAlpha <= 0) return;

		if (displayObject.opaqueBackground != null
			&& !(displayObject._ : _DisplayObject).__renderData.isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0)
		{
			#if !disable_batcher
			(renderer._ : _Context3DRenderer).batcher.flush();
			#end

			(renderer._ : _Context3DRenderer).__setBlendMode((displayObject._ : _DisplayObject).__worldBlendMode);
			(renderer._ : _Context3DRenderer).__pushMaskObject(displayObject);

			var context = (renderer._ : _Context3DRenderer).context3D;

			var rect = _Rectangle.__pool.get();
			rect.setTo(0, 0, displayObject.width, displayObject.height);
			(renderer._ : _Context3DRenderer).__pushMaskRect(rect, (displayObject._ : _DisplayObject).__renderTransform);

			var color:ARGB = (displayObject.opaqueBackground : ARGB);
			context.clear(color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1, 0, 0, Context3DClearMask.COLOR);

			(renderer._ : _Context3DRenderer).__popMaskRect();
			(renderer._ : _Context3DRenderer).__popMaskObject(displayObject);

			_Rectangle.__pool.release(rect);
		}

		if ((displayObject._ : _DisplayObject).__graphics != null)
		{
			Context3DShape.render(displayObject, renderer);
		}
	}

	public static inline function renderMask(displayObject:DisplayObject, renderer:OpenGLRenderer):Void
	{
		if (displayObject.opaqueBackground == null && (displayObject._ : _DisplayObject).__graphics == null) return;

		if (displayObject.opaqueBackground != null
			&& !(displayObject._ : _DisplayObject).__renderData.isCacheBitmapRender && displayObject.width > 0 && displayObject.height > 0)
		{
			// TODO

			// var rect = _Rectangle.__pool.get ();
			// rect.setTo (0, 0, displayObject.width, displayObject.height);
			// (renderer._ : _Context3DRenderer).__pushMaskRect (rect, (displayObject._ : _DisplayObject).__renderTransform);

			// var color:ARGB = (displayObject.opaqueBackground:ARGB);
			// gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, 1);
			// gl.clear (gl.COLOR_BUFFER_BIT);

			// (renderer._ : _Context3DRenderer).__popMaskRect ();
			// (renderer._ : _Context3DRenderer).__popMaskObject (displayObject);

			// _Rectangle.__pool.release (rect);
		}

		if ((displayObject._ : _DisplayObject).__graphics != null)
		{
			Context3DShape.renderMask(displayObject, renderer);
		}
	}
}
#end
