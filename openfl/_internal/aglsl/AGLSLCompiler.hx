package openfl._internal.aglsl; 


import openfl.utils.AGALMiniAssembler; 
import openfl.utils.ByteArray;


class AGLSLCompiler {
	
	
	public var glsl:String;
	
	
	public function new () {
		
		
		
	}
	
	
	public function compile (programType:String, source:String):String {
		
		var agalMiniAssembler = new AGALMiniAssembler ();
		var tokenizer = new AGALTokenizer ();
		var data:ByteArray;
		var concatSource:String;
		
		switch (programType) {
			case "vertex":
				
				concatSource = "part vertex 1 \n" + source + "\nendpart\n";
				agalMiniAssembler.assemble (concatSource);
				data = agalMiniAssembler.r.get ("vertex").data;
			
			case "fragment":
				
				concatSource = "part fragment 1 \n" + source + "\nendpart\n";
				agalMiniAssembler.assemble (concatSource);
				data = agalMiniAssembler.r.get ("fragment").data;
			
			default:
				
				throw "Unknown Context3DProgramType";
			
		}
		
		var description:Description = tokenizer.decribeAGALByteArray (data);
		var parser = new AGLSLParser ();
		this.glsl = parser.parse (description);
		return this.glsl;
		
	}
	
	
}