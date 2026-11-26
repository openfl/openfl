package;

import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.StageQuality;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.filters.GlowFilter;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.ui.Keyboard;
import openfl.utils.ByteArray;
import openfl.Lib;

/**
 * Visual repro for the Cairo cache surface vs painted-region mismatch
 * described in openfl/openfl#2866.
 *
 * Reproduces the production scenario described in TM-Haxe4 commit 8ad28032
 * ("fix goal clipping in high-res video export"): a goal-like shape with a
 * vertical post hugging the right edge of its drawn bounds, parented to a
 * Sprite that carries an invisible GlowFilter — the filter triggers the
 * cacheAsBitmap render path. When the parent is scaled up between frames
 * (simulating UI->export pixelRatio jump), the upstream `>` check reuses
 * the smaller cached Cairo surface; Cairo paints the new (larger) content
 * into the old surface's sub-region; Context3DShape composites the full
 * bitmap dims via worldTransform; the right post falls outside the painted
 * sub-region and visibly disappears.
 *
 * Layout (top half = "buggy" path, bottom half = comparison):
 *
 *   TOP    : Sprite with GlowFilter(alpha=0) wrapping the goal Shape;
 *            scaleX/scaleY tween simulates pixelRatio jump.
 *   BOTTOM : Same Shape, no parent filter, same scale tween for visual
 *            reference.
 *
 * The bug is visible at the FIRST frame after a scale increase: top goal
 * shows missing right post; bottom goal is intact.
 */
class Main extends Sprite
{
	public static function main()
	{
		#if sys
		try sys.io.File.saveContent("/tmp/cairo-surface-clip.log", "main() entered\n") catch (e:Dynamic) {}
		#end
		new Main();
	}

	// Goal bounds in shape-local coords. Post thickness 8, crossbar height 8,
	// total area 220 wide x 110 tall. Right post hugs the right edge.
	static inline var GOAL_W = 220.0;
	static inline var GOAL_H = 110.0;
	static inline var POST = 8.0;
	static inline var FILL = 0xE0E0E0;
	static inline var BACKDROP = 0x2A4030; // dark green pitch
	static inline var REFERENCE_BAR = 0xFF00C0;

	var topGoalWrapper:Sprite;
	var topGoal:Shape;
	var bottomGoal:Shape;
	var stats:TextField;

	var frame:Int = 0;
	var allocBaseline:Int = 0;

