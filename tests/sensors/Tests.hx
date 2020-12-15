import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new AccelerometerEventTest());
		runner.addCase(new AccelerometerTest());
		Report.create(runner);
		runner.run();
	}
}
