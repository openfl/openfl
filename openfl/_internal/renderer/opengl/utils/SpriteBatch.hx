package openfl._internal.renderer.opengl.utils ;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.opengl.shaders.AbstractShader;
import openfl._internal.renderer.RenderSession;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.geom.Rectangle;


@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Tilesheet)


class SpriteBatch {
	
	
	public var states:Array<State> = [];
	public var currentState:State;
	
	public var currentBaseTexture:GLTexture;
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
	public var vertexBuffer:GLBuffer;
	public var vertices:Float32Array;
	public var vertSize:Int;
	
	
	public function new (gl:GLRenderContext) {
		
		vertSize = 6;
		size = Math.floor(Math.pow(2, 16) /  this.vertSize);
		
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
		
		currentState = new State();
		
	}
	
	
	public function begin (renderSession:RenderSession):Void {
		
		this.renderSession = renderSession;
		shader = renderSession.shaderManager.defaultShader;
		drawing = true;
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
		drawing = false;
		
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
		
		var nextState:State;
		var batchSize = 0;
		var start = 0;
		
		currentState.texture = null;
		currentState.textureSmooth = true;
		currentState.blendMode = renderSession.blendModeManager.currentBlendMode;
		
		var j = this.currentBatchSize;
		for (i in 0...j) {
			
			nextState = states[i];
			
			if (currentState.texture != nextState.texture || currentState.blendMode != nextState.blendMode) {
				
				renderBatch (currentState, batchSize, start);
				
				start = i;
				batchSize = 0;
				currentState.texture = nextState.texture;
				currentState.textureSmooth = nextState.textureSmooth;
				currentState.blendMode = nextState.blendMode;
				
				
				renderSession.blendModeManager.setBlendMode (currentState.blendMode);
				
			}
			
			batchSize++;
			
		}
		
		renderBatch (currentState, batchSize, start);
		currentBatchSize = 0;
		
	}
	
	
	public function render (sprite:Bitmap):Void {
		
		var bitmapData = sprite.bitmapData;
		var texture = bitmapData.getTexture(gl);
		
		if (bitmapData == null) return;
		
		if (currentBatchSize >= size) {
			
			flush ();
			currentState.texture = texture;
			
		}
		
		var uvs = bitmapData.__uvData;
		if (uvs == null) return;
		
		var alpha = sprite.__worldAlpha;
		//var tint = sprite.tint;
		var tint = 0xFFFFFF;
		
		//var aX = sprite.anchor.x;
		var aX = 0;
		//var aY = sprite.anchor.y;
		var aY = 0;
		
		var index = currentBatchSize * 4 * vertSize;
		fillVertices(index, aX, aY, bitmapData.width, bitmapData.height, tint, alpha, uvs, sprite.__worldTransform);
		
		setState(currentBatchSize, texture, sprite.blendMode);
		
		currentBatchSize++;
		
	}
	
	public function renderCachedGraphics(object:DisplayObject) {
		var cachedTexture = object.__graphics.__cachedTexture;
		
		if (cachedTexture == null) return;
		
		if (currentBatchSize >= size) {
			
			flush ();
			currentBaseTexture = cachedTexture.texture;
			
		}
		
		var alpha = object.__worldAlpha;
		var tint = 0xFFFFFF;
		
		var aX = 0;
		var aY = 0;
		
		var uvs = new TextureUvs();
		uvs.x0 = 0;		uvs.y0 = 1;
		uvs.x1 = 1;		uvs.y1 = 1;
		uvs.x2 = 1;		uvs.y2 = 0;
		uvs.x3 = 0;		uvs.y3 = 0;
		
		var index = currentBatchSize * 4 * vertSize;
		var worldTransform = object.__worldTransform.clone();
		worldTransform.__translateTransformed(new Point(object.__graphics.__bounds.x, object.__graphics.__bounds.y));
		
		fillVertices(index, aX, aY, cachedTexture.width, cachedTexture.height, tint, alpha, uvs, worldTransform);

		setState(currentBatchSize, cachedTexture.texture, object.blendMode);
		
		currentBatchSize++;
	}
	
