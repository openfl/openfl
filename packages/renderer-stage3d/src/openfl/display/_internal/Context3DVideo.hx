package openfl.display._internal;

import openfl.display.OpenGLRenderer;
import openfl.media.Video;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Shader)
@:access(openfl.geom.ColorTransform)
@:access(openfl.media.Video)
@:access(openfl.net.NetStream)
@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DVideo
{
	private static var __textureSizeValue:Array<Float> = [0, 0.];

	public static function render(video:Video, renderer:OpenGLRenderer):Void
	{
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;

		if (video.__stream.__video != null)
		{
			var context = renderer.__context3D;
			var gl = context.gl;

			var texture = video.__getTexture(context);
			if (texture == null) return;

			renderer.__setBlendMode(video.__worldBlendMode);
			renderer.__pushMaskObject(video);
			// renderer.filterManager.pushObject (video);

			var shader = renderer.__initDisplayShader(cast video.__worldShader);
			renderer.setShader(shader);

			// TODO: Support ShaderInput<Video>
			renderer.applyBitmapData(null, true, false);
			// context.__bindGLTexture2D (video.__getTexture (context));
			// shader.uImage0.input = bitmap.__bitmapData;
			// shader.uImage0.smoothing = renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled);
			renderer.applyMatrix(renderer.__getMatrix(video.__renderTransform, AUTO));
			renderer.applyAlpha(video.__worldAlpha);
			renderer.applyColorTransform(video.__worldColorTransform);

			if (shader.__textureSize != null)
			{
				__textureSizeValue[0] = (video.__stream != null) ? video.__stream.__video.videoWidth : 0;
				__textureSizeValue[1] = (video.__stream != null) ? video.__stream.__video.videoHeight : 0;
				shader.__textureSize.value = __textureSizeValue;
			}

			renderer.updateShader();

			context.setTextureAt(0, video.__getTexture(context));
			context.__flushGLTextures();
			gl.uniform1i(shader.__texture.index, 0);

			if (video.smoothing)
			{
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			}
			else
			{
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			}

			var vertexBuffer = video.__getVertexBuffer(context);
			if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = video.__getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer.__clearShader();

			// renderer.filterManager.popObject (video);
			renderer.__popMaskObject(video);
		}
		#end
	}

	public static function renderDrawable(video:Video, renderer:OpenGLRenderer):Void
	{
		Context3DVideo.render(video, renderer);
		renderer.__renderEvent(video);
	}

	public static function renderDrawableMask(video:Video, renderer:OpenGLRenderer):Void
	{
		Context3DVideo.renderMask(video, renderer);
	}

	public static function renderMask(video:Video, renderer:OpenGLRenderer):Void
	{
		#if (js && html5)
		if (video.__stream == null) return;

		if (video.__stream.__video != null)
		{
			var context = renderer.__context3D;
			var gl = context.gl;

			var shader = renderer.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer.__getMatrix(video.__renderTransform, AUTO));
			renderer.updateShader();

			var vertexBuffer = video.__getVertexBuffer(context);
			if (shader.__position != null) context.setVertexBufferAt(shader.__position.index, vertexBuffer, 0, FLOAT_3);
			if (shader.__textureCoord != null) context.setVertexBufferAt(shader.__textureCoord.index, vertexBuffer, 3, FLOAT_2);
			var indexBuffer = video.__getIndexBuffer(context);
			context.drawTriangles(indexBuffer);

			#if gl_stats
			Context3DStats.incrementDrawCall(DrawCallContext.STAGE);
			#end

			renderer.__clearShader();
		}
		#end
	}
}
