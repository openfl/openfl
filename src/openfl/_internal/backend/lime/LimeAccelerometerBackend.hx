package openfl._internal.backend.lime;

#if lime
import lime.system.Sensor;
import lime.system.SensorType;
import openfl.sensors.Accelerometer;

@:access(openfl.sensors.Accelerometer)
class LimeAccelerometerBackend
{
	public static function initialize():Void
	{
		var sensors = Sensor.getSensors(SensorType.ACCELEROMETER);

		if (sensors.length > 0)
		{
			sensors[0].onUpdate.add(accelerometer_onUpdate);
			Accelerometer.supported = true;
		}
	}

	// Event Handlers
	private static function accelerometer_onUpdate(x:Float, y:Float, z:Float):Void
	{
		Accelerometer.currentX = x;
		Accelerometer.currentY = y;
		Accelerometer.currentZ = z;
	}
}
#end
