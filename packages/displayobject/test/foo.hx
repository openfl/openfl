package packages.displayobject.test;

// Bubbling

var sprite = new Sprite();
var sprite2 = new Sprite();
var spriteEvent = false;
var sprite2Event = false;

var listener = function(_)
{
	spriteEvent = true;
	correctOrder = true;
}

var listener2 = function(_)
{
	sprite2Event = true;
	correctOrder = false;
}

sprite.addEventListener("event", listener);
sprite2.addEventListener("event", listener2);
sprite.addChild(sprite2);
sprite2.dispatchEvent(new Event("event"));
Assert.assert(!spriteEvent);
Assert.assert(sprite2Event);
sprite2Event = false;
sprite2.dispatchEvent(new Event("event", true));
Assert.assert(spriteEvent);
Assert.assert(sprite2Event);
Assert.assert(correctOrder);
// Capture event bubbling
#if flash // todo
var sprite = new Sprite();
var sprite2 = new Sprite();
var spriteEvent = false;
var sprite2Event = false;

var listener = function(_)
{
	spriteEvent = true;
	correctOrder = true;
}

var listener2 = function(_)
{
	sprite2Event = true;
	correctOrder = false;
}

sprite.addEventListener("event", listener, true);
sprite2.addEventListener("event", listener2, true);
sprite.addChild(sprite2);
sprite2.dispatchEvent(new Event("event"));
Assert.assert(spriteEvent);
Assert.assert(!sprite2Event);
sprite2Event = false;
sprite2.dispatchEvent(new Event("event", true));
Assert.assert(spriteEvent);
Assert.assert(!sprite2Event);
Assert.assert(correctOrder);
// ADDED

var sprite = new Sprite();
var sprite2 = new Sprite();
var called = false;
var called2 = false;

var listener = function(e:Event)
{
	called = true;
	Assert.equal(e.target, sprite);
	Assert.equal(e.currentTarget, sprite);
}

var listener2 = function(e:Event)
{
	called2 = true;
	Assert.equal(e.target, sprite);
	Assert.equal(e.currentTarget, sprite2);
}

sprite.addEventListener(Event.ADDED, listener);
sprite2.addEventListener(Event.ADDED, listener2);
sprite2.addChild(sprite);
Assert.assert(called);
Assert.assert(called2);
sprite.removeEventListener(Event.ADDED, listener);
sprite2.removeEventListener(Event.ADDED, listener2);
// ADDED_TO_STAGE
called = false;
called2 = false;
var listener = function(e:Event)
{
	called = true;
	Assert.equal(e.target, sprite);
	Assert.equal(e.currentTarget, sprite);
}

var listener2 = function(e:Event)
{
	called2 = true;
	Assert.equal(e.target, sprite2);
	Assert.equal(e.currentTarget, sprite2);
}
sprite.addEventListener(Event.ADDED_TO_STAGE, listener);
sprite2.addEventListener(Event.ADDED_TO_STAGE, listener2);
Lib.current.stage.addChild(sprite2);
Assert.assert(called);
Assert.assert(called2);
