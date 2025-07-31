package openfl.utils._internal;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.ExprTools;
using haxe.macro.Tools;
using haxe.macro.TypeTools;

@SuppressWarnings("checkstyle:FieldDocComment")
class ShaderMacro
{
	#if 0
	private static var __suppressWarning:Array<Class<Dynamic>> = [Expr];
	#end

	public static function build():Array<Field>
	{
		var fields = Context.getBuildFields();

		var constructor = null;
		var shouldProcess = false;
		var version = null;

		// Determine if we need to process this class
		for (field in fields)
		{
			for (meta in field.meta)
			{
				if (!shouldProcess && (StringTools.startsWith(meta.name, ":gl") || StringTools.startsWith(meta.name, "gl")))
				{
					shouldProcess = true;
				}

				if (meta.name == ":glVersion" || meta.name == "glVersion")
				{
					version = meta.params[0].getValue();
				}
			}

			if (field.name == "new")
			{
				constructor = field;
			}
		}

		// Parse meta values into a private GLSLSourceAssembler instance to
		// compile header, body and sources into combined sources
		if (shouldProcess)
		{
			var pos = Context.currentPos();
			var code = [];
			var sources = "";

			code.push(Context.parse("__isGenerated = true", pos));
			code.push(Context.parse("var __assembler = new openfl.utils.GLSLSourceAssembler()", pos));

			var value, require;

			for (field in fields)
			{
				for (meta in field.meta)
				{
					value = null;

					switch (meta.name)
					{
						case ":glVertexHeader", "glVertexHeader":
							value = __processValue(meta, version, true);
							code.push(macro __assembler.addVertexHeader($v{value}));

						case ":glVertexBody", "glVertexBody":
							value = __processValue(meta, version, true);
							code.push(macro __assembler.addVertexBody($v{value}));

						case ":glVertexSource", "glVertexSource":
							value = __processValue(meta, version, true);
							code.push(macro __assembler.vertexSource = $v{value});

						case ":glFragmentHeader", "glFragmentHeader":
							value = __processValue(meta, version, false);
							code.push(macro __assembler.addFragmentHeader($v{value}));

						case ":glFragmentBody", "glFragmentBody":
							value = __processValue(meta, version, false);
							code.push(macro __assembler.addFragmentBody($v{value}));

						case ":glFragmentSource", "glFragmentSource":
							value = __processValue(meta, version, false);
							code.push(macro __assembler.fragmentSource = $v{value});

						case ":glExtension", "glExtension":
							value = meta.params[0].getValue();
							require = __getBool(meta, 1, true);
							code.push(macro __assembler.addExtension($v{value}, $v{require}));

						case ":glVertexExtension", "glVertexExtension":
							value = meta.params[0].getValue();
							require = __getBool(meta, 1, true);
							code.push(macro __assembler.addVertexExtension($v{value}, $v{require}));

						case ":glFragmentExtension", "glFragmentExtension":
							value = meta.params[0].getValue();
							require = __getBool(meta, 1, true);
							code.push(macro __assembler.addFragmentExtension($v{value}, $v{require}));

						default:
					}

					if (value != null)
					{
						sources += value + "\n";
					}
				}
			}

			// Inheritance is working in reverse -- sub-class assembler is defined *after* the parent class
			code.push(macro
				{
					if (__glSourceAssembler != null)
					{
						__assembler.concat(__glSourceAssembler);
					}
					__glSourceAssembler = __assembler;
					__glVertexSource = __glSourceAssembler.assembleVertexSource();
					__glFragmentSource = __glSourceAssembler.assembleFragmentSource();
				});

			var block = switch (constructor.kind)
			{
				case FFun(f):
					if (f.expr == null) null;
					switch (f.expr.expr)
					{
						case EBlock(e): e;
						default: null;
					}
				default: null;
			}

			// Concat code to beginning of new() block, before super()
			for (i in 0...code.length)
			{
				block.unshift(code[code.length - i - 1]);
			}

			block.push(Context.parse("__initGL ()", pos));

			// Add new fields for properties found within sources
			var shaderDataFields:Array<Field> = [];
			var uniqueFields:Array<Field> = [];

			__processFields(sources, "attribute", shaderDataFields, pos);
			__processFields(sources, "in", shaderDataFields, pos); // For higher GLSL versions
			__processFields(sources, "uniform", shaderDataFields, pos);

			if (shaderDataFields.length > 0)
			{
				var fieldNames = new Map<String, Bool>();
				var localClass = Context.getLocalClass().get();
				var superClass = localClass.superClass != null ? localClass.superClass.t.get() : null;
				var parent;

				for (field in shaderDataFields)
				{
					parent = superClass;
					while (parent != null)
					{
						for (parentField in parent.fields.get())
						{
							if (parentField.name == field.name)
							{
								fieldNames.set(field.name, true);
							}
						}
						parent = parent.superClass != null ? parent.superClass.t.get() : null;
					}
					if (!fieldNames.exists(field.name))
					{
						uniqueFields.push(field);
					}
					fieldNames[field.name] = true;
				}
			}

			fields = fields.concat(uniqueFields);
		}

		return fields;
	}

