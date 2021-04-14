import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ActivityEventTest());
		runner.addCase(new GameInputEventTest());
		runner.addCase(new KeyboardEventTest());
		runner.addCase(new KeyboardTest());
		runner.addCase(new MouseEventTest());
		runner.addCase(new MouseTest());
		runner.addCase(new MultitouchInputModeTest());
		runner.addCase(new MultitouchTest());
		runner.addCase(new TouchEventTest());
		Report.create(runner);
		runner.run();
	}
}
