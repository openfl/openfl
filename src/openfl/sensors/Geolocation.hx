package openfl.sensors;

#if (!flash && sys)
import openfl.errors.IllegalOperationError;
import openfl.permissions.PermissionStatus;

/**
	The Geolocation class dispatches events in response to the device's location
	sensor.

	If a device supports geolocation, you can use this class to obtain the
	current geographical location of the device. The geographical location is
	displayed on the device in the form of latitudinal and longitudinal
	coordinates (in WGS-84 standard format). When the location of the device
	hanges, you can receive updates about the changes. If the device supports
	this feature, you will be able to obtain information about the altitude,
	accuracy, heading, speed, and timestamp of the latest change in the
	location.

	You can test for support at run time using the `Geolocation.isSupported`
	property.

	_OpenFL target support:_ Not currently supported, except when targeting AIR.

	_Adobe AIR profile support:_ This feature is supported only on mobile
	devices. It is not supported on desktop or AIR for TV devices. See
	[AIR Profile Support](https://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	Note: To enable Geolocation in iOS, ensure that you add a key-value pair to
	the `infoAdditions` element in the application xml file. See
	[iOS Settings](http://help.adobe.com/en_US/air/build/WSfffb011ac560372f7e64a7f12cd2dd1867-8000.html)
	for more information on the `infoAdditions` element.
**/
class Geolocation
{
	/**
		The best level of accuracy available.
	**/
	public static final LOCATION_ACCURACY_BEST:String = "locationAccuracyBest";

	/**
		The highest possible accuracy that uses additional sensor data to
		facilitate navigation apps.
	**/
	public static final LOCATION_ACCURACY_BEST_FOR_NAVIGATION:String = "locationAccuracyBestForNavigation";

	/**
		Accurate to within one hundred meters.
	**/
	public static final LOCATION_ACCURACY_HUNDRED_METERS:String = "locationAccuracyHundredMeters";

	/**
		Accurate to the nearest kilometer.
	**/
	public static final LOCATION_ACCURACY_KILOMETER:String = "locationAccuracyKilometer";

	/**
		Accurate to within ten meters of the desired target.
	**/
	public static final LOCATION_ACCURACY_NEAREST_TEN_METERS:String = "locationAccuracyNearestTenMeters";

	/**
		Accurate to the nearest three kilometers.
	**/
	public static final LOCATION_ACCURACY_THREE_KILOMETERS:String = "locationAccuracyThreeKilometers";

	/**
		Whether a location sensor is available on the device (`true`);
		otherwise `false`.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		return false;
	}

	/**
		This property determines the accuracy of the geolocation data on iOS.
		Setting `pausesLocationUpdatesAutomatically` to `false` can cause
		battery drain as it keeps fetching geolocation data. Accuracy can be set
		to `LOCATION_ACCURACY_BEST_FOR_NAVIGATION`, `LOCATION_ACCURACY_BEST`,
		`LOCATION_ACCURACY_NEAREST_TEN_METERS`,
		`LOCATION_ACCURACY_HUNDRED_METERS`, `LOCATION_ACCURACY_KILOMETER` or
		`LOCATION_ACCURACY_THREE_KILOMETERS` based on the app's usage scenario.
		Set the property after calling `requestPermission()` and enabling
		location services in background. The default value of the property is
		`LOCATION_ACCURACY_BEST` which is the best level of accuracy available.
	**/
	public var desiredAccuracy:String = LOCATION_ACCURACY_BEST;

	/**
		This property determines the access permission type usage of
		geolocation. The permission type can be Always or When In Use. If the
		property is set to `false`, it requests When In Use permission else it
		requests Always use permission. Set the property before calling
		`requestPermission()`. The default value of the property is `false`.
	**/
	public var locationAlwaysUsePermission:Bool = false;

	/**
		Specifies whether the user has denied access to the geolocation (`true`)
		or allowed access (`false`). When this value changes, a `status` event
		is dispatched.
	**/
	public var muted(default, never):Bool = false;

	/**
		This property determines whether the geolocation services should pause
		due to app inactivity when application goes into background (on iOS).
		The value can be `true` or `false`. If the property is set to `false`,
		it ensures continous updates of geolocation services. Set the property
		after calling `requestPermission()` and enabling location services in
		background. The default value of the property is true.
	**/
	public var pausesLocationUpdatesAutomatically:Bool = true;

	/**
		Determine whether the application has been granted the permission to
		access Geolocation.
	**/
	public var permissionStatus(default, never):PermissionStatus = UNKNOWN;

	/**
		Creates a new Geolocation instance.
	**/
	public function new()
	{
		throw new IllegalOperationError("Not supported");
	}

	/**
		Requests permission to access Geolocation.
	**/
	public function requestPermission():Void {}

	/**
		Used to set the time interval for updates, in milliseconds. The update
		interval is only used as a hint to conserve the battery power. The
		actual time between location updates may be greater or lesser than this
		value. Any change in the update interval using this method affects all
		registered update event listeners. The Geolocation class can be used
		without calling the `setRequestedUpdateInterval()` method. In this case,
		the platform will return updates based on its default interval.

		Note: First-generation iPhones, which do not include a GPS unit,
		dispatch `update` events only occasionally. On these devices, a
		Geolocation object initially dispatches one or two `update` events. It
		then dispatches `update` events when information changes noticeably.
	**/
	public function setRequestedUpdateInterval(interval:Float):Void {}
}
#else
#if air
typedef Geolocation = flash.desktop.Geolocation;
#end
#end
