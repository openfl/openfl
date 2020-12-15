package;

import openfl.display.Sprite;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class FocusEventTest extends Test
{
	public function test_keyCode()
	{
		var focusEvent = new FocusEvent(FocusEvent.FOCUS_IN);
		var exists = focusEvent.keyCode;

		Assert.notNull(exists);
	}

	public function test_relatedObject()
	{
		var focusEvent = new FocusEvent(FocusEvent.FOCUS_IN);
		var exists = focusEvent.relatedObject;

		Assert.isNull(exists);
	}

	public function test_shiftKey()
	{
		var focusEvent = new FocusEvent(FocusEvent.FOCUS_IN);
		var exists = focusEvent.shiftKey;

		Assert.notNull(exists);
	}

	#if !integration
	@Ignored
	#end
	public function test_new_()
	{
		// TODO: Isolate so integration is not needed

		var sprite = new Sprite();
		sprite.name = "Sprite";
		var sprite2 = new Sprite();
		sprite2.name = "Sprite2";
		sprite2.addChild(sprite);

		// Native currently requires objects to be on stage
		Lib.current.stage.addChild(sprite2);

		var called = false;
		var called2 = false;

		var spriteListener = function(e:FocusEvent)
		{
			Assert.equals(sprite, e.target);
			Assert.equals(sprite, e.currentTarget);
			Assert.isNull(e.relatedObject);

			called = true;
		}

		var sprite2Listener = function(e:FocusEvent)
		{
			called2 = true;
			// Assert.fail ("Should not call parent");
		}

		sprite.addEventListener(FocusEvent.FOCUS_IN, spriteListener);
		sprite2.addEventListener(FocusEvent.FOCUS_IN, sprite2Listener);

		Lib.current.stage.focus = sprite;
		Assert.isTrue(called);
		Assert.isTrue(called2);

		sprite.removeEventListener(FocusEvent.FOCUS_IN, spriteListener);
		sprite2.removeEventListener(FocusEvent.FOCUS_IN, sprite2Listener);

		var called = false;
		var called2 = false;

		spriteListener = function(e)
		{
			called = true;

			Assert.equals(sprite, e.target);
			Assert.equals(sprite, e.currentTarget);
			Assert.equals(sprite2, cast e.relatedObject);
		}

		sprite2Listener = function(e)
		{
			called2 = true;

			Assert.equals(sprite2, e.target);
			Assert.equals(sprite2, e.currentTarget);
			Assert.equals(sprite, cast e.relatedObject);
		}

		sprite.addEventListener(FocusEvent.FOCUS_OUT, spriteListener);
		sprite2.addEventListener(FocusEvent.FOCUS_IN, sprite2Listener);

		Lib.current.stage.focus = sprite2;

		Assert.isTrue(called);
		Assert.isTrue(called2);

		sprite.removeEventListener(FocusEvent.FOCUS_OUT, spriteListener);
		sprite2.removeEventListener(FocusEvent.FOCUS_IN, sprite2Listener);
		called2 = false;

		spriteListener = function(e:FocusEvent)
		{
			Assert.fail("Should not be called");
		}

		sprite2Listener = function(e:FocusEvent)
		{
			called2 = true;

			Assert.equals(sprite2, e.target);
			Assert.equals(sprite2, e.currentTarget);
			Assert.equals(null, e.relatedObject);
		}

		sprite.addEventListener(FocusEvent.FOCUS_OUT, spriteListener);
		sprite2.addEventListener(FocusEvent.FOCUS_OUT, sprite2Listener);

		Lib.current.stage.focus = null;
		Assert.isTrue(called2);

		Lib.current.stage.removeChild(sprite2);

		// Our checker...
		var expect:Array<Dynamic> = [];
		var checkEvent = function(e:FocusEvent)
		{
			var nextEvt = expect.shift();
			Assert.notNull(nextEvt);
			Assert.equals(cast nextEvt.type, e.type);
			Assert.equals(cast nextEvt.phase, cast e.eventPhase);
			Assert.equals(cast nextEvt.cur, cast e.currentTarget);
			Assert.equals(cast nextEvt.tgt, cast e.target);
			Assert.equals(cast nextEvt.rel, e.relatedObject);
		}

		// Build this scene graph...
		//
		//	  /--> old1 ---> old2
		// root-
		//	  \--> new1 ---> new2
		//
		// And move the focus from old2 to new2.

		// Set up the scene graph...
		var root = new Sprite();
		var old1 = new Sprite();
		var old2 = new Sprite();
		var new1 = new Sprite();
		var new2 = new Sprite();
		root.addChild(old1);
		old1.addChild(old2);
		root.addChild(new1);
		new1.addChild(new2);

		// Native currently requires objects to be on stage
		Lib.current.stage.addChild(root);

		// Here's our expected event sequence for this test...
		var OUT = FocusEvent.FOCUS_OUT;
		var IN = FocusEvent.FOCUS_IN;
		var CAP = EventPhase.CAPTURING_PHASE;
		var TGT = EventPhase.AT_TARGET;
		var BUB = EventPhase.BUBBLING_PHASE;
		var expectedSeq = [
			{
				type: OUT,
				phase: CAP,
				cur: root,
				tgt: old2,
				rel: new2
			},
			{
				type: OUT,
				phase: CAP,
				cur: old1,
				tgt: old2,
				rel: new2
			},
			{
				type: OUT,
				phase: TGT,
				cur: old2,
				tgt: old2,
				rel: new2
			},
			{
				type: OUT,
				phase: BUB,
				cur: old1,
				tgt: old2,
				rel: new2
			},
			{
				type: OUT,
				phase: BUB,
				cur: root,
				tgt: old2,
				rel: new2
			},
			{
				type: IN,
				phase: CAP,
				cur: root,
				tgt: new2,
				rel: old2
			},
			{
				type: IN,
				phase: CAP,
				cur: new1,
				tgt: new2,
				rel: old2
			},
			{
				type: IN,
				phase: TGT,
				cur: new2,
				tgt: new2,
				rel: old2
			},
			{
				type: IN,
				phase: BUB,
				cur: new1,
				tgt: new2,
				rel: old2
			},
			{
				type: IN,
				phase: BUB,
				cur: root,
				tgt: new2,
				rel: old2
			}
		];

		// First put focus on the old...
		Lib.current.stage.focus = old2;

		// Now register our listeners...
		//
		// We should be able to reuse listener; see addEventListener:
		// "subsequent calls to addEventListener() with a different type
		// or useCapture value result in the creation of a separate
		// listener registration."
		for (s in [root, old1, old2, new1, new2])
		{
			s.addEventListener(FocusEvent.FOCUS_IN, checkEvent);
			s.addEventListener(FocusEvent.FOCUS_IN, checkEvent, true);
			s.addEventListener(FocusEvent.FOCUS_OUT, checkEvent);
			s.addEventListener(FocusEvent.FOCUS_OUT, checkEvent, true);
		}

		// Set up the expected sequence for the checker...
		expect = expectedSeq;

		// Now move the focus and see if it conforms...
		Lib.current.stage.focus = new2;

		// Ensure that all events were actually delivered...
		Assert.equals(0, expect.length);

		Lib.current.stage.removeChild(root);
	}
}
