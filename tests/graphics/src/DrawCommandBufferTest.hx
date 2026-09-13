package;

#if !flash
import openfl.display.GradientType;
import openfl.display.InterpolationMethod;
import openfl.display.SpreadMethod;
import openfl.display._internal.DrawCommandBuffer;
import utest.Assert;
import utest.Test;

@:access(openfl.display._internal.DrawCommandBuffer)
class DrawCommandBufferTest extends Test
{
	public function testStorageIsAllocatedOnlyWhenUsed()
	{
		var empty = new DrawCommandBuffer();
		var commands = new DrawCommandBuffer();

		commands.beginFill(0xFF0000, 1);

		Assert.isFalse(commands.types == empty.types);
		Assert.isFalse(commands.i == empty.i);
		Assert.isFalse(commands.f == empty.f);
		Assert.isTrue(commands.b == empty.b);
		Assert.isTrue(commands.o == empty.o);
		Assert.isTrue(commands.ff == empty.ff);
		Assert.isTrue(commands.ii == empty.ii);

		commands.beginBitmapFill(null, null, true, false);

		Assert.isFalse(commands.b == empty.b);
		Assert.isFalse(commands.o == empty.o);
		Assert.isTrue(commands.ff == empty.ff);
		Assert.isTrue(commands.ii == empty.ii);

		commands.beginGradientFill(GradientType.LINEAR, [0], [1], [0], null, SpreadMethod.PAD, InterpolationMethod.RGB, 0);

		Assert.isFalse(commands.ff == empty.ff);
		Assert.isFalse(commands.ii == empty.ii);
	}

	public function testCopyOnWriteIsIndependentPerStorage()
	{
		var source = new DrawCommandBuffer();
		source.beginFill(0xFF0000, 1);
		source.drawRect(0, 0, 10, 10);

		var copy = source.copy();

		Assert.isTrue(source.types == copy.types);
		Assert.isTrue(source.i == copy.i);
		Assert.isTrue(source.f == copy.f);

		copy.lineTo(20, 20);

		Assert.isFalse(source.types == copy.types);
		Assert.isTrue(source.i == copy.i);
		Assert.isFalse(source.f == copy.f);
		Assert.equals(2, source.length);
		Assert.equals(3, copy.length);

		source.beginFill(0x00FF00, 0.5);

		Assert.isFalse(source.i == copy.i);
		Assert.equals(2, source.i.length);
		Assert.equals(1, copy.i.length);
		Assert.equals(3, source.length);
		Assert.equals(3, copy.length);
	}

	public function testClearRestoresLazyStorage()
	{
		var empty = new DrawCommandBuffer();
		var commands = new DrawCommandBuffer();

		commands.beginGradientFill(GradientType.LINEAR, [0], [1], [0], null, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
		commands.clear();
		commands.beginFill(0xFF0000, 1);

		Assert.isFalse(commands.types == empty.types);
		Assert.isFalse(commands.i == empty.i);
		Assert.isFalse(commands.f == empty.f);
		Assert.isTrue(commands.b == empty.b);
		Assert.isTrue(commands.o == empty.o);
		Assert.isTrue(commands.ff == empty.ff);
		Assert.isTrue(commands.ii == empty.ii);
	}
}
#end
