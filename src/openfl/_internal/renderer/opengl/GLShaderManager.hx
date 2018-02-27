package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractShaderManager;
import openfl._internal.renderer.ShaderBuffer;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.ColorTransform;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Shader)
@:access(openfl.geom.ColorTransform)


class GLShaderManager extends AbstractShaderManager {
	
	
	private static var emptyAlpha = [ 1. ];
	private static var colorMultipliers = [ 0, 0, 0, 0. ];
	private static var colorOffsets = [ 0, 0, 0, 0. ];
	private static var emptyColor = [ 0, 0, 0, 0. ];
	private static var useColorTransform = [ 0 ];
	
	private var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		super ();
		
		this.gl = gl;
		
		defaultShader = new Shader ();
		initShader (defaultShader);
		
	}
	
	
	public inline function applyAlpha (alpha:Float):Void {
		
		if (currentShader.data.aAlpha.value == null) currentShader.data.aAlpha.value = [];
		currentShader.data.aAlpha.value[0] = alpha;
		
	}
	
	
	public inline function applyBitmap (bitmapData:BitmapData, smoothing:Bool, matrix:Array<Float>, alpha:Float, colorTransform:ColorTransform):Void {
		
		applyBitmapData (bitmapData, smoothing);
		applyMatrix (matrix);
		applyAlpha (alpha);
		applyColorTransform (colorTransform);
		
	}
	
	
	public inline function applyBitmapData (bitmapData:BitmapData, smoothing:Bool):Void {
		
		currentShader.data.uImage0.input = bitmapData;
		currentShader.data.uImage0.smoothing = smoothing;
		
	}
	
	
	public inline function applyColor (alpha:Float, colorTransform:ColorTransform):Void {
		
		applyAlpha (alpha);
		applyColorTransform (colorTransform);
		
	}
	
	
	public function applyColorTransform (colorTransform:ColorTransform):Void {
		
		var useColorTransform = (colorTransform != null && !colorTransform.__isDefault ());
		var shaderData = currentShader.data;
		
		if (shaderData.uUseColorTransform.value == null) shaderData.uUseColorTransform.value = [];
		shaderData.uUseColorTransform.value[0] = useColorTransform;
		
		if (useColorTransform) {
			
			colorTransform.__setArrays (colorMultipliers, colorOffsets);
			shaderData.aColorMultipliers = colorMultipliers;
			shaderData.aColorOffsets = colorOffsets;
			
		} else {
			
			shaderData.aColorMultipliers.value = emptyColor;
			shaderData.aColorOffsets.value = emptyColor;
			
		}
		
	}
	
	
	public function applyDefaultColor ():Void {
		
		if (currentShaderBuffer != null) {
			
			var hasAlpha = false;
			var hasMultipliers = false;
			var floatIndex = 0;
			
			for (i in 0...currentShaderBuffer.paramCount) {
				
				if (currentShaderBuffer.paramTypes[i] == 1) {
					
					if (currentShaderBuffer.paramRefs_Float[floatIndex].name == "aUseColorMultipliers") {
						
						hasMultipliers = (currentShaderBuffer.paramLengths[i] > 0);
						
					} else if (currentShaderBuffer.paramRefs_Float[floatIndex].name == "aAlpha") {
						
						hasAlpha = (currentShaderBuffer.paramLengths[i] > 0);
						
					}
					
					floatIndex++;
					
				}
				
			}
			
			useColorTransform[0] = hasMultipliers ? 1 : 0;
			currentShaderBuffer.addOverride ("uUseColorTransform", useColorTransform);
			
			if (!hasAlpha) {
				
				currentShaderBuffer.addOverride ("aAlpha", emptyAlpha);
				
			}
			
		} else if (currentShader != null) {
			
			var useColorTransform = (currentShader.data.aColorMultipliers.value != null);
			if (currentShader.data.uUseColorTransform.value == null) currentShader.data.uUseColorTransform.value = [];
			currentShader.data.uUseColorTransform.value[0] = useColorTransform;
			
		}
		
	}
	
	
	public function applyMatrix (matrix:Array<Float>):Void {
		
		if (currentShaderBuffer != null) {
			
			currentShaderBuffer.addOverride ("uMatrix", matrix);
			
		} else if (currentShader != null) {
			
			currentShader.data.uMatrix.value = matrix;
			
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
	
	
	public override function initShaderBuffer (shaderBuffer:ShaderBuffer):Shader {
		
		if (shaderBuffer != null) {
			
			return initShader (shaderBuffer.shader);
			
		}
		
		return defaultShader;
		
	}
	
	
	public override function setShader (shader:Shader):Void {
		
		if (currentShader == shader) return;
		
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
			initShader (shader);
			gl.useProgram (shader.glProgram);
			currentShader.__enable ();
			
		}
		
	}
	
	
	public override function setShaderBuffer (shaderBuffer:ShaderBuffer):Void {
		
		setShader (shaderBuffer.shader);
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
	
	
}