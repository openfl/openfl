namespace openfl._internal.backend.lime;

#if lime
import lime.system.Sensor;
import lime.system.SensorType;
import openfl.sensors.Accelerometer;

@: access(openfl.sensors.Accelerometer)
class LimeAccelerometerBackend
{
	public static initialize(): void
	{
		var sensors = Sensor.getSensors(SensorType.ACCELEROMETER);

		if (sensors.length > 0)
		{
			sensors[0].onUpdate.add(accelerometer_onUpdate);
			Accelerometer.supported = true;
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
