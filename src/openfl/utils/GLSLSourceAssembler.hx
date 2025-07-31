package openfl.utils;

class GLSLSourceAssembler
{
	public var fragmentBody:String;
	public var fragmentExtensions:Map<String, String>;
	public var fragmentHeader:String;
	public var fragmentSource:String;
	public var version:String;
	public var vertexBody:String;
	public var vertexExtensions:Map<String, String>;
	public var vertexHeader:String;
	public var vertexSource:String;

	/**
		Creates a new GLSLSourceAssembler instance
	**/
	public function new()
	{
		vertexExtensions = new Map();
		fragmentExtensions = new Map();
	}

	/**
		Add a GL extension for both vertex and fragment shaders
	**/
	public function addExtension(extension:String, behavior:String = "require"):Void
	{
		addVertexExtension(extension, behavior);
		addFragmentExtension(extension, behavior);
	}

	public function addExtensions(extensions:Map<String, String>):Void
	{
		addVertexExtensions(extensions);
		addFragmentExtensions(extensions);
	}

	/**
		Append source to the body of the GLSL fragment shader
	**/
	public function addFragmentBody(source:String):Void
	{
		if (fragmentBody == null)
		{
			fragmentBody = source;
		}
		else
		{
			fragmentBody += "\n" + source;
		}
	}

	/**
		Add a GL extension for the fragment shader
	**/
	public function addFragmentExtension(extension:String, behavior:String = "require"):Void
	{
		fragmentExtensions.set(extension, behavior);
	}

	public function addFragmentExtensions(extensions:Map<String, String>):Void
	{
		for (key in extensions)
		{
			fragmentExtensions[key] = extensions[key];
		}
	}

	/**
		Append source to the header of the GLSL fragment shader
	**/
	public function addFragmentHeader(source:String):Void
	{
		if (fragmentHeader == null)
		{
			fragmentHeader = source;
		}
		else
		{
			fragmentHeader += "\n" + source;
		}
	}

	/**
		Append source to the body of the GLSL vertex shader
	**/
	public function addVertexBody(source:String):Void
	{
		if (vertexBody == null)
		{
			vertexBody = source;
		}
		else
		{
			vertexBody += "\n" + source;
		}
	}

	/**
		Add a GL extension for the vertex shader
	**/
	public function addVertexExtension(extension:String, behavior:String = "require"):Void
	{
		vertexExtensions.set(extension, behavior);
	}

	public function addVertexExtensions(extensions:Map<String, String>):Void
	{
		for (key in extensions)
		{
			vertexExtensions[key] = extensions[key];
		}
	}

	/**
		Append source to the header of the GLSL vertex shader
	**/
	public function addVertexHeader(source:String):Void
	{
		if (vertexHeader == null)
		{
			vertexHeader = source;
		}
		else
		{
			vertexHeader += "\n" + source;
		}
	}

	/**
		Apply compatibility transforms to the specified GLSL shader sources to convert for the specified
		newer version.

		@param	source	The GLSL source to convert.
		@param	targetVersion	The target GLSL version.
		@param	isVertex	Whether the GLSL source is a component of a vertex shader. False if it is a fragment shader.
		@return	The converted GLSL source.
	**/
	public static function applyCompatibility(source:String, targetVersion:String, isVertex:Bool):String
	{
		if (targetVersion == "" || targetVersion == null) return applyCompatibility(source, __getDefaultVersion(), isVertex);

		// No processing needed on "compatibility" profile
		if (StringTools.endsWith(targetVersion, " compatibility")) return source;
		if (StringTools.endsWith(targetVersion, " core")) return applyCompatibility(source, StringTools.replace(targetVersion, " core", ""), isVertex);

		// Recall: Attribute values are per-vertex, varying values are per-fragment
		// Thus, an `out` value in the vertex shader is an `in` value in the fragment shader
		var attributeKeyword:EReg = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/g; // g to match all
		var varyingKeyword:EReg = ~/varying ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/g; // g to match all

		var texture2DKeyword:EReg = ~/texture2D/g;
		var glFragColorKeyword:EReg = ~/gl_FragColor/g;

		switch (targetVersion)
		{
			case "100", "110", "120", "130", "140", "150":
				return source;

			case "300 es":
				var result = source;
				// Migrate, replacing "attribute" with "in" and "varying" with "out".
				if (isVertex)
				{
					result = attributeKeyword.replace(result, "in $1 $2");
					result = varyingKeyword.replace(result, "out $1 $2");
				}
				else
				{
					result = varyingKeyword.replace(result, "in $1 $2");
				}
				result = texture2DKeyword.replace(result, "texture");
				result = glFragColorKeyword.replace(result, "fragColor");
				return result;

			case "310 es", "320 es":
				var result = applyCompatibility(source, "300 es", isVertex);
				return result;

			case "330":
				#if desktop
				var result = applyCompatibility(source, "300 es", isVertex);
				#else
				var result = source;
				#end
				return result;

			case "400", "410", "420", "430", "440", "450", "460":
				var result = applyCompatibility(source, "330", isVertex);
				return result;

			default:
		}

		return source;
	}

