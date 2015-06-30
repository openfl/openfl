package openfl._internal.macros;



#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Field;
import haxe.macro.Expr.FunctionArg;
import haxe.macro.Format;
import haxe.macro.MacroStringTools;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Expr.Function;
import haxe.macro.Expr.Binop;
import haxe.macro.Expr.TypePath;
import haxe.macro.Expr.Error;
import haxe.macro.Expr.ComplexType;

using haxe.macro.ExprTools;
using haxe.macro.ComplexTypeTools;
using haxe.macro.MacroStringTools;

class MacroShader
{

	static var uniformRegex = ~/^\s*uniform\s+(?:(?:high|medium|low)p\s+)?(sampler(?:2D|Cube)|[bi]?vec[234]|float|int|bool|mat[234])\s+(\w+)\s*(?:\[(\d+)\])?\s*;.*$/gmi;
	
	static var currentPos;
	
	static var addToData:Array<String>;
	static var vertexCode:Array<String>;
	static var fragmentCode:Array<String>;
	
	macro public static function buildUniforms():Array<Field> {
		var fields = Context.getBuildFields();
		
		addToData = [];
		vertexCode = [];
		fragmentCode = [];
		
		var isVertex = false;
		
		for (field in fields) {
			if (field.meta == null || Lambda.find(field.meta, function(m) return (m.name == "fragment" || m.name == "vertex")) == null) continue;
			
			isVertex = Lambda.find(field.meta, function(m) return m.name == "fragment") == null;
			
			currentPos = field.pos;
			switch(field.kind) {
			case FVar(_, expr):
				switch(expr.expr) {
					
				case EConst(CString(value)):
					parseString(fields, value, isVertex ? vertexCode : fragmentCode);
				case EArrayDecl(values):
					for (v in values) {
						switch(v.expr) {
						case EConst(CString(value)):
							parseString(fields, value, isVertex ? vertexCode : fragmentCode);
						default:
						}
					}
				default:
					
				}
			default:
				
			}
		}
		
		var n = Lambda.find(fields, function(f) return f.name == "new");
		if (n == null) throw new Error("There is no constructor!", currentPos);
		
		var block = switch(n.kind) {
			case FFun(f):
				if (f.expr == null) return null;
				switch(f.expr.expr) {
					case EBlock(exprs): exprs;
					default: null;
				}
			default:
				null;
		}
		if (block == null) throw new Error("I can't find the body of the constructor!", n.pos);
		
		var expr;
		for (add in addToData) {
			expr = {
				pos: currentPos,
				expr: ECall(macro $p { ['data', 'set'] }, [macro $v{add}, macro $i{'__$add'}]),
			}
			
			block.push(expr);
		}
		
		if (vertexCode.length > 0) {
			expr = {
				pos: currentPos,
				expr: ECall(macro $i {'__buildVertexCode'}, [vertexCode.join("\n").formatString(currentPos)]),
			}
			block.push(expr);
		}
		
		if (fragmentCode.length > 0) {
			expr = {
				pos: currentPos,
				expr: ECall(macro $i {'__buildFragmentCode'}, [fragmentCode.join("\n").formatString(currentPos)]),
			}
			block.push(expr);
		} else {
			throw new Error("No fragment code found!", currentPos);
		}
		
		return fields;
	}

	static private function parseString(fields, string:String, code:Array<String>) {
		
		code.push(string);
		
		var strings:Array<String> = string.split("\n");
		var name:String;
		var type:String;
		var array:Null<Int>;
		var extType;
		
		for (str in strings) {
			if (!uniformRegex.match(str)) continue;
			name = uniformRegex.matched(2);
			type = uniformRegex.matched(1);
			array = Std.parseInt(uniformRegex.matched(3));
			
			switch(type) {
				case "bool": 
					extType = macro:Bool;
				case "int": 
					extType = macro:Int;
				case "float":
					extType = macro:Float;
				case v if (v.indexOf("vec") > -1):
					extType = macro:Array<Float>;
				case m if (m.indexOf("mat") > -1):
					extType = macro:Array<Float>;
				case "sampler2D" | "samplerCube":
					extType = macro:openfl.display.BitmapData;
				case _: 
					//throw new Error('Invalid type found ($type): $str', currentPos);
					continue;
					
			}
			
			var intType = macro:openfl.display.Shader.GLShaderParameter;
			var tpath = switch(intType) {
				case TPath(p): p;
				case _: throw new Error('How is this even possible???', currentPos);
			}
			var priv:Field = {
				name: '__$name',
				access: [Access.APrivate],
				kind: FieldType.FVar(intType, {
					pos: currentPos,
					expr: ENew(tpath, [macro $v{type}, macro $v{0}])
					}),
				pos: currentPos,
			};
			
			var prop:Field = {
				name: name,
				doc: 'Auto-generated uniform property. The GLSL type is $type.',
				access: [Access.APublic],
				kind: FieldType.FProp('get_$name', 'set_$name', extType),
				pos: currentPos,
			};
			
			fields.push(priv);
			fields.push(prop);
			fields.push(createGetter(name, extType));
			fields.push(createSetter(name, extType));
			
			addToData.push(name);
		}
	}
	
