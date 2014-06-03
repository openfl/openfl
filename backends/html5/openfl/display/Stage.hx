package openfl.display;


import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.Element;
import js.html.HtmlElement;
import js.Browser;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;


@:access(openfl.events.Event)
@:access(openfl.display.Sprite)
class Stage extends Sprite {
	
	
	public var align:StageAlign;
	public var allowsFullScreen:Bool;
	public var color (get, set):Int;
	public var displayState(default, set):StageDisplayState;
	public var focus (get, set):InteractiveObject;
	public var frameRate:Float;
	public var quality:StageQuality;
	public var stageFocusRect:Bool;
	public var scaleMode:StageScaleMode;
	public var stageHeight (default, null):Int;
	public var stageWidth (default, null):Int;
	
	//private var __canvas:CanvasElement;
	private var __clearBeforeRender:Bool;
	private var __color:Int;
	private var __colorString:String;
	private var __context:CanvasRenderingContext2D;
	private var __cursor:String;
	private var __cursorHidden:Bool;
	private var __dirty:Bool;
	private var __div:DivElement;
	private var __dragBounds:Rectangle;
	private var __dragObject:Sprite;
	private var __dragOffsetX:Float;
	private var __dragOffsetY:Float;
	private var __element:HtmlElement;
	private var __focus:InteractiveObject;
	private var __fullscreen:Bool;
	private var __invalidated:Bool;
	private var __mouseX:Float = 0;
	private var __mouseY:Float = 0;
	private var __originalWidth:Int;
	private var __originalHeight:Int;
	private var __renderSession:RenderSession;
	private var __stack:Array<DisplayObject>;
	#if stats
	private var __stats:Dynamic;
	#end
	private var __transparent:Bool;
	private var __wasDirty:Bool;
	
	
	public function new (width:Int, height:Int, element:HtmlElement = null, color:Null<Int> = null) {
		
		super ();
		
		this.__element = element;
		
		if (color == null) {
			
			__transparent = true;
			this.color = 0x000000;
			
		} else {
			
			this.color = color;
			
		}
		
		this.name = null;
		
		__mouseX = 0;
		__mouseY = 0;
		
		#if !dom
		
		if (Std.is (__element, CanvasElement)) {
			
			__canvas = cast __element;
			
		} else {
			
			__canvas = cast Browser.document.createElement ("canvas");
			
		}
		
		if (__transparent) {
			
			__context = cast __canvas.getContext ("2d");
			
		} else {
			
			__canvas.setAttribute ("moz-opaque", "true");
			__context = untyped __js__ ('this.__canvas.getContext ("2d", { alpha: false })');
			
		}
		
		//untyped (__context).mozImageSmoothingEnabled = false;
		//untyped (__context).webkitImageSmoothingEnabled = false;
		//__context.imageSmoothingEnabled = false;
		
		var style = __canvas.style;
		style.setProperty ("-webkit-transform", "translateZ(0)", null);
		style.setProperty ("transform", "translateZ(0)", null);
		
		#else
		
		__div = cast Browser.document.createElement ("div");
		
		var style = __div.style;
		
		if (!__transparent) {
			
			style.backgroundColor = __colorString;
			
		}
		
		style.setProperty ("-webkit-transform", "translate3D(0,0,0)", null);
		style.setProperty ("transform", "translate3D(0,0,0)", null);
		//style.setProperty ("-webkit-transform-style", "preserve-3d", null);
		//style.setProperty ("transform-style", "preserve-3d", null);
		style.position = "relative";
		style.overflow = "hidden";
		style.setProperty ("-webkit-user-select", "none", null);
		style.setProperty ("-moz-user-select", "none", null);
		style.setProperty ("-ms-user-select", "none", null);
		style.setProperty ("-o-user-select", "none", null);
		
		// Disable image drag on Firefox
		Browser.document.addEventListener ("dragstart", function (e) {
			if (e.target.nodeName.toLowerCase() == "img") {
				e.preventDefault();
				return false;
			}
			return true;
		}, false);
		
		#end
		
		__originalWidth = width;
		__originalHeight = height;
		
		if (width == 0 && height == 0) {
			
			if (element != null) {
				
				width = element.clientWidth;
				height = element.clientHeight;
				
			} else {
				
				width = Browser.window.innerWidth;
				height = Browser.window.innerHeight;
				
			}
			
			__fullscreen = true;
			
		}
		
		stageWidth = width;
		stageHeight = height;
		
		if (__canvas != null) {
			
			__canvas.width = width;
			__canvas.height = height;
			
		} else {
			
			__div.style.width = width + "px";
			__div.style.height = height + "px";
			
		}
		
		__resize ();
		Browser.window.addEventListener ("resize", window_onResize);
		Browser.window.addEventListener ("focus", window_onFocus);
		Browser.window.addEventListener ("blur", window_onBlur);
		
		if (element != null) {
			
			if (__canvas != null) {
				
				if (element != cast __canvas) {
					
					element.appendChild (__canvas);
					
				}
				
			} else {
				
				element.appendChild (__div);
				
			}
			
		}
		
		this.stage = this;
		
		align = StageAlign.TOP_LEFT;
		allowsFullScreen = false;
		displayState = StageDisplayState.NORMAL;
		frameRate = 60;
		quality = StageQuality.HIGH;
		scaleMode = StageScaleMode.NO_SCALE;
		stageFocusRect = true;
		
		__clearBeforeRender = true;
		__stack = [];
		
		__renderSession = new RenderSession ();
		__renderSession.context = __context;
		__renderSession.roundPixels = true;
		
		if (__div != null) {
			
			__renderSession.element = __div;
			var prefix = untyped __js__ ("(function () {
			  var styles = window.getComputedStyle(document.documentElement, ''),
			    pre = (Array.prototype.slice
			      .call(styles)
			      .join('') 
			      .match(/-(moz|webkit|ms)-/) || (styles.OLink === '' && ['', 'o'])
			    )[1],
			    dom = ('WebKit|Moz|MS|O').match(new RegExp('(' + pre + ')', 'i'))[1];
			  return {
			    dom: dom,
			    lowercase: pre,
			    css: '-' + pre + '-',
			    js: pre[0].toUpperCase() + pre.substr(1)
			  };
			})")();
			__renderSession.vendorPrefix = prefix.lowercase;
			__renderSession.transformProperty = (prefix.lowercase == "webkit") ? "-webkit-transform" : "transform";
			__renderSession.transformOriginProperty = (prefix.lowercase == "webkit") ? "-webkit-transform-origin" : "transform-origin";
			
		}
		
