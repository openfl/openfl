package format.swf.tags;

import format.swf.SWFData;

class TagScriptLimits implements ITag
{
	public static inline var TYPE:Int = 65;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var maxRecursionDepth:Int;
	public var scriptTimeoutSeconds:Int;
	
	public function new() {
		type = TYPE;
		name = "ScriptLimits";
		version = 7;
		level = 1;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		maxRecursionDepth = data.readUI16();
		scriptTimeoutSeconds = data.readUI16();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 4);
		data.writeUI16(maxRecursionDepth);
		data.writeUI16(scriptTimeoutSeconds);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"MaxRecursionDepth: " + maxRecursionDepth + ", " +
			"ScriptTimeoutSeconds: " + scriptTimeoutSeconds;
	}
}