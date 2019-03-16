package test;

import lime.graphics.opengl.GL;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.Program3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Matrix3D;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.Assets;
import openfl.Vector;

class ContextLossTest1 extends FunctionalTest
{
	private var bitmap:Bitmap;
	private var bitmapIndexBuffer:IndexBuffer3D;
	private var bitmapRenderTransform:Matrix3D;
	private var bitmapTexture:RectangleTexture;
	private var bitmapTransform:Matrix3D;
	private var bitmapVertexBuffer:VertexBuffer3D;
	private var contextID = 0;
	private var direction = 1;
	private var extension:Dynamic;
	private var frame = 0;
	private var framesPerReset = 20;
	private var margin = 100;
	private var program:Program3D;
	private var programMatrixUniform:Int;
	private var programTextureAttribute:Int;
	private var programVertexAttribute:Int;
	private var projectionTransform:Matrix3D;
	private var status:TextField;

	public function new()
	{
		super();
	}

	public override function resize(width:Float, height:Float):Void
	{
		super.resize(width, height);

		if (stage.stage3Ds[0] != null)
		{
			var context = stage.stage3Ds[0].context3D;

			if (context != null)
			{
				context.configureBackBuffer(Math.ceil(contentWidth), Math.ceil(contentHeight), 0);

				projectionTransform = new Matrix3D();
				projectionTransform.copyRawDataFrom(Vector.ofArray([
					2.0 / contentWidth, 0.0, 0.0, 0.0, 0.0, 2.0 / contentHeight, 0.0, 0.0, 0.0, 0.0, -2.0 / 2000, 0.0, -1.0, -1.0, 0.0, 1.0
				]));
			}
		}
	}

	public override function start():Void
	{
		contextID = 0;
		direction = 1;
		frame = 0;

		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		bitmap = new Bitmap(bitmapData);
		bitmap.x = margin;
		bitmap.y = margin;
		content.addChild(bitmap);
		content.addEventListener(Event.ENTER_FRAME, content_onEnterFrame);

		var textFormat = new TextFormat("_sans", 24, 0xe8c343);
		status = new TextField();
		status.selectable = false;
		status.defaultTextFormat = textFormat;
		status.x = 0;
		status.y = 0;
		status.autoSize = TextFieldAutoSize.LEFT;
		status.text = "Context Loss: (Not supported)";
		content.addChild(status);

		if (stage.stage3Ds.length > 0)
		{
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, stage3D_onContext3DCreate);
			stage.stage3Ds[0].requestContext3D();
		}

		if (GL.context != null)
		{
			extension = GL.getExtension("WEBGL_lose_context");

			if (extension != null)
			{
				status.text = "Context Loss: " + contextID;
				stage.application.onUpdate.add(application_onUpdate);
			}
		}
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, content_onEnterFrame);
		stage.application.onUpdate.remove(application_onUpdate);

		if (stage.stage3Ds.length > 0)
		{
			stage.stage3Ds[0].removeEventListener(Event.CONTEXT3D_CREATE, stage3D_onContext3DCreate);

			if (stage.stage3Ds[0].context3D != null)
			{
				stage.stage3Ds[0].context3D.dispose();
			}
		}

		content.removeChild(bitmap);
		content.removeChild(status);
	}

	// Event Handlers
	private function application_onUpdate(deltaTime:Int):Void
	{
		// Event.ENTER_FRAME stops dispatching when context is lost

		frame++;

		if (frame == framesPerReset)
		{
			extension.loseContext();
		}
		else if (frame > framesPerReset)
		{
			frame = 0;

			contextID++;
			status.text = "Context Loss: " + contextID;

			extension.restoreContext();
		}
	}

	private function content_onEnterFrame(event:Event):Void
	{
		bitmap.x += direction;

		if (bitmap.x >= contentWidth - margin || bitmap.x <= margin)
		{
			direction *= -1;
		}

		if (stage.stage3Ds[0] != null && stage.stage3Ds[0].context3D != null)
		{
			var context = stage.stage3Ds[0].context3D;

			bitmapTransform.identity();
			bitmapTransform.appendTranslation(bitmap.x, bitmap.y + bitmap.height + margin, 0);

			bitmapRenderTransform.identity();
			bitmapRenderTransform.append(bitmapTransform);
			bitmapRenderTransform.append(projectionTransform);

			context.clear(1, 1, 1, 1);
			context.setProgram(program);

			context.setBlendFactors(ONE, ONE_MINUS_SOURCE_ALPHA);
			context.setTextureAt(0, bitmapTexture);
			context.setSamplerStateAt(0, CLAMP, LINEAR, MIPNONE);

			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, programMatrixUniform, bitmapRenderTransform, false);
			context.setVertexBufferAt(programVertexAttribute, bitmapVertexBuffer, 0, FLOAT_3);
			context.setVertexBufferAt(programTextureAttribute, bitmapVertexBuffer, 3, FLOAT_2);

			context.drawTriangles(bitmapIndexBuffer);
			context.present();
		}
	}

	private function stage3D_onContext3DCreate(event:Event):Void
	{
		var context = stage.stage3Ds[0].context3D;

		#if !flash
		var vertexSource = "attribute vec4 aPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
			
			uniform mat4 uMatrix;
			
			void main(void) {
				
				vTexCoord = aTexCoord;
				gl_Position = uMatrix * aPosition;
				
			}";

		var fragmentSource = #if !desktop "precision mediump float;" + #end

		"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
			
			void main(void)
			{
				gl_FragColor = texture2D (uImage0, vTexCoord);
			}";

		program = context.createProgram(GLSL);
		program.uploadSources(vertexSource, fragmentSource);

		programVertexAttribute = program.getAttributeIndex("aPosition");
		programTextureAttribute = program.getAttributeIndex("aTexCoord");
		programMatrixUniform = program.getConstantIndex("uMatrix");
		#else
		var vertexShaderAssembler = new AGALMiniAssembler();
		vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\n" + "mov v0, va1");

		var fragmentShaderAssembler = new AGALMiniAssembler();
		fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, "tex ft1, v0, fs0 <2d,linear,nomip>\n" + "mov oc, ft1");

		program = context.createProgram();
		program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);

		programVertexAttribute = 0;
		programTextureAttribute = 1;
		programMatrixUniform = 0;
		#end

		var bitmapData = Assets.getBitmapData("assets/openfl.png");
		bitmapTexture = context.createRectangleTexture(bitmapData.width, bitmapData.height, BGRA, false);
		bitmapTexture.uploadFromBitmapData(bitmapData);

		var vertexData = new Vector<Float>([
			bitmapData.width, bitmapData.height, 0, 1, 1, 0, bitmapData.height, 0, 0, 1, bitmapData.width, 0, 0, 1, 0, 0, 0, 0, 0, 0.0
		]);

		bitmapVertexBuffer = context.createVertexBuffer(4, 5);
		bitmapVertexBuffer.uploadFromVector(vertexData, 0, 4);

		var indexData = new Vector<UInt>([0, 1, 2, 2, 1, 3]);

		bitmapIndexBuffer = context.createIndexBuffer(6);
		bitmapIndexBuffer.uploadFromVector(indexData, 0, 6);

		bitmapTransform = new Matrix3D();
		bitmapTransform.appendTranslation(100, 100, 0);
		projectionTransform = new Matrix3D();
		bitmapRenderTransform = new Matrix3D();

		resize(contentWidth, contentHeight);
	}
}
