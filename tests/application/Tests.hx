import utest.Runner;
import utest.ui.Report;

class Tests
{
	public static function main()
	{
		var runner = new Runner();
		runner.addCase(new ClipboardFormatsTest());
		runner.addCase(new ClipboardTest());
		runner.addCase(new ClipboardTransferModeTest());
		runner.addCase(new FPSTest());
		runner.addCase(new LibTest());
		runner.addCase(new PreloaderTest());
		runner.addCase(new ClipboardRTFTest());
		Report.create(runner);
		runner.run();
	}
}
