namespace openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.backend.lime_standalone.Sensor;
import openfl._internal.backend.lime_standalone.SensorType;

@: access(openfl.ui.Accelerometer)
class HTML5AccelerometerBackend
{
	public static initialize(): void
	{
		var sensors = Sensor.getSensors(SensorType.ACCELEROMETER);

		if (sensors.length > 0)
		{
			sensors[0].onUpdate.add(accelerometer_onUpdate);
			supported = true;
		}
	}

	// Event Handlers
	private static accelerometer_onUpdate(x: number, y: number, z: number): void
	{
		Accelerometer.currentX = x;
		Accelerometer.currentY = y;
		Accelerometer.currentZ = z;
	}
}
#end
