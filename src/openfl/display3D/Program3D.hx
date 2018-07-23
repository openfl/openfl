package openfl.display3D; #if !flash


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.utils.BytePointer;
import lime.utils.Float32Array;
import openfl._internal.stage3D.opengl.GLProgram3D;
import openfl._internal.stage3D.SamplerState;
import openfl.utils.ByteArray;
import openfl.Vector;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
#else
import lime.graphics.GLRenderContext;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.Context3D)


@:final class Program3D {
	
	
	@:noCompletion private var __alphaSamplerEnabled:Array<Uniform>;
	@:noCompletion private var __alphaSamplerUniforms:List<Uniform>;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __fragmentShaderID:GLShader;
	@:noCompletion private var __fragmentSource:String;
	@:noCompletion private var __fragmentUniformMap:UniformMap;
	@:noCompletion private var __memUsage:Int;
	@:noCompletion private var __positionScale:Uniform;
	@:noCompletion private var __programID:GLProgram;
	@:noCompletion private var __samplerStates:Vector<SamplerState>;
	@:noCompletion private var __samplerUniforms:List<Uniform>;
	@:noCompletion private var __samplerUsageMask:Int;
	@:noCompletion private var __uniforms:List<Uniform>;
	@:noCompletion private var __vertexShaderID:GLShader;
	@:noCompletion private var __vertexSource:String;
	@:noCompletion private var __vertexUniformMap:UniformMap;
	
	
	@:noCompletion private function new (context3D:Context3D) {
		
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
		
		GLProgram3D.dispose (this, cast __context.__renderer);
		
	}
	
	
	public function upload (vertexProgram:ByteArray, fragmentProgram:ByteArray):Void {
		
		GLProgram3D.upload (this, cast __context.__renderer, vertexProgram, fragmentProgram);
		
	}
	
	
	@:noCompletion private function __flush ():Void {
		
		__vertexUniformMap.flush ();
		__fragmentUniformMap.flush ();
		
	}
	
	
	@:noCompletion private function __getSamplerState (sampler:Int):SamplerState {
		
		return __samplerStates[sampler];
		
	}
	
	
	@:noCompletion private function __markDirty (isVertex:Bool, index:Int, count:Int):Void {
		
		if (isVertex) {
			
			__vertexUniformMap.markDirty (index, count);
			
		} else {
			
			__fragmentUniformMap.markDirty (index, count);
			
		}
		
	}
	
	
	@:noCompletion private function __setPositionScale (positionScale:Float32Array):Void {
		
		if (__positionScale != null) {
			
			GLProgram3D.setPositionScale (this, cast __context.__renderer, positionScale);
			
		}
		
	}
	
	
	@:noCompletion private function __setSamplerState (sampler:Int, state:SamplerState):Void {
		
		__samplerStates[sampler] = state;
		
	}
	
	
	@:noCompletion private function __use ():Void {
		
		GLProgram3D.use (this, cast __context.__renderer);
		
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
	
	public var context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end;
	public var regDataPointer:BytePointer;
	
	
	public function new (context:#if (lime >= "7.0.0") RenderContext #else GLRenderContext #end) {
		
		this.context = context;
		
		isDirty = true;
		regDataPointer = new BytePointer ();
		
	}
	
	
	public function flush ():Void {
		
		#if (lime >= "7.0.0")
		var gl = context.webgl;
		#else
		var gl = context;
		#end
		
		GLProgram3D.flushUniform (this, context);
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:dox(hide) @:noCompletion class UniformMap {
	
	
	// TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
	
	@:noCompletion private var __allDirty:Bool;
	@:noCompletion private var __anyDirty:Bool;
	@:noCompletion private var __registerLookup:Vector<Uniform>;
	@:noCompletion private var __uniforms:Array<Uniform>;
	
	
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


#else
typedef Program3D = flash.display3D.Program3D;
#end