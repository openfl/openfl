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

		var glFragmentHeader = "";
		var glFragmentBody = "";
		var glVertexHeader = "";
		var glVertexBody = "";

		var glVersion:String = null;

		var glFragmentExtensions = [];
		var glVertexExtensions = [];

		var glFragmentSource = null;
		var glFragmentSourceRaw = "";
		var glVertexSource = null;
		var glVertexSourceRaw = "";

		for (field in fields)
		{
			for (meta in field.meta)
			{
				switch (meta.name)
				{
					case "glVersion", ":glVersion":
						glVersion = meta.params[0].getValue();

					case "glExtensions", ":glExtensions":
						glFragmentExtensions = glFragmentExtensions.concat(meta.params[0].getValue());
						glVertexExtensions = glVertexExtensions.concat(meta.params[0].getValue());

					case "glFragmentExtensions", ":glFragmentExtensions":
						glFragmentExtensions = glFragmentExtensions.concat(meta.params[0].getValue());

					case "glVertexExtensions", ":glVertexExtensions":
						glVertexExtensions = glVertexExtensions.concat(meta.params[0].getValue());

					default:
				}
			}

			for (meta in field.meta)
			{
				/**
					`@:glFragmentSource`, `@:glVertexSource`, `@:glFragmentHeader`, `@:glFragmentBody`, `@:glVertexHeader`, `@:glVertexBody`
					all have a second argument which, if true, will use `processGLSLText` to convert the text to be compatible with the current GLSL version.
					Defaults to false to prevent converting user-defined GLSL.
				**/
				var shouldProcess = meta.params.length > 1 && cast(meta.params[1].getValue(), Bool);

				switch (meta.name)
				{
					case "glFragmentSource", ":glFragmentSource":
						if (shouldProcess)
						{
							glFragmentSource = processGLSLText(meta.params[0].getValue(), glVersion, true);
						}
						else
						{
							glFragmentSource = meta.params[0].getValue();
						}

					case "glVertexSource", ":glVertexSource":
						if (shouldProcess)
						{
							glVertexSource = processGLSLText(meta.params[0].getValue(), glVersion, false);
						}
						else
						{
							glVertexSource = meta.params[0].getValue();
						}

					case "glFragmentHeader", ":glFragmentHeader":
						if (shouldProcess)
						{
							glFragmentHeader += processGLSLText(meta.params[0].getValue(), glVersion, true);
						}
						else
						{
							glFragmentHeader += meta.params[0].getValue();
						}

					case "glFragmentBody", ":glFragmentBody":
						if (shouldProcess)
						{
							glFragmentBody += processGLSLText(meta.params[0].getValue(), glVersion, true);
						}
						else
						{
							glFragmentBody += meta.params[0].getValue();
						}

					case "glVertexHeader", ":glVertexHeader":
						if (shouldProcess)
						{
							glVertexHeader += processGLSLText(meta.params[0].getValue(), glVersion, false);
						}
						else
						{
							glVertexHeader += meta.params[0].getValue();
						}

					case "glVertexBody", ":glVertexBody":
						if (shouldProcess)
						{
							glVertexBody += processGLSLText(meta.params[0].getValue(), glVersion, false);
						}
						else
						{
							glVertexBody += meta.params[0].getValue();
						}

					default:
				}
			}
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
				for (meta in field.meta.get())
				{
					switch (meta.name)
					{
						case "glVersion", ":glVersion":
							if (glVersion == null) glVersion = meta.params[0].getValue();

						case "glExtensions", ":glExtensions":
							glFragmentExtensions = glFragmentExtensions.concat(meta.params[0].getValue());
							glVertexExtensions = glVertexExtensions.concat(meta.params[0].getValue());

						case "glFragmentExtensions", ":glFragmentExtensions":
							glFragmentExtensions = glFragmentExtensions.concat(meta.params[0].getValue());

						case "glVertexExtensions", ":glVertexExtensions":
							glVertexExtensions = glVertexExtensions.concat(meta.params[0].getValue());

						default:
					}
				}

				for (meta in field.meta.get())
				{
					/**
						`@:glFragmentSource`, `@:glVertexSource`, `@:glFragmentHeader`, `@:glFragmentBody`, `@:glVertexHeader`, `@:glVertexBody`
						all have a second argument which, if true, will use `processGLSLText` to convert the text to be compatible with the current GLSL version.
						Defaults to false to prevent converting user-defined GLSL.
					**/
					var shouldProcess = meta.params.length > 1 && cast(meta.params[1].getValue(), Bool);

					switch (meta.name)
					{
						case "glFragmentSource", ":glFragmentSource":
							if (glFragmentSource == null)
							{
								if (shouldProcess)
								{
									glFragmentSource = processGLSLText(meta.params[0].getValue(), glVersion, true);
								}
								else
								{
									glFragmentSource = meta.params[0].getValue();
								}
							}

						case "glVertexSource", ":glVertexSource":
							if (glVertexSource == null)
							{
								if (shouldProcess)
								{
									glVertexSource = processGLSLText(meta.params[0].getValue(), glVersion, false);
								}
								else
								{
									glVertexSource = meta.params[0].getValue();
								}
							}

						case "glFragmentHeader", ":glFragmentHeader":
							if (shouldProcess)
							{
								glFragmentHeader = processGLSLText(meta.params[0].getValue(), glVersion, true) + "\n" + glFragmentHeader;
							}
							else
							{
								glFragmentHeader = meta.params[0].getValue() + "\n" + glFragmentHeader;
							}

						case "glFragmentBody", ":glFragmentBody":
							if (shouldProcess)
							{
								glFragmentBody = processGLSLText(meta.params[0].getValue(), glVersion, true) + "\n" + glFragmentBody;
							}
							else
							{
								glFragmentBody = meta.params[0].getValue() + "\n" + glFragmentBody;
							}

						case "glVertexHeader", ":glVertexHeader":
							if (shouldProcess)
							{
								glVertexHeader = processGLSLText(meta.params[0].getValue(), glVersion, false) + "\n" + glVertexHeader;
							}
							else
							{
								glVertexHeader = meta.params[0].getValue() + "\n" + glVertexHeader;
							}

						case "glVertexBody", ":glVertexBody":
							if (shouldProcess)
							{
								glVertexBody = processGLSLText(meta.params[0].getValue(), glVersion, false) + "\n" + glVertexBody;
							}
							else
							{
								glVertexBody = meta.params[0].getValue() + "\n" + glVertexBody;
							}

						default:
					}
				}
			}

			parent = parent.superClass != null ? parent.superClass.t.get() : null;
		}

		if (glVersion == null)
		{
			glVersion = getDefaultGLVersion();
		}

		glVertexExtensions = buildGLSLExtensions(glVertexExtensions, glVersion, false);
		glFragmentExtensions = buildGLSLExtensions(glFragmentExtensions, glVersion, true);

		if (glVertexSource != null || glFragmentSource != null)
		{
			if (glFragmentSource != null && glFragmentHeader != null && glFragmentBody != null)
			{
				glFragmentSourceRaw = glFragmentSource;
				glFragmentSource = StringTools.replace(glFragmentSource, "#pragma header", buildGLSLHeaders(glVersion) + glFragmentHeader);
				glFragmentSource = StringTools.replace(glFragmentSource, "#pragma body", glFragmentBody);
			}

			if (glVertexSource != null && glVertexHeader != null && glVertexBody != null)
			{
				glVertexSourceRaw = glVertexSource;
				glVertexSource = StringTools.replace(glVertexSource, "#pragma header", buildGLSLHeaders(glVersion) + glVertexHeader);
				glVertexSource = StringTools.replace(glVertexSource, "#pragma body", glVertexBody);
			}

			var shaderDataFields:Array<Field> = [];
			var uniqueFields:Array<Field> = [];

			processFields(glVertexSource, "attribute", shaderDataFields, pos);
			processFields(glVertexSource, "in", shaderDataFields, pos); // For higher GLSL versions
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

						block.unshift(Context.parse("__isGenerated = true", pos));

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

						if (glVertexSourceRaw != null)
						{
							block.unshift(macro if (__glVertexSourceRaw == null)
							{
								__glVertexSourceRaw = $v{glVertexSourceRaw};
							});
						}

						if (glFragmentSourceRaw != null)
						{
							block.unshift(macro if (__glFragmentSourceRaw == null)
							{
								__glFragmentSourceRaw = $v{glFragmentSourceRaw};
							});
						}

						if (glVertexBody != null)
						{
							block.unshift(macro if (__glVertexBodyRaw == null)
							{
								__glVertexBodyRaw = $v{glVertexBody};
							});
						}

						if (glFragmentBody != null)
						{
							block.unshift(macro if (__glFragmentBodyRaw == null)
							{
								__glFragmentBodyRaw = $v{glFragmentBody};
							});
						}

						if (glVertexHeader != null)
						{
							block.unshift(macro if (__glVertexHeaderRaw == null)
							{
								__glVertexHeaderRaw = $v{glVertexHeader};
							});
						}

						if (glFragmentHeader != null)
						{
							block.unshift(macro if (__glFragmentHeaderRaw == null)
							{
								__glFragmentHeaderRaw = $v{glFragmentHeader};
							});
						}

						if (glVertexExtensions != null)
						{
							block.unshift(macro if (__glVertexExtensions == null)
							{
								__glVertexExtensions = $v{glVertexExtensions};
							});
						}

						if (glFragmentExtensions != null)
						{
							block.unshift(macro if (__glFragmentExtensions == null)
							{
								__glFragmentExtensions = $v{glFragmentExtensions};
							});
						}

						if (glVersion != null)
						{
							block.unshift(macro if (__glVersion == null)
							{
								__glVersion = $v{glVersion};
							});
						}

						block.push(Context.parse("__initGL ()", pos));

					default:
				}
			}
			// #end

			fields = fields.concat(uniqueFields);
		}

		return fields;
	}

	private static inline function getDefaultGLVersion():String
	{
		// Specify the default glVersion.
		// We can use compile defines to guess the value that prevents crashes in the majority of cases.
		return #if (android) "100" #elseif (web) "100" #elseif (mac) "120" #else "100" #end;
	}

	/**
	 * Attempt to migrate GLSL code from the current (old) GLSL shader format to the specified (newer) one.
	 * @param source The source to convert.
	 * @param version The version to convert to.
	 * @param isFragment Whether the source is a fragment shader. False if it is a vertex shader.
	 * @return The converted source.
	 */
	private static function processGLSLText(source:String, glVersion:String, isFragment:Bool)
	{
		if (glVersion == "" || glVersion == null) return processGLSLText(source, getDefaultGLVersion(), isFragment);

		// No processing needed on "compatibility" profile
		if (StringTools.endsWith(glVersion, " compatibility")) return source;
		if (StringTools.endsWith(glVersion, " core")) return processGLSLText(source, StringTools.replace(glVersion, " core", ""), isFragment);

		// Recall: Attribute values are per-vertex, varying values are per-fragment
		// Thus, an `out` value in the vertex shader is an `in` value in the fragment shader
		var attributeKeyword:EReg = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/g; // g to match all
		var varyingKeyword:EReg = ~/varying ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/g; // g to match all

		var texture2DKeyword:EReg = ~/texture2D/g;
		var glFragColorKeyword:EReg = ~/gl_FragColor/g;

		switch (glVersion)
		{
			default:
				// We don't know this GLSL version, so don't do anything.
				return source;

			case "100":
				return source;
			case "110":
				return source;
			case "120":
				return source;
			case "130":
				return source;
			case "140":
				return source;
			case "150":
				return source;

			case "300 es":
				var result = source;
				// Migrate, replacing "attribute" with "in" and "varying" with "out".
				if (isFragment)
				{
					result = varyingKeyword.replace(result, "in $1 $2");
				}
				else
				{
					result = attributeKeyword.replace(result, "in $1 $2");
					result = varyingKeyword.replace(result, "out $1 $2");
				}
				result = texture2DKeyword.replace(result, "texture");
				result = glFragColorKeyword.replace(result, "fragColor");
				return result;

			case "310 es":
				var result = processGLSLText(source, "300 es", isFragment);
				return result;

			case "320 es":
				var result = processGLSLText(source, "310 es", isFragment);
				return result;

			case "330":
				#if desktop
				var result = processGLSLText(source, "320 es", isFragment);
				#else
				var result = source;
				#end
				return result;
			case "400":
				var result = processGLSLText(source, "330", isFragment);
				return result;
			case "410":
				var result = processGLSLText(source, "400", isFragment);
				return result;
			case "420":
				var result = processGLSLText(source, "410", isFragment);
				return result;
			case "430":
				var result = processGLSLText(source, "420", isFragment);
				return result;
			case "440":
				var result = processGLSLText(source, "430", isFragment);
				return result;
			case "450":
				var result = processGLSLText(source, "440", isFragment);
				return result;
			case "460":
				var result = processGLSLText(source, "450", isFragment);
				return result;
		}
	}

	private static function buildGLSLHeaders(glVersion:String):String
	{
		if (StringTools.endsWith(glVersion, " compatibility")) return "";
		if (StringTools.endsWith(glVersion, " core")) return buildGLSLHeaders(StringTools.replace(glVersion, " core", ""));

		switch (glVersion)
		{
			default:
				return "";

			case "100":
				return "";
			case "110":
				return "";
			case "120":
				return "";
			case "130":
				return "";
			case "140":
				return "";
			case "150":
				return "";

			case "300 es":
				#if desktop
				var result = "layout (location = 0) out vec4 fragColor;\n";
				#else
				var result = "out vec4 fragColor;\n";
				// var result = "";
				#end
				return result;
			case "310 es":
				var result = buildGLSLHeaders("300 es");
				return result;
			case "320 es":
				var result = buildGLSLHeaders("310 es");
				return result;

			case "330":
				var result = buildGLSLHeaders("320 es");
				return result;

			case "400":
				var result = buildGLSLHeaders("330");
				return result;
			case "410":
				var result = buildGLSLHeaders("400");
				return result;
			case "420":
				var result = buildGLSLHeaders("410");
				return result;
			case "430":
				var result = buildGLSLHeaders("420");
				return result;
			case "440":
				var result = buildGLSLHeaders("430");
				return result;
			case "450":
				var result = buildGLSLHeaders("440");
				return result;
			case "460":
				var result = buildGLSLHeaders("450");
				return result;
		}
	}

	private static function buildGLSLExtensions(glExtensions:Array<{name:String, behavior:String}>, glVersion:String,
			isFragment:Bool):Array<{name:String, behavior:String}>
	{
		if (StringTools.endsWith(glVersion, " compatibility")) return glExtensions;
		if (StringTools.endsWith(glVersion, " core")) return buildGLSLExtensions(glExtensions, StringTools.replace(glVersion, " core", ""), isFragment);

		switch (glVersion)
		{
			default:
				return glExtensions;

			case "100":
				return glExtensions;
			case "110":
				return glExtensions;
			case "120":
				return glExtensions;
			case "130":
				return glExtensions;
			case "140":
				return glExtensions;
			case "150":
				return glExtensions;

			case "300 es":
				var hasSeparateShaderObjects = false;
				for (extension in glExtensions)
				{
					if (extension.name == "GL_ARB_separate_shader_objects") hasSeparateShaderObjects = true;
					if (extension.name == "GL_EXT_separate_shader_objects") hasSeparateShaderObjects = true;
				}

				#if desktop
				if (!hasSeparateShaderObjects)
				{
					#if linux
					return glExtensions.concat([{name: "GL_EXT_separate_shader_objects", behavior: "require"}]);
					#else
					return glExtensions.concat([{name: "GL_ARB_separate_shader_objects", behavior: "require"}]);
					#end
				}
				#end
				return glExtensions;

			case "310 es":
				var result = buildGLSLExtensions(glExtensions, "300 es", isFragment);
				return result;

			case "320 es":
				var result = buildGLSLExtensions(glExtensions, "310 es", isFragment);
				return result;

			case "330":
				var result = buildGLSLExtensions(glExtensions, "320 es", isFragment);
				return result;

			case "400":
				return glExtensions;
			case "410":
				return glExtensions;
			case "420":
				return glExtensions;
			case "430":
				return glExtensions;
			case "440":
				return glExtensions;
			case "450":
				return glExtensions;
			case "460":
				return glExtensions;
		}
	}

	private static function processFields(source:String, storageType:String, fields:Array<Field>, pos:Position):Void
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
}
#end
