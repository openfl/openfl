package openfl._internal.renderer.context3D.batcher;

#if openfl_gl
import openfl._internal.backend.gl.GL;
import openfl._internal.backend.utils.Float32Array;
import openfl._internal.backend.utils.UInt16Array;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Shader;
import openfl.display.ShaderInput;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.WebGLRenderContext in WebGLRenderingContext;
#else
import openfl._internal.backend.gl.WebGLRenderingContext;
#end
#if gl_stats
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#end

@:access(openfl.display.Shader)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.geom.Matrix)
@SuppressWarnings("checkstyle:FieldDocComment")
class BatchRenderer
{
	private var gl:WebGLRenderingContext;
	private var renderer:Context3DRenderer;

	private var __batch:Batch;
	private var __indexBuffer:IndexBuffer3D;
	private var __emptyBitmapData:BitmapData;
	private var __maxQuads:Int;
	private var __maxTextures:Int;
	private var __samplers:Array<ShaderInput<BitmapData>> = [];
	private var __shader:BatchShader;
	private var __userUvs:Array<Float> = [for (i in 0...8) 0.0];
	private var __uvs:Array<Float>;
	private var __vertexBuffer:VertexBuffer3D;
	private var __vertices:Array<Float> = [for (i in 0...8) 0.0];

	private static inline var MAX_TEXTURES:Int = 16;

	private static var DEFAULT_UVS:Array<Float> = [
		0, 0,
		1, 0,
		1, 1,
		0, 1
	];

	public function new(renderer:Context3DRenderer, maxQuads:Int)
	{
		this.renderer = renderer;
		this.gl = renderer.gl;

		var context = renderer.context3D;

		__emptyBitmapData = new BitmapData(1, 1);

		__maxQuads = maxQuads;
		__maxTextures = Std.int(Math.min(MAX_TEXTURES, gl.getParameter(GL.MAX_TEXTURE_IMAGE_UNITS)));

		__shader = new BatchShader();
		__batch = new Batch(__maxQuads, __maxTextures);

		__vertexBuffer = context.createVertexBuffer(__maxQuads * 4, BatchShader.FLOATS_PER_VERTEX, DYNAMIC_DRAW);
		__vertexBuffer.uploadFromTypedArray(__batch.vertices);
		__indexBuffer = context.createIndexBuffer(__maxQuads * 6, STATIC_DRAW);
		__indexBuffer.uploadFromTypedArray(__createIndicesForQuads(__maxQuads));

		#if !macro
		__shader.aTextureId.__useArray = true;
		#end
		__samplers = [for (i in 0...__maxTextures) Reflect.field(__shader.data, "uSampler" + i)];
	}

	public function setVertices(transform:Matrix, x:Float, y:Float, w:Float, h:Float):Void
	{
		var x1 = x + w;
		var y1 = y + h;

		__vertices[0] = transform.__transformX(x, y);
		__vertices[1] = transform.__transformY(x, y);

		__vertices[2] = transform.__transformX(x1, y);
		__vertices[3] = transform.__transformY(x1, y);

		__vertices[4] = transform.__transformX(x1, y1);
		__vertices[5] = transform.__transformY(x1, y1);

		__vertices[6] = transform.__transformX(x, y1);
		__vertices[7] = transform.__transformY(x, y1);
	}

	public function useDefaultUvs():Void
	{
		__uvs = DEFAULT_UVS;
	}

	public function setUvs(u:Float, v:Float, s:Float, t:Float):Void
	{
		__userUvs[0] = u;
		__userUvs[1] = v;

		__userUvs[2] = s;
		__userUvs[3] = v;

		__userUvs[4] = s;
		__userUvs[5] = t;

		__userUvs[6] = u;
		__userUvs[7] = t;

		__uvs = __userUvs;
	}

	public function setUs(u:Float, s:Float):Void
	{
		__userUvs[0] = u;
		__userUvs[2] = s;
		__userUvs[4] = s;
		__userUvs[6] = u;

		__uvs = __userUvs;
	}

	public function setVs(v:Float, t:Float):Void
	{
		__userUvs[1] = v;
		__userUvs[3] = v;
		__userUvs[5] = t;
		__userUvs[7] = t;

		__uvs = __userUvs;
	}

