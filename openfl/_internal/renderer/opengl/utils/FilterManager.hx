package openfl._internal.renderer.opengl.utils;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.opengl.shaders.AbstractShader;
import openfl._internal.renderer.opengl.shaders.DefaultShader;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Rectangle;


class FilterManager {
	
	
	public var buffer:GLFramebuffer;
	public var colorArray:Float32Array;
	public var colorBuffer:GLBuffer;
	public var defaultShader:DefaultShader;
	public var filterStack:Array<Dynamic>;
	public var gl:GLRenderContext;
	public var height:Int;
	public var indexBuffer:GLBuffer;
	public var offsetX:Float;
	public var offsetY:Float;
	public var renderSession:RenderSession;
	public var texturePool:Array<FilterTexture>;
	public var transparent:Bool;
	public var uvArray:Float32Array;
	public var uvBuffer:GLBuffer;
	public var vertexArray:Float32Array;
	public var vertexBuffer:GLBuffer;
	public var width:Int;
	
	
	public function new (gl:GLRenderContext, transparent:Bool) {
		
		this.transparent = transparent;
		
		filterStack = [];
		
		offsetX = 0;
		offsetY = 0;
		
		setContext (gl);
		
	}
	
	
	public function applyFilterPass (filter:Dynamic, filterArea:Rectangle, width:Int, height:Int):Void {
		
		var gl = this.gl;
		var shader:DefaultShader = cast filter.shaders[GLRenderer.glContextId];
		
		if (shader == null) {
			
			shader = new DefaultShader (gl);
			shader.fragmentSrc = filter.fragmentSrc;
			shader.uniforms = filter.uniforms;
			shader.init ();
			
			filter.shaders[GLRenderer.glContextId] = shader;
			
		}
		
		renderSession.shaderManager.setShader (shader);
		
		gl.uniform2f (shader.projectionVector, width / 2, -height / 2);
		gl.uniform2f (shader.offsetVector, 0, 0);
		
		if (filter.uniforms.dimensions != null) {
			
			filter.uniforms.dimensions.value[0] = this.width + 0.0;
			filter.uniforms.dimensions.value[1] = this.height + 0.0;
			filter.uniforms.dimensions.value[2] = this.vertexArray[0];
			filter.uniforms.dimensions.value[3] = this.vertexArray[5];
			
		}
		
		shader.syncUniforms ();
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 0, 0);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, uvBuffer);
		gl.vertexAttribPointer (shader.aTextureCoord, 2, gl.FLOAT, false, 0, 0);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, colorBuffer);
		gl.vertexAttribPointer (shader.colorAttribute, 2, gl.FLOAT, false, 0, 0);
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		
		gl.drawElements (gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
		renderSession.drawCount++;
		
	}
	
	
	public function begin (renderSession:RenderSession, buffer:GLFramebuffer = null):Void {
		
		this.renderSession = renderSession;
		defaultShader = renderSession.shaderManager.defaultShader;
		
		var projection = renderSession.projection;
		
		width = Std.int (projection.x * 2);
		height = Std.int (-projection.y * 2);
		this.buffer = buffer;
		
	}
	
	
	public function destroy ():Void {
		
		var gl = this.gl;
		
		filterStack = null;
		
		offsetX = 0;
		offsetY = 0;
		
		for (texture in texturePool) {
			
			texture.destroy ();
			
		}
		
		texturePool = null;
		
		gl.deleteBuffer (vertexBuffer);
		gl.deleteBuffer (uvBuffer);
		gl.deleteBuffer (colorBuffer);
		gl.deleteBuffer (indexBuffer);
		
	}
	
	
	public function initShaderBuffers ():Void {
		
		var gl = this.gl;
		
		vertexBuffer = gl.createBuffer ();
		uvBuffer = gl.createBuffer ();
		colorBuffer = gl.createBuffer ();
		indexBuffer = gl.createBuffer ();
		
		vertexArray = new Float32Array ([ 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0 ]);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, vertexArray, gl.STATIC_DRAW);
		
		uvArray = new Float32Array ([ 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 1.0 ]);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, uvBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, uvArray, gl.STATIC_DRAW);
		
		colorArray = new Float32Array ([ 1.0, 0xFFFFFF, 1.0, 0xFFFFFF, 1.0, 0xFFFFFF, 1.0, 0xFFFFFF ]);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, colorBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, colorArray, gl.STATIC_DRAW);
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, new UInt16Array ([ 0, 1, 2, 1, 3, 2 ]), gl.STATIC_DRAW);
		
	}
	
	
	public function popFilter ():Void {
		
		var gl = this.gl;
		var filterBlock = filterStack.pop();
		var filterArea:Rectangle = filterBlock._filterArea;
		var texture = filterBlock._glFilterTexture;
		var projection = renderSession.projection;
		var offset = renderSession.offset;
		
		if (filterBlock.filterPasses.length > 1) {
			
			gl.viewport (0, 0, Std.int (filterArea.width), Std.int (filterArea.height));
			gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
			
			this.vertexArray[0] = 0;
			this.vertexArray[1] = filterArea.height;
			this.vertexArray[2] = filterArea.width;
			this.vertexArray[3] = filterArea.height;
			this.vertexArray[4] = 0;
			this.vertexArray[5] = 0;
			this.vertexArray[6] = filterArea.width;
			this.vertexArray[7] = 0;
			
			gl.bufferSubData (gl.ARRAY_BUFFER, 0, vertexArray);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, uvBuffer);
			
			this.uvArray[2] = filterArea.width / width;
			this.uvArray[5] = filterArea.height / height;
			this.uvArray[6] = filterArea.width / width;
			this.uvArray[7] = filterArea.height / height;
			
			gl.bufferSubData (gl.ARRAY_BUFFER, 0, uvArray);
			
			var inputTexture:FilterTexture = texture;
			var outputTexture:FilterTexture = texturePool.pop ();
			
			if (outputTexture == null) {
				
				outputTexture = new FilterTexture (gl, width, height);
				
			}
			
			outputTexture.resize (width, height);
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, outputTexture.frameBuffer);
			gl.clear (gl.COLOR_BUFFER_BIT);
			
			gl.disable (gl.BLEND);
			
			for (i in 0...Std.int (filterBlock.filterPasses.length - 1)) {
				
				var filterPass = filterBlock.filterPasses[i];
				
				gl.bindFramebuffer (gl.FRAMEBUFFER, outputTexture.frameBuffer);
				
				gl.activeTexture (gl.TEXTURE0);
				gl.bindTexture (gl.TEXTURE_2D, inputTexture.texture);
				
				applyFilterPass (filterPass, filterArea, Std.int (filterArea.width), Std.int (filterArea.height));
				
				var temp = inputTexture;
				inputTexture = outputTexture;
				outputTexture = temp;
				
			}
			
			gl.enable (gl.BLEND);
			
			texture = inputTexture;
			texturePool.push (outputTexture);
			
		}
		
		var filter = filterBlock.filterPasses[Std.int (filterBlock.filterPasses.length - 1)];
		
		this.offsetX -= filterArea.x;
		this.offsetY -= filterArea.y;
		
		var sizeX = width;
		var sizeY = height;
		
		var offsetX = 0.0;
		var offsetY = 0.0;
		
		var buffer = this.buffer;
		
		if (filterStack.length == 0) {
			
			gl.colorMask (true, true, true, true);
			
		} else {
			
			var currentFilter = filterStack[filterStack.length-1];
			filterArea = currentFilter._filterArea;
			
			sizeX = Std.int (filterArea.width);
			sizeY = Std.int (filterArea.height);
			
			offsetX = filterArea.x;
			offsetY = filterArea.y;
			
			buffer = currentFilter._glFilterTexture.frameBuffer;
			
		}
		
		projection.x = sizeX / 2;
		projection.y = -sizeY / 2;
		
		offset.x = offsetX;
		offset.y = offsetY;
		
		filterArea = filterBlock._filterArea;
		
		var x = filterArea.x - offsetX;
		var y = filterArea.y - offsetY;
		
		gl.bindBuffer (gl.ARRAY_BUFFER, this.vertexBuffer);
		
		vertexArray[0] = x;
		vertexArray[1] = y + filterArea.height;
		vertexArray[2] = x + filterArea.width;
		vertexArray[3] = y + filterArea.height;
		vertexArray[4] = x;
		vertexArray[5] = y;
		vertexArray[6] = x + filterArea.width;
		vertexArray[7] = y;
		
		gl.bufferSubData (gl.ARRAY_BUFFER, 0, vertexArray);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, uvBuffer);
		
		this.uvArray[2] = filterArea.width / width;
		this.uvArray[5] = filterArea.height / height;
		this.uvArray[6] = filterArea.width / width;
		this.uvArray[7] = filterArea.height / height;
		
		gl.bufferSubData (gl.ARRAY_BUFFER, 0, uvArray);
		
		gl.viewport (0, 0, sizeX, sizeY);
		gl.bindFramebuffer (gl.FRAMEBUFFER, buffer);
		
		gl.activeTexture (gl.TEXTURE0);
		gl.bindTexture (gl.TEXTURE_2D, texture.texture);
		
		applyFilterPass (filter, filterArea, sizeX, sizeY);
		
		renderSession.shaderManager.setShader (defaultShader);
		gl.uniform2f (defaultShader.projectionVector, sizeX / 2, -sizeY / 2);
		gl.uniform2f (defaultShader.offsetVector, -offsetX, -offsetY);
		
		texturePool.push (texture);
		filterBlock._glFilterTexture = null;
		
	}
	
	
	public function pushFilter (filterBlock:Dynamic):Void {
		
		var gl = this.gl;
		
		var projection = renderSession.projection;
		var offset =  renderSession.offset;
		
		if (filterBlock.target.filterArea != null) {
			
			filterBlock._filterArea = filterBlock.target.filterArea;
			
		} else {
			
			filterBlock._filterArea = filterBlock.target.getBounds ();
			
		}
		
		filterStack.push (filterBlock);
		
		var filter = filterBlock.filterPasses[0];
		
		offsetX += filterBlock._filterArea.x;
		offsetY += filterBlock._filterArea.y;
		
		var texture = this.texturePool.pop ();
		
		if (texture == null) {
			
			texture = new FilterTexture (gl, width, height);
			
		} else {
			
			texture.resize (width, height);
			
		}
		
		gl.bindTexture (gl.TEXTURE_2D, texture.texture);
		
		var filterArea:Rectangle = filterBlock._filterArea;
		
		var padding = filter.padding;
		filterArea.x -= padding;
		filterArea.y -= padding;
		filterArea.width += padding * 2;
		filterArea.height += padding * 2;
		
		if (filterArea.x < 0) filterArea.x = 0;
		if (filterArea.width > this.width) filterArea.width = this.width;
		if (filterArea.y < 0) filterArea.y = 0;
		if (filterArea.height > this.height) filterArea.height = this.height;
		
		gl.bindFramebuffer (gl.FRAMEBUFFER, texture.frameBuffer);
		
		gl.viewport (0, 0, Std.int (filterArea.width), Std.int (filterArea.height));
		
		projection.x = filterArea.width / 2;
		projection.y = -filterArea.height / 2;
		
		offset.x = -filterArea.x;
		offset.y = -filterArea.y;
		
		renderSession.shaderManager.setShader (defaultShader);
		gl.uniform2f (defaultShader.projectionVector, filterArea.width / 2, -filterArea.height / 2);
		gl.uniform2f (defaultShader.offsetVector, -filterArea.x, -filterArea.y);
		
		gl.colorMask (true, true, true, true);
		gl.clearColor (0, 0, 0, 0);
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		filterBlock._glFilterTexture = texture;
		
	}
	
	
	public function setContext (gl:GLRenderContext):Void {
		
		this.gl = gl;
		texturePool = [];
		
		initShaderBuffers ();
		
	}
	
	
}