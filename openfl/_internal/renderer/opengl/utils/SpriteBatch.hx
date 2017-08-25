package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.*;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;
import openfl._internal.renderer.opengl.shaders2.DefaultMaskedShader.MaskedUniform;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;
import openfl.display.Shader in FlashShader;
import openfl.display.GLShaderData;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.gl.GLBuffer;
import openfl.gl.GLTexture;
import openfl.display.BlendMode;
import lime.utils.*;
import lime.math.Vector2;

class VertexBufferContext
{
	public function new()
	{
	}

	public var vertexArray:VertexArray;
	public var positions:Float32Array;
	public var colors:UInt32Array;
}

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Shader)
@:access(openfl.geom.Matrix)
class SpriteBatch {

	static inline var VERTS_PER_SPRITE:Int = 4;

	public var gl:GLRenderContext;
	var renderSession:RenderSession;

	var states:Array<State> = [];
	var currentState:State;

	var vertexArray:VertexArray;
	var positions:Float32Array;
	var colors:UInt32Array;

	var indexBuffer:GLBuffer;
	var indices:UInt16Array;

	public var drawing:Bool = false;
	public var preventFlush:Bool = false;

	var clipRect:Rectangle;
	var maskBitmap:BitmapData;
	var maskMatrix:Matrix;

	var maxSprites:Int;
	var batchedSprites:Int;
	var vertexArraySize:Int;
	var indexArraySize:Int;
	var maxElementsPerVertex:Int;
	var elementsPerVertex:Int;

	var writtenVertexBytes:Int = 0;

	var shader:Shader;
	var attributes:Array<VertexAttribute> = [];

	var enableColor:Bool = true;

	var lastEnableColor:Bool = true;

	var matrix:Matrix = new Matrix();
	var colorTransform:ColorTransform = new ColorTransform();

	var vertexBufferContexts:Array<VertexBufferContext>;
	var vertexBufferContextIndex:Int = 0;

	public function new(gl:GLRenderContext, maxSprites:Int = 2000, vertexBufferContextCount:Int = 3) {
		this.maxSprites = maxSprites;

		attributes.push(new VertexAttribute(2, ElementType.FLOAT, false, DefAttrib.Position));
		attributes.push(new VertexAttribute(2, ElementType.FLOAT, false, DefAttrib.TexCoord));
		attributes.push(new VertexAttribute(4, ElementType.UNSIGNED_BYTE, true, DefAttrib.Color));

		attributes[2].defaultValue = new Float32Array([1, 1, 1, 1]);

		maxElementsPerVertex = 0;

		for (a in attributes) {
			maxElementsPerVertex += a.elements;
		}

		vertexArraySize = maxSprites * maxElementsPerVertex * VERTS_PER_SPRITE * 4;
		indexArraySize = maxSprites * 6;

		vertexBufferContexts = new Array<VertexBufferContext>();

		for(i in 0...vertexBufferContextCount)
		{
			vertexBufferContexts.push(new VertexBufferContext());
			var vbc = vertexBufferContexts[i];
			vbc.vertexArray = new VertexArray(attributes, vertexArraySize, false);
			vbc.positions = new Float32Array(vbc.vertexArray.buffer);
			vbc.colors = new UInt32Array(vbc.vertexArray.buffer);
		}

		vertexArray = vertexBufferContexts[0].vertexArray;
		positions = vertexBufferContexts[0].positions;
		colors = vertexBufferContexts[0].colors;

		indices = new UInt16Array(indexArraySize);

		var i = 0, j = 0;
		while (i < indexArraySize) {
			indices[i + 0] = j + 0;
			indices[i + 1] = j + 1;
			indices[i + 2] = j + 2;
			indices[i + 3] = j + 0;
			indices[i + 4] = j + 2;
			indices[i + 5] = j + 3;
			i += 6;
			j += 4;
		}

		currentState = new State();
		drawing = false;
		batchedSprites = 0;

		setContext(gl);

	}

