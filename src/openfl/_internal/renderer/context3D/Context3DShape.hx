package openfl._internal.renderer.context3D;


import lime.utils.Float32Array;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectShader;
import openfl.display.OpenGLRenderer;
import openfl.geom.Matrix;

#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.Shader)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)


class Context3DShape {
	
	
	public static function render (shape:DisplayObject, renderer:OpenGLRenderer):Void {
		
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			renderer.__setBlendMode (shape.__worldBlendMode);
			renderer.__pushMaskObject (shape);
			// renderer.filterManager.pushObject (shape);
			
			Context3DGraphics.render (graphics, renderer);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null && graphics.__visible) {
				
				var context = renderer.__context3D;
				
				var shader = renderer.__initDisplayShader (cast shape.__worldShader);
				renderer.setShader (shader);
				renderer.applyBitmapData (graphics.__bitmap, renderer.__allowSmoothing);
				renderer.applyMatrix (renderer.__getMatrix (graphics.__worldTransform, AUTO));
				renderer.applyAlpha (shape.__worldAlpha);
				renderer.applyColorTransform (shape.__worldColorTransform);
				renderer.updateShader ();
				
				var vertexBuffer = graphics.__bitmap.getVertexBuffer (context);
				if (shader.__position != null) context.setVertexBufferAt (shader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader.__textureCoord != null) context.setVertexBufferAt (shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics.__bitmap.getIndexBuffer (context);
				context.drawTriangles (indexBuffer);
				
				#if gl_stats
				Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				renderer.__clearShader ();
				
			}
			
			// renderer.filterManager.popObject (shape);
			renderer.__popMaskObject (shape);
			
		}
		
	}
	
	
	public static function renderMask (shape:DisplayObject, renderer:OpenGLRenderer):Void {
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			// TODO: Support invisible shapes
			
			Context3DGraphics.renderMask (graphics, renderer);
			
			var bounds = graphics.__bounds;
			
			if (graphics.__bitmap != null) {
				
				var context = renderer.__context3D;
				
				var shader = renderer.__maskShader;
				renderer.setShader (shader);
				renderer.applyBitmapData (graphics.__bitmap, renderer.__allowSmoothing);
				renderer.applyMatrix (renderer.__getMatrix (graphics.__worldTransform, AUTO));
				renderer.updateShader ();
				
				var vertexBuffer = graphics.__bitmap.getVertexBuffer (context);
				if (shader.__position != null) context.setVertexBufferAt (shader.__position.index, vertexBuffer, 0, FLOAT_3);
				if (shader.__textureCoord != null) context.setVertexBufferAt (shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
				var indexBuffer = graphics.__bitmap.getIndexBuffer (context);
				context.drawTriangles (indexBuffer);
				
				#if gl_stats
				Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
				#end
				
				renderer.__clearShader ();
				
			}
			
		}
		
	}
	
	
}