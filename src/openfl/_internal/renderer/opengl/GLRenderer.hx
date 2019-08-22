package openfl._internal.renderer.opengl;

import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.opengl.batcher.BatchRenderer;
import lime.graphics.WebGLRenderContext;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.RenderContext;
import lime.math.Matrix4;
import openfl.display3D.Context3D;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.OpenGLRenderer;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Graphics;
import openfl.display.IBitmapDrawable;
import openfl.display.Shape;
import openfl.display.SimpleButton;
import openfl.display.Stage;
import openfl.display.Tilemap;
import openfl.events.RenderEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.media.Video;
import openfl.text.TextField;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.renderer.canvas.CanvasRenderer)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.geom.Matrix)
class GLRenderer extends OpenGLRenderer
{
	public var projection:Matrix4;
	public var projectionFlipped:Matrix4;

	public var defaultRenderTarget:BitmapData;

	public var height:Int;
	public var width:Int;
	public var transparent:Bool;
	public var viewport:Rectangle;

	private var renderSession:RenderSession;
	private var stage:Stage;

	// private var cacheObject:BitmapData;
	private var currentRenderTarget:BitmapData;
	private var displayHeight:Int;
	private var displayMatrix:Matrix;
	private var displayWidth:Int;
	private var flipped:Bool;
	// private var gl:WebGLRenderContext;
	private var matrix:Matrix4;
	private var renderTargetA:BitmapData;
	private var renderTargetB:BitmapData;
	private var offsetX:Int;
	private var offsetY:Int;

	private var __context3D:Context3D;
	private var __context:RenderContext;

	private function new(context3D:Context3D, ?defaultRenderTarget:BitmapData)
	{
		super(context3D, defaultRenderTarget);

		__context3D = context3D;
		__context = context3D.__context;

		gl = context3D.__context.webgl;
		var stage = context3D.__stage;

		this.defaultRenderTarget = defaultRenderTarget;
		this.flipped = (defaultRenderTarget == null);

		if (Graphics.maxTextureWidth == null)
		{
			Graphics.maxTextureWidth = Graphics.maxTextureHeight = gl.getParameter(gl.MAX_TEXTURE_SIZE);
		}

		matrix = new Matrix4();

		renderSession = new RenderSession();
		renderSession.clearRenderDirty = true;
		renderSession.context3D = __context3D;
		renderSession.gl = gl;
		// renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.renderType = OPENGL;
		#if (js && html5)
		renderSession.pixelRatio = stage.window.scale;
		#end
		var blendModeManager = new GLBlendModeManager(gl);
		renderSession.blendModeManager = blendModeManager;
		renderSession.filterManager = new GLFilterManager(this, renderSession);
		var shaderManager = new GLShaderManager(__context3D);
		renderSession.shaderManager = shaderManager;
		renderSession.maskManager = new GLMaskManager(renderSession);

		renderSession.batcher = new BatchRenderer(gl, blendModeManager, shaderManager, 4096);

		if (stage.window != null)
		{
			// if (stage.stage3Ds[0].context3D == null)
			// {
			// 	stage.stage3Ds[0].__createContext(stage, renderSession);
			// }

			var width:Int = (defaultRenderTarget != null) ? defaultRenderTarget.width : Math.ceil(stage.window.width * stage.window.scale);
			var height:Int = (defaultRenderTarget != null) ? defaultRenderTarget.height : Math.ceil(stage.window.height * stage.window.scale);

			__resize(width, height);
		}
	}

	private override function __clear():Void
	{
		if (stage.__transparent)
		{
			gl.clearColor(0, 0, 0, 0);
		}
		else
		{
			gl.clearColor(stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2], 1);
		}

