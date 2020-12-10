package flash.net;

#if flash
extern class URLVariables implements Dynamic
{
	public function new(source:String = null);
	public function decode(source:String):Void;
	public function toString():String;
}
#else
typedef URLVariables = openfl.net.URLVariables;
#end
