package openfl.geom;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class PerspectiveProjection
{
	@SuppressWarnings("checkstyle:FieldDocComment")
	@:dox(hide) @:noCompletion public static inline var TO_RADIAN:Float = 0.01745329251994329577; // Math.PI / 180

	public var fieldOfView(get, set):Float;
	public var focalLength:Float;
	public var projectionCenter:Point; // FIXME: does this do anything at all?

	@:noCompletion private var __fieldOfView:Float;
	@:noCompletion private var matrix3D:Matrix3D;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(PerspectiveProjection.prototype, "fieldOfView", {
			get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_fieldOfView (); }"),
			set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_fieldOfView (v); }")
		});
	}
	#end

	public function new()
	{
		__fieldOfView = 0;
		this.focalLength = 0;

		matrix3D = new Matrix3D();
		projectionCenter = new Point(#if !openfl_unit_testing Lib.current.stage.stageWidth / 2, Lib.current.stage.stageHeight / 2 #end);
	}

	public function toMatrix3D():Matrix3D
	{
		if (#if neko __fieldOfView == null || #end projectionCenter == null) return null;

		var _mp = matrix3D.rawData;
		_mp[0] = focalLength;
		_mp[5] = focalLength;
		_mp[11] = 1.0;
		_mp[15] = 0;

		// matrix3D.rawData = [357.0370178222656,0,0,0,0,357.0370178222656,0,0,0,0,1,1,0,0,0,0];
		return matrix3D;
	}

	// Getters & Setters
	@:noCompletion private function get_fieldOfView():Float
	{
		return __fieldOfView;
	}

	@:noCompletion private function set_fieldOfView(fieldOfView:Float):Float
	{
		__fieldOfView = fieldOfView * TO_RADIAN;

		this.focalLength = 250.0 * (1.0 / Math.tan(__fieldOfView * 0.5));

		return __fieldOfView;
	}
}
#else
typedef PerspectiveProjection = flash.geom.PerspectiveProjection;
#end
