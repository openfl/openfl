package openfl._internal.renderer.opengl.utils;

import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders2.*;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefAttrib;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.gl.GLBuffer;
import openfl.gl.GLTexture;
import openfl.display.BlendMode;
import lime.utils.*;

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Tilesheet)
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
	
	var dirty:Bool = true;
	public var drawing:Bool = false;
	
	var clipRect:Rectangle;
	
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
	
	
	public function new(gl:GLRenderContext, maxSprites:Int = 2000) {
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
		
		vertexArray = new VertexArray(attributes, vertexArraySize, false);
		positions = new Float32Array(vertexArray.buffer);
		colors = new UInt32Array(vertexArray.buffer);
		
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
		dirty = true;
		drawing = false;
		batchedSprites = 0;
		
		setContext(gl);
		
	}
	
	public function destroy() {
		vertexArray.destroy();
		vertexArray = null;
		
		indices = null;
		gl.deleteBuffer(indexBuffer);
		
		currentState.destroy();
		for (state in states) {
			state.destroy();
		}
		
		gl = null;
	}
	
	public function begin(renderSession:RenderSession, ?clipRect:Rectangle = null):Void {
		
		this.renderSession = renderSession;
		shader = renderSession.shaderManager.defaultShader;
		drawing = true;
		start(clipRect);
		
	}
	
	public function finish() {
		stop();
		clipRect = null;
		drawing = false;
	}
	
	public function start(?clipRect:Rectangle = null) {
		if (!drawing) {
			throw "Call Spritebatch.begin() before start()";
		}
		dirty = true;
		this.clipRect = clipRect;
	}
	
	public function stop() {
		flush();
	}
	
	public function renderBitmapData(bitmapData:BitmapData, smoothing:Bool, matrix:Matrix, ct:ColorTransform, ?alpha:Float = 1, ?blendMode:BlendMode, ?pixelSnapping:PixelSnapping, bgra:Bool = false) {
		if (bitmapData == null) return;
		var texture = bitmapData.getTexture(gl);
		
		if (batchedSprites >= maxSprites) {
			flush();
		}
		
		var uvs = bitmapData.__uvData;
		if (uvs == null) return;
		
		var color:Int = ((Std.int(alpha * 255)) & 0xFF) << 24 | 0xFFFFFF;
		
		//enableAttributes(color);
		enableAttributes(0);
		
		var index = batchedSprites * 4 * elementsPerVertex;
		fillVertices(index, bitmapData.width, bitmapData.height, matrix, uvs, null, color, pixelSnapping);
		
		setState(batchedSprites, texture, smoothing, blendMode, ct, true);
		
		batchedSprites++;
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
			case Tilesheet.TILE_BLEND_SUBTRACT:	SUBTRACT;
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
		var alpha = 1.0, tint = 0xFFFFFF, color = 0xFFFFFFFF;
		var scale = 1.0, rotation = 0.0;
		var cosTheta = 1.0, sinTheta = 0.0;
		var a = 0.0, b = 0.0, c = 0.0, d = 0.0, tx = 0.0, ty = 0.0;
		var ox = 0.0, oy = 0.0;
		var matrix = new Matrix();
		var oMatrix = object.__worldTransform;
		var uvs = new TextureUvs();
		
		var bIndex = 0;
		
		//enableAttributes((useRGB || useAlpha) ? 0 : 0xFFFFFFFF);
		enableAttributes(0);
		
		while (iIndex < totalCount) {
			
			if (batchedSprites >= maxSprites) {
				flush ();
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
					alpha = tileData[iIndex + alphaIndex] * object.__worldAlpha;
				} else {
					alpha = object.__worldAlpha;
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
				matrix.tx = tx * oMatrix.a + ty * oMatrix.c + oMatrix.tx;
				matrix.ty = tx * oMatrix.b + ty * oMatrix.d + oMatrix.ty;
				
				uvs.x0 = tileUV.x;  uvs.y0 = tileUV.y;
				uvs.x1 = tileUV.width; uvs.y1 = tileUV.y;
				uvs.x2 = tileUV.width; uvs.y2 = tileUV.height;
				uvs.x3 = tileUV.x;  uvs.y3 = tileUV.height;
				
				bIndex = batchedSprites * 4 * elementsPerVertex;
				
				color = ((Std.int(alpha * 255)) & 0xFF) << 24 | (tint & 0xFF) << 16 | ((tint >> 8) & 0xFF) << 8 | ((tint >> 16) & 0xFF);
				
				fillVertices(bIndex, rect.width, rect.height, matrix, uvs, null, color, NEVER);
				
				setState(batchedSprites, texture, smooth, blendMode, object.__worldColorTransform, false);
				
				batchedSprites++;
			}
			
			iIndex += numValues;
			
		}
	}
	
	public function renderCachedGraphics(object:DisplayObject) {
		var cachedTexture = object.__graphics.__cachedTexture;
		
		if (cachedTexture == null) return;
		
		if (batchedSprites >= maxSprites) {
			flush();
		}
		
		var alpha = object.__worldAlpha;
		var color:Int = ((Std.int(alpha * 255)) & 0xFF) << 24 | 0xFFFFFF;
		

		var uvs = new TextureUvs();
		uvs.x0 = 0;		uvs.y0 = 1;
		uvs.x1 = 1;		uvs.y1 = 1;
		uvs.x2 = 1;		uvs.y2 = 0;
		uvs.x3 = 0;		uvs.y3 = 0;
		
		var worldTransform = object.__worldTransform.clone();
		worldTransform.__translateTransformed(object.__graphics.__bounds.x, object.__graphics.__bounds.y);
		
		enableAttributes(color);
		
		var index = batchedSprites * 4 * elementsPerVertex;
		fillVertices(index, cachedTexture.width, cachedTexture.height, worldTransform, uvs, null, color);
		
		setState(batchedSprites, cachedTexture.texture, object.blendMode, object.__worldColorTransform);
		
		batchedSprites++;
	}
	
	inline function fillVertices(index:Int, width:Float, height:Float, matrix:Matrix, uvs:TextureUvs, ?pivot:Point,
		?color:Int = 0xFFFFFFFF, ?pixelSnapping:PixelSnapping) {
		
		var w0:Float, w1:Float, h0:Float, h1:Float;
		
		
		if (pivot == null) {
			w0 = width; w1 = 0;
			h0 = height; h1 = 0;
		} else {
			w0 = width * (1 - pivot.x); 
			w1 = width * -pivot.x; 
			h0 = height * (1 - pivot.y); 
			h1 = height * -pivot.y; 
		}
		
		if (pixelSnapping == null) {
			pixelSnapping = PixelSnapping.NEVER;
		}
		
		var snap = pixelSnapping != NEVER;
		var a = matrix.a;
		var b = matrix.b;
		var c = matrix.c;
		var d = matrix.d;
		var tx = matrix.tx;
		var ty = matrix.ty;
		var cOffsetIndex = 0;
		
		if(!snap) {
			positions[index++] = (a * w1 + c * h1 + tx);
			positions[index++] = (d * h1 + b * w1 + ty);
		} else {
			positions[index++] = Math.fround(a * w1 + c * h1 + tx);
			positions[index++] = Math.fround(d * h1 + b * w1 + ty);
		}
		positions[index++] = uvs.x0;
		positions[index++] = uvs.y0;
		if(enableColor) {
			colors[index++] = color;
		}
		
		if(!snap) {
			positions[index++] = (a * w0 + c * h1 + tx);
			positions[index++] = (d * h1 + b * w0 + ty);
		} else {
			positions[index++] = Math.fround(a * w0 + c * h1 + tx);
			positions[index++] = Math.fround(d * h1 + b * w0 + ty);
		}
		positions[index++] = uvs.x1;
		positions[index++] = uvs.y1;
		if(enableColor) {
			colors[index++] = color;
		}
		
		if(!snap) {
			positions[index++] = (a * w0 + c * h0 + tx);
			positions[index++] = (d * h0 + b * w0 + ty);
		} else {
			positions[index++] = Math.fround(a * w0 + c * h0 + tx);
			positions[index++] = Math.fround(d * h0 + b * w0 + ty);
		}
		positions[index++] = uvs.x2;
		positions[index++] = uvs.y2;
		if(enableColor) {
			colors[index++] = color;
		}
		
		if(!snap) {
			positions[index++] = (a * w1 + c * h0 + tx);
			positions[index++] = (d * h0 + b * w1 + ty);
		} else {
			positions[index++] = Math.fround(a * w1 + c * h0 + tx);
			positions[index++] = Math.fround(d * h0 + b * w1 + ty);
		}
		positions[index++] = uvs.x3;
		positions[index++] = uvs.y3;
		if(enableColor) {
			colors[index++] = color;
		}
		
		writtenVertexBytes = index;
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
		if (batchedSprites == 0) return;
		
		if (clipRect != null) {
			gl.enable(gl.SCISSOR_TEST);
			gl.scissor(Math.floor(clipRect.x), 
						Math.floor(clipRect.y),
						Math.floor(clipRect.width),
						Math.floor(clipRect.height)
					);
		}
		
		if (dirty) {
			dirty = false;
			
			gl.activeTexture(gl.TEXTURE0);
			
			vertexArray.bind();
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		}
		
		if(writtenVertexBytes > (vertexArraySize * 0.5)) {
			vertexArray.upload(positions);
		} else {
			var view = positions.subarray(0, writtenVertexBytes);
			vertexArray.upload(view);
		}
		
		var nextState:State;
		var batchSize:Int = 0;
		var start:Int = 0;
		
		currentState.shader = renderSession.shaderManager.defaultShader;
		currentState.texture = null;
		currentState.textureSmooth = false;
		currentState.blendMode = renderSession.blendModeManager.currentBlendMode;
		currentState.colorTransform = null;
		currentState.skipColorTransformAlpha = false;
		
		for (i in 0...batchedSprites) {
			nextState = states[i];
			currentState.skipColorTransformAlpha = nextState.skipColorTransformAlpha;
			if (!nextState.equals(currentState)) {
				renderBatch(currentState, batchSize, start);
				
				start = i;
				batchSize = 0;
				
				currentState.shader = nextState.shader;
				currentState.texture = nextState.texture;
				currentState.textureSmooth = nextState.textureSmooth;
				currentState.blendMode = nextState.blendMode;
				currentState.colorTransform = nextState.colorTransform;
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
		
		var shader:Shader = state.shader == null ? renderSession.shaderManager.defaultShader : state.shader;
		renderSession.shaderManager.setShader(shader);
		
		// TODO cache this somehow?, don't do each state change?
		shader.bindVertexArray(vertexArray);
		
		gl.uniformMatrix3fv(shader.getUniformLocation(DefUniform.ProjectionMatrix), false, renderSession.projectionMatrix.toArray(true));
		
		if (state.colorTransform != null) {
			var ct = state.colorTransform;
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorMultiplier),
						ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, state.skipColorTransformAlpha ? 1 : ct.alphaMultiplier);
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorOffset),
						ct.redOffset / 255., ct.greenOffset / 255., ct.blueOffset / 255., ct.alphaOffset / 255.);
		} else {
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorMultiplier), 1, 1, 1, 1);
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorOffset), 0, 0, 0, 0);
		}
		
		renderSession.blendModeManager.setBlendMode(state.blendMode);
		gl.bindTexture(gl.TEXTURE_2D, state.texture);
		
		if (state.textureSmooth) {
		//if (false) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);						
		}
		
		gl.drawElements (gl.TRIANGLES, size * 6, gl.UNSIGNED_SHORT, start * 6 * 2);
		
		renderSession.drawCount++;
		
	}
	
	function setState(index:Int, texture:GLTexture, ?smooth:Bool = false, ?blendMode:BlendMode, ?colorTransform:ColorTransform, ?skipAlpha:Bool = false) {
		var state:State = states[index];
		if (state == null) {
			state = states[index] = new State();
		}
		state.texture = texture;
		state.textureSmooth = smooth;
		state.blendMode = blendMode;
		state.colorTransform = colorTransform;
		state.skipColorTransformAlpha = skipAlpha;
	}
	
	public function setContext(gl:GLRenderContext) {
		this.gl = gl;
		
		vertexArray.setContext(gl, positions);
		
		indexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
		
	}
	
	
	inline function getElementsPerVertex() {
		var r = 0;
		
		for (a in attributes) {
			if(a.enabled) r += a.elements;
		}
		
		return r;
	}
	
}

@:access(openfl.geom.ColorTransform)
private class State {
	public var texture:GLTexture;
	public var textureSmooth:Bool = true;
	public var blendMode:BlendMode;
	public var colorTransform:ColorTransform;
	public var skipColorTransformAlpha:Bool = false;
	public var shader:Shader;
	
	public function new() { }
	
	public inline function equals(other:State) {
		return ((shader == null || other.shader == null) || shader.ID == other.shader.ID) &&
				texture == other.texture &&
				textureSmooth == other.textureSmooth &&
				blendMode == other.blendMode &&
				// colorTransform.alphaMultiplier == object.__worldAlpha so we can skip it
				(colorTransform != null && colorTransform.__equals(other.colorTransform, skipColorTransformAlpha))
		;
	}
	
	public function destroy() {
		texture = null;
		colorTransform = null;
	}
}