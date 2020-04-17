import * as internal from "../../../../_internal/utils/InternalAccess";
import BitmapData from "../../../../display/BitmapData";
import BlendMode from "../../../../display/BlendMode";
import PixelSnapping from "../../../../display/PixelSnapping";
import Shader from "../../../../display/Shader";
import ShaderParameter from "../../../../display/ShaderParameter";
import ShaderInput from "../../../../display/ShaderInput";
import Context3DBufferUsage from "../../../../display3D/Context3DBufferUsage";
import Context3DTextureFilter from "../../../../display3D/Context3DTextureFilter";
import Context3DTriangleFace from "../../../../display3D/Context3DTriangleFace";
import Context3DVertexBufferFormat from "../../../../display3D/Context3DVertexBufferFormat";
import IndexBuffer3D from "../../../../display3D/IndexBuffer3D";
import VertexBuffer3D from "../../../../display3D/VertexBuffer3D";
import ColorTransform from "../../../../geom/ColorTransform";
import Matrix from "../../../../geom/Matrix";
import Context3DRenderer from "../Context3DRenderer";

class BatchShader extends Shader
{
	public static readonly FLOATS_PER_VERTEX = 2 + 2 + 4 + 4 + 1;

	glVertexSource = `
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
	`;

	glFragmentSource = `
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

			if (color.a == 0.0)
			{

				gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

			} else
			{

				color = vec4(color.rgb / color.a, color.a);
				color = clamp((color * openfl_ColorMultiplierv) + openfl_ColorOffsetv, 0.0, 1.0);
				gl_FragColor = vec4(color.rgb * color.a, color.a);

			}
		}
	`;

	public constructor()
	{
		super();
	}
}

export default class BatchRenderer
{
	private gl: WebGLRenderingContext;
	private renderer: Context3DRenderer;

	private __batch: Batch;
	private __indexBuffer: IndexBuffer3D;
	private __emptyBitmapData: BitmapData;
	private __maxQuads: number;
	private __maxTextures: number;
	private __samplers: Array<ShaderInput<BitmapData>> = [];
	private __shader: BatchShader;
	private __userUvs: Array<number> = [0, 0, 0, 0, 0, 0, 0, 0];
	private __uvs: Array<number>;
	private __vertexBuffer: VertexBuffer3D;
	private __vertices: Array<number> = [0, 0, 0, 0, 0, 0, 0, 0];

	private static readonly MAX_TEXTURES: number = 16;

	private static DEFAULT_UVS: Array<number> = [
		0, 0,
		1, 0,
		1, 1,
		0, 1
	];

	public constructor(renderer: Context3DRenderer, maxQuads: number)
	{
		this.renderer = renderer;
		this.gl = renderer.gl;

		var context = renderer.context3D;

		this.__emptyBitmapData = new BitmapData(1, 1);

		this.__maxQuads = maxQuads;
		this.__maxTextures = Math.min(BatchRenderer.MAX_TEXTURES, this.gl.getParameter(this.gl.MAX_TEXTURE_IMAGE_UNITS));

		this.__shader = new BatchShader();
		this.__batch = new Batch(this.__maxQuads, this.__maxTextures);

		this.__vertexBuffer = context.createVertexBuffer(this.__maxQuads * 4, BatchShader.FLOATS_PER_VERTEX, Context3DBufferUsage.DYNAMIC_DRAW);
		this.__vertexBuffer.uploadFromTypedArray(this.__batch.vertices);
		this.__indexBuffer = context.createIndexBuffer(this.__maxQuads * 6, Context3DBufferUsage.STATIC_DRAW);
		this.__indexBuffer.uploadFromTypedArray(BatchRenderer.__createIndicesForQuads(this.__maxQuads));

		(this.__shader.data.aTextureId as ShaderParameter).__useArray = true;
		this.__samplers = [];
		for (let i = 0; i < this.__maxTextures; i++)
		{
			this.__samplers[i] = this.__shader.data["uSampler" + i] as ShaderInput<BitmapData>;
		}
	}