	public function pushQuad(bitmapData:BitmapData, blendMode:BlendMode, alpha:Float, colorTransform:ColorTransform = null)
	{
		var terminateBatch:Bool = __batch.numQuads >= __maxQuads || __batch.blendMode != blendMode;
		#if (disable_batcher || openfl_disable_batcher)
		terminateBatch = true;
		#end
		if (terminateBatch)
		{
			flush();
		}

		var unit = 0;
		var texture:BitmapData = null;
		for (i in 0...__batch.numTextures)
		{
			if (__batch.textures[i] == bitmapData)
			{
				texture = __batch.textures[i];
				unit = i;
				break;
			}
		}
		if (texture == null)
		{
			// flush if we hit the texture limit
			if (__batch.numTextures == __maxTextures)
			{
				flush();
			}
			texture = bitmapData;
			unit = __batch.numTextures;
			__batch.textures[__batch.numTextures++] = texture;
		}

		__batch.blendMode = blendMode;
		__batch.push(unit, __vertices, __uvs, alpha, colorTransform);
	}

	public function flush():Void
	{
		if (__batch.numQuads == 0)
		{
			return;
		}

		var context = renderer.context3D;

		context.setCulling(NONE);
		renderer.__setBlendMode(__batch.blendMode);

		context.__bindGLArrayBuffer(__vertexBuffer.__id);

		var subArray = __batch.vertices.subarray(0, __batch.numQuads * Batch.FLOATS_PER_QUAD);
		gl.bufferSubData(GL.ARRAY_BUFFER, 0, subArray);

		renderer.setShader(__shader);

		renderer.applyMatrix(renderer.__getMatrix(Matrix.__identity, AUTO));
		renderer.useColorTransformArray();
		for (i in 0...__batch.numTextures)
		{
			__samplers[i].input = __batch.textures[i];
			__samplers[i].filter = LINEAR;
		}
		for (i in __batch.numTextures...__maxTextures)
		{
			__samplers[i].input = __emptyBitmapData;
		}
		renderer.updateShader();

		context.setVertexBufferAt(__shader.__position.index, __vertexBuffer, 0, FLOAT_2);
		context.setVertexBufferAt(__shader.__textureCoord.index, __vertexBuffer, 2, FLOAT_2);
		context.setVertexBufferAt(__shader.__colorMultiplier.index, __vertexBuffer, 4, FLOAT_4);
		context.setVertexBufferAt(__shader.__colorOffset.index, __vertexBuffer, 8, FLOAT_4);
		#if !macro
		context.setVertexBufferAt(__shader.aTextureId.index, __vertexBuffer, 12, FLOAT_1);
		#end

		context.drawTriangles(__indexBuffer, 0, __batch.numQuads * 2);

		#if gl_stats
		Context3DStats.incrementDrawCall(DrawCallContext.BATCHER);
		#end

		// start new batch
		__batch.clear();
	}

	private static function __createIndicesForQuads(numQuads:Int):UInt16Array
	{
		var totalIndices = numQuads * 6; // 2 triangles of 3 verties per quad
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
	public var blendMode:BlendMode;
	public var indices:UInt16Array;
	public var vertices:Float32Array;
	public var textures:Array<BitmapData>;

	public var numQuads:Int = 0;
	public var numTextures:Int = 0;

	public static inline var FLOATS_PER_QUAD = BatchShader.FLOATS_PER_VERTEX * 4;
	public static var IDENTITY_COLOR_TRANSFORM = new ColorTransform();

	public function new(maxQuads:Int, maxTextures:Int)
	{
		blendMode = null;
		vertices = new Float32Array(maxQuads * FLOATS_PER_QUAD);
		indices = new UInt16Array(maxQuads * 6);
		textures = [for (i in 0...maxTextures) null];
	}

	public function clear()
	{
		blendMode = null;
		numQuads = 0;
		numTextures = 0;
	}

	public function push(textureUnit:Int, verts:Array<Float>, uvs:Array<Float>, alpha:Float, colorTransform:ColorTransform)
	{
		var startOffset = numQuads * FLOATS_PER_QUAD;
		var ct = colorTransform != null ? colorTransform : IDENTITY_COLOR_TRANSFORM;

		var alphaOffset = ct.alphaOffset * alpha;

		inline function setVertex(i:Int):Void
		{
			var offset = startOffset + i * BatchShader.FLOATS_PER_VERTEX;
			vertices[offset + 0] = verts[i * 2 + 0];
			vertices[offset + 1] = verts[i * 2 + 1];
			vertices[offset + 2] = uvs[i * 2 + 0];
			vertices[offset + 3] = uvs[i * 2 + 1];
			vertices[offset + 4] = ct.redMultiplier;
			vertices[offset + 5] = ct.greenMultiplier;
			vertices[offset + 6] = ct.blueMultiplier;
			vertices[offset + 7] = alpha;
			vertices[offset + 8] = ct.redOffset;
			vertices[offset + 9] = ct.greenOffset;
			vertices[offset + 10] = ct.blueOffset;
			vertices[offset + 11] = alphaOffset;
			vertices[offset + 12] = textureUnit;
		}

		setVertex(0);
		setVertex(1);
		setVertex(2);
		setVertex(3);

		++numQuads;
	}
}

private class BatchShader extends Shader
{
	public static inline var FLOATS_PER_VERTEX = 2 + 2 + 4 + 4 + 1;

