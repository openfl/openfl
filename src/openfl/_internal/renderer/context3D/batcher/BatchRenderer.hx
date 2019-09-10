package openfl._internal.renderer.context3D.batcher;

import haxe.ds.IntMap;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.WebGLRenderContext;
import openfl.display.BlendMode;
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

// inspired by pixi.js SpriteRenderer

@SuppressWarnings("checkstyle:FieldDocComment")
class BatchRenderer
{
	private var gl:WebGLRenderContext;
	private var renderer:Context3DRenderer;
	private var maxQuads:Int;

	private var shader:MultiTextureShader;
	private var vertexBuffer:GLBuffer;
	private var indexBuffer:GLBuffer;

	private var batch:Batch;

	public var projectionMatrix:Float32Array;

	private var emptyTexture:GLTexture;

	public function new(renderer:Context3DRenderer, maxQuads:Int)
	{
		this.renderer = renderer;
		this.gl = renderer.gl;
		this.maxQuads = maxQuads;

		shader = new MultiTextureShader(gl);
		batch = new Batch(maxQuads, shader.maxTextures);

		emptyTexture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, emptyTexture);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);

		vertexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, batch.vertices, gl.DYNAMIC_DRAW);

		indexBuffer = gl.createBuffer();
		var indices = createIndicesForQuads(maxQuads);
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
	}

	public function push(quad:Quad):Void
	{
		var terminateBatch:Bool = batch.numQuads >= maxQuads || renderer.__blendMode != quad.blendMode;
		if (terminateBatch)
		{
			flush();
		}
		var texture:QuadTextureData = null;
		var unit = 0;
		for (i in 0...batch.numTextures)
		{
			if (batch.textures[i].data.glTexture == quad.texture.data.glTexture)
			{
				texture = batch.textures[i];
				unit = i;
				break;
			}
		}
		if (texture == null)
		{
			if (batch.numTextures == shader.maxTextures)
			{
				flush();
			}
			texture = quad.texture;
			unit = batch.numTextures;
			batch.textures[batch.numTextures++] = texture;
		}
		batch.push(unit, quad);
	}

	public function flush():Void
	{
		if (batch.numQuads == 0)
		{
			return;
		}

		@:privateAccess renderer.context3D.__flushGL();

		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);

		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, batch.vertices.subarray(0, batch.numQuads * Batch.FLOATS_PER_QUAD));

		var stride = MultiTextureShader.FLOATS_PER_VERTEX * Float32Array.BYTES_PER_ELEMENT;

		gl.vertexAttribPointer(shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
		gl.vertexAttribPointer(shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aTextureId, 1, gl.FLOAT, false, stride, 4 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorOffset, 4, gl.FLOAT, false, stride, 5 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorMultiplier, 4, gl.FLOAT, false, stride, 9 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aPremultipliedAlpha, 1, gl.FLOAT, false, stride, 13 * Float32Array.BYTES_PER_ELEMENT);

		shader.enable(projectionMatrix);

		for (i in 0...batch.numTextures)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			gl.bindTexture(gl.TEXTURE_2D, batch.textures[i].data.glTexture);
		}
		for (i in batch.numTextures...shader.maxTextures)
		{
			gl.activeTexture(gl.TEXTURE0 + i);
			gl.bindTexture(gl.TEXTURE_2D, emptyTexture);
		}
		gl.drawElements(gl.TRIANGLES, batch.numQuads * 6, gl.UNSIGNED_SHORT, 0);

		// start new batch
		batch.clear();
	}

	private static function createIndicesForQuads(numQuads:Int):UInt16Array
	{
		var totalIndices = numQuads * 3 * 2; // 2 triangles of 3 verties per quad
		var indices = new UInt16Array(totalIndices);
		var i = 0, j = 0;
		while (i < totalIndices)
		{
			indices[i + 0] = j + 0;
			indices[i + 1] = j + 1;
			indices[i + 2] = j + 2;
			indices[i + 3] = j + 0;
			indices[i + 4] = j + 2;
			indices[i + 5] = j + 3;
			i += 6;
			j += 4;
		}
		return indices;
	}
}

private class Batch
{
	public var indices:UInt16Array;
	public var vertices:Float32Array;
	public var textures:Array<QuadTextureData>;

	public var numQuads:Int = 0;
	public var numTextures:Int = 0;

	public static inline var FLOATS_PER_QUAD = MultiTextureShader.FLOATS_PER_VERTEX * 4;

	public function new(maxQuads:Int, maxTextures:Int)
	{
		vertices = new Float32Array(maxQuads * FLOATS_PER_QUAD);
		indices = new UInt16Array(maxQuads * 6);
		textures = [for (i in 0...maxTextures) null];

		trace(textures);
	}

	public function clear()
	{
		numQuads = 0;
		numTextures = 0;
	}

	public function push(textureUnit:Int, quad:Quad)
	{
		var vertexData = quad.vertexData;
		var uvs = quad.texture.uvs;
		var alpha = quad.alpha;
		var pma = quad.texture.premultipliedAlpha;
		var colorTransform = quad.colorTransform;
		var currentVertexBufferIndex = numQuads * FLOATS_PER_QUAD;

		inline function setVertex(i):Void
		{
			var offset = currentVertexBufferIndex + i * MultiTextureShader.FLOATS_PER_VERTEX;
			vertices[offset + 0] = vertexData[i * 2 + 0];
			vertices[offset + 1] = vertexData[i * 2 + 1];

			vertices[offset + 2] = uvs[i * 2 + 0];
			vertices[offset + 3] = uvs[i * 2 + 1];

			vertices[offset + 4] = textureUnit;

			if (colorTransform != null)
			{
				vertices[offset + 5] = colorTransform.redOffset / 255;
				vertices[offset + 6] = colorTransform.greenOffset / 255;
				vertices[offset + 7] = colorTransform.blueOffset / 255;
				vertices[offset + 8] = (colorTransform.alphaOffset / 255) * alpha;

				vertices[offset + 9] = colorTransform.redMultiplier;
				vertices[offset + 10] = colorTransform.greenMultiplier;
				vertices[offset + 11] = colorTransform.blueMultiplier;
				vertices[offset + 12] = colorTransform.alphaMultiplier * alpha;
			}
			else
			{
				vertices[offset + 5] = 0;
				vertices[offset + 6] = 0;
				vertices[offset + 7] = 0;
				vertices[offset + 8] = 0;

				vertices[offset + 9] = 1;
				vertices[offset + 10] = 1;
				vertices[offset + 11] = 1;
				vertices[offset + 12] = alpha;
			}
			vertices[offset + 13] = pma ? 1 : 0;
		}

		setVertex(0);
		setVertex(1);
		setVertex(2);
		setVertex(3);

		++numQuads;
	}
}
