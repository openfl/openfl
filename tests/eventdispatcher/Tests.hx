import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new DataEventTest());
		runner.addCase(new EventDispatcherTest());
		runner.addCase(new EventPhaseTest());
		runner.addCase(new EventTest());
		runner.addCase(new ProgressEventTest());
		runner.addCase(new TextEventTest());
		Report.create(runner);
		runner.run();
	}
}
