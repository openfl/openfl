package openfl.display3D;

#if !flash
#if !openfljs
#if cs
import openfl.utils._internal.NullUtils;
#end

/**
	Defines the values to use for specifying the Context3D profile.
**/
@:enum abstract Context3DProfile(Null<Int>)
{
	/**
		Use the default feature support profile.

		This profile most closely resembles Stage3D support used in previous releases.
	**/
	public var BASELINE = 0;

	/**
		Use a constrained feature support profile to target older GPUs

		This profile is primarily targeted at devices that only support PS_2.0 level
		shaders like the Intel GMA 9xx series. In addition, this mode tries to improve
		memory bandwidth usage by rendering directly into the back buffer. There are
		several side effects:

		* You are limited to 64 ALU and 32 texture instructions per shader.
		* Only four texture read instructions per shader.
		* No support for predicate register. This affects sln/sge/seq/sne, which you
		replace with compound mov/cmp instructions, available with ps_2_0.
		* The Context3D back buffer must always be within the bounds of the stage.
		* Only one instance of a Context3D running in Constrained profile is allowed
		within a Flash Player instance.
		* Standard display list list rendering is driven by `Context3D.present()` instead of
		being based on the SWF frame rate. That is, if a Context3D object is active and
		visible you must call `Context3D.present()` to render the standard display list.
		* Reading back from the back buffer through `Context3D.drawToBitmapData()` might
		include parts of the display list content. Alpha information will be lost.
	**/
	public var BASELINE_CONSTRAINED = 1;

	/**
		Use an extended feature support profile to target newer GPUs which support larger
		textures

		This profile increases the maximum 2D Texture and RectangleTexture size to 4096x4096
	**/
	public var BASELINE_EXTENDED = 2;

	/**
		Use an standard profile to target GPUs which support MRT, AGAL2 and float textures.

		This profile supports 4 render targets. Increase AGAL commands and register count.
		Add float textures.
	**/
	public var STANDARD = 3;

	/**
		Use an standard profile to target GPUs which support AGAL2 and float textures.

		This profile is an alternative to standard profile, which removes MRT and a few
		features in AGAL2 but can reach more GPUs.
	**/
	public var STANDARD_CONSTRAINED = 4;

	/**
		Use standard extended profile to target GPUs which support AGAL3 and instanced
		drawing feature.

		This profile extends the standard profile.

		This profile is enabled on mobile platforms from AIR 17.0 and on Windows and Mac
		from AIR 18.0.
	**/
	public var STANDARD_EXTENDED = 5;

	#if air
	// public var ENHANCED = 6;
	#end
	@:from private static function fromString(value:String):Context3DProfile
	{
		return switch (value)
		{
			case "baseline": BASELINE;
			case "baselineConstrained": BASELINE_CONSTRAINED;
			case "baselineExtended": BASELINE_EXTENDED;
			case "standard": STANDARD;
			case "standardConstrained": STANDARD_CONSTRAINED;
			case "standardExtended":
				STANDARD_EXTENDED;
				#if air
				// case "enhanced": ENHANCED;
				#end
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : Context3DProfile)
		{
			case Context3DProfile.BASELINE: "baseline";
			case Context3DProfile.BASELINE_CONSTRAINED: "baselineConstrained";
			case Context3DProfile.BASELINE_EXTENDED: "baselineExtended";
			case Context3DProfile.STANDARD: "standard";
			case Context3DProfile.STANDARD_CONSTRAINED: "standardConstrained";
			case Context3DProfile.STANDARD_EXTENDED:
				"standardExtended";
				#if air
				// case Context3DProfile.ENHANCED: "enhanced";
				#end
			default: null;
		}
	}

	#if cs
	@:noCompletion @:op(A == B) private static function equals(a:Context3DProfile, b:Context3DProfile):Bool
	{
		return NullUtils.valueEquals(a, b, Int);
	}
	#end

	#if cs
	@:noCompletion @:op(A != B) private static function notEquals(a:Context3DProfile, b:Context3DProfile):Bool
	{
		return !equals(a, b);
	}
	#end
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract Context3DProfile(String) from String to String
{
	public var BASELINE = "baseline";
	public var BASELINE_CONSTRAINED = "baselineConstrained";
	public var BASELINE_EXTENDED = "baselineExtended";
	public var STANDARD = "standard";
	public var STANDARD_CONSTRAINED = "standardConstrained";
	public var STANDARD_EXTENDED = "standardExtended";
	#if air
	// public var ENHANCED = "enhanced";
	#end
}
#end
#else
typedef Context3DProfile = flash.display3D.Context3DProfile;
#end
