package;

#if !flash
import openfl.display.Preloader;
#end
import utest.Assert;
import utest.Test;

class PreloaderTest extends Test
{
	#if flash
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Confirm functionality

		#if !flash
		var preloader = new Preloader();
		var exists = preloader;

		Assert.notNull(exists);
		#end
	}
}
