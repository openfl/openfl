package openfl.sensors;

#if (!flash && sys)
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
		Whether a location sensor is available on the device (`true`);
		otherwise `false`.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		return false;
	}
}
#else
#if air
typedef Geolocation = flash.desktop.Geolocation;
#end
#end