	public function renderTiles(object:DisplayObject, sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1) {		
		
		var texture = sheet.__bitmap.getTexture(gl);
		if (texture == null) return;
		
		var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
		var useRotation = (flags & Tilesheet.TILE_ROTATION) > 0;
		var useTransform = (flags & Tilesheet.TILE_TRANS_2x2) > 0;
		var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
		var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
		var useRect = (flags & Tilesheet.TILE_RECT) > 0;
		var useOrigin = (flags & Tilesheet.TILE_ORIGIN) > 0;
		
		var blendMode:BlendMode = switch(flags & 0xF0000) {
			case Tilesheet.TILE_BLEND_ADD:		ADD;
			case Tilesheet.TILE_BLEND_MULTIPLY:	MULTIPLY;
			case Tilesheet.TILE_BLEND_SCREEN:	SCREEN;
			case _:								NORMAL;
		};
		
		if (useTransform) { useScale = false; useRotation = false; }
		
		var scaleIndex = 0;
		var rotationIndex = 0;
		var rgbIndex = 0;
		var alphaIndex = 0;
		var transformIndex = 0;
		
		var numValues = 3;
		
		if (useRect) { numValues = useOrigin ? 8 : 6; }
		if (useScale) { scaleIndex = numValues; numValues ++; }
		if (useRotation) { rotationIndex = numValues; numValues ++; }
		if (useTransform) { transformIndex = numValues; numValues += 4; }
		if (useRGB) { rgbIndex = numValues; numValues += 3; }
		if (useAlpha) { alphaIndex = numValues; numValues ++; }
		
		var totalCount = tileData.length;
		if (count >= 0 && totalCount > count) totalCount = count;
		var itemCount = Std.int (totalCount / numValues);
		var iIndex = 0;
		
		var tileID = -1;
		var rect:Rectangle = sheet.__rectTile;
		var tileUV:Rectangle = sheet.__rectUV;
		var center:Point = sheet.__point;
		var x = 0.0, y = 0.0;
		var alpha = 1.0, tint = 0xFFFFFF;
		var scale = 1.0, rotation = 0.0;
		var cosTheta = 1.0, sinTheta = 0.0;
		var a = 0.0, b = 0.0, c = 0.0, d = 0.0, tx = 0.0, ty = 0.0;
		var ox = 0.0, oy = 0.0;
		var matrix = new Matrix();
		var oMatrix = object.__worldTransform;
		var uvs = new TextureUvs();
		
		var bIndex = 0;
		
		while (iIndex < totalCount) {
			
			if (currentBatchSize >= size) {
				flush ();
				currentBaseTexture = texture;
			}
			
			x = tileData[iIndex + 0];
			y = tileData[iIndex + 1];
			
			if (useRect) {
				tileID = -1;

				rect.x = tileData[iIndex + 2];
				rect.y = tileData[iIndex + 3];
				rect.width = tileData[iIndex + 4];
				rect.height = tileData[iIndex + 5];
				
				if (useOrigin) {
					center.x = tileData[iIndex + 6];
					center.y = tileData[iIndex + 7];
				} else {
					center.setTo(0, 0);
				}
				
				tileUV.setTo(rect.left / sheet.__bitmap.width, rect.top / sheet.__bitmap.height, rect.right / sheet.__bitmap.width, rect.bottom / sheet.__bitmap.height);
			} else {
				tileID = Std.int(#if (neko || js) tileData[iIndex + 2] == null ? 0 : #end tileData[iIndex + 2]);
				rect = sheet.getTileRect(tileID);
				center = sheet.getTileCenter(tileID);
				tileUV = sheet.getTileUVs(tileID);
			}
			
			if (rect != null && rect.width > 0 && rect.height > 0 && center != null) {
				
				alpha = 1;
				tint = 0xFFFFFF;
				a = 1; b = 0; c = 0; d = 1; tx = 0; ty = 0;
				scale = 1.0;
				rotation = 0.0;
				cosTheta = 1.0;
				sinTheta = 0.0;
				matrix.identity();
				
				if (useAlpha) {
					alpha = tileData[iIndex + alphaIndex];
				}
				
				if (useRGB) {
					tint = Std.int(tileData[iIndex + rgbIndex] * 255) << 16 | Std.int(tileData[iIndex + rgbIndex + 1] * 255) << 8 | Std.int(tileData[iIndex + rgbIndex + 2] * 255);
				}
				
				if (useScale) {
					scale = tileData[iIndex + scaleIndex];
				}
				
				if (useRotation) {
					rotation = tileData[iIndex + rotationIndex];
					cosTheta = Math.cos(rotation);
					sinTheta = Math.sin(rotation);
				}
				
				if (useTransform) {
					a = tileData[iIndex + transformIndex + 0];
					b = tileData[iIndex + transformIndex + 1];
					c = tileData[iIndex + transformIndex + 2];
					d = tileData[iIndex + transformIndex + 3];
				} else {
					a = scale * cosTheta;
					b = scale * sinTheta;
					c = -b;
					d = a;
				}
				
				ox = center.x * a + center.y * c;
				oy = center.x * b + center.y * d;
				
				tx = x - ox;
				ty = y - oy;
				
				matrix.a = a * oMatrix.a + b * oMatrix.c;
				matrix.b = a * oMatrix.b + b * oMatrix.d;
				matrix.c = c * oMatrix.a + d * oMatrix.c;
				matrix.d = c * oMatrix.b + d * oMatrix.d;
				matrix.tx = tx * oMatrix.a + ty * oMatrix.c/* + oMatrix.tx*/;
				matrix.ty = tx * oMatrix.b + ty * oMatrix.d/* + oMatrix.ty*/;
				
				uvs.x0 = tileUV.x;  uvs.y0 = tileUV.y;
				uvs.x1 = tileUV.width; uvs.y1 = tileUV.y;
				uvs.x2 = tileUV.width; uvs.y2 = tileUV.height;
				uvs.x3 = tileUV.x;  uvs.y3 = tileUV.height;
				
				bIndex = currentBatchSize * 4 * vertSize;
				
				fillVertices(bIndex, 0, 0, rect.width, rect.height, tint, alpha, uvs, matrix);
				
				setState(currentBatchSize, texture, smooth, blendMode);
				
				currentBatchSize++;
			}
			
			iIndex += numValues;
			
		}
	}
	
	private inline function fillVertices(index:Int,
										aX:Float, aY:Float,
										width:Float, height:Float,
										tint:Int, alpha:Float,
										uvs:TextureUvs,
										matrix:Matrix) {

		var w0, w1, h0, h1;
		w0 = width * (1 - aX);
		w1 = width * -aX;
		h0 = height * (1 - aY);
		h1 = height * -aY;
		
		var a = matrix.a;
		var b = matrix.b;
		var c = matrix.c;
		var d = matrix.d;
		var tx = matrix.tx;
		var ty = matrix.ty;
		
		vertices[index++] = (a * w1 + c * h1 + tx);
		vertices[index++] = (d * h1 + b * w1 + ty);
		vertices[index++] = uvs.x0;
		vertices[index++] = uvs.y0;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = (a * w0 + c * h1 + tx);
		vertices[index++] = (d * h1 + b * w0 + ty);
		vertices[index++] = uvs.x1;
		vertices[index++] = uvs.y1;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = (a * w0 + c * h0 + tx);
		vertices[index++] = (d * h0 + b * w0 + ty);
		vertices[index++] = uvs.x2;
		vertices[index++] = uvs.y2;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
		vertices[index++] = (a * w1 + c * h0 + tx);
		vertices[index++] = (d * h0 + b * w1 + ty);
		vertices[index++] = uvs.x3;
		vertices[index++] = uvs.y3;
		vertices[index++] = alpha;
		vertices[index++] = tint;
		
	}
	
	private function setState(index:Int, texture:GLTexture, smooth:Bool = true, blendMode:BlendMode) {
		var state:State = states[currentBatchSize];
		if (state == null) {
			state = states[currentBatchSize] = new State();
		}
		state.texture = texture;
		state.textureSmooth = smooth;
		state.blendMode = blendMode;
	}
	
		
	private function renderBatch (state:State, size:Int, startIndex:Int):Void {
		
		if (size == 0)return;
		
		//var gl = this.gl;
		
		//var tex:GLTexture = /*texture._glTextures[GLRenderer.glContextId];*/ texture.getTexture (gl);
		//if (tex == null) tex = Texture.createWebGLTexture (texture, gl);
		gl.bindTexture (gl.TEXTURE_2D, state.texture);
		
		if (state.textureSmooth) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);						
		}
		/*if (texture._dirty[GLRenderer.glContextId]) {
			
			Texture.updateWebGLTexture (currentBaseTexture, gl);
			
		}*/
		
		gl.drawElements (gl.TRIANGLES, size * 6, gl.UNSIGNED_SHORT, startIndex * 6 * 2);
		
		renderSession.drawCount++;
		
	}
	
	
	public function renderTilingSprite (tilingSprite:Dynamic):Void {
		/*
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
		*/
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

private class State {
	public var texture:GLTexture;
	public var textureSmooth:Bool = true;
	public var blendMode:BlendMode;
	// TODO
	//public var shader:Dynamic;
	
	public function new() {}
}