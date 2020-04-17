import * as internal from "../../../_internal/utils/InternalAccess";
import RectangleTexture from "../../../display3D/textures/RectangleTexture";
import Context3D from "../../../display3D/Context3D";
import Context3DTextureFormat from "../../../display3D/Context3DTextureFormat";
import Context3DVertexBufferFormat from "../../../display3D/Context3DVertexBufferFormat";
import IndexBuffer3D from "../../../display3D/IndexBuffer3D";
import VertexBuffer3D from "../../../display3D/VertexBuffer3D";
import DisplayObjectShader from "../../../display/DisplayObjectShader";
import Video from "../../../media/Video";
import Context3DMaskShader from "./Context3DMaskShader";
import Context3DRenderer from "./Context3DRenderer";
import PixelSnapping from "../../../display/PixelSnapping";

export default class Context3DVideo
{
	public static readonly VERTEX_BUFFER_STRIDE: number = 5;

	public static __textureSizeValue: Array<number> = [0, 0.];

	public static getIndexBuffer(video: Video, context: Context3D): IndexBuffer3D
	{
		if ((<internal.DisplayObject><any>video).__renderData.indexBuffer == null || (<internal.DisplayObject><any>video).__renderData.indexBufferContext != context)
		{
			// TODO: Use shared buffer on context

			(<internal.DisplayObject><any>video).__renderData.indexBufferData = new Uint16Array(6);
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[0] = 0;
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[1] = 1;
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[2] = 2;
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[3] = 2;
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[4] = 1;
			(<internal.DisplayObject><any>video).__renderData.indexBufferData[5] = 3;

			(<internal.DisplayObject><any>video).__renderData.indexBufferContext = context;
			(<internal.DisplayObject><any>video).__renderData.indexBuffer = context.createIndexBuffer(6);
			(<internal.DisplayObject><any>video).__renderData.indexBuffer.uploadFromTypedArray((<internal.DisplayObject><any>video).__renderData.indexBufferData);
		}

		return (<internal.DisplayObject><any>video).__renderData.indexBuffer;
	}

	public static getTexture(video: Video, context: Context3D): RectangleTexture
	{
		if ((<internal.Video><any>video).__stream == null) return null;

		var videoElement = (<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement();
		if (videoElement == null) return null;

		var gl = context.__gl;
		var internalFormat = gl.RGBA;
		var format = gl.RGBA;

		if (!(<internal.NetStream><any>(<internal.Video><any>video).__stream).__closed && videoElement.currentTime != (<internal.DisplayObject><any>video).__renderData.textureTime)
		{
			if ((<internal.DisplayObject><any>video).__renderData.texture == null)
			{
				(<internal.DisplayObject><any>video).__renderData.texture = context.createRectangleTexture(videoElement.videoWidth, videoElement.videoHeight, Context3DTextureFormat.BGRA, false);
			}

			context.__bindGLTexture2D((<internal.DisplayObject><any>video).__renderData.texture.__glTextureID);
			gl.texImage2D(gl.TEXTURE_2D, 0, internalFormat, format, gl.UNSIGNED_BYTE, videoElement);

			(<internal.DisplayObject><any>video).__renderData.textureTime = videoElement.currentTime;
		}

		return (<internal.DisplayObject><any>video).__renderData.texture as RectangleTexture;
	}

	public static getVertexBuffer(video: Video, context: Context3D): VertexBuffer3D
	{
		if ((<internal.DisplayObject><any>video).__renderData.vertexBuffer == null || (<internal.DisplayObject><any>video).__renderData.vertexBufferContext != context)
		{
			// #if openfl_power_of_two
			// var newWidth = 1;
			// var newHeight = 1;

			// while (newWidth < width)
			// {
			// 	newWidth <<= 1;
			// }

			// while (newHeight < height)
			// {
			// 	newHeight <<= 1;
			// }

			// var uvWidth = width / newWidth;
			// var uvHeight = height / newHeight;
			// #else
			var uvWidth = 1;
			var uvHeight = 1;
			// #end

			(<internal.DisplayObject><any>video).__renderData.vertexBufferData = new Float32Array(this.VERTEX_BUFFER_STRIDE * 4);

			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[0] = video.width;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[1] = video.height;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[3] = uvWidth;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[4] = uvHeight;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 1] = video.height;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE + 4] = uvHeight;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2] = video.width;
			(<internal.DisplayObject><any>video).__renderData.vertexBufferData[this.VERTEX_BUFFER_STRIDE * 2 + 3] = uvWidth;

