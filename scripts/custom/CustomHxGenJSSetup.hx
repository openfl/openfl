import genjs.generator.*;

class CustomHxGenJSSetup {
	
	/*
	Called in the build.hxml script.
	
	We supply our own custom ClassGenerator which overrides the one 
	used by the hxgenjs library. We use our own in order to remove the 
	trailing semicolons from the triple slash lines such as:
	
	/// #if debug; 
	/// #endif;
	
	Which are generated in the lib/_gen/ javascript files by the haxe 
	compiler whenever it encounters these lines in the haxe source.
	
	untyped __js__("/// #if debug");
	
	Note: If the haxe compiler wasn't adding semicolons to the end of these 
	lines, we wouldn't need this custom generator in the first place!
	
	We can then use the ifdef-loader webpack loader to conditionally 
	include or exclude lines of javascript from the javascript bundle.
	See src/openfl/display/MovieClip.hx for usage.
	*/
	public static function setup() {
		
		#if (!genjs || genjs != "no")
		var customConfig:genjs.Generator.Config = {
			mainGenerator: new MainGenerator(),
			classGenerator: new CustomClassGenerator(),
			enumGenerator: new EnumGenerator(),
			fileExtension: '.js',
			stubs: true,
		};
		
		genjs.Generator.generators.push(customConfig);
		#end
	}
}

