package;

#if !flash
import openfl.display.Sprite;
import openfl.display._internal.DrawCommandBuffer;
import utest.Assert;
import utest.Test;

@:access(openfl.display._internal.DrawCommandBuffer)
class DrawCommandBufferResetTest extends Test
{
	public function testResetKeepsTheStorageItOwns()
	{
		var commands = new DrawCommandBuffer();
		commands.moveTo(1, 2);
		commands.lineTo(3, 4);

		var types = commands.types;
		var f = commands.f;

		commands.reset();

		Assert.equals(0, commands.length);
		Assert.isTrue(commands.types == types);
		Assert.isTrue(commands.f == f);
		Assert.equals(0, f.length);

		commands.lineTo(5, 6);

		Assert.equals(1, commands.length);
		Assert.isTrue(commands.f == f);
		Assert.equals(5.0, commands.f[0]);
		Assert.equals(6.0, commands.f[1]);
	}

	public function testResetLeavesSharedStorage()
	{
		var source = new DrawCommandBuffer();
		source.moveTo(1, 2);
		source.lineTo(3, 4);

		var copy = source.copy();
		Assert.isTrue(source.f == copy.f);

		source.reset();

		Assert.equals(0, source.length);
		Assert.equals(2, copy.length);
		Assert.equals(4, copy.f.length);
		Assert.equals(3.0, copy.f[2]);

		source.lineTo(7, 8);

		Assert.equals(1, source.length);
		Assert.equals(2, copy.length);
		Assert.equals(1.0, copy.f[0]);
		Assert.equals(7.0, source.f[0]);
	}

	#if (lime_cairo || (js && html5))
	public function testShapeHitTestsRepeat()
	{
		// Two fills, replayed from the same buffers for each test
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xFF0000);
		sprite.graphics.moveTo(0, 0);
		sprite.graphics.lineTo(100, 0);
		sprite.graphics.lineTo(0, 100);
		sprite.graphics.lineTo(0, 0);
		sprite.graphics.endFill();
		sprite.graphics.beginFill(0x0000FF);
		sprite.graphics.drawCircle(150, 50, 20);
		sprite.graphics.endFill();

		// hitTestPoint only answers for an object on the stage
		openfl.Lib.current.addChild(sprite);

		for (i in 0...3)
		{
			Assert.isTrue(sprite.hitTestPoint(10, 10, true));
			Assert.isFalse(sprite.hitTestPoint(90, 90, true));
			Assert.isTrue(sprite.hitTestPoint(150, 50, true));
			Assert.isFalse(sprite.hitTestPoint(125, 25, true));
		}

		openfl.Lib.current.removeChild(sprite);
	}
	#end
}
#end
