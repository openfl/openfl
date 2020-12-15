import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new SharedObjectFlushStatusTest());
		runner.addCase(new SharedObjectTest());
		Report.create(runner);
		runner.run();
	}
}
