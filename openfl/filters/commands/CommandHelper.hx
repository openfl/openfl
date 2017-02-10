package openfl.filters.commands;

import lime.graphics.GLRenderContext;

import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.opengl.utils.VertexAttribute;

import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shader;
import lime.utils.Float32Array;

import openfl._internal.renderer.RenderSession;

@:access(openfl.display.BitmapData)
@:access(openfl.display.Shader)

class CommandHelper {

	private static var vertexArray : openfl._internal.renderer.opengl.utils.VertexArray;

	public static function initialize(renderSession:RenderSession)
	{
		var attributes:Array<VertexAttribute> = [];

		attributes.push(new VertexAttribute(2, ElementType.FLOAT, false, DefAttrib.Position));
		attributes.push(new VertexAttribute(2, ElementType.FLOAT, false, DefAttrib.TexCoord));

		vertexArray = new VertexArray(attributes, 4 * 4 * ( 2 + 2 ), true);
		var positions = new Float32Array(vertexArray.buffer);

		positions[0] 	= 0;
		positions[1] 	= 0;
		positions[4] 	= 1;
		positions[5] 	= 0;
		positions[8] 	= 0;
		positions[9] 	= 1;
		positions[12] 	= 1;
		positions[13] 	= 1;

		positions[2] = 0;
		positions[3] = 0;
		positions[6] = 1;
		positions[7] = 0;
		positions[10] = 0;
		positions[11] = 1;
		positions[14] = 1;
		positions[15] = 1;

		vertexArray.setContext(renderSession.gl, positions);

	}

	public static function apply (renderSession:RenderSession, target:BitmapData, source:BitmapData, shader:Shader, drawSelf:Bool) {

		if (target.__usingPingPongTexture) {
			target.__pingPongTexture.swap();
		}

		if (drawSelf) {
			target.__pingPongTexture.useOldTexture = true;
		}

		target.__pushFrameBuffer(renderSession, true,  true, true);

		var gl = renderSession.gl;

		prepareShader (gl, shader, source);
		var internalShader = shader.__shader;
		renderSession.shaderManager.setShader(internalShader);

		vertexArray.bind();
		// TODO cache this somehow?, don't do each state change?
		internalShader.bindVertexArray(vertexArray);

		var blendMode:BlendMode = internalShader.blendMode;
		
		if (blendMode == null) {
			blendMode = NORMAL;
		}
		
		renderSession.blendModeManager.setBlendMode(blendMode);


		gl.activeTexture(gl.TEXTURE0 + 0);
		gl.bindTexture(gl.TEXTURE_2D, source.getTexture (gl));

		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);

		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, internalShader.wrapS);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, internalShader.wrapT);

		internalShader.applyData(shader.data, renderSession);

		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);

		target.__popFrameBuffer (renderSession, false);

		if (drawSelf) {
			target.__pingPongTexture.useOldTexture = false;
		}
	}

	inline static function prepareShader(gl:GLRenderContext, flashShader:Shader, ?bd:BitmapData) {
		if (flashShader != null) {
			flashShader.__init(gl);
			flashShader.__shader.wrapS = flashShader.repeatX;
			flashShader.__shader.wrapT = flashShader.repeatY;
			flashShader.__shader.smooth = flashShader.smooth;
			flashShader.__shader.blendMode = flashShader.blendMode;

			var objSize = flashShader.data.get(Shader.uObjectSize);
			var texSize = flashShader.data.get(Shader.uTextureSize);
			var scaleVector = flashShader.data.get ("openfl_uScaleVector");

			if (bd != null) {
				objSize.value[0] = bd.width;
				objSize.value[1] = bd.height;
				if(bd.__pingPongTexture != null) {
					var renderTexture = bd.__pingPongTexture.renderTexture;
					texSize.value[0] = @:privateAccess renderTexture.__width;
					texSize.value[1] = @:privateAccess renderTexture.__height;
					scaleVector.value[0] = @:privateAccess renderTexture.__uvData.x1;
					scaleVector.value[1] = @:privateAccess renderTexture.__uvData.y2;
				} else {
					texSize.value[0] = bd.width;
					texSize.value[1] = bd.height;
					scaleVector.value[0] = bd.__uvData.x1;
					scaleVector.value[1] = bd.__uvData.y2;
				}
			} else {
				objSize.value[0] = 0;
				objSize.value[1] = 0;
				texSize.value[0] = 0;
				texSize.value[1] = 0;
				scaleVector.value[0] = 0;
				scaleVector.value[1] = 0;
			}
		}
	}
}
