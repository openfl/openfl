package openfl._internal.renderer.opengl.batcher;

import haxe.ds.Vector;

import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.opengl.GLBlendModeManager;
import openfl._internal.renderer.opengl.GLShaderManager;
import openfl._internal.renderer.opengl.batcher.BitHacks.*;
import openfl._internal.renderer.opengl.batcher.Quad;

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

// inspired by pixi.js SpriteRenderer
class BatchRenderer {
	var gl:GLRenderContext;
	var blendModeManager:GLBlendModeManager;
	var shaderManager:GLShaderManager;
	var maxQuads:Int;
	var maxTextures:Int;

	var shader:MultiTextureShader;
	var indexBuffer:GLBuffer;
	var vertexBuffer:GLBuffer;
	var vertexBufferData:Float32Array;

	var groups:Vector<RenderGroup>;
	var boundTextures:Vector<TextureData>;

	var currentBlendMode = BlendMode.NORMAL;
	var currentTexture:TextureData;
	var currentQuadIndex = 0;
	var currentGroup:RenderGroup;
	var currentGroupCount = 0;

	var tick = 0;
	var textureTick = 0;

	public var projectionMatrix:Float32Array;
	
	var emptyTexture:GLTexture;
	
	static inline var floatsPerQuad = MultiTextureShader.floatsPerVertex * 4;