	public function destroy() {

		for(vbc in vertexBufferContexts)
		{
			vbc.vertexArray.destroy();
			vbc.vertexArray = null;
		}

		indices = null;
		gl.deleteBuffer(indexBuffer);

		currentState.destroy();
		for (state in states) {
			state.destroy();
		}

		colorTransform = null;

		gl = null;
	}
	
	public function begin(renderSession:RenderSession, ?clipRect:Rectangle = null, ?maskBitmap:BitmapData, ?maskMatrix:Matrix):Void {
		
		this.renderSession = renderSession;
		shader = renderSession.shaderManager.defaultShader;
		start(clipRect, maskBitmap, maskMatrix);

	}

	public function finish() {
		stop();
		clipRect = null;
	}

	public function start(clipRect:Rectangle, mask: BitmapData = null, maskMatrix:Matrix = null) {
		drawing = true;

		this.maskBitmap = mask;
		this.maskMatrix = maskMatrix;
		this.clipRect = clipRect;
	}

	public function stop() {
		drawing = false;
		flush();
	}

	public inline function renderBitmapData(bitmapData:BitmapData, smoothing:Bool, matrix:Matrix, ct:ColorTransform, ?alpha:Float = 1, ?blendMode:BlendMode, ?flashShader:FlashShader, ?pixelSnapping:PixelSnapping) {
		if (bitmapData == null) return;

		renderBitmapDataEx(bitmapData, bitmapData.width, bitmapData.height, bitmapData.__uvData, smoothing, matrix, ct, alpha, blendMode, flashShader, pixelSnapping);
	}

	public function renderBitmapDataEx(bitmapData:BitmapData, width:Float, height:Float, uvs:TextureUvs, smoothing:Bool, matrix:Matrix, ct:ColorTransform, alpha:Float, blendMode:BlendMode, flashShader:FlashShader, pixelSnapping:PixelSnapping) {
		var texture = bitmapData.getTexture(gl);

		if (batchedSprites >= maxSprites) {
			flush();
		}

		if (uvs == null) return;

		prepareShader(flashShader, bitmapData);

		var color:Int = ((Std.int(alpha * 255)) & 0xFF) << 24 | 0xFFFFFF;

		//enableAttributes(color);
		enableAttributes(0);

		var renderTargetBaseTransform = renderSession.getRenderTargetBaseTransform ();
		var localMatrix = Matrix.pool.get ();

		localMatrix.copyFrom (matrix);
		localMatrix.concat (renderTargetBaseTransform);

		var index = batchedSprites * 4 * elementsPerVertex;
		fillVertices(index, width, height, localMatrix, uvs, color, pixelSnapping);

		var itIsSimpleBlit:Bool = Math.abs (Math.abs (localMatrix.a) * width - bitmapData.physicalWidth) < 0.5
		&& Math.abs (Math.abs (localMatrix.d) * height - bitmapData.physicalHeight) < 0.5
		&& Math.abs (localMatrix.b) < 0.001
		&& Math.abs (localMatrix.c) < 0.001;

		setState(batchedSprites, texture, smoothing && !itIsSimpleBlit, blendMode, ct, flashShader);

		batchedSprites++;
		Matrix.pool.put (localMatrix);
	}


