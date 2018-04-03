package openfl.events;


import openfl.display.Stage;
import openfl.display.DisplayObject;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.display.Bitmap;
import openfl.geom.Point;
import massive.munit.Assert;
import openfl.display.Sprite;


class MouseEventTest {
	
	var points: Array<MousePoint>;
	var targets: Array<String>;
	var currentTargets: Array<String>;
	
	var stage: Stage;
	var grandParent: Sprite;
	var parent_: Sprite;
	var child_: Sprite;
	var grandChild2: Sprite;
	var grandChild1: Bitmap;
	
	
	@BeforeClass public function setUp () {
		
		points = new Array<MousePoint>();
		targets = new Array<String>();
		currentTargets = new Array<String>();
		
		// Mouse Over points
		points.push(new MousePoint(new Point(145, 555), true));
		points.push(new MousePoint(new Point(290, 580), false));
		points.push(new MousePoint(new Point(290, 510), true));
		points.push(new MousePoint(new Point(380, 400), false));
		points.push(new MousePoint(new Point(320, 310), true));
		points.push(new MousePoint(new Point(140, 190), false));
		points.push(new MousePoint(new Point(80, 60), true));
		points.push(new MousePoint(new Point(40, 10), true));
		
		
		stage = Lib.current.stage;
		
		// Display structure
		grandParent = new Sprite();
		var gpTitle: TextField = new TextField();
		gpTitle.text = "GRANDPARENT";
		gpTitle.name = "grandParentTf";
		grandParent.name = "grandParent";
		grandParent.addChild(gpTitle);
		stage.addChild(grandParent);
		
		parent_ = new Sprite();
		var pTitle: TextField = new TextField();
		pTitle.textColor = 0xFFFFFF;
		pTitle.height = 25;
		pTitle.text = "PARENT";
		pTitle.name = "parent_Tf";
		parent_.name = "parent_";
		parent_.graphics.beginFill(0xFF0000);
		parent_.graphics.drawRect(0, 0, 200, 200);
		parent_.graphics.endFill();
		parent_.addChild(pTitle);
		parent_.x = parent_.y = 50; 
		grandParent.addChild(parent_);
		
		child_ = new Sprite();
		var cTitle: TextField = new TextField();
		cTitle.textColor = 0xFFFFFF;
		cTitle.height = 25;
		cTitle.text = "CHILD";
		cTitle.name = "child_Tf";
		child_.name = "child_";
		child_.graphics.beginFill(0x0000FF);
		child_.graphics.drawRect(0, 0, 150, 150);
		child_.graphics.endFill();
		child_.addChild(cTitle);
		child_.x = child_.y = 250; 
		parent_.addChild(child_);
	
		grandChild1 = new Bitmap(new BitmapData(100,100, false, 0xFF00FF));
		grandChild1.name = "grandChild1";
		grandChild1.x = -200;
		grandChild1.y = 200; 
		child_.addChild(grandChild1);
		
		grandChild2 = new Sprite();
		var gcTitle: TextField = new TextField();
		gcTitle.textColor = 0xFFFFFF;
		gcTitle.height = 25;
		gcTitle.text = "GRANDCHILD 2";
		gcTitle.name = "grandChild2Tf";
		grandChild2.name = "grandChild2";
		grandChild2.graphics.beginFill(0x00FF00);
		grandChild2.graphics.drawRect(0, 0, 100, 100);
		grandChild2.graphics.endFill();
		grandChild2.addChild(gcTitle);
		grandChild2.x = -50;
		grandChild2.y = 200; 
		child_.addChild(grandChild2);
		
		var grandChild2Cover: Sprite = new Sprite();
		grandChild2Cover.x = -50;
		grandChild2Cover.y = 200;
		grandChild2Cover.name = "grandChild2Cover";
		grandChild2Cover.graphics.beginFill(0x0000FF);
		grandChild2Cover.graphics.drawRect(0, 0, grandChild2.width, grandChild2.height);
		grandChild2Cover.graphics.endFill();
		grandChild2Cover.mouseEnabled = grandChild2Cover.mouseChildren = false;
		child_.addChild(grandChild2Cover);
		
		var coverBmp = new Bitmap(new BitmapData(2000, 2000, false, 0xFF00FF));
		coverBmp.name = "coverBmp";
		var cover = new Sprite();
		cover.addChild(coverBmp);
		cover.mouseEnabled = false;
		cover.name = "wholeCoverWithBitmapChild";
		stage.addChild(cover);
		
		var coverSprite = new Sprite();
		coverSprite.graphics.beginFill(0x00FF00);
		coverSprite.graphics.drawRect(0, 0, 2000, 2000);
		coverSprite.graphics.endFill();
		coverSprite.mouseEnabled = false;
		coverSprite.name = "wholeCoverSprite";
		stage.addChild(coverSprite);
		
		grandParent.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		parent_.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		child_.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		grandChild2.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		
	}
	
	
	@AfterClass public function tearDown() {
		
		grandParent.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		parent_.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		child_.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		grandChild2.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		stage.removeChild(grandParent);
		
	}
	
	
	private function onMouseOver(e:MouseEvent) {
		
		targets.push(cast(e.target, DisplayObject).name);
		currentTargets.push(cast(e.currentTarget, DisplayObject).name);
		
	}
	
