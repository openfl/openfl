package openfl._internal.renderer.context3D;


import lime.utils.Float32Array;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.OpenGLRenderer;

#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml(' tags="haxe,release" ')
@:noDebug
#end

@:access(openfl.display3D.Context3D)
@:access(openfl.display.Bitmap)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)


class Context3DBitmap {
	
	
	public static function render (bitmap:Bitmap, renderer:OpenGLRenderer):Void {
		
		if (!bitmap.__renderable || bitmap.__worldAlpha <= 0) return;
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			var context = renderer.__context3D;
			
			renderer.__setBlendMode (bitmap.__worldBlendMode);
			renderer.__pushMaskObject (bitmap);
			// renderer.filterManager.pushObject (bitmap);
			
			var shader = renderer.__initDisplayShader (cast bitmap.__worldShader);
			renderer.setShader (shader);
			renderer.applyBitmapData (bitmap.__bitmapData, renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled));
			renderer.applyMatrix (renderer.__getMatrix (bitmap.__renderTransform, bitmap.pixelSnapping));
			renderer.applyAlpha (bitmap.__worldAlpha);
			renderer.applyColorTransform (bitmap.__worldColorTransform);
			renderer.updateShader ();
			
			var vertexBuffer = bitmap.__bitmapData.getVertexBuffer (context);
			if (shader.__position != null) context.setVertexBufferAt (shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt (shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap.__bitmapData.getIndexBuffer (context);
			context.drawTriangles (indexBuffer);
			
			#if gl_stats
			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
			// renderer.filterManager.popObject (bitmap);
			renderer.__popMaskObject (bitmap);
			
		}
		
	}
	
	
	public static function renderMask (bitmap:Bitmap, renderer:OpenGLRenderer):Void {
		
		if (bitmap.__bitmapData != null && bitmap.__bitmapData.__isValid) {
			
			var context = renderer.__context3D;
			
			var shader = renderer.__maskShader;
			renderer.setShader (shader);
			renderer.applyBitmapData (Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix (renderer.__getMatrix (bitmap.__renderTransform, bitmap.pixelSnapping));
			renderer.updateShader ();
			
			var vertexBuffer = bitmap.__bitmapData.getVertexBuffer (context);
			if (shader.__position != null) context.setVertexBufferAt (shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt (shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = bitmap.__bitmapData.getIndexBuffer (context);
			context.drawTriangles (indexBuffer);
			
			#if gl_stats
			Context3DStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
			
			renderer.__clearShader ();
			
		}
		
	}
	
	
}