package openfl._v2.display; #if lime_legacy

import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.display.S3DView;

class S3D {
	private static var lime_get_s3d_supported:Void->Bool;
	private static var lime_get_s3d_enabled:Void->Bool;
	private static var lime_set_s3d_enabled:Bool->Void;
	private static var lime_gl_s3d_get_eye_separation:Void->Float;
	private static var lime_gl_s3d_set_eye_separation:Float->Void;
	private static var lime_gl_s3d_get_focal_length:Void->Float;
	private static var lime_gl_s3d_set_focal_length:Float->Void;

	public static var enabled (get, set):Bool;
	public static var supported (get, null):Bool;

	public static var eyeSeparation (get, set):Float;
	public static var focalLength (get, set):Float;

	public static function get_supported () {
		if (lime_get_s3d_supported == null)
			return false;

		return lime_get_s3d_supported ();
	}

	public static function get_enabled () {
		if (lime_get_s3d_enabled == null)
			return false;

		return lime_get_s3d_enabled ();
	}

	public static function set_enabled (enabled:Bool) {
		if (lime_set_s3d_enabled == null)
			return false;
			
		lime_set_s3d_enabled (enabled);
		return enabled;
	}

	public static function get_eyeSeparation ():Float {
		if (lime_gl_s3d_get_eye_separation == null)
			return 0;

		return lime_gl_s3d_get_eye_separation ();
	}

	public static function set_eyeSeparation (separation:Float):Float {
		if (lime_gl_s3d_set_eye_separation != null)
			lime_gl_s3d_set_eye_separation (separation);
			
		return separation;
	}

	public static function get_focalLength ():Float {
		if (lime_gl_s3d_get_focal_length == null)
			return 0.0;

		return lime_gl_s3d_get_focal_length ();
	}

	public static function set_focalLength (length:Float):Float {
		if (lime_gl_s3d_set_focal_length != null)
			lime_gl_s3d_set_focal_length (length);

		return length;
	}

	public static function __init__ () {
		lime_get_s3d_enabled = Lib.load ("lime", "lime_get_s3d_enabled", 0);
		lime_set_s3d_enabled = Lib.load ("lime", "lime_set_s3d_enabled", 1);
		lime_get_s3d_supported = Lib.load ("lime", "lime_get_s3d_supported", 0);
		lime_gl_s3d_get_eye_separation = Lib.load ("lime", "lime_gl_s3d_get_eye_separation", 0);
		lime_gl_s3d_set_eye_separation = Lib.load ("lime", "lime_gl_s3d_set_eye_separation", 1);
		lime_gl_s3d_get_focal_length = Lib.load ("lime", "lime_gl_s3d_get_focal_length", 0);
		lime_gl_s3d_set_focal_length = Lib.load ("lime", "lime_gl_s3d_set_focal_length", 1);
	}
}


#end