	public setVertices(transform: Matrix, x: number, y: number, w: number, h: number): void
	{
		var x1 = x + w;
		var y1 = y + h;

		this.__vertices[0] = (<internal.Matrix><any>transform).__transformX(x, y);
		this.__vertices[1] = (<internal.Matrix><any>transform).__transformY(x, y);

		this.__vertices[2] = (<internal.Matrix><any>transform).__transformX(x1, y);
		this.__vertices[3] = (<internal.Matrix><any>transform).__transformY(x1, y);

		this.__vertices[4] = (<internal.Matrix><any>transform).__transformX(x1, y1);
		this.__vertices[5] = (<internal.Matrix><any>transform).__transformY(x1, y1);

		this.__vertices[6] = (<internal.Matrix><any>transform).__transformX(x, y1);
		this.__vertices[7] = (<internal.Matrix><any>transform).__transformY(x, y1);
	}

	public useDefaultUvs(): void
	{
		this.__uvs = BatchRenderer.DEFAULT_UVS;
	}

	public setUvs(u: number, v: number, s: number, t: number): void
	{
		this.__userUvs[0] = u;
		this.__userUvs[1] = v;

		this.__userUvs[2] = s;
		this.__userUvs[3] = v;

		this.__userUvs[4] = s;
		this.__userUvs[5] = t;

		this.__userUvs[6] = u;
		this.__userUvs[7] = t;

		this.__uvs = this.__userUvs;
	}

	public setUs(u: number, s: number): void
	{
		this.__userUvs[0] = u;
		this.__userUvs[2] = s;
		this.__userUvs[4] = s;
		this.__userUvs[6] = u;

		this.__uvs = this.__userUvs;
	}

	public setVs(v: number, t: number): void
	{
		this.__userUvs[1] = v;
		this.__userUvs[3] = v;
		this.__userUvs[5] = t;
		this.__userUvs[7] = t;

		this.__uvs = this.__userUvs;
	}

	public pushQuad(bitmapData: BitmapData, blendMode: BlendMode, alpha: number, colorTransform: ColorTransform = null)
	{
		var terminateBatch: boolean = this.__batch.numQuads >= this.__maxQuads || this.__batch.blendMode != blendMode;
		// #if(disable_batcher || openfl_disable_batcher)
		// terminateBatch = true;
		// #end
		if (terminateBatch)
		{
			this.flush();
		}

		var unit = 0;
		var texture: BitmapData = null;
		for (let i = 0; i < this.__batch.numTextures; i++)
		{
			if (this.__batch.textures[i] == bitmapData)
			{
				texture = this.__batch.textures[i];
				unit = i;
				break;
			}
		}
		if (texture == null)
		{
			// flush if we hit the texture limit
			if (this.__batch.numTextures == this.__maxTextures)
			{
				this.flush();
			}
			texture = bitmapData;
			unit = this.__batch.numTextures;
			this.__batch.textures[this.__batch.numTextures++] = texture;
		}

		this.__batch.blendMode = blendMode;
		this.__batch.push(unit, this.__vertices, this.__uvs, alpha, colorTransform);
	}