	public function new()
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		Lib.current.addChild(this);
	}

	function onAdded(_)
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		stage.quality = StageQuality.BEST;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);

		drawBackground();

		// TOP: goal inside a wrapper Sprite carrying an invisible GlowFilter.
		// `DisplayObject.cacheAsBitmap` getter returns true whenever filters is
		// non-null, regardless of the field. This routes rendering through the
		// cached-bitmap path described in our PR.
		topGoal = new Shape();
		paintGoal(topGoal);
		topGoalWrapper = new Sprite();
		topGoalWrapper.x = 60;
		topGoalWrapper.y = 130;
		topGoalWrapper.filters = [new GlowFilter(0xFFFFFF, 0.0, 0, 0, 1, 1)];
		topGoalWrapper.addChild(topGoal);
		addChild(topGoalWrapper);

		// BOTTOM: same goal, no filter, no wrapper — direct path for comparison.
		bottomGoal = new Shape();
		paintGoal(bottomGoal);
		bottomGoal.x = 60;
		bottomGoal.y = 380;
		addChild(bottomGoal);

		stats = makeText();
		stats.x = 10;
		stats.y = 10;
		stats.width = 780;
		stats.height = 96;
		addChild(stats);

		allocBaseline = AllocCounter.surfaceAllocs;
		addEventListener(Event.ENTER_FRAME, onFrame);
	}

	function drawBackground()
	{
		graphics.beginFill(BACKDROP);
		graphics.drawRect(0, 0, 800, 600);
		graphics.endFill();

		// Reference vertical bars below each goal at known positions; the goal
		// occupies x = 60 .. 60 + GOAL_W*scaleMax, so bars 0..N anchor where
		// the right post SHOULD be in each render.
		graphics.beginFill(REFERENCE_BAR);
		for (i in 0...10)
		{
			var x = 60 + i * 70;
			graphics.drawRect(x, 270, 4, 12);
			graphics.drawRect(x, 530, 4, 12);
		}
		graphics.endFill();
	}

	function paintGoal(shape:Shape)
	{
		// Use drawRoundRect so the shape routes through CairoGraphics (curves
		// are not hardware-compatible; `Context3DGraphics.isCompatible` falls
		// back to the software path). Plain drawRect would bypass the bug.
		shape.graphics.clear();
		shape.graphics.beginFill(FILL);
		// Left post.
		shape.graphics.drawRoundRect(0, 0, POST, GOAL_H, 2, 2);
		// Right post — hugs right edge. The content the bug clips.
		shape.graphics.drawRoundRect(GOAL_W - POST, 0, POST, GOAL_H, 2, 2);
		// Crossbar across the top.
		shape.graphics.drawRoundRect(0, 0, GOAL_W, POST, 2, 2);
		// Back-support stripes near the right side.
		shape.graphics.drawRoundRect(GOAL_W - 30, GOAL_H - POST, 30, POST, 2, 2);
		shape.graphics.drawRoundRect(GOAL_W - 30, GOAL_H * 0.5 - POST * 0.5, 30, POST, 2, 2);
		shape.graphics.endFill();
	}

	function onKey(e:KeyboardEvent)
	{
		switch (e.keyCode)
		{
			case Keyboard.R:
				allocBaseline = AllocCounter.surfaceAllocs;
				frame = 0;
			case Keyboard.F:
				topGoalWrapper.filters = (topGoalWrapper.filters == null)
					? [new GlowFilter(0xFFFFFF, 0.0, 0, 0, 1, 1)] : null;
		}
	}

	function onFrame(_)
	{
		frame++;
		// Render schedule (60 fps):
		//   frame   1- 60 : scale = 1.0   (UI-equivalent, baseline cache size)
		//   frame  60     : capture "before jump"
		//   frame  61     : scale jumps to 3.0 (export-equivalent)
		//   frame  61     : capture "first frame after jump" — bug shows here
		//                   if Cairo surface from prev frame is reused undersized
		//   frame  90     : capture "settled at 3x"
		//   frame 120     : scale drops back to 1.0
		//   frame 121     : capture "first frame after shrink"
		var scaleNow = scaleForFrame(frame);
		topGoalWrapper.scaleX = topGoalWrapper.scaleY = scaleNow;
		bottomGoal.scaleX = bottomGoal.scaleY = scaleNow;

		updateStats(scaleNow);

		// Capture via Context3D.drawToBitmapData -> Window.readPixels = real GL
		// framebuffer. The framebuffer reflects the PREVIOUS frame's render
		// (current frame's render happens after ENTER_FRAME), so capture one
		// frame AFTER the phase change to read the post-change render.
		switch (frame)
		{
			case 55:  capture('1_settled_scale1');       // mid-phase scale=1
			case 65:  capture('2_just_after_jump');      // 5 frames after jump to 3
			case 175: capture('3_settled_scale3');       // deep into scale=3
			case 185: capture('4_just_after_shrink');    // 5 frames after drop to 1
			case 235: capture('5_settled_scale1_again'); // deep into final scale=1
		}

		if (frame >= 240)
		{
			#if sys try sys.io.File.append("/tmp/cairo-surface-clip.log", false).writeString("done\n") catch (e:Dynamic) {} #end
			removeEventListener(Event.ENTER_FRAME, onFrame);
		}
	}

	function scaleForFrame(f:Int):Float
	{
		// Long phases so the GL swap chain (typically 2-3 frames deep) has
		// fully reflected the post-change render by the time we capture.
		if (f <= 60) return 1.0;
		if (f <= 180) return 3.0;
		return 1.0;
	}

	function capture(tag:String)
	{
		#if sys
		try
		{
			var ctx = stage.context3D;
			if (ctx == null)
			{
				sys.io.File.append("/tmp/cairo-surface-clip.log", false)
					.writeString('capture $tag: no Context3D, skipping\n');
				return;
			}
			var w = Std.int(stage.stageWidth);
			var h = Std.int(stage.stageHeight);
			var bmp = new BitmapData(w, h, false, 0x000000);
			ctx.drawToBitmapData(bmp);
			var ba:ByteArray = bmp.encode(new Rectangle(0, 0, w, h), new PNGEncoderOptions());
			var path = '/tmp/cairo-surface-clip-$tag.png';
			var out = sys.io.File.write(path, true);
			ba.position = 0;
			out.writeBytes(haxe.io.Bytes.ofData(ba), 0, ba.length);
			out.close();
			sys.io.File.append("/tmp/cairo-surface-clip.log", false)
				.writeString('captured $path at frame=$frame scale=${topGoalWrapper.scaleX}\n');
		}
		catch (e:Dynamic)
		{
			#if sys
			try sys.io.File.append("/tmp/cairo-surface-clip.log", false)
				.writeString('capture $tag failed: $e\n') catch (e2:Dynamic) {}
			#end
		}
		#end
	}


	function updateStats(scaleNow:Float)
	{
		var allocs = AllocCounter.surfaceAllocs - allocBaseline;
		var cacheAllocs = AllocCounter.cacheBitmapAllocs;
		stats.text = 'frame: $frame   scale: $scaleNow\n'
			+ 'CairoGraphics surface allocs: $allocs   cacheBitmapData allocs: $cacheAllocs\n'
			+ 'TOP    : Sprite with GlowFilter(alpha=0) -> cacheAsBitmap path\n'
			+ 'Schedule: 1..60 scale=1, 61..120 scale=3, 121..180 scale=1   (r=reset, f=toggle filter)';
		if (frame % 30 == 0)
		{
			#if sys
			try sys.io.File.append("/tmp/cairo-surface-clip.log", false)
				.writeString('frame=$frame scale=$scaleNow surfaceAllocs=$allocs cacheBitmapAllocs=$cacheAllocs\n') catch (e:Dynamic) {}
			#end
		}
	}

	static function makeText():TextField
	{
		var tf = new TextField();
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.defaultTextFormat = new TextFormat("_sans", 13, 0xE0E0E0);
		return tf;
	}
}
