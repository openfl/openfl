package openfl._internal.renderer.opengl.batcher;

import haxe.ds.Vector;

import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLBuffer;
import openfl.display.BlendMode;
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
	var vertexBufferDatas:Array<Float32Array>;

	var renderedQuadCount:Int;
	var renderedQuads:Array<Quad>;
	var groups:Vector<RenderGroup>;
	var boundTextures:Vector<TextureData>;
	var tick = 0;
	var textureTick = 0;

	public var projectionMatrix:Float32Array;

	public function new(gl:GLRenderContext, blendModeManager:GLBlendModeManager, shaderManager:GLShaderManager, maxQuads:Int) {
		this.gl = gl;
		this.blendModeManager = blendModeManager;
		this.shaderManager = shaderManager;
		this.maxQuads = maxQuads;

		// determine amount of textures we can draw at once and generate a shader for that
		maxTextures = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
		shader = new MultiTextureShader(gl, maxTextures);

		// a singleton vector we use to track texture binding when rendering
		boundTextures = new Vector(maxTextures);

		// preallocate blocks of memory for vertex buffers of different sizes
		// smallest one can render just one quad, biggest one can render maximum amount
		vertexBufferDatas = [];
		var i = 1, l = nextPow2(maxQuads);
		while (i <= l) {
			vertexBufferDatas.push(new Float32Array(i * 4 * MultiTextureShader.floatPerVertex));
			i *= 2;
		}

		// create the vertex buffer for further uploading
		vertexBuffer = gl.createBuffer();

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

		// the quads array is allocated once, grows when we add new quads, but never shrinks, so we store length in a separate var
		renderedQuads = [];
		renderedQuadCount = 0;
	}

	/** schedule quad for rendering **/
	public function render(quad:Quad) {
		if (renderedQuadCount >= maxQuads) {
			flush();
		}
		renderedQuads[renderedQuadCount++] = quad;
	}

	/** render all the quads we collected **/
	public function flush() {
		if (renderedQuadCount == 0) {
			return;
		}

		// use local vars to save some field access
		var gl = this.gl;
		var renderedQuads = this.renderedQuads;
		var boundTextures = this.boundTextures;
		var groups = this.groups;

		// choose vertex buffer based on the amount of quads
		var bufferIndex = log2(nextPow2(renderedQuadCount));
		var vertexBufferData = vertexBufferDatas[bufferIndex];

		var vertexBufferIndex = 0;
		var currentTexture = null;
		var blendMode = renderedQuads[0].blendMode;

		var currentGroup;
		var groupCount = 0;
		var quadIndex = 0;

		inline function startNextGroup() {
			currentGroup = groups[groupCount];
			currentGroup.textureCount = 0;
			currentGroup.start = quadIndex;
			currentGroup.blendMode = blendMode;
			// we always increase the tick when staring a new render group, so all textures become "disabled" and need to be processed
			tick++;
			groupCount++;
		}

		inline function finishCurrentGroup() {
			currentGroup.size = quadIndex - currentGroup.start;
		}

		for (i in 0...maxTextures) {
			boundTextures[i] = null;
		}

		// initialize first group
		startNextGroup();

		// iterate over quads, fill the vertex buffer and create render groups
		while (quadIndex < renderedQuadCount) {
			var quad = renderedQuads[quadIndex];
			renderedQuads[quadIndex] = null;

			var nextTexture = quad.texture.data;

			if (blendMode != quad.blendMode) {
				blendMode = quad.blendMode;
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
						if (nextTexture.textureUnitId == -1)
							throw "WAT";
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
			var colorTransform = quad.colorTransform;

			// trace('Group $groupCount uses texture $textureUnitId');

			inline function setVertex(i) {
				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 0] = vertexData[i * 2 + 0];
				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 1] = vertexData[i * 2 + 1];

				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 2] = uvs[i * 2 + 0];
				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 3] = uvs[i * 2 + 1];

				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 4] = textureUnitId;

				vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 5] = alpha;

				if (colorTransform != null) {
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 6] = colorTransform.redOffset / 255;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 7] = colorTransform.greenOffset / 255;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 8] = colorTransform.blueOffset / 255;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 9] = colorTransform.alphaOffset / 255;

					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 10] = colorTransform.redMultiplier;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 11] = colorTransform.greenMultiplier;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 12] = colorTransform.blueMultiplier;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 13] = colorTransform.alphaMultiplier;
				} else {
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 6] = 0;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 7] = 0;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 8] = 0;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 9] = 0;

					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 10] = 1;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 11] = 1;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 12] = 1;
					vertexBufferData[vertexBufferIndex + i * MultiTextureShader.floatPerVertex + 13] = 1;
				}
			}

			setVertex(0);
			setVertex(1);
			setVertex(2);
			setVertex(3);

			vertexBufferIndex += MultiTextureShader.floatPerVertex * 4;
			quadIndex++;
		}

		// finish the current group
		finishCurrentGroup();

		// disable the current OpenFL shader so it'll be re-enabled properly on next non-batched openfl render
		// this is needed because we don't use ShaderManager to set our shader. Ideally we should do that, but
		// this will requires some rework for the whole OpenFL shader system, which we'll do when we'll fork away for good 
		shaderManager.setShader(null);
		
		shader.enable(projectionMatrix);

		// bind the index buffer
		gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);

		// upload vertex data and setup attribute pointers
		gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
		gl.bufferData(gl.ARRAY_BUFFER, vertexBufferData.byteLength, vertexBufferData, gl.STREAM_DRAW);

		var stride = MultiTextureShader.floatPerVertex * Float32Array.BYTES_PER_ELEMENT;
		gl.vertexAttribPointer(shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
		gl.vertexAttribPointer(shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aTextureId, 1, gl.FLOAT, false, stride, 4 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aAlpha, 1, gl.FLOAT, false, stride, 5 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorOffset, 4, gl.FLOAT, false, stride, 6 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer(shader.aColorMultiplier, 4, gl.FLOAT, false, stride, 10 * Float32Array.BYTES_PER_ELEMENT);

		// iterate over groups and render them
		for (i in 0...groupCount) {
			var group = groups[i];
			// trace('Rendering group ${i + 1} (${group.size})');

			// bind this group's textures
			for (i in 0...group.textureCount) {
				currentTexture = group.textures[i];
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

				currentTexture.textureUnitId = -1; // clear the binding for subsequent flush calls
			}

			blendModeManager.setBlendMode(group.blendMode);

			// draw this group's slice of vertices
			gl.drawElements(gl.TRIANGLES, group.size * 6, gl.UNSIGNED_SHORT, group.start * 6 * UInt16Array.BYTES_PER_ELEMENT);

			#if gl_stats
				GLStats.incrementDrawCall (DrawCallContext.STAGE);
			#end
		}

		// we've rendered everything \o/ reset the quad count
		renderedQuadCount = 0;
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
