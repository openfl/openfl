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
@:access(openfl.geom.ColorTransform)


class GLShaderManager extends AbstractShaderManager {
	
	
	private static var emptyAlpha = [ 1. ];
	private static var colorMultipliers = [ 0, 0, 0, 0. ];
	private static var colorOffsets = [ 0, 0, 0, 0. ];
	private static var emptyColor = [ 0, 0, 0, 0. ];
	private static var useColorTransform = [ 0 ];
	
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
		
		if (currentGraphicsShader != null) {
			
			if (currentGraphicsShader.data.alpha.value == null) currentGraphicsShader.data.alpha.value = [];
			currentGraphicsShader.data.alpha.value[0] = alpha;
			
		} else {
			
			if (currentDisplayShader.data.alpha.value == null) currentDisplayShader.data.alpha.value = [];
			currentDisplayShader.data.alpha.value[0] = alpha;
			
		}
		
	}
	
	
	public inline function applyBitmap (bitmapData:BitmapData, smoothing:Bool, matrix:Array<Float>, alpha:Float, colorTransform:ColorTransform):Void {
		
		applyBitmapData (bitmapData, smoothing);
		applyMatrix (matrix);
		applyAlpha (alpha);
		applyColorTransform (colorTransform);
		
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
	
	
	public inline function applyColor (alpha:Float, colorTransform:ColorTransform):Void {
		
		applyAlpha (alpha);
		applyColorTransform (colorTransform);
		
	}
	
	
	public function applyColorTransform (colorTransform:ColorTransform):Void {
		
		var useColorTransform = (colorTransform != null && !colorTransform.__isDefault ());
		
		if (currentGraphicsShader != null) {
			
			var shaderData = currentGraphicsShader.data;
			
			if (shaderData.openfl_HasColorTransform.value == null) shaderData.openfl_HasColorTransform.value = [];
			shaderData.openfl_HasColorTransform.value[0] = useColorTransform;
			
			if (useColorTransform) {
				
				colorTransform.__setArrays (colorMultipliers, colorOffsets);
				shaderData.colorMultipliers.value = colorMultipliers;
				shaderData.colorOffsets.value = colorOffsets;
				
			} else {
				
				shaderData.colorMultipliers.value = emptyColor;
				shaderData.colorOffsets.value = emptyColor;
				
			}
			
		} else {
			
			var shaderData = currentDisplayShader.data;
			
			if (shaderData.openfl_HasColorTransform.value == null) shaderData.openfl_HasColorTransform.value = [];
			shaderData.openfl_HasColorTransform.value[0] = useColorTransform;
			
			if (useColorTransform) {
				
				colorTransform.__setArrays (colorMultipliers, colorOffsets);
				shaderData.colorMultipliers.value = colorMultipliers;
				shaderData.colorOffsets.value = colorOffsets;
				
			} else {
				
				shaderData.colorMultipliers.value = emptyColor;
				shaderData.colorOffsets.value = emptyColor;
				
			}
			
		}
		
	}
	
	
	public function applyDefaultColor ():Void {
		
		if (currentShaderBuffer != null) {
			
			var hasAlpha = false;
			var hasMultipliers = false;
			var floatIndex = 0;
			
			for (i in 0...currentShaderBuffer.paramCount) {
				
				if (currentShaderBuffer.paramTypes[i] == 1) {
					
					if (currentShaderBuffer.paramRefs_Float[floatIndex].name == "openfl_HasColorMultipliers") {
						
						hasMultipliers = (currentShaderBuffer.paramLengths[i] > 0);
						
					} else if (currentShaderBuffer.paramRefs_Float[floatIndex].name == "alpha") {
						
						hasAlpha = (currentShaderBuffer.paramLengths[i] > 0);
						
					}
					
					floatIndex++;
					
				}
				
			}
			
			useColorTransform[0] = hasMultipliers ? 1 : 0;
			currentShaderBuffer.addOverride ("openfl_HasColorTransform", useColorTransform);
			
			if (!hasAlpha) {
				
				currentShaderBuffer.addOverride ("alpha", emptyAlpha);
				
			}
			
		} else if (currentGraphicsShader != null) {
			
			var useColorTransform = (currentGraphicsShader.data.colorMultipliers.value != null);
			if (currentGraphicsShader.data.openfl_HasColorTransform.value == null) currentGraphicsShader.data.openfl_HasColorTransform.value = [];
			currentGraphicsShader.data.openfl_HasColorTransform.value[0] = useColorTransform;
			
		} else if (currentDisplayShader != null) {
			
			var useColorTransform = (currentDisplayShader.data.colorMultipliers.value != null);
			if (currentDisplayShader.data.openfl_HasColorTransform.value == null) currentDisplayShader.data.openfl_HasColorTransform.value = [];
			currentDisplayShader.data.openfl_HasColorTransform.value[0] = useColorTransform;
			
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
	
	
}