	public flush(): void
	{
		if (this.__batch.numQuads == 0)
		{
			return;
		}

		var context = this.renderer.context3D;

		context.setCulling(Context3DTriangleFace.NONE);
		this.renderer.__setBlendMode(this.__batch.blendMode);

		context.__bindGLArrayBuffer((<internal.VertexBuffer3D><any>this.__vertexBuffer).__glBufferID);

		var subArray = this.__batch.vertices.subarray(0, this.__batch.numQuads * Batch.FLOATS_PER_QUAD);
		this.gl.bufferSubData(this.gl.ARRAY_BUFFER, 0, subArray);

		this.renderer.setShader(this.__shader);

		this.renderer.applyMatrix(this.renderer.__getMatrix((<internal.Matrix><any>Matrix).__identity, PixelSnapping.AUTO));
		this.renderer.useColorTransformArray();
		for (let i = 0; i < this.__batch.numTextures; i++)
		{
			this.__samplers[i].input = this.__batch.textures[i];
			this.__samplers[i].filter = Context3DTextureFilter.LINEAR;
		}
		for (let i = this.__batch.numTextures; i < this.__maxTextures; i++)
		{
			this.__samplers[i].input = this.__emptyBitmapData;
		}
		this.renderer.updateShader();

		context.setVertexBufferAt((<internal.Shader><any>this.__shader).__position.index, this.__vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
		context.setVertexBufferAt((<internal.Shader><any>this.__shader).__textureCoord.index, this.__vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
		context.setVertexBufferAt((<internal.Shader><any>this.__shader).__colorMultiplier.index, this.__vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4);
		context.setVertexBufferAt((<internal.Shader><any>this.__shader).__colorOffset.index, this.__vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4);
		context.setVertexBufferAt(this.__shader.data.aTextureId.index, this.__vertexBuffer, 12, Context3DVertexBufferFormat.FLOAT_1);

		context.drawTriangles(this.__indexBuffer, 0, this.__batch.numQuads * 2);

		// start new batch
		this.__batch.clear();
	}

	private static __createIndicesForQuads(numQuads: number): Uint16Array
	{
		var totalIndices = numQuads * 6; // 2 triangles of 3 vertices per quad
		var indices = new Uint16Array(totalIndices);
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

class Batch
{
	public blendMode: BlendMode;
	public indices: Uint16Array;
	public vertices: Float32Array;
	public textures: Array<BitmapData>;

	public numQuads: number = 0;
	public numTextures: number = 0;

	public static readonly FLOATS_PER_QUAD = BatchShader.FLOATS_PER_VERTEX * 4;
	public static IDENTITY_COLOR_TRANSFORM = new ColorTransform();

	public constructor(maxQuads: number, maxTextures: number)
	{
		this.blendMode = null;
		this.vertices = new Float32Array(maxQuads * Batch.FLOATS_PER_QUAD);
		this.indices = new Uint16Array(maxQuads * 6);
		this.textures = [];
		for (let i = 0; i < maxTextures; i++)
		{
			this.textures[i] = null;
		}
	}

	public clear()
	{
		this.blendMode = null;
		this.numQuads = 0;
		this.numTextures = 0;
	}

	public push(textureUnit: number, verts: Array<number>, uvs: Array<number>, alpha: number, colorTransform: ColorTransform)
	{
		var startOffset = this.numQuads * Batch.FLOATS_PER_QUAD;
		var ct = colorTransform != null ? colorTransform : Batch.IDENTITY_COLOR_TRANSFORM;

		var alphaOffset = ct.alphaOffset * alpha;

		var setVertex = (i: number): void =>
		{
			var offset = startOffset + i * BatchShader.FLOATS_PER_VERTEX;
			this.vertices[offset + 0] = verts[i * 2 + 0];
			this.vertices[offset + 0] = verts[i * 2 + 0];
			this.vertices[offset + 1] = verts[i * 2 + 1];
			this.vertices[offset + 2] = uvs[i * 2 + 0];
			this.vertices[offset + 3] = uvs[i * 2 + 1];
			this.vertices[offset + 4] = ct.redMultiplier;
			this.vertices[offset + 5] = ct.greenMultiplier;
			this.vertices[offset + 6] = ct.blueMultiplier;
			this.vertices[offset + 7] = alpha;
			this.vertices[offset + 8] = ct.redOffset;
			this.vertices[offset + 9] = ct.greenOffset;
			this.vertices[offset + 10] = ct.blueOffset;
			this.vertices[offset + 11] = alphaOffset;
			this.vertices[offset + 12] = textureUnit;
		}

		setVertex(0);
		setVertex(1);
		setVertex(2);
		setVertex(3);

		++this.numQuads;
	}
}