	@:glVertexSource("
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec2 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		attribute float aTextureId;

		uniform mat4 openfl_Matrix;

		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float vTextureId;

		void main(void) {
			gl_Position = openfl_Matrix * vec4(openfl_Position, 0, 1);
			openfl_TextureCoordv = openfl_TextureCoord;
			openfl_ColorMultiplierv = openfl_ColorMultiplier;
			openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
			vTextureId = aTextureId;
		}
	")
	@:glFragmentSource('
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		varying float vTextureId;

		uniform sampler2D uSampler0;
		uniform sampler2D uSampler1;
		uniform sampler2D uSampler2;
		uniform sampler2D uSampler3;
		uniform sampler2D uSampler4;
		uniform sampler2D uSampler5;
		uniform sampler2D uSampler6;
		uniform sampler2D uSampler7;
		uniform sampler2D uSampler8;
		uniform sampler2D uSampler9;
		uniform sampler2D uSampler10;
		uniform sampler2D uSampler11;
		uniform sampler2D uSampler12;
		uniform sampler2D uSampler13;
		uniform sampler2D uSampler14;
		uniform sampler2D uSampler15;

		void main(void) {
			vec4 color;
			if (vTextureId == 0.0) color = texture2D(uSampler0, openfl_TextureCoordv);
			else if (vTextureId == 1.0) color = texture2D(uSampler1, openfl_TextureCoordv);
			else if (vTextureId == 2.0) color = texture2D(uSampler2, openfl_TextureCoordv);
			else if (vTextureId == 3.0) color = texture2D(uSampler3, openfl_TextureCoordv);
			else if (vTextureId == 4.0) color = texture2D(uSampler4, openfl_TextureCoordv);
			else if (vTextureId == 5.0) color = texture2D(uSampler5, openfl_TextureCoordv);
			else if (vTextureId == 6.0) color = texture2D(uSampler6, openfl_TextureCoordv);
			else if (vTextureId == 7.0) color = texture2D(uSampler7, openfl_TextureCoordv);
			else if (vTextureId == 8.0) color = texture2D(uSampler8, openfl_TextureCoordv);
			else if (vTextureId == 9.0) color = texture2D(uSampler9, openfl_TextureCoordv);
			else if (vTextureId == 10.0) color = texture2D(uSampler10, openfl_TextureCoordv);
			else if (vTextureId == 11.0) color = texture2D(uSampler11, openfl_TextureCoordv);
			else if (vTextureId == 12.0) color = texture2D(uSampler12, openfl_TextureCoordv);
			else if (vTextureId == 13.0) color = texture2D(uSampler13, openfl_TextureCoordv);
			else if (vTextureId == 14.0) color = texture2D(uSampler14, openfl_TextureCoordv);
			else if (vTextureId == 15.0) color = texture2D(uSampler15, openfl_TextureCoordv);

			if (color.a == 0.0) {

				gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

			} else {

				color = vec4(color.rgb / color.a, color.a);
				color = clamp((color * openfl_ColorMultiplierv) + openfl_ColorOffsetv, 0.0, 1.0);
				gl_FragColor = vec4(color.rgb * color.a, color.a);

			}
		}
	')
	public function new()
	{
		super();
	}
}
#end
