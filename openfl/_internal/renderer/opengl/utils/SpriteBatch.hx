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
import openfl.display.Shader in FlashShader;
import openfl.display.Shader.GLShaderData;
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
@:access(openfl.display.Shader)
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
	
	var matrix:Matrix = new Matrix();
	var uvs:TextureUvs = new TextureUvs();
	
	
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
			stop();
		}
		dirty = true;
		this.clipRect = clipRect;
	}
	
	public function stop() {
		flush();
	}
	
	public function renderBitmapData(bitmapData:BitmapData, smoothing:Bool, matrix:Matrix, ct:ColorTransform, ?alpha:Float = 1, ?blendMode:BlendMode, ?flashShader:FlashShader, ?pixelSnapping:PixelSnapping, bgra:Bool = false) {
		if (bitmapData == null) return;
		var texture = bitmapData.getTexture(gl);
		
		if (batchedSprites >= maxSprites) {
			flush();
		}
		
		var uvs = bitmapData.__uvData;
		if (uvs == null) return;
		
		prepareShader(flashShader, bitmapData);
		
		var color:Int = ((Std.int(alpha * 255)) & 0xFF) << 24 | 0xFFFFFF;
		
		//enableAttributes(color);
		enableAttributes(0);
		
		var index = batchedSprites * 4 * elementsPerVertex;
		fillVertices(index, bitmapData.width, bitmapData.height, matrix, uvs, color, pixelSnapping);
		
		setState(batchedSprites, texture, smoothing, blendMode, ct, flashShader, true);
		
		batchedSprites++;
	}
	
	public function renderTiles(object:DisplayObject, sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, ?flashShader:FlashShader, count:Int = -1) {		
		
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
			case Tilesheet.TILE_BLEND_ADD:                ADD;
			case Tilesheet.TILE_BLEND_MULTIPLY:           MULTIPLY;
			case Tilesheet.TILE_BLEND_SCREEN:             SCREEN;
			case Tilesheet.TILE_BLEND_SUBTRACT:           SUBTRACT;
			case _: switch(flags & 0xF00000) {
				case Tilesheet.TILE_BLEND_DARKEN:         DARKEN;
				case Tilesheet.TILE_BLEND_LIGHTEN:        LIGHTEN;
				case Tilesheet.TILE_BLEND_OVERLAY:        OVERLAY;
				case Tilesheet.TILE_BLEND_HARDLIGHT:      HARDLIGHT;
				case _: switch(flags & 0xF000000) {
					case Tilesheet.TILE_BLEND_DIFFERENCE: DIFFERENCE;
					case Tilesheet.TILE_BLEND_INVERT:     INVERT;
					case _:                               NORMAL;
				}
			}
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
		var itemCount = Math.ceil (totalCount / numValues);
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
		
		var oMatrix = object.__worldTransform;
		
		var bIndex = 0;
		var tMa  = 1.0, tMb  = 0.0;
		var tMc  = 0.0, tMd  = 1.0;
		var tMtx = 0.0, tMty = 0.0;
		
		var oMa  = oMatrix.a;
		var oMb  = oMatrix.b;
		var oMc  = oMatrix.c;
		var oMd  = oMatrix.d;
		var oMtx = oMatrix.tx;
		var oMty = oMatrix.ty;
		
		var rx = 0.0, ry = 0.0, rw = 0.0, rh = 0.0;
		var tuvx = 0.0, tuvy = 0.0, tuvw = 0.0, tuvh = 0.0;
		
		//enableAttributes((useRGB || useAlpha) ? 0 : 0xFFFFFFFF);
		enableAttributes(0);
		
		prepareShader(flashShader);
		
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
				
				rw = rect.width; rh = rect.height;
				tuvx = rect.left / sheet.__bitmap.width;
				tuvy = rect.top / sheet.__bitmap.height;
				tuvw = rect.right / sheet.__bitmap.width;
				tuvh = rect.bottom / sheet.__bitmap.height;
			} else {
				tileID = Std.int(#if (neko || js) tileData[iIndex + 2] == null ? 0 : #end tileData[iIndex + 2]);
				rect = sheet.getTileRect(tileID);
				center = sheet.getTileCenter(tileID);
				tileUV = sheet.getTileUVs(tileID);
				
				if (rect != null) {
					rw = rect.width; rh = rect.height;
					tuvx = tileUV.x; tuvy = tileUV.y; tuvw = tileUV.width; tuvh = tileUV.height;
				}
			}
			
			if (rect != null && rect.width > 0 && rect.height > 0 && center != null) {
				
				alpha = 1;
				tint = 0xFFFFFF;
				scale = 1.0;
				rotation = 0.0;
				cosTheta = 1.0;
				sinTheta = 0.0;
				
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
				
				// expanded fillVertices here since it doesn't need to access matrix or uvs
				
				tMa = (a * oMa + b * oMc) * rw;
				tMb = (a * oMb + b * oMd) * rw;
				tMc = (c * oMa + d * oMc) * rh;
				tMd = (c * oMb + d * oMd) * rh;
				tMtx = tx * oMa + ty * oMc + oMtx;
				tMty = tx * oMb + ty * oMd + oMty;
				
				bIndex = batchedSprites * 4 * elementsPerVertex;
				// POSITIONS
				positions[bIndex + 0] 	= (tMtx);
				positions[bIndex + 1] 	= (tMty);
				positions[bIndex + 5] 	= (tMa + tMtx);
				positions[bIndex + 6] 	= (tMb + tMty);
				positions[bIndex + 10] 	= (tMa + tMc + tMtx);
				positions[bIndex + 11] 	= (tMd + tMb + tMty);
				positions[bIndex + 15] 	= (tMc + tMtx);
				positions[bIndex + 16] 	= (tMd + tMty);
				//COLORS
				colors[bIndex + 4] = colors[bIndex + 9] = colors[bIndex + 14] = colors[bIndex + 19] = ((Std.int(alpha * 255)) & 0xFF) << 24 | tint;
				// UVS
				positions[bIndex + 2]  = tuvx;
				positions[bIndex + 3]  = tuvy;
				positions[bIndex + 7]  = tuvw;
				positions[bIndex + 8]  = tuvy;
				positions[bIndex + 12] = tuvw;
				positions[bIndex + 13] = tuvh;
				positions[bIndex + 17] = tuvx;
				positions[bIndex + 18] = tuvh;
				
				writtenVertexBytes = bIndex + 20;
				
				setState(batchedSprites, texture, smooth, blendMode, object.__worldColorTransform, flashShader, false);
				
				batchedSprites++;
			}
			
			iIndex += numValues;
			
		}
	}
	
	inline function fillVertices(index:Int, width:Float, height:Float, matrix:Matrix, uvs:TextureUvs,
		color:Int = 0xFFFFFFFF, ?pixelSnapping:PixelSnapping) {
		
		var a = matrix.a;
		var b = matrix.b;
		var c = matrix.c;
		var d = matrix.d;
		var tx = matrix.tx;
		var ty = matrix.ty;
		
		// POSITION
		if (pixelSnapping == null || pixelSnapping == NEVER) {
			positions[index + 0] 	= (tx);
			positions[index + 1] 	= (ty);
			positions[index + 5] 	= (a * width + tx);
			positions[index + 6] 	= (b * width + ty);
			positions[index + 10] 	= (a * width + c * height + tx);
			positions[index + 11] 	= (d * height + b * width + ty);
			positions[index + 15] 	= (c * height + tx);
			positions[index + 16] 	= (d * height + ty);
		} else {
			positions[index + 0] 	= Math.fround(tx);
			positions[index + 1] 	= Math.fround(ty);
			positions[index + 5] 	= Math.fround(a * width + tx);
			positions[index + 6] 	= Math.fround(b * width + ty);
			positions[index + 10] 	= Math.fround(a * width + c * height + tx);
			positions[index + 11] 	= Math.fround(d * height + b * width + ty);
			positions[index + 15] 	= Math.fround(c * height + tx);
			positions[index + 16] 	= Math.fround(d * height + ty);
		}
		
		// COLOR
		if (enableColor) {
			colors[index + 4] = colors[index + 9] = colors[index + 14] = colors[index + 19] = color;
		}
		
		// UVS
		positions[index + 2] = uvs.x0;
		positions[index + 3] = uvs.y0;
		positions[index + 7] = uvs.x1;
		positions[index + 8] = uvs.y1;
		positions[index + 12] = uvs.x2;
		positions[index + 13] = uvs.y2;
		positions[index + 17] = uvs.x3;
		positions[index + 18] = uvs.y3;
		
		writtenVertexBytes = index + 20;
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
						Math.ceil(clipRect.width),
						Math.ceil(clipRect.height)
					);
		}
		
		if (dirty) {
			dirty = false;
			
			renderSession.activeTextures = 1;
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
		
		currentState.shader = null;
		currentState.shaderData = null;
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
				currentState.shaderData = nextState.shaderData;
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
		
		renderSession.blendModeManager.setBlendMode(shader.blendMode != null ? shader.blendMode : state.blendMode);
		
		gl.uniformMatrix3fv(shader.getUniformLocation(DefUniform.ProjectionMatrix), false, renderSession.projectionMatrix.toArray(true));
		
		if (state.colorTransform != null) {
			gl.uniform1i(shader.getUniformLocation(DefUniform.UseColorTransform), 1);
			var ct = state.colorTransform;
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorMultiplier),
						ct.redMultiplier, ct.greenMultiplier, ct.blueMultiplier, state.skipColorTransformAlpha ? 1 : ct.alphaMultiplier);
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorOffset),
						ct.redOffset / 255., ct.greenOffset / 255., ct.blueOffset / 255., ct.alphaOffset / 255.);
		} else {
			gl.uniform1i(shader.getUniformLocation(DefUniform.UseColorTransform), 0);
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorMultiplier), 1, 1, 1, 1);
			gl.uniform4f(shader.getUniformLocation(DefUniform.ColorOffset), 0, 0, 0, 0);
		}
		
		gl.activeTexture(gl.TEXTURE0 + 0);
		gl.bindTexture(gl.TEXTURE_2D, state.texture);
		gl.uniform1i(shader.getUniformLocation(DefUniform.Sampler), 0);
		
		if ((shader.smooth != null && shader.smooth) || state.textureSmooth) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
		}
		
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, shader.wrapS);
		gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, shader.wrapT);
		
		shader.applyData(state.shaderData, renderSession);
		
		gl.drawElements (gl.TRIANGLES, size * 6, gl.UNSIGNED_SHORT, start * 6 * 2);
		
		renderSession.drawCount++;
		
	}
	
	inline function setState(index:Int, texture:GLTexture, ?smooth:Bool = false, ?blendMode:BlendMode, ?colorTransform:ColorTransform, ?shader:FlashShader, ?skipAlpha:Bool = false) {
		var state:State = states[index];
		if (state == null) {
			state = states[index] = new State();
		}
		state.texture = texture;
		state.textureSmooth = smooth;
		state.blendMode = blendMode;
		// colorTransform is default, skipping it
		state.colorTransform = (colorTransform != null && @:privateAccess colorTransform.__isDefault()) ? null : colorTransform;
		state.skipColorTransformAlpha = skipAlpha;
		if (shader == null) {
			state.shader = null;
			state.shaderData = null;
		} else {
			state.shader = shader.__shader;
			state.shaderData = shader.data;
		}
	}
	
	public function setContext(gl:GLRenderContext) {
		this.gl = gl;
		
		vertexArray.setContext(gl, positions);
		
		indexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
		
	}
	
	inline function prepareShader(flashShader:FlashShader, ?bd:BitmapData) {
		if (flashShader != null) {
			flashShader.__init(this.gl);
			flashShader.__shader.wrapS = flashShader.repeatX;
			flashShader.__shader.wrapT = flashShader.repeatY;
			flashShader.__shader.smooth = flashShader.smooth;
			flashShader.__shader.blendMode = flashShader.blendMode;
			
			var objSize = flashShader.data.get(FlashShader.uObjectSize);
			var texSize = flashShader.data.get(FlashShader.uTextureSize);
			if (bd != null) {
				objSize.value[0] = bd.width;
				objSize.value[1] = bd.height;
				if(bd.__pingPongTexture != null) {
					texSize.value[0] = @:privateAccess bd.__pingPongTexture.renderTexture.__width;
					texSize.value[1] = @:privateAccess bd.__pingPongTexture.renderTexture.__height;
				} else {
					texSize.value[0] = bd.width;
					texSize.value[1] = bd.height;
				}
			} else {
				objSize.value[0] = 0;
				objSize.value[1] = 0;
				texSize.value[0] = 0;
				texSize.value[1] = 0;
			}
		}
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
	public var shaderData:GLShaderData;
	
	public function new() { }
	
	public inline function equals(other:State) {
		return (
				// if both shaders are null we are using the DefaultShader, if not, check the id
				((shader == null && other.shader == null) || (shader != null && other.shader != null && shader.ID == other.shader.ID)) &&
				texture == other.texture &&
				textureSmooth == other.textureSmooth &&
				blendMode == other.blendMode &&
				// colorTransform.alphaMultiplier == object.__worldAlpha so we can skip it
				((colorTransform == null && other.colorTransform == null) || (colorTransform != null && other.colorTransform != null && colorTransform.__equals(other.colorTransform, skipColorTransformAlpha)))
		);
	}
	
	public function destroy() {
		texture = null;
		colorTransform = null;
	}
}