	public function assembleFragmentSource(useCompatibility:Bool = true):String
	{
		var version = (this.version != null ? this.version : __getDefaultVersion());
		var fragmentExtensions = __buildExtensions(this.fragmentExtensions.copy(), version, false);
		var fragmentSource = __appendPrefix(this.fragmentSource, version, fragmentExtensions);

		if (fragmentSource != null)
		{
			if (this.fragmentHeader != null)
			{
				fragmentSource = StringTools.replace(fragmentSource, "#pragma header", __createDefaultHeader(version) + this.fragmentHeader);
			}

			if (this.fragmentBody != null)
			{
				fragmentSource = StringTools.replace(fragmentSource, "#pragma body", this.fragmentBody);
			}

			if (useCompatibility)
			{
				applyCompatibility(fragmentSource, version, false);
			}
		}

		return fragmentSource;
	}

	public function assembleVertexSource(useCompatibility:Bool = true):String
	{
		var version = (this.version != null ? this.version : __getDefaultVersion());
		var vertexExtensions = __buildExtensions(this.vertexExtensions.copy(), version, true);
		var vertexSource = __appendPrefix(this.vertexSource, version, vertexExtensions);

		if (vertexSource != null)
		{
			if (this.vertexHeader != null)
			{
				vertexSource = StringTools.replace(vertexSource, "#pragma header", __createDefaultHeader(version) + this.vertexHeader);
			}

			if (this.vertexBody != null)
			{
				vertexSource = StringTools.replace(vertexSource, "#pragma body", this.vertexBody);
			}

			if (useCompatibility)
			{
				applyCompatibility(vertexSource, version, true);
			}
		}

		return vertexSource;
	}

	public function concat(other:GLSLSourceAssembler):GLSLSourceAssembler
	{
		addVertexExtensions(other.vertexExtensions);
		if (other.fragmentHeader != null) addFragmentHeader(other.fragmentHeader);
		if (other.fragmentBody != null) addFragmentBody(other.fragmentBody);
		if (other.fragmentSource != null) fragmentSource = other.fragmentSource;
		addFragmentExtensions(other.fragmentExtensions);
		if (other.version != null) version = other.version;
		if (other.vertexHeader != null) addVertexHeader(other.vertexHeader);
		if (other.vertexBody != null) addVertexBody(other.vertexBody);
		if (other.vertexSource != null) vertexSource = other.vertexSource;
		return this;
	}

	private static function __appendPrefix(source:String, version:String, extensions:Map<String, String>):String
	{
		if (source == null) return null;

		var output = "#version " + version + "\n";

		for (key in extensions.keys())
		{
			output + "#extension " + key + " : " + extensions[key] + "\n";
		}

		output += "\n#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
			+ "precision highp float;\n"
			+ "#else\n"
			+ "precision mediump float;\n"
			+ "#endif\n\n";

		output += source;
		return output;
	}

	private static function __buildExtensions(extensions:Map<String, String>, version:String, isVertex:Bool):Map<String, String>
	{
		if (StringTools.endsWith(version, " compatibility")) return extensions;
		if (StringTools.endsWith(version, " core")) return __buildExtensions(extensions, StringTools.replace(version, " core", ""), isVertex);

		switch (version)
		{
			#if desktop
			case "300 es", "310 es", "320 es", "330":
				if (!extensions.exists("GL_ARB_separate_shader_objects") && !extensions.exists("GL_EXT_separate_shader_objects"))
				{
					#if linux
					extensions.set("GL_EXT_separate_shader_objects", "require");
					#else
					extensions.set("GL_ARB_separate_shader_objects", "require");
					#end
				}
			#end

			default:
		}

		return extensions;
	}

	private static function __createDefaultHeader(version:String):String
	{
		if (StringTools.endsWith(version, " compatibility"))
		{
			return "";
		}

		if (StringTools.endsWith(version, " core"))
		{
			return __createDefaultHeader(StringTools.replace(version, " core", ""));
		}

		switch (version)
		{
			#if desktop
			case "300 es":
				return "layout (location = 0) out vec4 fragColor;\n";
			#else
			case "300 es":
				return "out vec4 fragColor;\n";
			#end

			case "310 es", "320 es", "330", "400", "410", "420", "430", "440", "450", "460":
				return __createDefaultHeader("300 es");

			default:
		};

		return "";
	}

	private static inline function __getDefaultVersion():String
	{
		// Specify the default GLSL version.
		// We can use compile defines to guess the value that prevents crashes in the majority of cases.
		#if mac
		return "120";
		#elseif (android || web)
		return "100";
		#else
		return "100";
		#end
	}

	/**
		Reset all values on this object
	**/
	public function clear():Void
	{
		fragmentBody = null;
		fragmentExtensions = new Map();
		fragmentHeader = null;
		fragmentSource = null;
		vertexBody = null;
		vertexExtensions = new Map();
		vertexHeader = null;
		vertexSource = null;
		version = null;
	}
}