	inline function fillVertices(index:Int, width:Float, height:Float, matrix:Matrix, uvs:TextureUvs,
		color:Int = 0xFFFFFFFF, ?pixelSnapping:PixelSnapping) {

		var a = matrix.a;
		var b = matrix.b;
		var c = matrix.c;
		var d = matrix.d;
		var tx = matrix.tx;
		var ty = matrix.ty;

		// POSITION
		if (pixelSnapping == null || pixelSnapping == NEVER) {
			positions[index + 0] 	= (tx);
			positions[index + 1] 	= (ty);
			positions[index + 5] 	= (a * width + tx);
			positions[index + 6] 	= (b * width + ty);
			positions[index + 10] 	= (a * width + c * height + tx);
			positions[index + 11] 	= (d * height + b * width + ty);
			positions[index + 15] 	= (c * height + tx);
			positions[index + 16] 	= (d * height + ty);
		} else {
			positions[index + 0] 	= Math.fround(tx);
			positions[index + 1] 	= Math.fround(ty);
			positions[index + 5] 	= Math.fround(tx) + a * width;
			positions[index + 6] 	= Math.fround(ty) + b * width;
			positions[index + 10] 	= Math.fround(tx) + a * width + c * height;
			positions[index + 11] 	= Math.fround(ty) + d * height + b * width;
			positions[index + 15] 	= Math.fround(tx) + c * height;
			positions[index + 16] 	= Math.fround(ty) + d * height;
		}

		// COLOR
		if (enableColor) {
			colors[index + 4] = colors[index + 9] = colors[index + 14] = colors[index + 19] = color;
		}

		// UVS
		positions[index + 2] = uvs.x0;
		positions[index + 3] = uvs.y0;
		positions[index + 7] = uvs.x1;
		positions[index + 8] = uvs.y1;
		positions[index + 12] = uvs.x2;
		positions[index + 13] = uvs.y2;
		positions[index + 17] = uvs.x3;
		positions[index + 18] = uvs.y3;

		writtenVertexBytes = index + 20;
	}

	inline function enableAttributes(?color:Int = 0xFFFFFFFF) {
		enableColor = color != 0xFFFFFFFF;

		if (enableColor != lastEnableColor) {
			flush();
			lastEnableColor = enableColor;
		}

		attributes[2].enabled = lastEnableColor;

		elementsPerVertex = getElementsPerVertex();
	}

	function flush() {

		if (preventFlush) throw "SpriteBatch flush forbidden";

		if (batchedSprites == 0) return;

		if (clipRect != null) {
			gl.enable(gl.SCISSOR_TEST);
			gl.scissor(Math.floor(clipRect.x),
						Math.floor(clipRect.y),
						Math.ceil(clipRect.width),
						Math.ceil(clipRect.height)
					);
		}

		renderSession.activeTextures = 1;
		vertexArray.bind();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);


		if (writtenVertexBytes > (vertexArraySize >> 1)) {
			vertexArray.upload(positions);
		} else {
			vertexArray.upload(positions.subarray(0, writtenVertexBytes));
		}

		setNextVertexBufferContext();

		var nextState:State;
		var batchSize:Int = 0;
		var start:Int = 0;

		currentState.shader = null;
		currentState.shaderData = null;
		currentState.texture = null;
		currentState.maskTexture = null;
		currentState.maskMatrix = null;
		currentState.textureSmooth = false;
		currentState.blendMode = renderSession.blendModeManager.currentBlendMode;
		currentState.colorTransform = null;

		for (i in 0...batchedSprites) {

			nextState = states[i];

			if (!nextState.equals(currentState)) {

				renderBatch(currentState, batchSize, start);

				start = i;
				batchSize = 0;

				currentState.shader = nextState.shader;
				currentState.shaderData = nextState.shaderData;
				currentState.texture = nextState.texture;
				currentState.maskTexture = nextState.maskTexture;
				var maskTextureUVScale = nextState.maskTextureUVScale;
				currentState.maskTextureUVScale.setTo(maskTextureUVScale.x, maskTextureUVScale.y);
				currentState.maskMatrix = nextState.maskMatrix;
				currentState.textureSmooth = nextState.textureSmooth;
				currentState.blendMode = nextState.blendMode;
				currentState.skipColorTransform = nextState.skipColorTransform;
				currentState.colorTransform = currentState.skipColorTransform ? null : nextState.colorTransform;

			}

			batchSize++;
		}

		renderBatch (currentState, batchSize, start);
		batchedSprites = 0;
		writtenVertexBytes = 0;

