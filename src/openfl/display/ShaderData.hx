package openfl.display;

#if !flash
import openfl.utils.ByteArray;

/**
	// TODO: Document GLSL Shaders
	A ShaderData object contains properties representing any parameters and
	inputs for a shader kernel, as well as properties containing any metadata
	specified for the shader.
	These properties are added to the ShaderData object when it is created.
	The properties' names match the names specified in the shader's source
	code. The data type of each property varies according to what aspect of
	the shader the property represents. The properties that represent shader
	parameters are ShaderParameter instances, the properties that represent
	input images are ShaderInput instances, and the properties that represent
	shader metadata are instances of the ActionScript class corresponding to
	their data type (for example, a String instance for textual metadata and a
	uint for uint metadata).

	For example, consider this shader, which is defined with one input image
	(`src`), two parameters (`size` and `radius`), and three metadata values
	(`nameSpace`, `version`, and `description`):

	```as3
	<languageVersion : 1.0;>

	kernel DoNothing
	<
		namespace: "Adobe::Example";
		vendor: "Adobe examples";
		version: 1;
		description: "A shader that does nothing, but does it well.";
	>
	{
		input image4 src;

		output pixel4 dst;

		parameter float2 size
		<
			description: "The size of the image to which the kernel is applied";
			minValue: float2(0.0, 0.0);
			maxValue: float2(100.0, 100.0);
			defaultValue: float2(50.0, 50.0);
		>;

		parameter float radius
		<
			description: "The radius of the effect";
			minValue: 0.0;
			maxValue: 50.0;
			defaultValue: 25.0;
		>;

		void evaluatePixel()
		{
			float2 one = (radius / radius) ∗ (size / size);
			dst = sampleNearest(src, outCoord());
		}
	}
	```

	If you create a Shader instance by loading the byte code for this shader,
	the ShaderData instance in its `data` property contains these properties:

	| Property | Data type | Value |
	| --- | --- | --- |
	| name | `String` | "DoNothing" |
	| nameSpace | `String` | "Adobe::Example" |
	| version | `String` | "1" |
	| description | `String` | "A shader that does nothing, but does it well." |
	| src | `ShaderInput` | _[A ShaderInput instance]_ |
	| size | `ShaderParameter` | _[A ShaderParameter instance, with properties for the parameter metadata]_ |
	| radius | `ShaderParameter` | _[A ShaderParameter instance, with properties for the parameter metadata]_ |

	Note that any input image or parameter that is defined in the shader
	source code but not used in the shader's `evaluatePixel()` function is
	removed when the shader is compiled to byte code. In that case, there is
	no corresponding ShaderInput or ShaderParameter instance added as a
	property of the ShaderData instance.

	Generally, developer code does not create a ShaderData instance. A
	ShaderData instance containing data, parameters, and inputs for a shader
	is available as the Shader instance's `data` property.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:forward()
@SuppressWarnings("checkstyle:Dynamic")
abstract ShaderData(Dynamic) from Dynamic to Dynamic
{
	/**
		Creates a ShaderData instance. Generally, developer code does not call
		the ShaderData constructor directly. A ShaderData instance containing
		data, parameters, and inputs for a Shader instance is accessed using
		its `data` property.

		@param byteCode The shader's byte code.
	**/
	public function new(byteArray:ByteArray)
	{
		this = {};
	}
}
#else
typedef ShaderData = flash.display.ShaderData;
#end
