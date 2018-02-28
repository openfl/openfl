package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShaderManager;
import openfl._internal.renderer.ShaderBuffer;
import openfl.display.BitmapData;
import openfl.display.DisplayObjectShader;
import openfl.display.GraphicsShader;
import openfl.display.Shader;
import openfl.geom.ColorTransform;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Shader)
@:access(openfl.display.ShaderParameter)
@:access(openfl.geom.ColorTransform)


class GLShaderManager extends AbstractShaderManager {
	
	
	private static var alphaValue = [ 1. ];
	private static var colorMultipliersValue = [ 0, 0, 0, 0. ];
	private static var colorOffsetsValue = [ 0, 0, 0, 0. ];
	private static var emptyColorValue = [ 0, 0, 0, 0. ];
	private static var emptyAlphaValue = [ 1. ];
	private static var hasColorTransformValue = [ false ];
	
	public var defaultDisplayShader:DisplayObjectShader;
	public var defaultGraphicsShader:GraphicsShader;
	
	private var currentDisplayShader:DisplayObjectShader;
	private var currentGraphicsShader:GraphicsShader;
	private var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		defaultDisplayShader = new DisplayObjectShader ();
		defaultGraphicsShader = new GraphicsShader ();
		defaultShader = defaultDisplayShader;
		
