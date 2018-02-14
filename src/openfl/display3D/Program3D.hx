package openfl.display3D;


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.GLRenderContext;
import lime.utils.BytePointer;
import lime.utils.Float32Array;
import openfl._internal.stage3D.opengl.GLProgram3D;
import openfl._internal.stage3D.SamplerState;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:final class Program3D {
	
	
	private var __alphaSamplerEnabled:Array<Uniform>;
	private var __alphaSamplerUniforms:List<Uniform>;
	private var __context:Context3D;
	private var __fragmentShaderID:GLShader;
	private var __fragmentSource:String;
	private var __fragmentUniformMap:UniformMap;
	private var __memUsage:Int;
	private var __positionScale:Uniform;
	private var __programID:GLProgram;
	private var __samplerStates:Vector<SamplerState>;
	private var __samplerUniforms:List<Uniform>;
	private var __samplerUsageMask:Int;
	private var __uniforms:List<Uniform>;
	private var __vertexShaderID:GLShader;
	private var __vertexSource:String;
	private var __vertexUniformMap:UniformMap;
	
	
	private function new (context3D:Context3D) {
		
		__context = context3D;
		
		__memUsage = 0;
		__samplerUsageMask = 0;
		
		__uniforms = new List<Uniform> ();
		__samplerUniforms = new List<Uniform> ();
		__alphaSamplerUniforms = new List<Uniform> ();
		__alphaSamplerEnabled = new Array<Uniform> ();
		
		__samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		
	}
	
	
	public function dispose ():Void {
		
		GLProgram3D.dispose (this, __context.__renderSession);
		
	}
	
	
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void {
		
		GLProgram3D.upload (this, __context.__renderSession, vertexProgram, fragmentProgram);
		
	}
	
	
	private function __flush ():Void {
		
		__vertexUniformMap.flush ();
		__fragmentUniformMap.flush ();
		
	}
	
	
	private function __getSamplerState (sampler:Int):SamplerState {
		
		return __samplerStates[sampler];
		
	}
	
	
	private function __markDirty (isVertex:Bool, index:Int, count:Int):Void {
		
		if (isVertex) {
			
			__vertexUniformMap.markDirty (index, count);
			
		} else {
			
			__fragmentUniformMap.markDirty (index, count);
			
		}
		
	}
	
	
	private function __setPositionScale (positionScale:Float32Array):Void {
		
		if (__positionScale != null) {
			
			GLProgram3D.setPositionScale (this, __context.__renderSession, positionScale);
			
		}
		
	}
	
	
	public function __setSamplerState (sampler:Int, state:SamplerState):Void {
		
		__samplerStates[sampler] = state;
		
	}
	
	
	private function __use ():Void {
		
		GLProgram3D.use (this, __context.__renderSession);
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) @:noCompletion class Uniform {
	
	
	public var name:String;
	public var location:GLUniformLocation;
	public var type:Int;
	public var size:Int;
	public var regData:Float32Array;
	public var regIndex:Int;
	public var regCount:Int;
	public var isDirty:Bool;
	
	public var gl:GLRenderContext;
	public var regDataPointer:BytePointer;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		
		isDirty = true;
		regDataPointer = new BytePointer ();
		
	}
	
	
	public function flush ():Void {
		
		GLProgram3D.flushUniform (this, gl);
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) @:noCompletion class UniformMap {
	
	
	// TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
	
	private var __allDirty:Bool;
	private var __anyDirty:Bool;
	private var __registerLookup:Vector<Uniform>;
	private var __uniforms:Array<Uniform>;
	
	
	public function new (list:Array<Uniform>) {
		
		__uniforms = list;
		
		__uniforms.sort (function (a, b):Int {
			
			return Reflect.compare (a.regIndex, b.regIndex);
			
		});
		
		var total = 0;
		
		for (uniform in __uniforms) {
			
			if (uniform.regIndex + uniform.regCount > total) {
				
				total = uniform.regIndex + uniform.regCount;
				
			}
			
		}
		
		__registerLookup = new Vector<Uniform> (total);
		
		for (uniform in __uniforms) {
			
			for (i in 0...uniform.regCount) {
				
				__registerLookup[uniform.regIndex + i] = uniform;
				
			}
			
		}
		
		__anyDirty = __allDirty = true;
		
	}
	
	
	public function flush ():Void {
		
		if (__anyDirty) {
			
			for (uniform in __uniforms) {
				
				if (__allDirty || uniform.isDirty) {
					
					uniform.flush ();
					uniform.isDirty = false;
					
				}
				
			}
			
			__anyDirty = __allDirty = false;
			
		}
		
	}
	
	
	public function markAllDirty ():Void {
		
		__allDirty = true;
		__anyDirty = true;
		
	}
	
	
	public function markDirty (start:Int, count:Int):Void {
		
		if (__allDirty) {
			
			return;
			
		}
		
		var end = start + count;
		
		if (end > __registerLookup.length) {
			
			end = __registerLookup.length;
			
		}
		
		var index = start;
		
		while (index < end) {
			
			var uniform = __registerLookup[index];
			
			if (uniform != null) {
				
				uniform.isDirty = true;
				__anyDirty = true;
				
				index = uniform.regIndex + uniform.regCount;
				
			} else {
				
				index ++;
				
			}
			
		}
		
	}
	
	
}