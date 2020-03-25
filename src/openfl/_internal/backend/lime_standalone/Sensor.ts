namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class Sensor
{
	private static sensorByID = new Map<Int, Sensor>();
	private static sensors = new Array<Sensor>();

	public id: number;
	public onUpdate = new LimeEvent < Float -> Float -> Float -> Void > ();
	public type: SensorType;

	protected new(type: SensorType, id: number)
	{
		this.type = type;
		this.id = id;
	}

	public static getSensors(type: SensorType = null): Array<Sensor>
	{
		if (type == null)
		{
			return sensors.copy();
		}
		else
		{
			var result = [];

			for (sensor in sensors)
			{
				if (sensor.type == type)
				{
					result.push(sensor);
				}
			}

			return result;
		}
	}

	private static registerSensor(type: SensorType, id: number): Sensor
	{
		var sensor = new Sensor(type, id);

		sensors.push(sensor);
		sensorByID.set(id, sensor);

		return sensor;
	}
}
#end
