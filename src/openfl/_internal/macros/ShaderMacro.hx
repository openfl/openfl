package openfl._internal.macros; #if macro


import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ExprTools;
using haxe.macro.Tools;


class ShaderMacro {
	
	
	private static var defaultFields = new Map<String, Bool> ();
	
	
	public static function build ():Array<Field> {
		
		var fields = Context.getBuildFields ();
		
		var glFragmentSource = null;
		var glVertexSource = null;
		
		for (field in fields) {
			
			for (meta in field.meta) {
				
				switch (meta.name) {
					
					case "glFragmentSource", ":glFragmentSource":
						
						glFragmentSource = meta.params[0].getValue ();
					
					case "glVertexSource", ":glVertexSource":
						
						glVertexSource = meta.params[0].getValue ();
					
					default:
					
				}
				
			}
			
		}
		
		if (glVertexSource != null || glFragmentSource != null) {
			
			var pos = Context.currentPos ();
			var localClass = Context.getLocalClass ().get ();
			
			var isBaseClass = (localClass.name == "Shader" && localClass.pack.length == 2 && localClass.pack[0] == "openfl" && localClass.pack[1] == "display");
			
			var shaderDataFields = new Array<Field> ();
			var dataClassName;
			
			processFields (glVertexSource, "attribute", shaderDataFields, isBaseClass, pos);
			processFields (glVertexSource, "uniform", shaderDataFields, isBaseClass, pos);
			processFields (glFragmentSource, "uniform", shaderDataFields, isBaseClass, pos);
			
			if (isBaseClass) {
				
				dataClassName = "ShaderData";
				
			} else if (shaderDataFields.length > 0) {
				
				dataClassName = "_" + localClass.name + "_ShaderData";
				
				Context.defineType ({
					
					pos: pos,
					pack: localClass.pack,
					name: dataClassName,
					kind: TDClass ({ pack: [ "openfl", "display" ], name: "ShaderData", params: [] }, null, false),
					fields: shaderDataFields,
					params: [],
					meta: [ { name: ":dox", params: [ macro hide ], pos: pos }, { name: ":noCompletion", pos: pos }, { name: ":hack", pos: pos } ]
					
				});
				
			} else {
				
				dataClassName = "_Shader_ShaderData";
				
			}
			
			for (field in fields) {
				
				switch (field.name) {
					
					case "new":
						
						var block = switch (field.kind) {
							
							case FFun (f):
								
								if (f.expr == null) null;
								
								switch (f.expr.expr) {
									
									case EBlock (e): e;
									default: null;
									
								}
							
							default: null;
							
						}
						
						if (glVertexSource != null) block.unshift (macro if (__glVertexSource == null) __glVertexSource = $v{glVertexSource});
						if (glFragmentSource != null) block.unshift (macro if (__glFragmentSource == null) __glFragmentSource = $v{glFragmentSource});
					
					case "__data":
						
						field.kind = FVar (TPath ({ name: dataClassName, pack: localClass.pack, params: [] }), Context.parse ("new " + dataClassName + " (null)", pos));
					
					case "get_data":
						
						switch (field.kind) {
							
							case FFun (f):
								
								f.ret = TPath ({ name: dataClassName, pack: localClass.pack, params: [] });
							
							default:
							
						}
					
					default:
					
				}
				
			}
			
		}
		
		return fields;
		
	}
	
	
	private static function processFields (source:String, storageType:String, fields:Array<Field>, isBaseClass:Bool, pos:Position):Void {
		
		if (source == null) return;
		
		var lastMatch = 0, position, regex, name, type;
		
		if (storageType == "uniform") {
			
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		} else {
			
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9]+)/;
			
		}
		
		while (regex.matchSub (source, lastMatch)) {
			
			type = regex.matched (1);
			name = regex.matched (2);
			
			if (isBaseClass) {
				
				defaultFields.set (name, true);
				
			} else if (defaultFields.exists (name)) {
				
				position = regex.matchedPos ();
				lastMatch = position.pos + position.len;
				continue;
				
			}
			
			if (StringTools.startsWith (type, "sampler")) {
				
				fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderInput<openfl.display.BitmapData>), pos: pos } );
				
			} else {
				
				var parameterType:openfl.display.ShaderParameterType = switch (type) {
					
					case "bool": BOOL;
					case "double", "float": FLOAT;
					case "int", "uint": INT;
					case "bvec2": BOOL2;
					case "bvec3": BOOL3;
					case "bvec4": BOOL4;
					case "ivec2", "uvec2": INT2;
					case "ivec3", "uvec3": INT3;
					case "ivec4", "uvec4": INT4;
					case "vec2", "dvec2": FLOAT2;
					case "vec3", "dvec3": FLOAT3;
					case "vec4", "dvec4": FLOAT4;
					case "mat2", "mat2x2": MATRIX2X2;
					case "mat2x3": MATRIX2X3;
					case "mat2x4": MATRIX2X4;
					case "mat3x2": MATRIX3X2;
					case "mat3", "mat3x3": MATRIX3X3;
					case "mat3x4": MATRIX3X4;
					case "mat4x2": MATRIX4X2;
					case "mat4x3": MATRIX4X3;
					case "mat4", "mat4x4": MATRIX4X4;
					default: null;
					
				}
				
				switch (parameterType) {
					
					case BOOL, BOOL2, BOOL3, BOOL4:
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Bool>), pos: pos } );
					
					case INT, INT2, INT3, INT4:
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Int>), pos: pos } );
					
					default:
						
						fields.push ( { name: name, access: [ APublic ], kind: FVar (macro :openfl.display.ShaderParameter<Float>), pos: pos } );
					
				}
				
			}
			
			position = regex.matchedPos ();
			lastMatch = position.pos + position.len;
			
		}
		
	}
	
	
}


#end