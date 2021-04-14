import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new HTTPStatusEventTest());
		runner.addCase(new NetStatusEventTest());
		runner.addCase(new URLRequestHeaderTest());
		runner.addCase(new URLRequestMethodTest());
		runner.addCase(new URLRequestTest());
		runner.addCase(new URLVariablesTest());
		Report.create(runner);
		runner.run();
	}
}
