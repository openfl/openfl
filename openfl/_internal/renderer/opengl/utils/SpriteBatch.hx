package openfl._internal.renderer.opengl.utils ;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.opengl.shaders.AbstractShader;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;


@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObject)


class SpriteBatch {
	
	
	public var blendModes:Array<BlendMode>;
	public var currentBaseTexture:BitmapData;
	public var currentBatchSize:Int;
	public var currentBlendMode:BlendMode;
	public var dirty:Bool;
	public var drawing:Bool;
	public var gl:GLRenderContext;
	public var indexBuffer:GLBuffer;
	public var indices:UInt16Array;
	public var lastIndexCount:Int;
	public var renderSession:RenderSession;
	public var shader:AbstractShader;
	public var size:Int;
	public var textures:Array<BitmapData>;
	public var vertexBuffer:GLBuffer;
	public var vertices:Float32Array;
	public var vertSize:Int;
	
	
	public function new (gl:GLRenderContext) {
		
		vertSize = 6;
		size = 2000;//Math.pow(2, 16) /  this.vertSize;
		
		var numVerts = size * 4 * vertSize;
		var numIndices = size * 6;
		
		vertices = new Float32Array (numVerts);
		indices = new UInt16Array (numIndices);
		
		lastIndexCount = 0;
		
		var i = 0;
		var j = 0;
		
		while (i < numIndices) {
			
			indices[i + 0] = j + 0;
			indices[i + 1] = j + 1;
			indices[i + 2] = j + 2;
			indices[i + 3] = j + 0;
			indices[i + 4] = j + 2;
			indices[i + 5] = j + 3;
			i += 6;
			j += 4;
			
		}
		
		drawing = false;
		currentBatchSize = 0;
		currentBaseTexture = null;
		
		setContext (gl);
		
		dirty = true;
		
		textures = [];
		blendModes = [];
		
	}
	
	
	public function begin (renderSession:Dynamic):Void {
		
		this.renderSession = renderSession;
		shader = renderSession.shaderManager.defaultShader;
		
		start ();
		
	}
	
	
	public function destroy ():Void {
		
		vertices = null;
		indices = null;
		
		gl.deleteBuffer (vertexBuffer);
		gl.deleteBuffer (indexBuffer);
		
		currentBaseTexture = null;
		
		gl = null;
		
	}
	
	
	public function end ():Void {
		
		flush ();
		
	}
	
	
	private function flush ():Void {
		
		if (currentBatchSize == 0) return;
		
		var gl = this.gl;
		
		renderSession.shaderManager.setShader (renderSession.shaderManager.defaultShader);
		
		if (dirty) {
			
			dirty = false;
			gl.activeTexture (gl.TEXTURE0);
			
			gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			
			var projection = renderSession.projection;
			gl.uniform2f (shader.projectionVector, projection.x, projection.y);
			
			var stride =  vertSize * 4;
			gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
			gl.vertexAttribPointer (shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * 4);
			gl.vertexAttribPointer (shader.colorAttribute, 2, gl.FLOAT, false, stride, 4 * 4);
			
		}
		
		if (currentBatchSize > (size * 0.5)) {
			
			gl.bufferSubData (gl.ARRAY_BUFFER, 0, vertices);
			
		} else {
			
			var view = vertices.subarray (0, currentBatchSize * 4 * vertSize);
			gl.bufferSubData (gl.ARRAY_BUFFER, 0, view);
			
		}
		
		var nextTexture, nextBlendMode;
		var batchSize = 0;
		var start = 0;
		
		var currentBaseTexture = null;
		var currentBlendMode = renderSession.blendModeManager.currentBlendMode;
		
		var j = this.currentBatchSize;
		for (i in 0...j) {
			
			nextTexture = this.textures[i];
			nextBlendMode = this.blendModes[i];
			
			if (currentBaseTexture != nextTexture || currentBlendMode != nextBlendMode) {
				
				renderBatch (currentBaseTexture, batchSize, start);
				
				start = i;
				batchSize = 0;
				currentBaseTexture = nextTexture;
				currentBlendMode = nextBlendMode;
				
				renderSession.blendModeManager.setBlendMode (currentBlendMode);
				
			}
			
			batchSize++;
			
		}
		
		renderBatch (currentBaseTexture, batchSize, start);
		currentBatchSize = 0;
		
	}
	
	
	public function render (sprite:Bitmap):Void {
		
		var texture = sprite.bitmapData;
		
		if (texture == null) return;
		
		if (currentBatchSize >= size) {
			
			flush ();
			currentBaseTexture = texture;
			
		}
		
		var uvs = texture.__uvData;
		if (uvs == null) return;
		
		var alpha = sprite.__worldAlpha;
		//var tint = sprite.tint;
		var tint = 0xFFFFFF;
		
		var vertices = this.vertices;
		
		//var aX = sprite.anchor.x;
		var aX = 0;
		//var aY = sprite.anchor.y;
		var aY = 0;
		
		var w0, w1, h0, h1;
		
		/*if (texture.trim != null) {
			
			var trim = texture.trim;
			
			w1 = trim.x - aX * trim.width;
			w0 = w1 + texture.crop.width;
			h1 = trim.y - aY * trim.height;
			h0 = h1 + texture.crop.height;
			
		} else {
			
			w0 = (texture.frame.width) * (1 - aX);
			w1 = (texture.frame.width) * -aX;
			h0 = texture.frame.height * (1 - aY);
			h1 = texture.frame.height * -aY;
			
		}*/
		
		w0 = (texture.width) * (1 - aX);
		w1 = (texture.width) * -aX;
		h0 = texture.height * (1 - aY);
		h1 = texture.height * -aY;
		
		var index = currentBatchSize * 4 * vertSize;
		var worldTransform = sprite.__worldTransform;
		var a = worldTransform.a;//[0];
		var b = worldTransform.c;//[3];
		var c = worldTransform.b;//[1];
		var d = worldTransform.d;//[4];
		var tx = worldTransform.tx;//[2];
		var ty = worldTransform.ty;///[5];
		
		vertices[index++] = a * w1 + c * h1 + tx;
		vertices[index++] = d * h1 + b * w1 + ty;
		vertices[index++] = uvs.x0;
		vertices[index++] = uvs.y0;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = a * w0 + c * h1 + tx;
		vertices[index++] = d * h1 + b * w0 + ty;
		vertices[index++] = uvs.x1;
		vertices[index++] = uvs.y1;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = a * w0 + c * h0 + tx;
		vertices[index++] = d * h0 + b * w0 + ty;
		vertices[index++] = uvs.x2;
		vertices[index++] = uvs.y2;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = a * w1 + c * h0 + tx;
		vertices[index++] = d * h0 + b * w1 + ty;
		vertices[index++] = uvs.x3;
		vertices[index++] = uvs.y3;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		textures[currentBatchSize] = /*sprite.bitmapData.texture.baseTexture*/sprite.bitmapData;
		blendModes[currentBatchSize] = sprite.blendMode;
		
		currentBatchSize++;
		
	}
	
	
	private function renderBatch (texture:BitmapData, size:Int, startIndex:Int):Void {
		
		if (size == 0)return;
		
		var gl = this.gl;
		
		var tex:GLTexture = /*texture._glTextures[GLRenderer.glContextId];*/ texture.getTexture (gl);
		//if (tex == null) tex = Texture.createWebGLTexture (texture, gl);
		gl.bindTexture (gl.TEXTURE_2D, tex);
		
		/*if (texture._dirty[GLRenderer.glContextId]) {
			
			Texture.updateWebGLTexture (currentBaseTexture, gl);
			
		}*/
		
		gl.drawElements (gl.TRIANGLES, size * 6, gl.UNSIGNED_SHORT, startIndex * 6 * 2);
		
		renderSession.drawCount++;
		
	}
	
	
	public function renderTilingSprite (tilingSprite:Dynamic):Void {
		
		var texture = tilingSprite.tilingTexture;
		
		if (currentBatchSize >= size) {
			
			flush ();
			currentBaseTexture = texture;
			
		}
		
		if (tilingSprite._uvs == null) tilingSprite._uvs = new TextureUvs ();
		var uvs = tilingSprite._uvs;
		
		tilingSprite.tilePosition.x %= texture.width * tilingSprite.tileScaleOffset.x;
		tilingSprite.tilePosition.y %= texture.height * tilingSprite.tileScaleOffset.y;
		
		var offsetX =  tilingSprite.tilePosition.x / (texture.width * tilingSprite.tileScaleOffset.x);
		var offsetY =  tilingSprite.tilePosition.y / (texture.height * tilingSprite.tileScaleOffset.y);
		
		var scaleX =  (tilingSprite.width / texture.width)  / (tilingSprite.tileScale.x * tilingSprite.tileScaleOffset.x);
		var scaleY =  (tilingSprite.height / texture.height) / (tilingSprite.tileScale.y * tilingSprite.tileScaleOffset.y);
		
		uvs.x0 = 0 - offsetX;
		uvs.y0 = 0 - offsetY;
		
		uvs.x1 = (1 * scaleX) - offsetX;
		uvs.y1 = 0 - offsetY;
		
		uvs.x2 = (1 * scaleX) - offsetX;
		uvs.y2 = (1 * scaleY) - offsetY;
		
		uvs.x3 = 0 - offsetX;
		uvs.y3 = (1 * scaleY) - offsetY;
		
		var alpha = tilingSprite.worldAlpha;
		var tint = tilingSprite.tint;
		
		var vertices = this.vertices;
		
		var width = tilingSprite.width;
		var height = tilingSprite.height;
		
		var aX = tilingSprite.anchor.x;
		var aY = tilingSprite.anchor.y;
		var w0 = width * (1 - aX);
		var w1 = width * -aX;
		
		var h0 = height * (1 - aY);
		var h1 = height * -aY;
		
		var index = this.currentBatchSize * 4 * this.vertSize;
		
		var worldTransform = tilingSprite.worldTransform;
		
		var a = worldTransform.a;//[0];
		var b = worldTransform.b;//[3];
		var c = worldTransform.c;//[1];
		var d = worldTransform.d;//[4];
		var tx = worldTransform.tx;//[2];
		var ty = worldTransform.ty;///[5];
		
		vertices[index++] = a * w1 + c * h1 + tx;
		vertices[index++] = d * h1 + b * w1 + ty;
		vertices[index++] = uvs.x0;
		vertices[index++] = uvs.y0;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = (a * w0 + c * h1 + tx);
		vertices[index++] = d * h1 + b * w0 + ty;
		vertices[index++] = uvs.x1;
		vertices[index++] = uvs.y1;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = a * w0 + c * h0 + tx;
		vertices[index++] = d * h0 + b * w0 + ty;
		vertices[index++] = uvs.x2;
		vertices[index++] = uvs.y2;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = a * w1 + c * h0 + tx;
		vertices[index++] = d * h0 + b * w1 + ty;
		vertices[index++] = uvs.x3;
		vertices[index++] = uvs.y3;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		textures[currentBatchSize] = texture;
		blendModes[currentBatchSize] = tilingSprite.blendMode;
		currentBatchSize++;
		
	}
	
	
	public function setContext (gl:GLRenderContext):Void {
		
		this.gl = gl;
		
		vertexBuffer = gl.createBuffer ();
		indexBuffer = gl.createBuffer ();
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, vertices, gl.DYNAMIC_DRAW);
		
		currentBlendMode = null;
		
	}
	
	
	public function start ():Void {
		
		dirty = true;
		
	}
	
	
	public function stop ():Void {
		
		flush ();
		
	}
	
	
}