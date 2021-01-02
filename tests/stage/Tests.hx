import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new FullScreenEventTest());
		runner.addCase(new StageAlignTest());
		runner.addCase(new StageDisplayStateTest());
		runner.addCase(new StageQualityTest());
		runner.addCase(new StageScaleModeTest());
		runner.addCase(new StageTest());
		Report.create(runner);
		runner.run();
	}
}
