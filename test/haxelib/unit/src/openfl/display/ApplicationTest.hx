package openfl.display;

class ApplicationTest
{
	@Test public function new_()
	{
		var application = new Application();
		Assert.isNotNull(application);
	}
}