	static private function createGetter(name:String, type:ComplexType):Field {
		var ret = switch(type) {
			case TPath(p):
				switch(p.name) {
				/**
				 * return o.value[0] == 1 ? true : false;
				 */
				case "Bool":
					{
						expr: ETernary( {
							pos: currentPos,
							expr: EBinop(OpEq, getArrayExpr(name, 0), macro $v { 1 } ),
						}, macro $v { true }, macro $v { false }),
						pos: currentPos,
					};
				/**
				 * return Std.int(o.value[0]);
				 */
				case "Int":
					{
						expr: ECall(macro $p { ['Std', 'int'] }, [getArrayExpr(name, 0)]),
						pos: currentPos 
					};
				/**
				 * return o.value[0];
				 */
				case "Float":
					getArrayExpr(name, 0);
				/**
				 * return o.value;
				 */
				case "Array":
					macro $p { ['__$name', 'value'] };
				/**
				 * return o.bitmap;
				 */
				case "BitmapData":
					macro $p { ['__$name', 'bitmap'] };
				case _:
					null;
				}
			case _:
				null;
		};
		
		
		var f = {
			args: [],
			ret: type,
			expr: {
				pos: currentPos,
				expr: EBlock([{ 
						pos: currentPos, 
						expr: EReturn(ret),
					}]),
			},
		};
		
		var fget = {
			name: 'get_$name',
			access: [Access.APrivate, Access.AInline],
			pos: currentPos,
			kind: FieldType.FFun(cast f),
			#if (haxe_ver >= 3.2) 
			meta: [ { name: "noCompletion", pos: currentPos } ], 
			#end
		};
		
		return fget;
	}
	
	static private function createSetter(name:String, type:ComplexType):Field {
		var ret = switch(type) {
			case TPath(p):
				switch(p.name) {
				/**
				 * return { o.value[0] = v ? 1 : 0; v; };
				 */
				case "Bool":
					macro $b { [ {
							pos: currentPos,
							expr: EBinop(OpAssign, getArrayExpr(name, 0), {
								pos: currentPos,
								expr: ETernary( macro $i { 'v' }, macro $v { 1 }, macro $v { 0 } ),
							}),
						}, 
						macro $i { 'v' }
					] };
				/**
				 * return Std.int(o.value[0] = v);
				 */
				case "Int":
					{
						pos: currentPos,
						expr: ECall(macro $p { ['Std', 'int'] }, [ {
							pos: currentPos,
							expr: EBinop(Binop.OpAssign, getArrayExpr(name, 0), macro $i { 'v' }),
						} ]),
					}
				/**
				 * return o.value[0] = v;
				 */				
				case "Float":
					{
						pos: currentPos,
						expr: EBinop(Binop.OpAssign, getArrayExpr(name, 0), macro $i{'v'})
					}
				/**
				 * return o.value = v;
				 */
				case "Array":
					{
						pos: currentPos,
						expr: EBinop(Binop.OpAssign, macro $p { ['__$name', 'value'] }, macro $i{'v'})
					}
				/**
				 * return o.bitmap = v;
				 */
				case "BitmapData":
					{
						pos: currentPos,
						expr: EBinop(Binop.OpAssign, macro $p { ['__$name', 'bitmap'] }, macro $i{'v'})
					}
				case _:
					null;
			}
			case _:
				null;
		};
		
		var f = {
			args: [{name: "v", type:type}],
			ret: type,
			expr: {
				pos: currentPos,
				expr: EBlock([{ 
						pos: currentPos, 
						expr: EReturn(ret),
					}]),
			},
		};
		var fset = {
			name: 'set_$name',
			access: [Access.APrivate, Access.AInline],
			pos: currentPos,
			kind: FieldType.FFun(cast f),
			#if (haxe_ver >= 3.2) 
			meta: [ { name: "noCompletion", pos: currentPos } ], 
			#end
		};
		
		return fset;
	}
	
	static private inline function getArrayExpr(name, index) {
		return {
			pos: currentPos,
			expr: EArray(macro $p{['__$name','value']}, macro $v{index}),
		};
	}
	
}	

#end
	