package openfl.display;


import haxe.EnumFlags;
import lime.graphics.canvas.CanvasRenderContext;
import lime.graphics.dom.DOMRenderContext;
import lime.graphics.opengl.GLRenderContext;
import lime.graphics.RenderContext;
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

#if js
import js.html.CanvasElement;
import js.html.DivElement;
import js.html.Element;
import js.html.HtmlElement;
import js.Browser;
#end


@:access(openfl.events.Event)
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
	
	private var __clearBeforeRender:Bool;
	private var __color:Int;
	private var __colorSplit:Array<Float>;
	private var __colorString:String;
	private var __cursor:String;
	private var __cursorHidden:Bool;
	private var __dirty:Bool;
	private var __dragBounds:Rectangle;
	private var __dragObject:Sprite;
	private var __dragOffsetX:Float;
	private var __dragOffsetY:Float;
	private var __focus:InteractiveObject;
	private var __fullscreen:Bool;
	private var __glContextID:Int;
	private var __glContextLost:Bool;
	private var __glOptions:Dynamic;
	private var __invalidated:Bool;
	private var __mouseX:Float = 0;
	private var __mouseY:Float = 0;
	private var __originalWidth:Int;
	private var __originalHeight:Int;
	private var __renderSession:RenderSession;
	private var __stack:Array<DisplayObject>;
	private var __transparent:Bool;
	private var __wasDirty:Bool;
	
	#if js
	//private var __div:DivElement;
	//private var __element:HtmlElement;
	#if stats
	private var __stats:Dynamic;
	#end
	#end
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		super ();
		
		if (color == null) {
			
			__transparent = true;
			this.color = 0x000000;
			
		} else {
			
			this.color = color;
			
		}
		
		this.name = null;
		
		__mouseX = 0;
		__mouseY = 0;
		
		__renderSession = new RenderSession ();
		__renderSession.roundPixels = true;
		
		#if js
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
		#end
		
		stageWidth = width;
		stageHeight = height;
		
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
	
	
	private function __render (context:RenderContext):Void {
		
		__broadcast (new Event (Event.ENTER_FRAME), true);
		
		if (__invalidated) {
			
			__invalidated = false;
			__broadcast (new Event (Event.RENDER), true);
			
		}
		
		__renderable = true;
		__update (false, true);
		
		switch (context) {
			
			case OPENGL (gl):
				
				if (!__glContextLost) {
					
					gl.viewport (0, 0, stageWidth, stageHeight);
					gl.bindFramebuffer (gl.FRAMEBUFFER, null);
					
					if (__transparent) {
						
						gl.clearColor (1, 0, 0 ,0);
						
					} else {
						
						gl.clearColor (__colorSplit[0], __colorSplit[1], __colorSplit[2], 1);
						
					}
					
					gl.clear (gl.COLOR_BUFFER_BIT);
					
					__renderSession.gl = gl;
					__renderGL (__renderSession);
					
				}
			
			case CANVAS (context):
				
				context.setTransform (1, 0, 0, 1, 0, 0);
				context.globalAlpha = 1;
				
				if (!__transparent && __clearBeforeRender) {
					
					context.fillStyle = __colorString;
					context.fillRect (0, 0, stageWidth, stageHeight);
					
				} else if (__transparent && __clearBeforeRender) {
					
					context.clearRect (0, 0, stageWidth, stageHeight);
					
				}
				
				__renderSession.context = context;
				__renderCanvas (__renderSession);
			
			case DOM (element):
				
				__renderSession.z = 1;
				__renderSession.element = element;
				__renderDOM (__renderSession);
			
			default:
			
		}
		
	}
	
	
	private function __resize ():Void {
		
		/*
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
			
		}*/
		
	}
	
	
	private function __setCursor (cursor:String):Void {
		
		if (__cursor != cursor) {
			
			__cursor = cursor;
			
			if (!__cursorHidden) {
				
				//var element = __canvas != null ? __canvas : __div;
				//element.style.cursor = cursor;
				
			}
			
		}
		
	}
	
	
	private function __setCursorHidden (value:Bool):Void {
		
		if (__cursorHidden != value) {
			
			__cursorHidden = value;
			
			//var element = __canvas != null ? __canvas : __div;
			//element.style.cursor = value ? "none" : __cursor;
			
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
	
	
	
	
	#if js
	private function canvas_onContextLost (event:js.html.webgl.ContextEvent):Void {
		
		__glContextLost = true;
		
	}
	
	
	private function canvas_onContextRestored (event:js.html.webgl.ContextEvent):Void {
		
		__glContextLost = false;
		
	}
	#end
	
	
	private function application_onWindow (event:lime.ui.WindowEvent):Void {
		
		switch (event.type) {
			
			case WINDOW_ACTIVATE:
				
				var event = new Event (Event.ACTIVATE);
				__broadcast (event, true);
			
			case WINDOW_DEACTIVATE:
				
				var event = new Event (Event.ACTIVATE);
				__broadcast (event, true);
			
			default:
			
		}
		
		//var focusEvent = new FocusEvent (FocusEvent.FOCUS_IN, true, false, this, false, 0);
		//focusEvent.target = this;
		//__fireEvent (focusEvent, [ this ]);
		
	}
	
	
	private function application_onTouch (event:lime.ui.TouchEvent):Void {
		
		/*event.preventDefault ();
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			
		}
		
		var touch = event.changedTouches[0];
		var point = new Point ((touch.pageX - rect.left) * (stageWidth / rect.width), (touch.pageY - rect.top) * (stageHeight / rect.height));
		*/
		var point = new Point (event.x, event.y);
		
		__mouseX = point.x;
		__mouseY = point.y;
		
		__stack = [];
		
		var type = null;
		var mouseType = null;
		
		switch (event.type) {
			
			case TOUCH_START:
				
				type = TouchEvent.TOUCH_BEGIN;
				mouseType = MouseEvent.MOUSE_DOWN;
			
			case TOUCH_MOVE:
				
				type = TouchEvent.TOUCH_MOVE;
				mouseType = MouseEvent.MOUSE_MOVE;
			
			case TOUCH_END:
				
				type = TouchEvent.TOUCH_END;
				mouseType = MouseEvent.MOUSE_UP;
			
			default:
			
		}
		
		if (__hitTest (mouseX, mouseY, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, event, null/*touch*/, localPoint, cast target);
			touchEvent.touchPointID = event.id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, cast event, localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			__fireEvent (touchEvent, __stack);
			__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, event, null/*touch*/, point, this);
			touchEvent.touchPointID = event.id;
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
	
	
	private function application_onMouse (event:lime.ui.MouseEvent):Void {
		
		/*var rect;
		
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
			
		}*/
		
		__mouseX = event.x;
		__mouseY = event.y;
		
		__stack = [];
		
		var type = switch (event.type) {
			
			case MOUSE_DOWN: MouseEvent.MOUSE_DOWN;
			case MOUSE_UP: MouseEvent.MOUSE_UP;
			case MOUSE_MOVE: MouseEvent.MOUSE_MOVE;
			//case "click": MouseEvent.CLICK;
			//case "dblclick": MouseEvent.DOUBLE_CLICK;
			case MOUSE_WHEEL: MouseEvent.MOUSE_WHEEL;
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
	
	
	private function application_onKey (event:lime.ui.KeyEvent):Void {
		
		var keyCode =  Keyboard.__convertMozillaCode (event.key);
		
		#if (haxe_ver > 3.100)
		var keyLocation = cast (event.location, KeyLocation);
		#else
		var keyLocation = Type.createEnumIndex (KeyLocation, event.location);
		#end
		
		var stack = new Array <DisplayObject> ();
		
		if (__focus == null) {
			
			__getInteractive (stack);
			
		} else {
			
			__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			stack.reverse ();
			__fireEvent (new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey), stack);
			
		}
		
	}
	
	
	#if js
	private function window_onResize (event:js.html.Event):Void {
		
		__resize ();
		
		var event = new Event (Event.RESIZE);
		__broadcast (event, false);
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_color ():Int {
		
		return __color;
		
	}
	
	
	private function set_color (value:Int):Int {
		
		var r = (value & 0xFF0000) >>> 16;
		var g = (value & 0x00FF00) >>> 8;
		var b = (value & 0x0000FF);
		
		__colorSplit = [ r / 0xFF, g / 0xFF, b / 0xFF ];
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
		
		/*switch(value) {
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
		displayState = value;*/
		return value;
	}
	
}


class RenderSession {
	
	
	public var context:CanvasRenderContext;
	public var element:DOMRenderContext;
	public var gl:GLRenderContext;
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


class RenderCommands {
	
	
	public var data:Array<Float>;
	public var elements:Array<RenderElement>;
	
	
	public function new () {
		
		data = new Array ();
		elements = new Array ();
		
	}
	
	
}


class RenderElement {
	
	
	public var color:Int;
	public var count:Int;
	public var flags:EnumFlags<Dynamic>;
	public var stride:Int;
	public var surface:HardwareSurface;
	public var type:RenderCommandType;
	public var textureOffset:Int;
	public var vertexOffset:Int;
	
	
	public function new () {
		
		
		
	}
	
	
}


class HardwareSurface {
	
	
	public function new () {
		
		
		
	}
	
	
}


enum RenderCommandType {
	
	TRIANGLE_FAN;
	TRIANGLE_STRIP;
	TRIANGLES;
	LINE_STRIP;
	POINTS;
	LINES;
	
}