		if (clipRect != null) {
			gl.disable(gl.SCISSOR_TEST);
		}

	}


	function renderBatch(state:State, size:Int, start:Int) {
		if (size == 0 || state.texture == null) return;

		var shader:Shader = state.shader == null ?
			( state.maskTexture != null ? renderSession.shaderManager.defaultMaskedShader : renderSession.shaderManager.defaultShader )
			: state.shader;

		var updatedShader = false;
		renderSession.shaderManager.setShader(shader);
		shader.bindVertexArray(vertexArray);
		updatedShader = true;

		renderSession.blendModeManager.setBlendMode(shader.blendMode != null ? shader.blendMode : state.blendMode);

		shader.uniformMatrix3fv(shader.getUniformLocation (DefUniform.ProjectionMatrix), false, renderSession.projectionMatrix);

		if (state.colorTransform != null) {
			shader.uniform1i(shader.getUniformLocation (DefUniform.UseColorTransform), 1);
			var ct = state.colorTransform;
			shader.uniform4f(shader.getUniformLocation (DefUniform.ColorMultiplier),
						ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, 1);
			shader.uniform4f(shader.getUniformLocation (DefUniform.ColorOffset),
						ct.redOffset / 255., ct.greenOffset / 255., ct.blueOffset / 255., ct.alphaOffset / 255.);
		} else {
			shader.uniform1i(shader.getUniformLocation (DefUniform.UseColorTransform), 0);
			shader.uniform4f(shader.getUniformLocation (DefUniform.ColorMultiplier), 1, 1, 1, 1);
			shader.uniform4f(shader.getUniformLocation (DefUniform.ColorOffset), 0, 0, 0, 0);
		}

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, state.texture);

		if ((shader.smooth != null && shader.smooth) || state.textureSmooth) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
		}

		if ( updatedShader ) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, shader.wrapS);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, shader.wrapT);
		}

		if (state.maskTexture != null){
			gl.activeTexture(gl.TEXTURE1);
			gl.bindTexture(gl.TEXTURE_2D, state.maskTexture);

			shader.uniformMatrix3fv(shader.getUniformLocation (MaskedUniform.MaskMatrix), false, state.maskMatrix);
			shader.uniform2f( shader.getUniformLocation(MaskedUniform.MaskUVScale), state.maskTextureUVScale.x, state.maskTextureUVScale.y );
		}

		shader.applyData(state.shaderData, renderSession);

		gl.drawElements (gl.TRIANGLES, size * 6, gl.UNSIGNED_SHORT, start * 6 * 2);

		renderSession.drawCount++;

	}

	inline function setState(index:Int, texture:GLTexture, ?smooth:Bool = false, ?blendMode:BlendMode, ?colorTransform:ColorTransform, ?shader:FlashShader) {

		var state:State = states[index];
		if (state == null) {
			state = states[index] = new State();
		}
		state.texture = texture;
		if (maskBitmap != null) {
			state.maskTexture = maskBitmap.getTexture(gl);
			var uvData = @:privateAccess maskBitmap.__uvData;
			state.maskTextureUVScale.setTo( uvData.x1, uvData.y2 );
			state.maskMatrix.copyFrom (maskMatrix);
		} else {
			state.maskTexture = null;
		}
		state.textureSmooth = smooth;
		state.blendMode = blendMode != null ? blendMode : NORMAL;

		// colorTransform is default, skipping it
		state.skipColorTransform = (colorTransform != null && @:privateAccess colorTransform.__isDefault());

		if (!state.skipColorTransform) {
			state.colorTransform.redMultiplier   = colorTransform.redMultiplier;
			state.colorTransform.greenMultiplier = colorTransform.greenMultiplier;
			state.colorTransform.blueMultiplier  = colorTransform.blueMultiplier;
			state.colorTransform.alphaMultiplier = colorTransform.alphaMultiplier;
			state.colorTransform.redOffset       = colorTransform.redOffset;
			state.colorTransform.greenOffset     = colorTransform.greenOffset;
			state.colorTransform.blueOffset      = colorTransform.blueOffset;
			state.colorTransform.alphaOffset     = colorTransform.alphaOffset;
		}

		if (shader == null) {
			state.shader = null;
			state.shaderData = null;
		} else {
			state.shader = shader.__shader;
			state.shaderData = shader.data;
		}
	}

	public function setContext(gl:GLRenderContext) {
		this.gl = gl;


		for(vbc in vertexBufferContexts)
		{
			vbc.vertexArray.setContext(gl, vbc.positions);
		}

		indexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);

	}

	inline function prepareShader(flashShader:FlashShader, ?bd:BitmapData) {
		if (flashShader != null) {
			flashShader.__init(this.gl);
			flashShader.__shader.wrapS = flashShader.repeatX;
			flashShader.__shader.wrapT = flashShader.repeatY;
			flashShader.__shader.smooth = flashShader.smooth;
			flashShader.__shader.blendMode = flashShader.blendMode;

			var objSize = flashShader.data.get(FlashShader.uObjectSize);
			var texSize = flashShader.data.get(FlashShader.uTextureSize);
			if (bd != null) {
				objSize.value[0] = bd.width;
				objSize.value[1] = bd.height;
				if(bd.__pingPongTexture != null) {
					texSize.value[0] = @:privateAccess bd.__pingPongTexture.renderTexture.__width;
					texSize.value[1] = @:privateAccess bd.__pingPongTexture.renderTexture.__height;
				} else {
					texSize.value[0] = bd.width;
					texSize.value[1] = bd.height;
				}
			} else {
				objSize.value[0] = 0;
				objSize.value[1] = 0;
				texSize.value[0] = 0;
				texSize.value[1] = 0;
			}
		}
	}

	inline function getElementsPerVertex() {
		var r = 0;

		for (a in attributes) {
			if(a.enabled) r += a.elements;
		}

		return r;
	}

	inline private function setNextVertexBufferContext()
	{
		vertexBufferContextIndex = (vertexBufferContextIndex+1) %  vertexBufferContexts.length;

		vertexArray = vertexBufferContexts[vertexBufferContextIndex].vertexArray;
		positions = vertexBufferContexts[vertexBufferContextIndex].positions;
		colors = vertexBufferContexts[vertexBufferContextIndex].colors;
	}

}