		gl.clear(gl.COLOR_BUFFER_BIT);
	}

	public function getCacheObject():Void
	{
		// gl.bindFramebuffer (gl.FRAMEBUFFER, cacheObject.__getFramebuffer (gl));
		// gl.viewport (0, 0, width, height);
		// gl.clearColor (0, 0, 0, 0);
		// gl.clear (gl.COLOR_BUFFER_BIT);

		// flipped = false;
	}

	@:noCompletion private function __getFramebuffer(bitmapData:BitmapData, context:Context3D, requireStencil:Bool):GLFramebuffer
	{
		if (bitmapData.__framebuffer == null || bitmapData.__framebufferContext != context.__context)
		{
			var gl = context.gl;
			var texture = bitmapData.getTexture(context);
			context.__bindGLTexture2D(texture.__textureID);
			bitmapData.__framebufferContext = context.__context;
			bitmapData.__framebuffer = gl.createFramebuffer();
			context.__bindGLFramebuffer(bitmapData.__framebuffer);
			gl.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, texture.__textureID, 0);
			if (gl.checkFramebufferStatus(gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE)
			{
				trace(gl.getError());
			}
		}
		if (requireStencil && bitmapData.__stencilBuffer == null)
		{
			var gl = context.gl;
			bitmapData.__stencilBuffer = gl.createRenderbuffer();
			gl.bindRenderbuffer(gl.RENDERBUFFER, bitmapData.__stencilBuffer);
			gl.renderbufferStorage(gl.RENDERBUFFER, gl.STENCIL_INDEX8, bitmapData.__textureWidth, bitmapData.__textureHeight);
			context.__bindGLFramebuffer(bitmapData.__framebuffer);
			gl.framebufferRenderbuffer(gl.FRAMEBUFFER, gl.STENCIL_ATTACHMENT, gl.RENDERBUFFER, bitmapData.__stencilBuffer);
			if (gl.checkFramebufferStatus(gl.FRAMEBUFFER) != gl.FRAMEBUFFER_COMPLETE)
			{
				trace(gl.getError());
			}
			gl.bindRenderbuffer(gl.RENDERBUFFER, null);
		}
		return bitmapData.__framebuffer;
	}

	static var getMatrixHelperMatrix = new Matrix();

	public function getDisplayTransformTempMatrix(transform:Matrix, snapToPixel:Bool):Matrix
	{
		var matrix = getMatrixHelperMatrix;
		matrix.copyFrom(transform);
		matrix.concat(displayMatrix);

		if (snapToPixel)
		{
			matrix.tx = Math.round(matrix.tx);
			matrix.ty = Math.round(matrix.ty);
		}

		return matrix;
	}

	public function getMatrix(transform:Matrix, snapToPixel:Bool = false):Matrix4
	{
		var _matrix = getDisplayTransformTempMatrix(transform, renderSession.roundPixels || snapToPixel);

		matrix.identity();
		matrix[0] = _matrix.a;
		matrix[1] = _matrix.b;
		matrix[4] = _matrix.c;
		matrix[5] = _matrix.d;
		matrix[12] = _matrix.tx;
		matrix[13] = _matrix.ty;
		matrix.append(flipped ? projectionFlipped : projection);

		return matrix;
	}

	public function getRenderTarget(framebuffer:Bool):Void
	{
		if (framebuffer)
		{
			if (renderTargetA == null)
			{
				renderTargetA = BitmapData.fromTexture(stage.stage3Ds[0].context3D.createRectangleTexture(width, height, BGRA, true));

				gl.bindTexture(gl.TEXTURE_2D, renderTargetA.getTexture(__context3D).__getTexture());
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			}

			if (renderTargetB == null)
			{
				renderTargetB = BitmapData.fromTexture(stage.stage3Ds[0].context3D.createRectangleTexture(width, height, BGRA, true));

				gl.bindTexture(gl.TEXTURE_2D, renderTargetB.getTexture(__context3D).__getTexture());
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			}

			if (currentRenderTarget == renderTargetA)
			{
				currentRenderTarget = renderTargetB;
			}
			else
			{
				currentRenderTarget = renderTargetA;
			}

			gl.bindFramebuffer(gl.FRAMEBUFFER, __getFramebuffer(currentRenderTarget, __context3D));
			gl.viewport(0, 0, width, height);
			gl.clearColor(0, 0, 0, 0);
			gl.clear(gl.COLOR_BUFFER_BIT);

			flipped = false;
		}
		else
		{
			currentRenderTarget = defaultRenderTarget;
			var frameBuffer:GLFramebuffer = (currentRenderTarget != null) ? __getFramebuffer(currentRenderTarget, __context3D) : null;

			gl.bindFramebuffer(gl.FRAMEBUFFER, frameBuffer);

			flipped = (currentRenderTarget == null);
		}
	}

	private function renderBitmap(bitmap:Bitmap):Void
	{
		// __updateCacheBitmap (renderSession, false);

		if (bitmap.__cacheBitmap != null && !bitmap.__isCacheBitmapRender)
		{
			GLBitmap.render(bitmap.__cacheBitmap, renderSession);
		}
		else
		{
			GLBitmap.render(bitmap, renderSession);
		}
	}

	private function renderDisplayObject(object:DisplayObject):Void
	{
		if (object != null)
		{
			switch (object.__type)
			{
				case BITMAP:
					renderBitmap(cast object);
				case DISPLAY_OBJECT_CONTAINER:
					renderDisplayObjectContainer(cast object);
				case DISPLAY_OBJECT, SHAPE:
					renderShape(cast object);
				case SIMPLE_BUTTON:
					renderSimpleButton(cast object);
				case TEXTFIELD:
					renderTextField(cast object);
				case TILEMAP:
					renderTilemap(cast object);
				case VIDEO:
					renderVideo(cast object);
				default:
			}

			// if (object.__customRenderEvent != null)
			// {
			// 	var event = object.__customRenderEvent;
			// 	event.allowSmoothing = __allowSmoothing;
			// 	event.objectMatrix.copyFrom(object.__renderTransform);
			// 	event.objectColorTransform.__copyFrom(object.__worldColorTransform);
			// 	event.renderer = this;
			// 	event.type = RenderEvent.RENDER_OPENGL;

			// 	__setBlendMode(object.__worldBlendMode);
			// 	__pushMaskObject(object);

			// 	object.dispatchEvent(event);

			// 	__popMaskObject(object);
			// }
		}
	}

	private function renderDisplayObjectContainer(container:DisplayObjectContainer):Void
	{
		container.__cleanupRemovedChildren();

		if (!container.__renderable || container.__worldAlpha <= 0) return;

		// __updateCacheBitmap (renderSession, false);

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender)
		{
			GLBitmap.render(container.__cacheBitmap, renderSession);
		}
		else
		{
			GLDisplayObject.render(container, renderSession);
		}

		if (container.__cacheBitmap != null && !container.__isCacheBitmapRender) return;

		if (container.__children.length > 0)
		{
			renderSession.maskManager.pushObject(container);
			renderSession.filterManager.pushObject(container);

			if (renderSession.clearRenderDirty)
			{
				for (child in container.__children)
				{
					renderDisplayObject(child);
					child.__renderDirty = false;
				}

				container.__renderDirty = false;
			}
			else
			{
				for (child in container.__children)
				{
					renderDisplayObject(child);
				}
			}
		}

		if (container.__children.length > 0)
		{
			renderSession.filterManager.popObject(container);
			renderSession.maskManager.popObject(container);
		}
	}

	private function renderMask(mask:DisplayObject):Void
	{
		if (mask != null)
		{
			switch (mask.__type)
			{
				case BITMAP:
					// __updateCacheBitmap (renderSession, false);

					if (mask.__cacheBitmap != null && !mask.__isCacheBitmapRender)
					{
						GLBitmap.renderMask(mask.__cacheBitmap, renderSession);
					}
					else
					{
						GLBitmap.renderMask(mask, renderSession);
					}

				case DISPLAY_OBJECT_CONTAINER:
					var container:DisplayObjectContainer = cast mask;
					container.__cleanupRemovedChildren();

					// __updateCacheBitmap (renderSession, false);

					if (mask.__cacheBitmap != null && !mask.__isCacheBitmapRender)
					{
						GLBitmap.renderMask(mask.__cacheBitmap, renderSession);
					}
					else
					{
						GLDisplayObject.renderMask(mask, renderSession);
					}

					if (mask.__cacheBitmap != null && !mask.__isCacheBitmapRender) return;

					if (renderSession.clearRenderDirty)
					{
						for (child in container.__children)
						{
							renderDisplayObject(child);
							child.__renderDirty = false;
						}

						mask.__renderDirty = false;
					}
					else
					{
						for (child in container.__children)
						{
							renderDisplayObject(child);
						}
					}

				case DOM_ELEMENT:

				case SIMPLE_BUTTON:
					var button:SimpleButton = cast mask;
					renderMask(button.__currentState);

				default:
					// __updateCacheBitmap (renderSession, false);

					if (mask.__cacheBitmap != null && !mask.__isCacheBitmapRender)
					{
						GLBitmap.renderMask(mask.__cacheBitmap, renderSession);
					}
					else
					{
						GLDisplayObject.renderMask(mask, renderSession);
					}
			}
		}
	}

	private function renderShape(shape:Shape):Void
	{
		// __updateCacheBitmap (renderSession, false);

		if (shape.__cacheBitmap != null && !shape.__isCacheBitmapRender)
		{
			GLBitmap.render(shape.__cacheBitmap, renderSession);
		}
		else
		{
			GLDisplayObject.render(shape, renderSession);
		}
	}

	private function renderSimpleButton(button:SimpleButton):Void
	{
		if (!button.__renderable || button.__worldAlpha <= 0 || button.__currentState == null) return;

		renderSession.maskManager.pushObject(button);
		renderDisplayObject(__currentState);
		renderSession.maskManager.popObject(button);
	}

	private function renderTextField(textField:TextField):Void
	{
		// textField.__forceCachedBitmapUpdate = textField.__forceCachedBitmapUpdate || textField.__dirty;
		#if (js && html5)
		CanvasTextField.render(textField, this, textField.__worldTransform);
		#elseif lime_cairo
		CairoTextField.render(textField, this, textField.__worldTransform);
		#end

		// __updateCacheBitmap (renderSession, false);

		if (textField.__cacheBitmap != null && !textField.__isCacheBitmapRender)
		{
			GLBitmap.render(textField.__cacheBitmap, renderSession);
		}
		else
		{
			GLDisplayObject.render(textField, renderSession);
		}
	}

	private function renderTilemap(tilemap:Tilemap):Void
	{
		// __updateCacheBitmap (renderSession, false);

		if (tilemap.__cacheBitmap != null && !tilemap.__cacheBitmapRender)
		{
			GLBitmap.render(tilemap.__cacheBitmap, renderSession);
		}
		else
		{
			GLDisplayObject.render(tilemap, renderSession);
			GLTilemap.render(tilemap, renderSession);
		}
	}

	private function renderVideo(video:Video):Void
	{
		GLVideo.render(video, renderSession);
	}

	private override function __render(object:IBitmapDrawable):Void
	{
		gl.viewport(offsetX, offsetY, displayWidth, displayHeight);

		renderSession.allowSmoothing = (stage.quality != LOW);
		renderSession.forceSmoothing = #if always_smooth_on_upscale (displayMatrix.a != 1 || displayMatrix.d != 1); #else false; #end

		// setup projection matrix for the batcher as it's an uniform value for all the draw calls
		renderSession.batcher.projectionMatrix = flipped ? projectionFlipped : projection;

		renderDisplayObjectContainer(stage);

		// flush whatever is left in the batch to render
		renderSession.batcher.flush();

		if (offsetX > 0 || offsetY > 0)
		{
			gl.clearColor(0, 0, 0, 1);
			gl.enable(gl.SCISSOR_TEST);

			if (offsetX > 0)
			{
				gl.scissor(0, 0, offsetX, height);
				gl.clear(gl.COLOR_BUFFER_BIT);

				gl.scissor(offsetX + displayWidth, 0, width, height);
				gl.clear(gl.COLOR_BUFFER_BIT);
			}

			if (offsetY > 0)
			{
				gl.scissor(0, 0, width, offsetY);
				gl.clear(gl.COLOR_BUFFER_BIT);

				gl.scissor(0, offsetY + displayHeight, width, height);
				gl.clear(gl.COLOR_BUFFER_BIT);
			}

			gl.disable(gl.SCISSOR_TEST);
		}
	}

	// public override function renderStage3D():Void
	// {
	// 	for (stage3D in stage.stage3Ds)
	// 	{
	// 		stage3D.__renderGL(stage, renderSession);
	// 	}
	// }

	private override function __resize(width:Int, height:Int):Void
	{
		super.__resize(width, height);

		// if (cacheObject == null || cacheObject.width != width || cacheObject.height != height) {

		// 	cacheObject = BitmapData.fromTexture (stage.stage3Ds[0].context3D.createRectangleTexture (width, height, BGRA, true));

		// 	gl.bindTexture (gl.TEXTURE_2D, cacheObject.getTexture (gl).data.glTexture);
		// 	gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
		// 	gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

		// }

		if (width > 0 && height > 0)
		{
			if (renderTargetA != null && (renderTargetA.width != width || renderTargetA.height != height))
			{
				renderTargetA = BitmapData.fromTexture(stage.stage3Ds[0].context3D.createRectangleTexture(width, height, BGRA, true));

				gl.bindTexture(gl.TEXTURE_2D, renderTargetA.getTexture(__context3D).__getTexture());
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			}

			if (renderTargetB != null && (renderTargetB.width != width || renderTargetB.height != height))
			{
				renderTargetB = BitmapData.fromTexture(stage.stage3Ds[0].context3D.createRectangleTexture(width, height, BGRA, true));

				gl.bindTexture(gl.TEXTURE_2D, renderTargetB.getTexture(__context3D).__getTexture());
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			}
		}

		displayMatrix = (defaultRenderTarget == null) ? stage.__displayMatrix : new Matrix();

		var w = (defaultRenderTarget == null) ? stage.stageWidth : defaultRenderTarget.width;
		var h = (defaultRenderTarget == null) ? stage.stageHeight : defaultRenderTarget.height;

		offsetX = Math.round(displayMatrix.__transformX(0, 0));
		offsetY = Math.round(displayMatrix.__transformY(0, 0));
		displayWidth = Math.round(displayMatrix.__transformX(w, 0) - offsetX);
		displayHeight = Math.round(displayMatrix.__transformY(0, h) - offsetY);

		if (projection == null) projection = new Matrix4();
		if (projectionFlipped == null) projectionFlipped = new Matrix4();
		projection.createOrtho(offsetX, displayWidth + offsetX, offsetY, displayHeight + offsetY, -1000, 1000);
		projectionFlipped.createOrtho(offsetX, displayWidth + offsetX, displayHeight + offsetY, offsetY, -1000, 1000);
	}
}
