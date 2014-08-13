package openfl._internal.renderer.opengl;


import openfl._internal.renderer.canvas.CanvasTextField;
import openfl._internal.renderer.RenderSession;
import openfl.text.TextField;

@:access(openfl.text.TextField)


class GLTextField {
	
	
	public static function render (textField:TextField, renderSession:RenderSession) {
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
		
		#if js
		
		var gl = renderSession.gl;
		var changed = CanvasTextField.update (textField);
		
		if (textField.__texture == null) {
			
			textField.__texture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, (textField.__texture));
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			changed = true;
			
		}
		
		if (changed) {
			
			gl.bindTexture (gl.TEXTURE_2D, textField.__texture);
			
			// TODO: Premultiply
			
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textField.__canvas);
			gl.bindTexture (gl.TEXTURE_2D, null);
			
		}
		
		/*renderSession.shaderManager.setShader (renderSession.shaderManager.defaultShader);
		
		gl.activeTexture (gl.TEXTURE0);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		
		var projection = renderSession.projection;
		gl.uniform2f (shader.projectionVector, projection.x, projection.y);
		
		var stride =  vertSize * 4;
		gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
		gl.vertexAttribPointer (shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * 4);
		gl.vertexAttribPointer (shader.colorAttribute, 2, gl.FLOAT, false, stride, 4 * 4);*/
		
		#end
		
	}
	
	
}