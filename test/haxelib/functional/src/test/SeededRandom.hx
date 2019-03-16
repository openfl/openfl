package test;

/**
 * Class: SeededRandom
 *
 * Haxe's Math.Random and Std.random don't include a way to view or set the
 * seed.  neko.Random does, but we aren't using neko. So, we have to use our
 * own random implementation for this.
 *
 * This algorithm was gotten from:
 * http://en.wikipedia.org/wiki/Multiply-with-carry#Implementation
 *
 * Create a new SeededRandom with the seed passed to the constructor, then call
 * then random(<max>) to return a random number in the range 0..(max - 1).
 */
class SeededRandom
{
	// This is the number of pregenerated starting points
	// that are rotated through
	private static inline var residues:Int = 4096;
	// I don't know what these next two numbers are. They are
	// from the sample code on Wikipedia. If you want to sort
	// through the formulas there, you can figure it out.
	private static inline var Phi:Int = 0x9e3779b9;
	private static var c:Int = 362436;

	// This is the current index of the pregenerated starting point
	private var rotation:Int;
	// This is the array of pregenerated starting points.
	private var Q:Array<Int>;

	private static var g:SeededRandom = new SeededRandom(Std.int(Date.now().getTime() * 1000));

	private function new(seed:Int)
	{
		Q = new Array<Int>();

		Q.push(seed);
		Q.push(seed + Phi);
		Q.push(seed + Phi + Phi);

		for (i in 3...residues)
		{
			Q.push(Q[i - 3] ^ Q[i - 2] ^ Phi ^ i);
		}

		rotation = residues - 1;
	}

	public static function random(max:Int):Int
	{
		return g.randomInt(max);
	}

	private function randomInt(max:Int):Int
	{
		// What are these values? I don't know--they were
		// in the sample code from wikipedia.
		var a:Int = 18782;
		var r:Int = 0xfffffffe;
		var t:Int;
		var x:Int;

		rotation = (rotation + 1) & (residues - 1);
		t = a * Q[rotation] + c;
		c = (t >> 32);
		x = t + c;
		if (x < c)
		{
			x++;
			c++;
		}
		Q[rotation] = r - x;

		// Looks like % doesn't work the way I expect--it gives
		// use negative number. So, patch that up here...
		var returnValue = Q[rotation] % max;
		while (returnValue < 0)
		{
			returnValue = returnValue + max;
		}

		return returnValue;
	}

	public static function seed(seed:Int):Void
	{
		g = new SeededRandom(seed);
	}
}