			(<internal.DisplayObject><any>video).__renderData.vertexBufferContext = context;
			(<internal.DisplayObject><any>video).__renderData.vertexBuffer = context.createVertexBuffer(3, this.VERTEX_BUFFER_STRIDE);
			(<internal.DisplayObject><any>video).__renderData.vertexBuffer.uploadFromTypedArray((<internal.DisplayObject><any>video).__renderData.vertexBufferData);
		}

		return (<internal.DisplayObject><any>video).__renderData.vertexBuffer;
	}

	public static render(video: Video, renderer: Context3DRenderer): void
	{
		if (!(<internal.DisplayObject><any>video).__renderable || (<internal.DisplayObject><any>video).__worldAlpha <= 0 || (<internal.Video><any>video).__stream == null) return;

		var videoElement = (<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement();

		if (videoElement != null)
		{
			var context = renderer.context3D;
			var gl = context.__gl;

			var texture = this.getTexture(video, context);
			if (texture == null) return;

			renderer.__setBlendMode((<internal.DisplayObject><any>video).__worldBlendMode);
			renderer.__pushMaskObject(video);
			// renderer.filterManager.pushObject (video);

			var shader = renderer.__initDisplayShader((<internal.DisplayObject><any>video).__worldShader as DisplayObjectShader);
			renderer.setShader(shader);

			// TODO: Support ShaderInput<Video>
			renderer.applyBitmapData(null, true, false);
			// context.__bindGLTexture2D (getTexture(video, context));
			// shader.uImage0.input = bitmap.__bitmapData;
			// shader.uImage0.smoothing = renderer.__allowSmoothing && (bitmap.smoothing || renderer.__upscaled);
			renderer.applyMatrix(renderer.__getMatrix((<internal.DisplayObject><any>video).__renderTransform, PixelSnapping.AUTO));
			renderer.applyAlpha(renderer.__getAlpha((<internal.DisplayObject><any>video).__worldAlpha));
			renderer.applyColorTransform((<internal.DisplayObject><any>video).__worldColorTransform);

			if ((<internal.Shader><any>shader).__textureSize != null)
			{
				this.__textureSizeValue[0] = ((<internal.Video><any>video).__stream != null) ? videoElement.videoWidth : 0;
				this.__textureSizeValue[1] = ((<internal.Video><any>video).__stream != null) ? videoElement.videoHeight : 0;
				(<internal.Shader><any>shader).__textureSize.value = this.__textureSizeValue;
			}

			renderer.updateShader();

			context.setTextureAt(0, this.getTexture(video, context));
			context.__flushGLTextures();
			gl.uniform1i((<internal.Shader><any>shader).__texture.index, 0);

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

			var vertexBuffer = this.getVertexBuffer(video, context);
			if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			var indexBuffer = this.getIndexBuffer(video, context);
			context.drawTriangles(indexBuffer);

			renderer.__clearShader();

			// renderer.filterManager.popObject (video);
			renderer.__popMaskObject(video);
		}
	}

	public static renderMask(video: Video, renderer: Context3DRenderer): void
	{
		if ((<internal.Video><any>video).__stream == null) return;

		if ((<internal.NetStream><any>(<internal.Video><any>video).__stream).__getVideoElement() != null)
		{
			var context = renderer.context3D;

			var shader = renderer.__maskShader;
			renderer.setShader(shader);
			renderer.applyBitmapData(Context3DMaskShader.opaqueBitmapData, true);
			renderer.applyMatrix(renderer.__getMatrix((<internal.DisplayObject><any>video).__renderTransform, PixelSnapping.AUTO));
			renderer.updateShader();

			var vertexBuffer = this.getVertexBuffer(video, context);
			if ((<internal.Shader><any>shader).__position != null) context.setVertexBufferAt((<internal.Shader><any>shader).__position.index, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if ((<internal.Shader><any>shader).__textureCoord != null) context.setVertexBufferAt((<internal.Shader><any>shader).__textureCoord.index, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			var indexBuffer = this.getIndexBuffer(video, context);
			context.drawTriangles(indexBuffer);

			renderer.__clearShader();
		}
	}
}
