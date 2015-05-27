package openfl.display; #if !flash #if !openfl_legacy

// TODO: change ShaderParamater to an interface so I can use it for ShaderInput
@:forward
abstract ShaderData(Map<String, ShaderParameter>) {
	
	public function new() {
		this = new Map();
	}
	
}

/*
class ShaderData {
	
	private var parameters:Array<ShaderParameter>;
	
	public function new() {
		parameters = [];
	}
	
}
*/


#else
typedef ShaderData = openfl._legacy.display.ShaderData;
#end
#else
typedef ShaderData = flash.display.ShaderData;
#end