		#if stats
		__stats = untyped __js__("new Stats ()");
		__stats.domElement.style.position = "absolute";
		__stats.domElement.style.top = "0px";
		Browser.document.body.appendChild (__stats.domElement);
		#end
		
		var keyEvents = [ "keydown", "keyup" ];
		var touchEvents = [ "touchstart", "touchmove", "touchend" ];
		var mouseEvents = [ "mousedown", "mousemove", "mouseup", /*"click",*/ "dblclick", "mousewheel" ];
		var focusEvents = [ "focus", "blur" ];
		
		var element = __canvas != null ? __canvas : __div;
		
		for (type in keyEvents) {
			
			Browser.window.addEventListener (type, window_onKey, false);
			
		}
		
		for (type in touchEvents) {
			
			element.addEventListener (type, element_onTouch, true);
			
		}
		
		for (type in mouseEvents) {
			
			element.addEventListener (type, element_onMouse, true);
			
		}
		
		for (type in focusEvents) {
			
			element.addEventListener (type, element_onFocus, true);
			
		}
		
		Browser.window.requestAnimationFrame (cast __render);
		
	}
	
	
	public override function globalToLocal (pos:Point):Point {
		
		return pos;
		
	}
	
	
	public function invalidate ():Void {
		
		__invalidated = true;
		
	}
	
	
	public override function localToGlobal (pos:Point):Point {
		
		return pos;
		
	}
	
	
	private function __drag (mouse:Point):Void {
		
		var parent = __dragObject.parent;
		if (parent != null) {
			
			mouse = parent.globalToLocal (mouse);
			
		}
		
		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;
		
		if (__dragBounds != null) {
			
			if (x < __dragBounds.x) {
				
				x = __dragBounds.x;
				
			} else if (x > __dragBounds.right) {
				
				x = __dragBounds.right;
				
			}
			
			if (y < __dragBounds.y) {
				
				y = __dragBounds.y;
				
			} else if (y > __dragBounds.bottom) {
				
				y = __dragBounds.bottom;
				
			}
			
		}
		
		__dragObject.x = x;
		__dragObject.y = y;
		
	}
	
	
	private function __fireEvent (event:Event, stack:Array<DisplayObject>):Void {
		
		var length = stack.length;
		
		if (length == 0) {
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
		} else {
			
			event.eventPhase = EventPhase.CAPTURING_PHASE;
			event.target = stack[stack.length - 1];
			
			for (i in 0...length - 1) {
				
				stack[i].__broadcast (event, false);
				
				if (event.__isCancelled) {
					
					return;
					
				}
				
			}
			
			event.eventPhase = EventPhase.AT_TARGET;
			event.target.__broadcast (event, false);
			
			if (event.__isCancelled) {
				
				return;
				
			}
			
			if (event.bubbles) {
				
				event.eventPhase = EventPhase.BUBBLING_PHASE;
				var i = length - 2;
				
				while (i >= 0) {
					
					stack[i].__broadcast (event, false);
					
					if (event.__isCancelled) {
						
						return;
						
					}
					
					i--;
					
				}
				
			}
			
		}
		
	}
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Void {
		
		stack.push (this);
		
	}
	
	
	private function __render ():Void {
		
		#if stats
		__stats.begin ();
		#end
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		__renderable = true;
		__update (false, true);
		
		if (__canvas != null) {
			
			if (!__fullscreen || __element != cast __canvas) {
				
				if (stageWidth != __canvas.width || stageHeight != __canvas.height) {
					
					__canvas.width = stageWidth;
					__canvas.height = stageHeight;
					
				}
				
			} else {
				
				stageWidth = __canvas.width;
				stageHeight = __canvas.height;
				
			}
			
			__context.setTransform (1, 0, 0, 1, 0, 0);
			__context.globalAlpha = 1;
			
			if (!__transparent && __clearBeforeRender) {
				
				__context.fillStyle = __colorString;
				__context.fillRect (0, 0, stageWidth, stageHeight);
				
			} else if (__transparent && __clearBeforeRender) {
				
				__context.clearRect (0, 0, stageWidth, stageHeight);
				
			}
			
			__renderCanvas (__renderSession);
			
		} else {
			
			__renderSession.z = 1;
			__renderDOM (__renderSession);
			
		}
		
		/*// run interaction!
		if(stage.interactive) {
			
			//need to add some events!
			if(!stage._interactiveEventsAdded) {
				
				stage._interactiveEventsAdded = true;
				stage.interactionManager.setTarget(this);
				
			}
			
		}

		// remove frame updates..
		if(PIXI.Texture.frameUpdates.length > 0) {
			
			PIXI.Texture.frameUpdates.length = 0;
			
		}*/
		
		#if stats
		__stats.end ();
		#end
		
		Browser.window.requestAnimationFrame (cast __render);
		
	}
	
	
	private function __resize ():Void {
		
		if (__element != null && (__div == null || (__div != null && __fullscreen))) {
			
			if (__fullscreen) {
				
				stageWidth = __element.clientWidth;
				stageHeight = __element.clientHeight;
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.width = stageWidth;
						__canvas.height = stageHeight;
						
					}
					
				} else {
					
					__div.style.width = stageWidth + "px";
					__div.style.height = stageHeight + "px";
					
				}
				
			} else {
				
				var scaleX = __element.clientWidth / __originalWidth;
				var scaleY = __element.clientHeight / __originalHeight;
				
				var currentRatio = scaleX / scaleY;
				var targetRatio = Math.min (scaleX, scaleY);
				
				if (__canvas != null) {
					
					if (__element != cast __canvas) {
						
						__canvas.style.width = __originalWidth * targetRatio + "px";
						__canvas.style.height = __originalHeight * targetRatio + "px";
						__canvas.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
						__canvas.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
						
					}
					
				} else {
					
					__div.style.width = __originalWidth * targetRatio + "px";
					__div.style.height = __originalHeight * targetRatio + "px";
					__div.style.marginLeft = ((__element.clientWidth - (__originalWidth * targetRatio)) / 2) + "px";
					__div.style.marginTop = ((__element.clientHeight - (__originalHeight * targetRatio)) / 2) + "px";
					
				}
				
			}
			
		}
		
	}
	
	
	private function __setCursor (cursor:String):Void {
		
		if (__cursor != cursor) {
			
			__cursor = cursor;
			
			if (!__cursorHidden) {
				
				var element = __canvas != null ? __canvas : __div;
				element.style.cursor = cursor;
				
			}
			
		}
		
	}
	
	
	private function __setCursorHidden (value:Bool):Void {
		
		if (__cursorHidden != value) {
			
			__cursorHidden = value;
			
			var element = __canvas != null ? __canvas : __div;
			element.style.cursor = value ? "none" : __cursor;
			
		}
		
	}
	
	
	private function __startDrag (sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void {
		
		__dragBounds = (bounds == null) ? null : bounds.clone ();
		__dragObject = sprite;
		
		if (__dragObject != null) {
			
			if (lockCenter) {
				
				__dragOffsetX = -__dragObject.width / 2;
				__dragOffsetY = -__dragObject.height / 2;
				
			} else {
				
				var mouse = new Point (mouseX, mouseY);
				var parent = __dragObject.parent;
				
				if (parent != null) {
					
					mouse = parent.globalToLocal (mouse);
					
				}
				
				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				
			}
			
		}
		
	}
	
	
	private function __stopDrag (sprite:Sprite):Void {
		
		__dragBounds = null;
		__dragObject = null;
		
	}
	
	
	public override function __update (transformOnly:Bool, updateChildren:Bool):Void {
		
		if (transformOnly) {
			
			if (DisplayObject.__worldTransformDirty > 0) {
				
				super.__update (true, updateChildren);
				
				if (updateChildren) {
					
					DisplayObject.__worldTransformDirty = 0;
					__dirty = true;
					
				}
				
			}
			
		} else {
			
			if (DisplayObject.__worldTransformDirty > 0 || __dirty || DisplayObject.__worldRenderDirty > 0) {
				
				super.__update (false, updateChildren);
				
				if (updateChildren) {
					
					#if dom
					__wasDirty = true;
					#end
					
					DisplayObject.__worldTransformDirty = 0;
					DisplayObject.__worldRenderDirty = 0;
					__dirty = false;
					
				}
				
			} #if dom else if (__wasDirty) {
				
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				
				super.__update (false, updateChildren);
				
				if (updateChildren) {
					
					__wasDirty = false;
					
				}
				
			} #end
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private override function get_mouseX ():Float {
		
		return __mouseX;
		
	}
	
	
	private override function get_mouseY ():Float {
		
		return __mouseY;
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function element_onFocus (event:js.html.Event):Void {
		
		//var focusEvent = new FocusEvent (FocusEvent.FOCUS_IN, true, false, this, false, 0);
		//focusEvent.target = this;
		//__fireEvent (focusEvent, [ this ]);
		
	}
	
	
	private function element_onTouch (event:js.html.TouchEvent):Void {
		
		event.preventDefault ();
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			
		}
		
		var touch = event.changedTouches[0];
		var point = new Point ((touch.pageX - rect.left) * (stageWidth / rect.width), (touch.pageY - rect.top) * (stageHeight / rect.height));
		
		__mouseX = point.x;
		__mouseY = point.y;
		
		__stack = [];
		
		var type = null;
		var mouseType = null;
		
		switch (event.type) {
			
			case "touchstart":
				
				type = TouchEvent.TOUCH_BEGIN;
				mouseType = MouseEvent.MOUSE_DOWN;
			
			case "touchmove":
				
				type = TouchEvent.TOUCH_MOVE;
				mouseType = MouseEvent.MOUSE_MOVE;
			
			case "touchend":
				
				type = TouchEvent.TOUCH_END;
				mouseType = MouseEvent.MOUSE_UP;
			
			default:
			
		}
		
		if (__hitTest (mouseX, mouseY, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, event, touch, localPoint, cast target);
			touchEvent.touchPointID = touch.identifier;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, cast event, localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, __stack);
			__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, event, touch, point, this);
			touchEvent.touchPointID = touch.identifier;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, cast event, point, this);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, [ this ]);
			__fireEvent (mouseEvent, [ this ]);
			
		}
		
		if (type == TouchEvent.TOUCH_MOVE && __dragObject != null) {
			
			__drag (point);
			
		}
		
		/*case "touchstart":
				
				var evt:js.html.TouchEvent = cast evt;
				evt.preventDefault ();
				var touchInfo = new TouchInfo ();
				__touchInfo[evt.changedTouches[0].identifier] = touchInfo;
				__onTouch (evt, evt.changedTouches[0], TouchEvent.TOUCH_BEGIN, touchInfo, false);
			
			case "touchmove":
				
				var evt:js.html.TouchEvent = cast evt;
				evt.preventDefault ();
				var touchInfo = __touchInfo[evt.changedTouches[0].identifier];
				__onTouch (evt, evt.changedTouches[0], TouchEvent.TOUCH_MOVE, touchInfo, true);
			
			case "touchend":
				
				var evt:js.html.TouchEvent = cast evt;
				evt.preventDefault ();
				var touchInfo = __touchInfo[evt.changedTouches[0].identifier];
				__onTouch (evt, evt.changedTouches[0], TouchEvent.TOUCH_END, touchInfo, true);
				__touchInfo[evt.changedTouches[0].identifier] = null;
				
				
				var rect:Dynamic = untyped Lib.mMe.__scr.getBoundingClientRect ();
		var point : Point = untyped new Point (touch.pageX - rect.left, touch.pageY - rect.top);
		var obj = __getObjectUnderPoint (point);
		
		// used in drag implementation
		_mouseX = point.x;
		_mouseY = point.y;
		
		var stack = new Array<InteractiveObject> ();
		if (obj != null) obj.__getInteractiveObjectStack (stack);
		
		if (stack.length > 0) {
			
			//var obj = stack[0];
			
			stack.reverse ();
			var local = obj.globalToLocal (point);
			var evt = TouchEvent.__create (type, event, touch, local, cast obj);
			
			evt.touchPointID = touch.identifier;
			evt.isPrimaryTouchPoint = isPrimaryTouchPoint;
			
			__checkInOuts (evt, stack, touchInfo);
			obj.__fireEvent (evt);
			
			var mouseType = switch (type) {
				
				case TouchEvent.TOUCH_BEGIN: MouseEvent.MOUSE_DOWN;
				case TouchEvent.TOUCH_END: MouseEvent.MOUSE_UP;
				default: 
					
					if (__dragObject != null) {
						
						__drag (point);
						
					}
					
					MouseEvent.MOUSE_MOVE;
				
			}
			
			obj.__fireEvent (MouseEvent.__create (mouseType, cast evt, local, cast obj));
			
		} else {
			
			var evt = TouchEvent.__create (type, event, touch, point, null);
			evt.touchPointID = touch.identifier;
			evt.isPrimaryTouchPoint = isPrimaryTouchPoint;
			__checkInOuts (evt, stack, touchInfo);
			
		}*/
		
	}
	
	
	private function element_onMouse (event:js.html.MouseEvent):Void {
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			__mouseX = (event.clientX - rect.left) * (stageWidth / rect.width);
			__mouseY = (event.clientY - rect.top) * (stageHeight / rect.height);
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			//__mouseX = (event.clientX - rect.left) * (__div.style.width / rect.width);
			__mouseX = (event.clientX - rect.left);
			//__mouseY = (event.clientY - rect.top) * (__div.style.height / rect.height);
			__mouseY = (event.clientY - rect.top);
			
		}
		
		__stack = [];
		
		var type = switch (event.type) {
			
			case "mousedown": MouseEvent.MOUSE_DOWN;
			case "mouseup": MouseEvent.MOUSE_UP;
			case "mousemove": MouseEvent.MOUSE_MOVE;
			//case "click": MouseEvent.CLICK;
			case "dblclick": MouseEvent.DOUBLE_CLICK;
			case "mousewheel": MouseEvent.MOUSE_WHEEL;
			default: null;
			
		}

		if (__hitTest (mouseX, mouseY, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			__setCursor (untyped (target).buttonMode ? "pointer" : "default");
			__fireEvent (MouseEvent.__create (type, event, target.globalToLocal (new Point (mouseX, mouseY)), cast target), __stack);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				__fireEvent (MouseEvent.__create (MouseEvent.CLICK, event, target.globalToLocal (new Point (mouseX, mouseY)), cast target), __stack);
				
			}
			
		} else {
			
			__setCursor (buttonMode ? "pointer" : "default");
			__fireEvent (MouseEvent.__create (type, event, new Point (mouseX, mouseY), this), [ this ]);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				__fireEvent (MouseEvent.__create (MouseEvent.CLICK, event, new Point (mouseX, mouseY), this), [ this ]);
				
			}
			
		}
		
		if (__dragObject != null) {
			
			__drag (new Point (mouseX, mouseY));
			
		}
		
		/*case "mousemove":
				
				__onMouse (cast evt, MouseEvent.MOUSE_MOVE);
			
			case "mousedown":
				
				__onMouse (cast evt, MouseEvent.MOUSE_DOWN);
			
			case "mouseup":
				
				__onMouse (cast evt, MouseEvent.MOUSE_UP);
				
				
				
				var rect:Dynamic = untyped Lib.mMe.__scr.getBoundingClientRect ();
		var point:Point = untyped new Point (event.clientX - rect.left, event.clientY - rect.top);
		
		if (__dragObject != null) {
			
			__drag (point);
			
		}
		
		var obj = __getObjectUnderPoint (point);
		
		// used in drag implementation
		_mouseX = point.x;
		_mouseY = point.y;
		
		var stack = new Array<InteractiveObject> ();
		if (obj != null) obj.__getInteractiveObjectStack (stack);
		
		if (stack.length > 0) {
			
			//var global = obj.localToGlobal(point);
			//var obj = stack[0];
			
			stack.reverse ();
			var local = obj.globalToLocal (point);
			var evt = MouseEvent.__create (type, event, local, cast obj);
			
			__checkInOuts (evt, stack);
			
			// MOUSE_DOWN brings focus to the clicked object, and takes it
			// away from any currently focused object
			if (type == MouseEvent.MOUSE_DOWN) {
				
				__onFocus (stack[stack.length - 1]);
				
			}
			
			obj.__fireEvent (evt);
			
		} else {
			
			var evt = MouseEvent.__create (type, event, point, null);
			__checkInOuts (evt, stack);
			
		}*/
		
	}
	
	
	private function window_onKey (event:js.html.KeyboardEvent):Void {
		
		var keyCode = (event.keyCode != null ? event.keyCode : event.which);
		keyCode = Keyboard.__convertMozillaCode (keyCode);
		
		var location = untyped (event).location != null ? untyped (event).location : event.keyLocation;
		
		#if (haxe_ver > 3.100)
		var keyLocation = cast (location, KeyLocation);
		#else
		var keyLocation = Type.createEnumIndex (KeyLocation, location);
		#end
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			stack.reverse ();
			__fireEvent (new KeyboardEvent (event.type == "keydown" ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.charCode, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey), stack);
			
		}
		
	}
	
	
	private function window_onResize (event:js.html.Event):Void {
		
		__resize ();
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);
		
	}
	
	private function window_onFocus (event:js.html.Event):Void {
		
		var event = new Event (Event.ACTIVATE);
		__broadcast (event, true);
		
	}
	
	private function window_onBlur (event:js.html.Event):Void {
		
		var event = new Event (Event.DEACTIVATE);
		__broadcast (event, true);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_color ():Int {
		
		return __color;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		//this.backgroundColorSplit = PIXI.hex2rgb(this.backgroundColor);
		//var hex = this.backgroundColor.toString (16);
		//hex = '000000'.substr(0, 6 - hex.length) + hex;
		__colorString = "#" + StringTools.hex (value, 6);
		
		return __color = value;
		
	}
	
	
	private function get_focus ():InteractiveObject {
		
		return __focus;
		
	}
	
	
	private function set_focus (value:InteractiveObject):InteractiveObject {
		
		if (value != __focus) {
			
			if (__focus != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_OUT, true, false, value, false, 0);
				__stack = [];
				__focus.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
			if (value != null) {
				
				var event = new FocusEvent (FocusEvent.FOCUS_IN, true, false, __focus, false, 0);
				__stack = [];
				value.__getInteractive (__stack);
				__stack.reverse ();
				__fireEvent (event, __stack);
				
			}
			
			__focus = value;
			
		}
		
		return __focus;
		
	}


	function set_displayState (value:StageDisplayState):StageDisplayState {
		switch(value) {
			case NORMAL:
				var fs_exit_function = untyped __js__("function() {
			    if (document.exitFullscreen) {
			      document.exitFullscreen();
			    } else if (document.msExitFullscreen) {
			      document.msExitFullscreen();
			    } else if (document.mozCancelFullScreen) {
			      document.mozCancelFullScreen();
			    } else if (document.webkitExitFullscreen) {
			      document.webkitExitFullscreen();
			    }
				}");
				fs_exit_function();
			case FULL_SCREEN | FULL_SCREEN_INTERACTIVE:
				var fsfunction = untyped __js__("function(elem) {
					if (elem.requestFullscreen) elem.requestFullscreen();
					else if (elem.msRequestFullscreen) elem.msRequestFullscreen();
					else if (elem.mozRequestFullScreen) elem.mozRequestFullScreen();
					else if (elem.webkitRequestFullscreen) elem.webkitRequestFullscreen();
				}");
				fsfunction(__element);
			default:
		}
		displayState = value;
		return value;
	}
	
}


