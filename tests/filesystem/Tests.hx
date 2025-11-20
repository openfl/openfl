import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new FileModeTest());
		runner.addCase(new FileTest());
		runner.addCase(new FileStreamTest());
		Report.create(runner);
		runner.run();
	}
}
