import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new DateTimeFormatterTest());
		runner.addCase(new DateTimeNameContextTest());
		runner.addCase(new DateTimeNameStyleTest());
		runner.addCase(new DateTimeStyleTest());
		runner.addCase(new LastOperationStatusTest());
		Report.create(runner);
		runner.run();
	}
}
