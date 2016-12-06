package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl._internal.renderer.AbstractFilterManager;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.Vector;

@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)
@:access(openfl.filters.BitmapFilter)
@:keep


class GLFilterManager extends AbstractFilterManager {
	
	
	private var filterDepth:Int;
	private var gl:GLRenderContext;
	private var matrix:Matrix;
	private var renderer:GLRenderer;
	
	
	public function new (renderer:GLRenderer, renderSession:RenderSession) {
		
		super (renderSession);
		
		this.renderer = renderer;
		this.gl = renderSession.gl;
		
		filterDepth = 0;
		matrix = new Matrix ();
		
	}
	
	
	public override function renderFilters (object:DisplayObject, src:BitmapData):BitmapData {

		if (object.__filters != null && object.__filters.length > 0) {

			var filtersDirty:Bool = object.__filterDirty;
			for (filter in object.__filters) {
				filtersDirty = filtersDirty || filter.__filterDirty;
			}
			
			if (object.__filterBitmap == null || filtersDirty) {
		
				// Only support single filter at the moment for offsets
				object.__filterOffset = object.__filters[0].__filterOffset;
				var bounds:Rectangle = object.__filterBounds = new Rectangle( 0, 0, src.width, src.height );
				var filterBounds:Rectangle;
				for (filter in object.__filters) {
					filterBounds = filter.__getFilterBounds( src );
					bounds.x = Math.max( bounds.x, filterBounds.x);
					bounds.y = Math.max( bounds.y, filterBounds.y);
					bounds.width = Math.max( bounds.width, filterBounds.width);
					bounds.height = Math.max( bounds.height, filterBounds.height);
				}
				
				var displacedSource = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), src.transparent, 0x0);
				displacedSource.copyPixels( src, src.rect, new Point( bounds.x, bounds.y ) );
				object.__filterBitmap = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), src.transparent, 0x0);

				for (filter in object.__filters) {
					filter.__renderFilter( displacedSource, object.__filterBitmap );
				}

				displacedSource = null;

				object.__filterDirty = false;
				
			}
			
		}

		return object.__filterBitmap;
	}


	public override function pushObject (object:DisplayObject):Shader {
		
		// TODO: Support one-pass filters?
		
		if (object.__filters != null && object.__filters.length > 0) {
			
			renderer.getRenderTarget (true);
			filterDepth++;
			
		}
		
		return renderSession.shaderManager.defaultShader;
		
	}
	
	
	public override function popObject (object:DisplayObject):Void {
		
		if (object.__filters != null && object.__filters.length > 0 && !renderSession.filterManager.useCPUFilters ) {
			
			var filter =  object.__filters[0];
			var currentTarget, shader;
			
			if (filter.__cacheObject) {
				
				currentTarget = renderer.currentRenderTarget;
				renderer.getCacheObject ();
				
				renderPass (currentTarget, renderSession.shaderManager.defaultShader);
				
			}
			
			for (i in 0...filter.__numPasses) {
				
				currentTarget = renderer.currentRenderTarget;
				renderer.getRenderTarget (true);
				shader = filter.__initShader (renderSession, i);
				
				renderPass (currentTarget, shader);
				
			}
			
			// TODO: Properly handle filter-within-filter rendering
			
			filterDepth--;
			renderer.getRenderTarget (filterDepth > 0);
			
			renderPass (renderer.currentRenderTarget, renderSession.shaderManager.defaultShader);
			
		}
		
	}
	
	
	private function renderPass (target:BitmapData, shader:Shader):Void {
		
		shader.data.uImage0.input = target;
		shader.data.uImage0.smoothing = renderSession.allowSmoothing && (renderSession.upscaled);
		shader.data.uMatrix.value = renderer.getMatrix (matrix);
		
		renderSession.shaderManager.setShader (shader);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, target.getBuffer (gl, 1));
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
	}
	
	
}
