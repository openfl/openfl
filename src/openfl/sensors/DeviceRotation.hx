package openfl.sensors;

#if (!flash && sys)
import openfl.errors.IllegalOperationError;

/**
	The DeviceRotation class dispatches events based on activity detected by the
	device's accelerometer, gyroscope sensors. This data represents the device's
	roll, pitch, yaw and quaternions. When the device rotates, the sensors
	detect this rotation and return this data. The DeviceRotation class provides
	methods to query whether or not device rotation event handling is supported,
	and also to set the rate at which device rotation events are dispatched.

	Note: Use the `DeviceRotation.isSupported` property to test the runtime
	environment for the ability to use this feature. While the DeviceRotation
	class and its members are accessible for multiple runtime platforms an
	devices, this does not imply that the handler is always supported at
	runtime. There are a few cases such as Android version etc where this
	handler is not supported, so you must check the support of this handler by
	using `DeviceRotation.isSupported` property. If
	`DeviceRotation.isSupported` is `true` at runtime, then DeviceRotation
	support currently exists.

	_OpenFL target support:_ Not currently supported, except when targeting AIR.

	_Adobe AIR profile support:_ This feature is supported only on mobile
	devices. It is not supported on desktop or AIR for TV devices. See
	[AIR Profile Support](https://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.
**/
class DeviceRotation
{
	/**
		The isSupported property is set to `true` if the accelerometer and
		gyroscope sensors are available on the device, otherwise it is set to
		`false`.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		return false;
	}

	/**
		Specifies whether the user has denied access to the Device Rotation data
		(`true`) or allowed access (`false`). When this value changes, a
		`status` event is dispatched.
	**/
	public var muted(default, never):Bool = false;

	/**
		Creates a new DeviceRotation instance.
	**/
	public function new()
	{
		throw new IllegalOperationError("Not supported");
	}

	/**
		The setRequestedUpdateInterval method is used to set the desired time
		interval for updates. The time interval is measured in milliseconds. The
		update interval is only used as a hint to conserve the battery power.
		The actual time between device rotation vector updates may be greater or
		lesser than this value. Any change in the update interval affects all
		registered listeners. You can use the DeviceRotation class without
		calling the setRequestedUpdateInterval() method. In this case, the
		application receives updates based on the device's default interval.
	**/
	public function setRequestedUpdateInterval(interval:Float):Void {}
}
#else
#if air
typedef DeviceRotation = flash.desktop.DeviceRotation;
#end
#end