		initShader (defaultShader);
		
	}
	
	
	public inline function applyAlpha (alpha:Float):Void {
		
		alphaValue[0] = alpha;
		
		if (currentShaderBuffer != null) {
			
			var floatRefs = currentShaderBuffer.paramRefs_Float;
			var floatStart = currentShaderBuffer.paramRefs_Bool.length;
			var hasAlpha = false;
			
			for (i in 0...floatRefs.length) {
				
				if (floatRefs[i].name == "alpha") {
					
					hasAlpha = (currentShaderBuffer.paramLengths[floatStart + i] > 0);
					break;
					
				}
				
			}
			
			if (!hasAlpha) {
				
				currentShaderBuffer.addOverride ("alpha", alphaValue);
				
			}
			
		} else if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.alpha.value = alphaValue;
			
		} else {
			
			currentDisplayShader.data.alpha.value = alphaValue;
			
		}
		
	}
	
	
	public inline function applyBitmapData (bitmapData:BitmapData, smoothing:Bool):Void {
		
		if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.texture0.input = bitmapData;
			currentGraphicsShader.data.texture0.smoothing = smoothing;
			
		} else {
			
			currentDisplayShader.data.texture0.input = bitmapData;
			currentDisplayShader.data.texture0.smoothing = smoothing;
			
		}
		
	}
	
	
	public function applyColorTransform (colorTransform:ColorTransform):Void {
		
		if (currentShaderBuffer != null) {
			
			var floatRefs = currentShaderBuffer.paramRefs_Float;
			var floatStart = currentShaderBuffer.paramRefs_Bool.length;
			
			for (i in 0...floatRefs.length) {
				
				if (floatRefs[i].name == "openfl_HasColorMultipliers") {
					
					applyHasColorTransform (currentShaderBuffer.paramLengths[floatStart + i] > 0);
					break;
					
				}
				
			}
			
		} else {
			
			var enabled = (colorTransform != null && !colorTransform.__isDefault ());
			applyHasColorTransform (enabled);
			
			if (currentGraphicsShader != null) {
				
				var shaderData = currentGraphicsShader.data;
				
				if (enabled) {
					
					colorTransform.__setArrays (colorMultipliersValue, colorOffsetsValue);
					shaderData.colorMultipliers.value = colorMultipliersValue;
					shaderData.colorOffsets.value = colorOffsetsValue;
					
				} else {
					
					shaderData.colorMultipliers.value = emptyColorValue;
					shaderData.colorOffsets.value = emptyColorValue;
					
				}
				
			} else {
				
				var shaderData = currentDisplayShader.data;
				
				if (enabled) {
					
					colorTransform.__setArrays (colorMultipliersValue, colorOffsetsValue);
					shaderData.colorMultipliers.value = colorMultipliersValue;
					shaderData.colorOffsets.value = colorOffsetsValue;
					
				} else {
					
					shaderData.colorMultipliers.value = emptyColorValue;
					shaderData.colorOffsets.value = emptyColorValue;
					
				}
				
			}
			
		}
		
	}
	
	
	public function applyHasColorTransform (enabled:Bool):Void {
		
		hasColorTransformValue[0] = enabled;
		
		if (currentShaderBuffer != null) {
			
			currentShaderBuffer.addOverride ("openfl_HasColorTransform", hasColorTransformValue);
			
		} else if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.openfl_HasColorTransform.value = hasColorTransformValue;
			
		} else {
			
			currentDisplayShader.data.openfl_HasColorTransform.value = hasColorTransformValue;
			
		}
		
	}
	
	
	public function applyMatrix (matrix:Array<Float>):Void {
		
		if (currentShaderBuffer != null) {
			
			currentShaderBuffer.addOverride ("openfl_Matrix", matrix);
			
		} else if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.openfl_Matrix.value = matrix;
			
		} else if (currentDisplayShader != null) {
			
			currentDisplayShader.data.openfl_Matrix.value = matrix;
			
		}
		
	}
	
	
	public function clear ():Void {
		
		if (currentGraphicsShader != null) {
			
			if (currentShaderBuffer == null) {
				
				currentGraphicsShader.data.texture0.input = null;
				
			}
			
			currentGraphicsShader.data.openfl_HasColorTransform.value = null;
			currentGraphicsShader.data.openfl_Position.value = null;
			currentGraphicsShader.data.openfl_Matrix.value = null;
			currentGraphicsShader.__clearUseArray ();
			
		} else if (currentDisplayShader != null) {
			
			currentDisplayShader.data.texture0.input = null;
			currentDisplayShader.data.openfl_HasColorTransform.value = null;
			currentDisplayShader.data.openfl_Position.value = null;
			currentDisplayShader.data.openfl_Matrix.value = null;
			currentDisplayShader.__clearUseArray ();
			
		}
		
	}
	
	
	public override function initShader (shader:Shader):Shader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.gl == null) {
				
				shader.gl = gl;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return defaultShader;
		
	}
	
	
	public function initDisplayShader (shader:DisplayObjectShader):DisplayObjectShader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.gl == null) {
				
				shader.gl = gl;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return defaultDisplayShader;
		
	}
	
	
	public function initGraphicsShader (shader:GraphicsShader):GraphicsShader {
		
		if (shader != null) {
			
			// TODO: Change of GL context?
			
			if (shader.gl == null) {
				
				shader.gl = gl;
				shader.__init ();
				
			}
			
			//currentShader = shader;
			return shader;
			
		}
		
		return defaultGraphicsShader;
		
	}
	
	
	public override function initShaderBuffer (shaderBuffer:ShaderBuffer):GraphicsShader {
		
		if (shaderBuffer != null) {
			
			return initGraphicsShader (shaderBuffer.shader);
			
		}
		
		return defaultGraphicsShader;
		
	}
	
	
	public inline function setDisplayShader (shader:DisplayObjectShader):Void {
		
		setShader (shader, false);
		
	}
	
	
	public inline function setGraphicsShader (shader:GraphicsShader):Void {
		
		setShader (shader, true);
		
	}
	
	
	public /*override*/ function setShader (shader:Shader, graphics:Bool):Void {
		
		if (currentShader == shader) return;
		
		currentDisplayShader = null;
		currentGraphicsShader = null;
		
		if (currentShader != null) {
			
			currentShader.__disable ();
			currentShaderBuffer = null;
			
		}
		
		if (shader == null) {
			
			currentShader = null;
			gl.useProgram (null);
			return;
			
		} else {
			
			currentShader = shader;
			
			if (graphics) currentGraphicsShader = cast shader;
			else currentDisplayShader = cast shader;
			
			initShader (shader);
			gl.useProgram (shader.glProgram);
			currentShader.__enable ();
			
		}
		
	}
	
	
	public override function setShaderBuffer (shaderBuffer:ShaderBuffer):Void {
		
		setShader (shaderBuffer.shader, true);
		currentShaderBuffer = shaderBuffer;
		
	}
	
	
	public override function updateShader ():Void {
		
		if (currentShader != null) {
			
			currentShader.__update ();
			
		}
		
	}
	
	
	public override function updateShaderBuffer ():Void {
		
		if (currentShader != null && currentShaderBuffer != null) {
			
			currentShader.__updateFromBuffer (currentShaderBuffer);
			
		}
		
	}
	
	
	public function useAlphaArray ():Void {
		
		if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.alpha.__useArray = true;
			
		} else if (currentDisplayShader != null) {
			
			currentDisplayShader.data.alpha.__useArray = true;
			
		}
		
	}
	
	
	public function useColorTransformArray ():Void {
		
		if (currentGraphicsShader != null) {
			
			currentGraphicsShader.data.colorMultipliers.__useArray = true;
			currentGraphicsShader.data.colorOffsets.__useArray = true;
			
		} else if (currentDisplayShader != null) {
			
			currentDisplayShader.data.colorMultipliers.__useArray = true;
			currentDisplayShader.data.colorOffsets.__useArray = true;
			
		}
		
	}
	
	
}