	public function new(gl:GLRenderContext, blendModeManager:GLBlendModeManager, shaderManager:GLShaderManager, maxQuads:Int) {
		this.gl = gl;
		this.blendModeManager = blendModeManager;
		this.shaderManager = shaderManager;
		this.maxQuads = maxQuads;

		// determine amount of textures we can draw at once and generate a shader for that
		shader = new MultiTextureShader(gl);
		maxTextures = shader.maxTextures;
		
		emptyTexture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, emptyTexture);
		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, 1, 1, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);

		// a singleton vector we use to track texture binding when rendering
		boundTextures = new Vector(maxTextures);

		// preallocate block of memory for the vertex buffer
		vertexBufferData = new Float32Array(maxQuads * floatsPerQuad);

		// create the vertex buffer for further uploading
		vertexBuffer = gl.createBuffer();
		
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, vertexBufferData.byteLength, vertexBufferData, gl.STREAM_DRAW);

		// preallocate a static index buffer for rendering any number of quads
		var indices = createIndicesForQuads(maxQuads);
		indexBuffer = gl.createBuffer();
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices.byteLength, indices, gl.STATIC_DRAW);

		// preallocate render group objects for any number of quads (worst case - 1 group per quad)
		groups = new Vector(maxQuads);
		for (i in 0...maxQuads) {
			groups[i] = new RenderGroup();
		}
		
		startNextGroup();
	}

	inline function finishCurrentGroup() {
		currentGroup.size = currentQuadIndex - currentGroup.start;
	}

	inline function startNextGroup() {
		currentGroup = groups[currentGroupCount];
		currentGroup.textureCount = 0;
		currentGroup.start = currentQuadIndex;
		currentGroup.blendMode = currentBlendMode;
		// we always increase the tick when staring a new render group, so all textures become "disabled" and need to be processed
		tick++;
		currentGroupCount++;
	}

	public function flipVertical() {
		shader.positionScale[1] = -1;
	}

	public function unflipVertical() {
		shader.positionScale[1] = 1;
	}

	/** schedule quad for rendering **/
	public function render(quad:Quad) {
		if (currentQuadIndex >= maxQuads) {
			flush();
		}

		var nextTexture = quad.texture.data;

		if (currentBlendMode != quad.blendMode) {
			currentBlendMode = quad.blendMode;
			currentTexture = null;

			finishCurrentGroup();
			startNextGroup();
		}

		// if the texture has changed - we need to either pack it into the current render group or create the next one
		// and since on the first iteration the `currentTexture` is null, it's always "changed"
		if (currentTexture != nextTexture) {
			currentTexture = nextTexture;

			// if the texture's tick and current tick are equal, that means
			// that the texture was already enabled in the current group
			// and we don't need to do anything, otherwise...
			if (currentTexture.enabledTick != tick) {

				// if the current group is already full of textures, finish it and start a new one
				if (currentGroup.textureCount == maxTextures) {
					finishCurrentGroup();
					startNextGroup();
				}

				// if the texture hasn't yet been bound to a texture unit this render, we need to choose one
				if (nextTexture.textureUnitId == -1) {
					// iterate over possible texture "slots"
					for (i in 0...maxTextures) {
						// we use "texture tick" for calculating texture unit,
						// so we always start checking with the next texture unit,
						// relative to previous binding
						var textureUnit = (i + textureTick) % maxTextures;

						// if there's no bound texture in this slot, or that texture
						// wasn't used in this group (ticks are different), we can use this slot!
						var boundTexture = boundTextures[textureUnit];
						if (boundTexture == null || boundTexture.enabledTick != tick) {
							// if there was a texture in this slot - unbind it, since we're replacing it
							if (boundTexture != null) {
								boundTexture.textureUnitId = -1;
							}

							// assign this texture to the texture unit
							nextTexture.textureUnitId = textureUnit;
							boundTextures[textureUnit] = nextTexture;

							// increase the tick so next time we'll start looking directly from the next texture unit
							textureTick++;

							// and we're done here
							break;
						}
					}
					if (nextTexture.textureUnitId == -1) {
						throw "Unable to find free texture unit for the batch render group! This should NOT happen!";
					}
				}

				// mark the texture as enabled in this group
				nextTexture.enabledTick = tick;
				// add the texture to the group textures array
				currentGroup.textures[currentGroup.textureCount] = nextTexture;
				// save the texture unit number separately as it can change when processing next group
				currentGroup.textureUnits[currentGroup.textureCount] = nextTexture.textureUnitId;
				currentGroup.textureSmoothing[currentGroup.textureCount] = quad.smoothing;
				currentGroup.textureCount++;
			}
		}

		// fill the vertex buffer with vertex and texture coordinates, as well as the texture id
		var vertexData = quad.vertexData;
		var uvs = quad.texture.uvs;
		var textureUnitId = nextTexture.textureUnitId;
		var alpha = quad.alpha;
		var pma = quad.texture.premultipliedAlpha;
		var colorTransform = quad.colorTransform;
		var currentVertexBufferIndex = currentQuadIndex * floatsPerQuad;

		// trace('Group $currentGroupCount uses texture $textureUnitId');

		inline function setVertex(i) {
			var offset = currentVertexBufferIndex + i * MultiTextureShader.floatsPerVertex;
			vertexBufferData[offset + 0] = vertexData[i * 2 + 0];
			vertexBufferData[offset + 1] = vertexData[i * 2 + 1];

			vertexBufferData[offset + 2] = uvs[i * 2 + 0];
			vertexBufferData[offset + 3] = uvs[i * 2 + 1];

			vertexBufferData[offset + 4] = textureUnitId;

			if (colorTransform != null) {
				vertexBufferData[offset + 5] = colorTransform.redOffset / 255;
				vertexBufferData[offset + 6] = colorTransform.greenOffset / 255;
				vertexBufferData[offset + 7] = colorTransform.blueOffset / 255;
				vertexBufferData[offset + 8] = (colorTransform.alphaOffset / 255) * alpha;

				vertexBufferData[offset + 9] = colorTransform.redMultiplier;
				vertexBufferData[offset + 10] = colorTransform.greenMultiplier;
				vertexBufferData[offset + 11] = colorTransform.blueMultiplier;
				vertexBufferData[offset + 12] = colorTransform.alphaMultiplier * alpha;
			} else {
				vertexBufferData[offset + 5] = 0;
				vertexBufferData[offset + 6] = 0;
				vertexBufferData[offset + 7] = 0;
				vertexBufferData[offset + 8] = 0;

				vertexBufferData[offset + 9] = 1;
				vertexBufferData[offset + 10] = 1;
				vertexBufferData[offset + 11] = 1;
				vertexBufferData[offset + 12] = alpha;
			}

			vertexBufferData[offset + 13] = pma ? 1 : 0;
		}

		setVertex(0);
		setVertex(1);
		setVertex(2);
		setVertex(3);

		currentQuadIndex++;
		#if gl_stats
			GLStats.quadCounter.increment();
		#end
	}

	/** render all the quads we collected **/
	public function flush() {
		if (currentQuadIndex == 0) {
			return;
		}

		// finish the current group
		finishCurrentGroup();

		// use local vars to save some field access
		var gl = this.gl;
		var blendModeManager = this.blendModeManager;
		var vertexBufferData = this.vertexBufferData;
		var boundTextures = this.boundTextures;
		var groups = this.groups;

		shader.enable(projectionMatrix);

		// bind the index buffer
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);

		// upload vertex data and setup attribute pointers
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		var subArray = vertexBufferData.subarray(0, currentQuadIndex * floatsPerQuad);
		gl.bufferSubData(gl.ARRAY_BUFFER, 0, subArray.byteLength, subArray);

		var stride = MultiTextureShader.floatsPerVertex * Float32Array.BYTES_PER_ELEMENT;
		gl.vertexAttribPointer(shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
		gl.vertexAttribPointer(shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aTextureId, 1, gl.FLOAT, false, stride, 4 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorOffset, 4, gl.FLOAT, false, stride, 5 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorMultiplier, 4, gl.FLOAT, false, stride, 9 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aPremultipliedAlpha, 1, gl.FLOAT, false, stride, 13 * Float32Array.BYTES_PER_ELEMENT);

		for (i in 0...maxTextures) {
			gl.activeTexture(gl.TEXTURE0 + i);
			gl.bindTexture(gl.TEXTURE_2D, emptyTexture);
		}

		var lastBlendMode = null;

		// iterate over groups and render them
		for (i in 0...currentGroupCount) {
			var group = groups[i];
			if (group.size == 0) {
				// TODO: don't even create empty groups (can happen when staring drawing with a non-NORMAL blendmode)
				continue;
			}
			// trace('Rendering group ${i + 1} (${group.size})');

			// bind this group's textures
			for (i in 0...group.textureCount) {
				var currentTexture = group.textures[i];
				// trace('Activating texture at ${group.textureUnits[i]}: ${currentTexture.glTexture}');
				gl.activeTexture(gl.TEXTURE0 + group.textureUnits[i]);
				gl.bindTexture(gl.TEXTURE_2D, currentTexture.glTexture);

				if (group.textureSmoothing[i]) {
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
				} else {
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
					gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
				}

				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
				gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

				currentTexture.textureUnitId = -1; // clear the binding for subsequent flush calls
			}

			// apply the blend mode if changed
			if (group.blendMode != lastBlendMode) {
				lastBlendMode = group.blendMode;
				lastBlendMode.apply(gl);
			}
			

			// draw this group's slice of vertices
			gl.drawElements(gl.TRIANGLES, group.size * 6, gl.UNSIGNED_SHORT, group.start * 6 * UInt16Array.BYTES_PER_ELEMENT);

			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
		}

		// disable the current OpenFL shader so it'll be re-enabled properly on next non-batched openfl render
		// this is needed because we don't use ShaderManager to set our shader. Ideally we should do that, but
		// this will requires some rework for the whole OpenFL shader system, which we'll do when we'll fork away for good 
		shaderManager.setShader(null);
		blendModeManager.setBlendMode(NORMAL);

		for (i in 0...maxTextures) {
			boundTextures[i] = null;
		}
		currentTexture = null;
		currentQuadIndex = 0;
		currentBlendMode = BlendMode.NORMAL;
		currentGroupCount = 0;
		startNextGroup();
	}

	/** creates an pre-filled index buffer data for rendering triangles **/
	static function createIndicesForQuads(numQuads:Int):UInt16Array {
		var totalIndices = numQuads * 3 * 2; // 2 triangles of 3 verties per quad
		var indices = new UInt16Array(totalIndices);
		var i = 0, j = 0;
		while (i < totalIndices) {
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

private class RenderGroup {
	public var textures = new Array<TextureData>();
	public var textureUnits = new Array<Int>();
	public var textureSmoothing = new Array<Bool>();
	public var textureCount = 0;
	public var size = 0;
	public var start = 0;
	public var blendMode:BlendMode;
	public function new() {}
}