	function simulateMouseMove() {
		for (point in points) {
			// mouse Over
			stage.onMouseMove (stage.window, point.point.x, point.point.y);
			//mouse out
			if (point.triggerMouseOut) {
				stage.onMouseMove (stage.window, 2000, 2000);
			}
		}
	}
	
	@Test public function testMouseEventsContainerAndChildrenEnabled() {
		
		// expected values are how flash events would behave
		var expectedTargets = [ "child_", "child_", "child_", 
								"grandChild2", "grandChild2", "grandChild2", "grandChild2", 
								"grandChild2Tf", "grandChild2Tf", "grandChild2Tf", "grandChild2Tf",
								"child_", "child_", "child_",
								"child_Tf", "child_Tf", "child_Tf",
								"parent_", "parent_",
								"parent_Tf", "parent_Tf",
								"grandParentTf"];
		var expectedCurrentTargets = [  "child_", "parent_", "grandParent", 
										"grandChild2", "child_", "parent_", "grandParent",
										"grandChild2", "child_", "parent_", "grandParent",
										"child_", "parent_", "grandParent",
										"child_", "parent_", "grandParent",
										"parent_", "grandParent",
										"parent_", "grandParent",
										"grandParent"];
		child_.mouseEnabled = true;
		child_.mouseChildren = true;
		targets.splice(0, targets.length);
		currentTargets.splice(0, currentTargets.length);
		simulateMouseMove();
		
		var equalAsExpected = targets.length > 0;
		for (i in 0...targets.length) {
			if (targets[i] != expectedTargets[i]) {
				equalAsExpected = false;
				break;
			}
		}
		
		if (equalAsExpected) {
			for (i in 0...currentTargets.length) {
				if (currentTargets[i] != expectedCurrentTargets[i]) {
					equalAsExpected = false;
					break;
				}
			}
		}
		
		Assert.isTrue(equalAsExpected);
		
	}
	
	
	@Test public function testMouseEventsContainerAndChildrenDisabled() {
		
		// expected values are how flash events would behave
		var expectedTargets = [ "parent_", "parent_",
								"parent_", "parent_",
								"parent_", "parent_",
								"parent_", "parent_",
								"parent_Tf", "parent_Tf",
								"grandParentTf"];
		var expectedCurrentTargets = [  "parent_", "grandParent",
										"parent_", "grandParent", 
										"parent_", "grandParent",
										"parent_", "grandParent",
										"parent_", "grandParent",
										"grandParent"];
		child_.mouseEnabled = false;
		child_.mouseChildren = false;
		targets.splice(0, targets.length);
		currentTargets.splice(0, currentTargets.length);
		simulateMouseMove();
		
		var equalAsExpected = targets.length > 0;
		for (i in 0...targets.length) {
			if (targets[i] != expectedTargets[i]) {
				equalAsExpected = false;
				break;
			}
		}
		
		if (equalAsExpected) {
			for (i in 0...currentTargets.length) {
				if (currentTargets[i] != expectedCurrentTargets[i]) {
					equalAsExpected = false;
					break;
				}
			}
		}
		
		Assert.isTrue(equalAsExpected);
		
	}
	
	
	@Test public function testMouseEventsContainerEnabledAndChildrenDisabled() {
		
		// expected values are how flash events would behave
		var expectedTargets = [ "child_", "child_", "child_", 
								"child_", "child_", "child_",
								"child_", "child_", "child_",
								"parent_", "parent_",
								"parent_Tf", "parent_Tf",
								"grandParentTf"];
		var expectedCurrentTargets = [  "child_", "parent_", "grandParent", 
										"child_", "parent_", "grandParent", 
										"child_", "parent_", "grandParent",
										"parent_", "grandParent",
										"parent_", "grandParent",
										"grandParent"];
		
		child_.mouseEnabled = true;
		child_.mouseChildren = false;
		targets.splice(0, targets.length);
		currentTargets.splice(0, currentTargets.length);
		simulateMouseMove();
		
		var equalAsExpected = targets.length > 0;
		for (i in 0...targets.length) {
			if (targets[i] != expectedTargets[i]) {
				equalAsExpected = false;
				break;
			}
		}
		
		if (equalAsExpected) {
			for (i in 0...currentTargets.length) {
				if (currentTargets[i] != expectedCurrentTargets[i]) {
					equalAsExpected = false;
					break;
				}
			}
		}
		
		Assert.isTrue(equalAsExpected);
		
	}
	
	
	@Test public function testMouseEventsContainerDisabledAndChildrenEnabled() {
		
		// expected values are how flash events would behave
		var expectedTargets = [ "parent_", "parent_",
								"grandChild2", "grandChild2", "grandChild2", "grandChild2", 
								"grandChild2Tf", "grandChild2Tf", "grandChild2Tf", "grandChild2Tf",
								"parent_", "parent_",
								"child_Tf", "child_Tf", "child_Tf",
								"parent_", "parent_",
								"parent_Tf", "parent_Tf",
								"grandParentTf"];
		var expectedCurrentTargets = [  "parent_", "grandParent", 
										"grandChild2", "child_", "parent_", "grandParent",
										"grandChild2", "child_", "parent_", "grandParent",
										"parent_", "grandParent",
										"child_", "parent_", "grandParent",
										"parent_", "grandParent",
										"parent_", "grandParent",
										"grandParent"];

		child_.mouseEnabled = false;
		child_.mouseChildren = true;
		targets.splice(0, targets.length);
		currentTargets.splice(0, currentTargets.length);
		simulateMouseMove();
		
		var equalAsExpected = targets.length > 0;
		for (i in 0...targets.length) {
			if (targets[i] != expectedTargets[i]) {
				equalAsExpected = false;
				break;
			}
		}
		
		if (equalAsExpected) {
			for (i in 0...currentTargets.length) {
				if (currentTargets[i] != expectedCurrentTargets[i]) {
					equalAsExpected = false;
					break;
				}
			}
		}
		
		Assert.isTrue(equalAsExpected);
		
	}
	
	
	@Test public function altKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.altKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function buttonDown () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.buttonDown;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ctrlKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.ctrlKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function delta () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.delta;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localX () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localX;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function localY () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localY;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function relatedObject () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		mouseEvent.relatedObject = new Sprite ();
		var exists = mouseEvent.relatedObject;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function shiftKey () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.shiftKey;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stageX () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageX;
		
		Assert.isNaN (exists);
		
	}
	
	
	@Test public function stageY () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageY;
		
		Assert.isNaN (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		Assert.isNotNull (mouseEvent);
		
	}
	
	
	@Test public function updateAfterEvent () {
		
		// TODO: Confirm functionality
		
		var mouseEvent = new MouseEvent (MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.updateAfterEvent;
		
		Assert.isNotNull (exists);
		
	}
	
	
}

private class MousePoint {
	
	
	public var point: Point; 
	public var triggerMouseOut: Bool;
	
	
	public function new(point: Point, mouseOut:Bool) {
		
		this.point = point;
		triggerMouseOut = mouseOut;
		
	}
	
	
}