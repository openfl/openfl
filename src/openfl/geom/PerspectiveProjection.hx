package openfl.geom; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class PerspectiveProjection {
	
	
	public static inline var TO_RADIAN:Float = 0.01745329251994329577; // Math.PI / 180
	
	public var fieldOfView (get, set):Float;
	public var focalLength:Float;
	public var projectionCenter:Point; // FIXME: does this do anything at all?
	
	@:noCompletion private var __fieldOfView:Float;
	@:noCompletion private var matrix3D:Matrix3D;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperty (PerspectiveProjection.prototype, "fieldOfView", { get: untyped __js__ ("function () { return this.get_fieldOfView (); }"), set: untyped __js__ ("function (v) { return this.set_fieldOfView (v); }") });
		
	}
	#end
	
	
	public function new () {
		
		__fieldOfView = 0;
		this.focalLength = 0;
		
		matrix3D = new Matrix3D ();
		projectionCenter = new Point (Lib.current.stage.stageWidth / 2, Lib.current.stage.stageHeight / 2);
		
	}
	
	
	public function toMatrix3D ():Matrix3D {
		
		if (#if neko __fieldOfView == null || #end projectionCenter == null) return null;
		
		var _mp = matrix3D.rawData;
		_mp[0] = focalLength;
		_mp[5] = focalLength;
		_mp[11] = 1.0;
		_mp[15] = 0;
		
		//matrix3D.rawData = [357.0370178222656,0,0,0,0,357.0370178222656,0,0,0,0,1,1,0,0,0,0];
		return matrix3D;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_fieldOfView ():Float {
		
		return __fieldOfView;
		
	}
	
	
	@:noCompletion private function set_fieldOfView (fieldOfView:Float):Float {
		
		var p_nFovY = fieldOfView * TO_RADIAN;
		__fieldOfView = p_nFovY;
		var cotan = 1 / Math.tan (p_nFovY / 2);
		this.focalLength = 500 / 2 * cotan;
		return __fieldOfView;
		
	}
	
	
}


#else
typedef PerspectiveProjection = flash.geom.PerspectiveProjection;
#end