@:access(openfl.geom.ColorTransform)
private class State {
	public var texture:GLTexture;
	public var textureSmooth:Bool = true;
	public var blendMode:BlendMode;
	public var colorTransform:ColorTransform = new ColorTransform();
	public var skipColorTransform:Bool = false;
	public var shader:Shader;
	public var shaderData:GLShaderData;

	public var maskTexture:GLTexture;
	public var maskTextureUVScale:Vector2 = new Vector2();
	public var maskMatrix:Matrix = new Matrix();

	public function new() { }

	public inline function equals(other:State) {
		return (
				// if both shaders are null we are using the DefaultShader, if not, check the id
				((shader == null && other.shader == null) || (shader != null && other.shader != null && shader.ID == other.shader.ID)) &&
				texture == other.texture &&
				maskTexture == other.maskTexture && /* :TRICKY: if masks are equal, we expect on matrices being equal as well */
				textureSmooth == other.textureSmooth &&
				blendMode == other.blendMode &&
				// colorTransform.alphaMultiplier == object.__worldAlpha so we can skip it
				((skipColorTransform && other.skipColorTransform) || (!skipColorTransform && !other.skipColorTransform && colorTransform.__equals(other.colorTransform, true)))

		);
	}

	public function destroy() {
		texture = null;
		colorTransform = null;
		maskTexture = null;

		if (maskMatrix != null) {
			maskMatrix = null;
		}
	}
}
