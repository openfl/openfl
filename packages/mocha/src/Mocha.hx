@:native("window")
extern class Mocha
{
	public static function after(method:Dynamic):Void;
	public static function afterEach(method:Dynamic):Void;
	public static function before(method:Dynamic):Void;
	public static function beforeEach(method:Dynamic):Void;
	public static function describe(label:String, method:Dynamic):Void;
	public static function it(label:String, method:Dynamic):Void;
}
