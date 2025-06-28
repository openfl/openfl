package openfl.utils._internal;

#if macro
import haxe.display.Position;
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

		var glMetas = new GlMetas();

		for (field in fields)
		{
			if (field.name == "new" && field.meta != null)
				glMetas.add(field.meta);
		}

		var pos = Context.currentPos();
		var localClass = Context.getLocalClass().get();
		var superClass = localClass.superClass != null ? localClass.superClass.t.get() : null;
		var parent = superClass;
		var parentFields:Array<ClassField>;

		while (parent != null)
		{
			parentFields = [parent.constructor.get()].concat(parent.fields.get());

			for (field in parentFields)
			{
				if (field.name == "new")
					glMetas.add(field.meta.get());
			}

			parent = parent.superClass != null ? parent.superClass.t.get() : null;
		}

		var glFragmentSource = glMetas.constructFragmentSource();
		var glVertexSource = glMetas.constructVertexSource();
		if (glVertexSource != null || glFragmentSource != null)
		{
			var shaderDataFields:Array<Field> = [];
			var uniqueFields:Array<Field> = [];

			processFields(glVertexSource, "attribute", shaderDataFields, pos);
			processFields(glVertexSource, "uniform", shaderDataFields, pos);
			processFields(glFragmentSource, "uniform", shaderDataFields, pos);

			if (shaderDataFields.length > 0)
			{
				var fieldNames = new Map<String, Bool>();

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

			// #if !display
			for (field in fields)
			{
				switch (field.name)
				{
					case "new":
						var block = switch (field.kind)
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

						if (glVertexSource != null)
						{
							block.unshift(macro if (__glVertexSource == null)
							{
								__glVertexSource = $v{glVertexSource};
							});
						}

						if (glFragmentSource != null)
						{
							block.unshift(macro if (__glFragmentSource == null)
							{
								__glFragmentSource = $v{glFragmentSource};
							});
						}

						block.push(Context.parse("__isGenerated = true", pos));
						block.push(Context.parse("__initGL ()", pos));

					default:
				}
			}
			// #end

			fields = fields.concat(uniqueFields);
		}

		return fields;
	}

	private static function processFields(source:String, storageType:String, fields:Array<Field>, pos:Position):Void
	{
		if (source == null) return;

		var lastMatch = 0, position, regex, field:Field, name, type;

		if (storageType == "uniform")
		{
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
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
}

/**
	Stores metadata and uses them to constructa  glsl shader, with important logging info
 */
abstract GlMetas(Array<Map<String, MetadataEntry>>)
{
	inline static var GL_FRAGMENT_SOURCE = "glFragmentSource";
	inline static var GL_FRAGMENT_HEADER = "glFragmentHeader";
	inline static var GL_FRAGMENT_BODY = "glFragmentBody";
	inline static var GL_VERTEX_SOURCE = "glVertexSource";
	inline static var GL_VERTEX_HEADER = "glVertexHeader";
	inline static var GL_VERTEX_BODY = "glVertexBody";
	
	static var names = [GL_FRAGMENT_SOURCE, GL_FRAGMENT_HEADER, GL_FRAGMENT_BODY, GL_VERTEX_SOURCE, GL_VERTEX_HEADER, GL_VERTEX_BODY];

	inline public function new ()
	{
		this = [];
	}
	
	public function add(metas:Metadata)
	{
		var result = new Map<String, MetadataEntry>();

		for (meta in metas)
		{
			var metaName = meta.name.split(":").join("");
			if (names.contains(metaName))
				result[metaName] = meta;
		}
		
		this.push(result);
	}
	
	public function constructFragmentSource():Null<String>
	{
		return construct(getFirst(GL_FRAGMENT_SOURCE), concatAll(GL_FRAGMENT_HEADER), concatAll(GL_FRAGMENT_BODY));
	}
	
	public function constructVertexSource():Null<String>
	{
		return construct(getFirst(GL_VERTEX_SOURCE), concatAll(GL_VERTEX_HEADER), concatAll(GL_VERTEX_BODY));
	}
	
	function construct(source, header, body):Null<String>
	{
		if (source != null && header != null && body != null)
		{
			source = StringTools.replace(source, "#pragma header", header);
			source = StringTools.replace(source, "#pragma body", body);
		}
		return source;
	}
	
	inline function getFirst(name:String):Null<String>
	{
		var meta = Lambda.find(this, function (item) { return item.exists(name); });
		return meta == null ? null : metaToString(meta[name]);
	}

	inline function concatAll(name:String):Null<String>
	{
		return Lambda.fold(this, function (item, result)
		{
			if (!item.exists(name))
				return result;
			
			return '${metaToString(item[name])}\n$result';
		}, "");
	}
	
	inline function metaToString(meta:MetadataEntry):String
	{
		#if haxe4
		var loc = meta.params[0].pos.toLocation();
		var name = meta.name.split(":").join("");
		return '// { openfl_region       $name - ${loc.file}:${loc.range.start.line}\n'
			+  '${meta.params[0].getValue()}\n'
			+  '// } openfl_endregion    $name - ${loc.file}:${loc.range.end.line}';
		#else
		return meta.params[0].getValue();
		#end
	}
}
#end
