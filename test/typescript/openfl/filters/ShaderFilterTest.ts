import Shader from "openfl/display/Shader";
// import ShaderFilter from "openfl/filters/ShaderFilter";
import * as assert from "assert";


// import format.pbj.Data;
// import format.pbj.Writer;
// import haxe.io.BytesOutput;
// import openfl.display.Shader;


describe ("TypeScript | ShaderFilter", function () {
	
	
	var _shader:Shader = null;
	
	
	// @BeforeClass public function _init ():Void {
		
	// 	#if flash
		
	// 	var pbj : PBJ = {
	// 		version : 1,
	// 		name : "Multiply",
	// 		metadatas : [],
	// 		// the parameters are the input/output of the shader
	// 		// see PBJ Reference below for a full description
	// 		parameters : [
	// 			{ name : "_OutCoord", p : Parameter(TFloat2,false,RFloat(0,[R,G])), metas : [] },
	// 			{ name : "background", p : Texture(4,0), metas : [] },
	// 			{ name : "foreground", p : Texture(4,1), metas : [] },
	// 			{ name : "dst", p : Parameter(TFloat4,true,RFloat(1)), metas : [] },
	// 		],
	// 		// this is our assembler code for the shader, you can see it's similar
	// 		// to what we have written in previous section
	// 		code : [
	// 			OpSampleNearest(RFloat(2),RFloat(0,[R,G]),0),
	// 			OpSampleNearest(RFloat(1),RFloat(0,[R,G]),1),
	// 			OpMul(RFloat(1),RFloat(2)),
	// 		],
	// 	};
		
	// 	var output = new BytesOutput ();
	// 	var writer = new Writer (output);
	// 	writer.write (pbj);
		
	// 	_shader = new Shader (output.getBytes ());
		
	// 	#else
		
	// 	_shader = new Shader ();
		
	// 	#end
		
		
	// });
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		// var shaderFilter = new ShaderFilter (_shader);
		// assert.notEqual (shaderFilter, null);
		
	});
	
	
	it ("shader", function () {
		
		// TODO: Confirm functionality
		
		// var shaderFilter = new ShaderFilter (_shader);
		// var exists = shaderFilter.shader;
		
		// assert.notEqual (exists, null);
		
	});
	
	
});