class RenderSession {
	
	
	public var context:CanvasRenderingContext2D;
	public var element:Element;
	//public var mask:Bool;
	public var maskManager:MaskManager;
	//public var scaleMode:ScaleMode;
	public var roundPixels:Bool;
	public var transformProperty:String;
	public var transformOriginProperty:String;
	public var vendorPrefix:String;
	public var z:Int;
	//public var smoothProperty:Null<Bool> = null;
	
	
	public function new () {
		
		maskManager = new MaskManager (this);
		
	}
	
	
}


class MaskManager {
	
	
	private var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		
	}
	
	
	public function pushMask (mask:IBitmapDrawable):Void {
		
		var context = renderSession.context;
		
		context.save ();
		
		//var cacheAlpha = mask.__worldAlpha;
		var transform = mask.__worldTransform;
		if (transform == null) transform = new Matrix ();
		
		context.setTransform (transform.a, transform.c, transform.b, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		mask.__renderMask (renderSession);
		
		context.clip ();
		
		//mask.worldAlpha = cacheAlpha;
		
	}
	
	
	public function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		var context = renderSession.context;
		context.save ();
		
		context.setTransform (transform.a, transform.c, transform.b, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		context.rect (rect.x, rect.y, rect.width, rect.height);
		context.clip ();
		
	}
	
	
	public function popMask ():Void {
		
		renderSession.context.restore ();
		
	}
	
	
}
