package flash.display;

#if flash
import openfl.utils.ByteArray;

/**
	A Shader instance represents a Pixel Bender shader kernel in ActionScript.
	To use a shader in your application, you create a Shader instance for it.
	You then use that Shader instance in the appropriate way according to the
	effect you want to create. For example, to use the shader as a filter, you
	assign the Shader instance to the `shader` property of a ShaderFilter
	object.
	A shader defines a function that executes on all the pixels in an image,
	one pixel at a time. The result of each call to the function is the output
	color at that pixel coordinate in the image. A shader can specify one or
	more input images, which are images whose content can be used in
	determining the output of the function. A shader can also specify one or
	more parameters, which are input values that can be used in calculating
	the function output. In a single shader execution, the input and parameter
	values are constant. The only thing that varies is the coordinate of the
	pixel whose color is the function result. Shader function calls for
	multiple output pixel coordinates execute in parallel to improve shader
	execution performance.

	The shader bytecode can be loaded at run time using a URLLoader instance.
	The following example demonstrates loading a shader bytecode file at run
	time and linking it to a Shader instance.

	```as3
	var loader:URLLoader = new URLLoader();
	loader.dataFormat = URLLoaderDataFormat.BINARY;
	loader.addEventListener(Event.COMPLETE, onLoadComplete);
	loader.load(new URLRequest("myShader.pbj"));
	var shader:Shader;

	function onLoadComplete(event:Event):void {
		// Create a new shader and set the loaded data as its bytecode
		shader = new Shader();
		shader.byteCode = loader.data;

		// You can also pass the bytecode to the Shader() constructor like this:
		// shader = new Shader(loader.data);

		// do something with the shader
	}
	```

	You can also embed the shader into the SWF at compile time using the
	`[Embed]` metadata tag. The `[Embed]` metadata tag is only available if
	you use the Flex SDK to compile the SWF. The `[Embed]` tag's `source`
	parameter points to the shader file, and its `mimeType` parameter is
	`"application/octet-stream"`, as in this example:

	```as3
	[Embed(source="myShader.pbj", mimeType="application/octet-stream)] var MyShaderClass:Class;

	// ...

	// create a new shader and set the embedded shader as its bytecode var
	shaderShader = new Shader();
	shader.byteCode = new MyShaderClass();

	// You can also pass the bytecode to the Shader() constructor like this:
	// var shader:Shader = new Shader(new MyShaderClass());

	// do something with the shader
	```

	In either case, you link the raw shader (the `URLLoader.data` property or
	an instance of the `[Embed]` data class) to the Shader instance. As the
	previous examples demonstrate, you can do this in two ways. You can pass
	the shader bytecode as an argument to the `Shader()` constructor.
	Alternatively, you can set it as the Shader instance's `byteCode`
	property.

	Once a Shader instance is created, it can be used in one of several ways:

	* A shader fill: The output of the shader is used as a fill for content
	drawn with the drawing API. Pass the Shader instance as an argument to the
	`Graphics.beginShaderFill()` method.
	* A shader filter: The output of the shader is used as a graphic filter
	applied to a display object. Assign the Shader instance to the `shader`
	property of a ShaderFilter instance.
	* A blend mode: The output of the shader is rendered as the blending
	between two overlapping display objects. Assign the Shader instance to the
	`blendShader` property of the upper of the two display objects.
	* Background shader processing: The shader executes in the background,
	avoiding the possibility of freezing the display, and dispatches an event
	when processing is complete. Assign the Shader instance to the `shader`
	property of a ShaderJob instance.

	Shader fills, filters, and blends are not supported under GPU rendering.

	**Mobile Browser Support:** This feature is not supported in mobile
	browsers.

	_Adobe AIR profile support:_ This feature is supported on all desktop operating
	systems, but it is not supported on all mobile devices. It is not
	supported on AIR for TV devices. See
	[AIR Profile Support](https://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.
**/
@:require(flash10)
extern class Shader
{
	#if (haxe_ver < 4.3)
	public var byteCode(never, default):ByteArray;
	public var data:ShaderData;
	public var precisionHint:ShaderPrecision;
	#else
	@:flash.property var byteCode(never, set):ByteArray;
	@:flash.property var data(get, set):ShaderData;
	@:flash.property var precisionHint(get, set):ShaderPrecision;
	#end

	public var glFragmentSource(get, set):String;
	public var glProgram(get, never):Dynamic;
	public var glVertexSource(get, set):String;

	public function new(code:ByteArray = null):Void;

	@:noCompletion private inline function get_glFragmentSource():String
	{
		return null;
	}
	@:noCompletion private inline function set_glFragmentSource(value:String):String
	{
		return null;
	}
	@:noCompletion private inline function get_glProgram():String
	{
		return null;
	}
	@:noCompletion private inline function get_glVertexSource():String
	{
		return null;
	}
	@:noCompletion private inline function set_glVertexSource(value:String):String
	{
		return null;
	}

	#if (haxe_ver >= 4.3)
	private function get_data():ShaderData;
	private function get_precisionHint():ShaderPrecision;
	private function set_byteCode(value:ByteArray):ByteArray;
	private function set_data(value:ShaderData):ShaderData;
	private function set_precisionHint(value:ShaderPrecision):ShaderPrecision;
	#end
}
#else
typedef Shader = openfl.display.Shader;
#end
