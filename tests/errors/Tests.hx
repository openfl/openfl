import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ArgumentErrorTest());
		runner.addCase(new AsyncErrorEventTest());
		runner.addCase(new EOFErrorTest());
		runner.addCase(new ErrorEventTest());
		runner.addCase(new ErrorTest());
		runner.addCase(new IllegalOperationErrorTest());
		runner.addCase(new IOErrorEventTest());
		runner.addCase(new IOErrorTest());
		runner.addCase(new RangeErrorTest());
		runner.addCase(new SecurityErrorTest());
		runner.addCase(new TypeErrorTest());
		Report.create(runner);
		runner.run();
	}
}