	private static function __getBool(meta:MetadataEntry, argIndex:Int = 1, defaultValue:Bool = true):Bool
	{
		if (meta.params.length > argIndex)
		{
			return cast(meta.params[argIndex].getValue(), Bool);
		}

		return defaultValue;
	}

	private static function __processFields(source:String, storageType:String, fields:Array<Field>, pos:Position):Void
	{
		if (source == null) return;

		var lastMatch = 0, position, regex, field:Field, name, type;

		if (storageType == "uniform")
		{
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
		}
		else if (storageType == "in")
		{
			regex = ~/in ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
		}
		else
		{
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
		}

		var fieldAccess:Access;

		while (regex.matchSub(source, lastMatch))
		{
			type = regex.matched(1);
			name = regex.matched(2);

			if (StringTools.startsWith(name, "gl_"))
			{
				continue;
			}

			if (StringTools.startsWith(name, "openfl_"))
			{
				fieldAccess = APrivate;
			}
			else
			{
				fieldAccess = APublic;
			}

			if (StringTools.startsWith(type, "sampler"))
			{
				field = {
					name: name,
					meta: [],
					access: [fieldAccess],
					kind: FVar(macro :openfl.display.ShaderInput<openfl.display.BitmapData>),
					pos: pos
				};
			}
			else
			{
				var parameterType:openfl.display.ShaderParameterType = switch (type)
				{
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

				switch (parameterType)
				{
					case BOOL, BOOL2, BOOL3, BOOL4:
						field = {
							name: name,
							meta: [{name: ":keep", pos: pos}],
							access: [fieldAccess],
							kind: FVar(macro :openfl.display.ShaderParameter<Bool>),
							pos: pos
						};

					case INT, INT2, INT3, INT4:
						field = {
							name: name,
							meta: [{name: ":keep", pos: pos}],
							access: [fieldAccess],
							kind: FVar(macro :openfl.display.ShaderParameter<Int>),
							pos: pos
						};

					default:
						field = {
							name: name,
							meta: [{name: ":keep", pos: pos}],
							access: [fieldAccess],
							kind: FVar(macro :openfl.display.ShaderParameter<Float>),
							pos: pos
						};
				}
			}

			if (StringTools.startsWith(name, "openfl_"))
			{
				field.meta = [
					{name: ":keep", pos: pos},
					{name: ":dox", params: [macro hide], pos: pos},
					{name: ":noCompletion", pos: pos},
					{name: ":allow", params: [macro openfl.display._internal], pos: pos}
				];
			}
			else
			{
				field.meta = [{name: ":keep", pos: pos}];
			}

			fields.push(field);

			position = regex.matchedPos();
			lastMatch = position.pos + position.len;
		}
	}

	private static function __processValue(meta:MetadataEntry, glVersion:String, isVertex:Bool):String
	{
		var source = meta.params[0].getValue();
		var compatibility = __getBool(meta, 1, false);

		if (compatibility)
		{
			return GLSLSourceAssembler.applyCompatibility(source, glVersion, false);
		}
		else
		{
			return source;
		}
	}
}
#end
