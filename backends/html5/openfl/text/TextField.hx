package openfl.text;

import haxe.Json;
import openfl.events.TextEvent;
import haxe.Timer;
import Math;
import js.Browser;
import StringTools;
import js.Browser;
import openfl.events.FocusEvent;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.DivElement;
import js.html.Element;
import js.Browser;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.InteractiveObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;
import openfl.events.Event;

@:access(openfl.display.Graphics)
@:access(openfl.text.TextFormat)
class TextField extends InteractiveObject {
	
	
	private static var __defaultTextFormat:TextFormat;
	private static var __inputs:Array<TextField>;

	public var antiAliasType:AntiAliasType;
	@:isVar public var autoSize (default, set):TextFieldAutoSize;
	@:isVar public var background (default, set):Bool;
	@:isVar public var backgroundColor (default, set):Int;
	@:isVar public var border (default, set):Bool;
	@:isVar public var borderColor (default, set):Int;
	public var bottomScrollV (get, null):Int;
	public var caretIndex:Int;
	public var caretPos (get, null):Int;
	public var defaultTextFormat (get, set):TextFormat;
	public var displayAsPassword:Bool;
	public var embedFonts:Bool;
	public var gridFitType:GridFitType;
	public var htmlText (get, set):String;
	public var length (default, null):Int;
	public var maxChars:Int;
	public var maxScrollH (get, null):Int;
	public var maxScrollV (get, null):Int;
	public var multiline:Bool;
	public var numLines (get, null):Int;
	public var restrict:String;
	public var scrollH:Int;
	public var scrollV:Int;
	public var selectable:Bool;
	public var selectionBeginIndex:Int;
	public var selectionEndIndex:Int;
	public var sharpness:Float;
	public var text (get, set):String;
	public var textColor (get, set):Int;
	public var textHeight (get, null):Float;
	public var textWidth (get, null):Float;
	@:isVar public var type (default, set):TextFieldType;
	@:isVar public var wordWrap (get, set):Bool;
	
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __dirty:Bool;
	private var __div:DivElement;
	private var __height:Float;
	private var __isHTML:Bool;
	private var __measuredHeight:Int;
	private var __measuredWidth:Int;
	private var __ranges:Array<TextFormatRange>;
	private var __text:String;
	private var __textFormat:TextFormat;
	private var __width:Float;


	private var __hasFocus:Bool;
	private var __selectionStart:Int;
	private var __cursorPos:Int;
	private var __mouseDown:Bool;
	private var __isKeyDown:Bool;
	private var __hiddenInput:Dynamic;

	private var __verticalPadding:Float = 5;
	private var __showCursor:Bool;
	private var __currentTimer:Timer;
	private var __inputsIndex :UInt;


	public function new () {
		
		super ();
		
		__width = 100;
		__height = 100;
		__text = "";

		type = TextFieldType.DYNAMIC;
		autoSize = TextFieldAutoSize.NONE;
		displayAsPassword = false;
		embedFonts = false;
		selectable = true;
		borderColor = 0x000000;
		border = false;
		backgroundColor = 0xffffff;
		background = false;
		gridFitType = GridFitType.PIXEL;
		maxChars = 0;
		multiline = false;
		sharpness = 0;
		scrollH = 0;
		scrollV = 1;
		wordWrap = false;
		
		if (__defaultTextFormat == null) {
			
			__defaultTextFormat = new TextFormat ("Times New Roman", 12, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			__defaultTextFormat.blockIndent = 0;
			__defaultTextFormat.bullet = false;
			__defaultTextFormat.letterSpacing = 0;
			__defaultTextFormat.kerning = false;
			
		}
		
		__textFormat = __defaultTextFormat.clone ();
		
	}


	private function setupTextInput():Void
	{
		if(__inputs == null) __inputs = new Array<TextField>();
		__cursorPos = -1;

		__inputs.push(this);
		__inputsIndex = __inputs.length - 1;
		// create the hidden input element
		if(__hiddenInput == null)
		{
			__hiddenInput = Browser.document.createElement('input');
			__hiddenInput.type = 'text';
			__hiddenInput.style.position = 'absolute';
			__hiddenInput.style.opacity = 0;
			__hiddenInput.style.pointerEvents = 'none';

			__hiddenInput.style.left = (this.x + ( (__canvas != null) ? __canvas.offsetLeft : 0)) + 'px';
			__hiddenInput.style.top = (this.y + ( (__canvas != null) ? __canvas.offsetTop : 0)) + 'px';
			__hiddenInput.style.width = __width + 'px';
			__hiddenInput.style.height = __height + 'px';
			__hiddenInput.style.zIndex = 0;
			if (this.maxChars > 0) {
				__hiddenInput.maxLength = this.maxChars;
			}
			Browser.document.body.appendChild(__hiddenInput);
			__hiddenInput.value = text;
		}

		if(stage != null)
		{
			handleAddedToStage(null);
		}
		else
		{
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
		}

	}

	private function unsetTextInput():Void
	{
		if(__inputs != null)
		{
			__inputs.remove(this);
		}
		removeEventsListeners();
	}
	
	private function addEventsListeners():Void
	{
		this.stage.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);

		__hiddenInput.addEventListener('keyup', handleKeyUp);
		__hiddenInput.addEventListener('keydown', handleKeyDown);
		// use for get the backspace on android
		__hiddenInput.addEventListener('input', handleKeyUp);

		this.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		this.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageClick);
	}
	
	private function removeEventsListeners():Void
	{
		if(this.stage != null)this.stage.removeEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);

		if(__hiddenInput != null) __hiddenInput.removeEventListener('keyup', handleKeyUp);
		if(__hiddenInput != null) __hiddenInput.removeEventListener('input', handleKeyUp);
		if(__hiddenInput != null) __hiddenInput.removeEventListener('keydown', handleKeyDown);

		this.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		this.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		if(this.stage != null) this.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageClick);
	}

	private function handleAddedToStage(e:Event):Void
	{
		addEventsListeners();
	}

	private function handleRemovedFromStage(e:Event):Void
	{
		removeEventsListeners();
	}

	private function handleFocusOut(e:FocusEvent):Void
	{
		blur();
	}

	private function blur():Void
	{
		__cursorPos = -1;
		__hasFocus = false;
		stopCursorTimerLoop();
		__hiddenInput.blur();
		__dirty = true;
	}

	private function handleStageClick(e:FocusEvent):Void
	{
		this.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
	}

	private function handleMouseDown(e:MouseEvent):Void
	{
		// start the selection drag if inside the input
		__selectionStart = getClickPos(e.localX, e.localY);
		this.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
	}

	private function getClickPos(posX:Float, y:Float):Int
	{
		var value:String = text;

		// determine where the click was made along the string
		var text:String = value; //clipText(value);
		var totalW:Float = 0;
		var pos = text.length;

		if (posX < getTextWidth(text)) {
			// loop through each character to identify the position
			for(i in 0...text.length) {
				totalW += getTextWidth(text.charAt(i));
				if (totalW >= posX) {
					pos = i;
					break;
				}
			}
		}
		return pos;
	}

	private function clipText(value) {
		var textWidth:Float = getTextWidth(value);
		var fillPer = textWidth / __width;
		text = fillPer > 1 ? text.substr(-1 * Math.floor(text.length / fillPer)) : text;

		return text + '';
	}

	private function getTextWidth(text):Float {

		if(__context == null)
		{
			__canvas = cast Browser.document.createElement ("canvas");
			__context = __canvas.getContext ("2d");
		}

		__context.font = __getFont (__textFormat);
		__context.textAlign = 'left';

		return __context.measureText(text).width;
	}

	private function isOverInput(x:Float, y:Float):Bool
	{
		return x >= 0 && x <= get_textWidth();

	}

	private function handleMouseUp(e:MouseEvent):Void
	{
		//hide Cursor
		var upPos:Int = getClickPos(e.localX, e.localY);

		var leftPos:Int;
		var rightPos:Int;

		leftPos = Std.int(Math.min(__selectionStart, upPos));
		rightPos = Std.int(Math.max(__selectionStart, upPos));

		__selectionStart = leftPos;
		__cursorPos = rightPos;
		this.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);

		focus();
	}

	private function handleMouseMove(e:MouseEvent)
	{
		if (__hasFocus && __selectionStart >= 0) {
			__cursorPos = getClickPos(e.localX, e.localY);
			__dirty = true;
		}
	}

	private function focus():Void
	{
		this.stage.focus = this;
		if(__cursorPos < 0){
			__cursorPos = text.length;
			__selectionStart = __cursorPos;
		}
		__hiddenInput.focus();
		__hiddenInput.selectionStart = __selectionStart;
		__hiddenInput.selectionEnd = __cursorPos;

		stopCursorTimerLoop();
		startCursorTimerLoop();

		__hasFocus = true;
		__dirty = true;
	}

	private function stopCursorTimerLoop():Void
	{
		if(__currentTimer != null) __currentTimer.stop();
	}

	private function startCursorTimerLoop():Void
	{
		__currentTimer = Timer.delay(startCursorTimerLoop, 500);
		__showCursor = !__showCursor;
		__dirty = true;
	}

	private function handleKeyUp(e:Dynamic):Void
	{
		__isKeyDown = false;
		e = (e != null) ? e : Browser.window.event;

		// update the canvas input state information from the hidden input
		setTextValue(__hiddenInput.value);
		__cursorPos = __hiddenInput.selectionStart;
		__selectionStart = __cursorPos;
		__dirty = true;
		dispatchEvent(new Event(Event.CHANGE, true));
	}

	private function handleKeyDown(e:Dynamic):Void
	{
		__isKeyDown = true;

		e = (e != null) ? e : Browser.window.event;

		var keyCode:Int = e.which;
		var isShift:Bool = e.shiftKey;

		// add support for Ctrl/Cmd+A selection
		if (keyCode == 65 && (e.ctrlKey || e.metaKey)) {
			__hiddenInput.selectionStart = 0;
			__hiddenInput.selectionEnd = this.text.length;
			e.preventDefault();
			__dirty = true;
			return;
		}

		// block keys that shouldn't be processed
		if (keyCode == 17 || e.metaKey || e.ctrlKey) {
			return;
		}
		/*if (keyCode == 13) { // enter key
			e.preventDefault();
			//submit;
		}*/
		if (keyCode == 9) { // tab key
			e.preventDefault();
			if (__inputs.length > 1) {
				var nextIndex:Int =  (__inputs.indexOf(this)+1) % __inputs.length;
				this.blur();
				Timer.delay(
					function() {
						__inputs[nextIndex].focus();
					}, 10);
			}
		}

		// update the canvas input state information from the hidden input
		setTextValue(__hiddenInput.value);
		this.__selectionStart = __hiddenInput.selectionStart;
		this.__ranges = null;

		__dirty = true;
	}
	/*end input*/

	public function appendText (text:String):Void {
		
		this.text += text;
		
	}
	
	public function getCharBoundaries (a:Int):Rectangle {
		
		openfl.Lib.notImplemented ("TextField.getCharBoundaries");
		
		return null;
		
	}
	
	
	public function getCharIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getCharIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getLineIndexAtPoint (x:Float, y:Float):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineIndexAtPoint");
		
		return 0;
		
	}
	
	
	public function getLineMetrics (lineIndex:Int):TextLineMetrics {
		
		openfl.Lib.notImplemented ("TextField.getLineMetrics");
		
		return null;
		
	}
	
	
	public function getLineOffset (lineIndex:Int):Int {
		
		openfl.Lib.notImplemented ("TextField.getLineOffset");
		
		return 0;
		
	}
	
	
	public function getLineText (lineIndex:Int):String {
		
		openfl.Lib.notImplemented ("TextField.getLineText");
		
		return "";
		
	}
	
	
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	public function setSelection (beginIndex:Int, endIndex:Int) {
		
		openfl.Lib.notImplemented ("TextField.setSelection");
		
	}
	
	
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void {
		
		if (format.font != null) __textFormat.font = format.font;
		if (format.size != null) __textFormat.size = format.size;
		if (format.color != null) __textFormat.color = format.color;
		if (format.bold != null) __textFormat.bold = format.bold;
		if (format.italic != null) __textFormat.italic = format.italic;
		if (format.underline != null) __textFormat.underline = format.underline;
		if (format.url != null) __textFormat.url = format.url;
		if (format.target != null) __textFormat.target = format.target;
		if (format.align != null) __textFormat.align = format.align;
		if (format.leftMargin != null) __textFormat.leftMargin = format.leftMargin;
		if (format.rightMargin != null) __textFormat.rightMargin = format.rightMargin;
		if (format.indent != null) __textFormat.indent = format.indent;
		if (format.leading != null) __textFormat.leading = format.leading;
		if (format.blockIndent != null) __textFormat.blockIndent = format.blockIndent;
		if (format.bullet != null) __textFormat.bullet = format.bullet;
		if (format.kerning != null) __textFormat.kerning = format.kerning;
		if (format.letterSpacing != null) __textFormat.letterSpacing = format.letterSpacing;
		if (format.tabStops != null) __textFormat.tabStops = format.tabStops;
		
		__dirty = true;
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = new Rectangle (0, 0, __width, __height);
		bounds.transform (__worldTransform);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private function __getFont (format:TextFormat):String {
		
		var font = format.italic ? "italic " : "normal ";
		font += "normal ";
		font += format.bold ? "bold " : "normal ";
		font += format.size + "px";
		font += "/" + (format.size + format.leading + 4) + "px ";
		
		font += "'" + switch (format.font) {
			
			case "_sans": "sans-serif";
			case "_serif": "serif";
			case "_typewriter": "monospace";
			default: format.font;
			
		}
		
		font += "'";
		
		return font;
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || (interactiveOnly && !mouseEnabled)) return false;
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private function __measureText ():Array<Float> {
		
		if (__ranges == null) {
			
			__context.font = __getFont (__textFormat);
			return [ __context.measureText (__text).width ];
			
		} else {
			
			var measurements = [];
			
			for (range in __ranges) {
				
				__context.font = __getFont (range.format);
				measurements.push (__context.measureText (text.substring (range.start, range.end)).width);
				
			}
			
			return measurements;
			
		}
		
	}
	
	
	private function __measureTextWithDOM ():Void {
	 	
		var div:Element = __div;
		
		if (__div == null) {
			
			div = Browser.document.createElement ("div");
			div.innerHTML = __text;
			div.style.setProperty ("font", __getFont (__textFormat), null);
			div.style.position = "absolute";
			div.style.top = "110%"; // position off-screen!
			Browser.document.body.appendChild (div);
			
		}
		
		__measuredWidth = div.clientWidth;
		
		// Now set the width so that the height is accurate as a
		// function of the flow within the width bounds...
		if (__div == null) {
			
			div.style.width = Std.string (__width) + "px";
			
		}
		
		__measuredHeight = div.clientHeight;
		
		if (__div == null) {
			
			Browser.document.body.removeChild (div);
			
		}
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		if (__dirty) {
			
			if (((__text == null || __text == "") && !background && !border) || ((width <= 0 || height <= 0) && autoSize != TextFieldAutoSize.LEFT)) {
				
				__canvas = null;
				__context = null;
				
			} else {
				var passwordMask:String = "";
				if(displayAsPassword)
				{
					var length:Int = text.length;

					for(i in 0...length)
					{
						passwordMask += "*";
					}
				}

				if (__canvas == null) {
					
					__canvas = cast Browser.document.createElement ("canvas");
					__context = __canvas.getContext ("2d");
					
				}

				if (__text != null && __text != "") {

					var measurements = __measureText ();
					var textWidth = 0.0;
					
					for (measurement in measurements) {
						
						textWidth += measurement;
						
					}
					
					if (autoSize == TextFieldAutoSize.LEFT) {
						
						__width = textWidth + 4;
						
					}
					
					__canvas.width = Math.ceil (__width);
					__canvas.height = Math.ceil (__height);
					
					if (border || background) {
						
						__context.rect (0.5, 0.5, __width - 1, __height - 1);
						
						if (background) {
							
							__context.fillStyle = "#" + StringTools.hex (backgroundColor, 6);
							__context.fill ();
							
						}
						
						if (border) {
							
							__context.lineWidth = 1;
							__context.strokeStyle = "#" + StringTools.hex (borderColor, 6);
							__context.stroke ();
							
						}
						
					}

					//draw cursor
					if(__hasFocus && (__selectionStart == __cursorPos) && __showCursor)
					{
						var cursorOffset = getTextWidth((displayAsPassword? passwordMask:text).substring(0, __cursorPos));
						__context.fillStyle = "#" + StringTools.hex (__textFormat.color, 6);
						__context.fillRect( cursorOffset, __verticalPadding, 1, __textFormat.size - __verticalPadding);
					}
					else if(__hasFocus && ( Math.abs(__selectionStart - __cursorPos)) > 0  && !__isKeyDown )
					{
						var lowPos:Int = Std.int(Math.min(__selectionStart, __cursorPos));
						var highPos:Int = Std.int(Math.max(__selectionStart, __cursorPos));

						var xPos:Float = getTextWidth( (displayAsPassword? passwordMask:text).substring(0, lowPos));
						var widthPos:Float = getTextWidth((displayAsPassword? passwordMask:text).substring(lowPos, highPos));

						__context.fillStyle = "#" + StringTools.hex (__textFormat.color, 6);
						__context.fillRect( xPos, __verticalPadding, widthPos, __textFormat.size - __verticalPadding );
					}

					if (__ranges == null) {
						
						__renderText ( displayAsPassword? passwordMask:text, __textFormat, 0);
						
					} else {
						
						var currentIndex = 0;
						var range;
						var offsetX = 0.0;
						
						for (i in 0...__ranges.length) {
							
							range = __ranges[i];
							
							__renderText (text.substring (range.start, range.end), range.format, offsetX);
							offsetX += measurements[i];
							
						}
						
					}



				} else {
					
					if (autoSize == TextFieldAutoSize.LEFT) {
						
						__width = 4;
						
					}
					
					__canvas.width = Math.ceil (__width);
					__canvas.height = Math.ceil (__height);
					
					if (border || background) {
						
						if (border) {
							
							__context.rect (0.5, 0.5, __width - 1, __height - 1);

						} else {
							
							__context.rect (0, 0, __width, __height);

						}					
						
						if (background) {
							
							__context.fillStyle = "#" + StringTools.hex (backgroundColor, 6);
							__context.fill ();
							
						}
						
						if (border) {
							
							__context.lineWidth = 1;
							__context.lineCap = "square";
							__context.strokeStyle = "#" + StringTools.hex (borderColor, 6);
							__context.stroke ();
							
						}
						
					}
					
				}



			}
			
			__dirty = false;
			
		}
		
		if (__canvas != null) {
			
			var context = renderSession.context;
			
			context.globalAlpha = __worldAlpha;
			var transform = __worldTransform;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (__canvas, 0, 0);
				
			} else {
				
				context.drawImage (__canvas, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
		}
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		if (stage != null && __worldVisible && __renderable) {
			
			if (__dirty || __div == null) {
				
				if (__text != "" || background || border) {
					
					if (__div == null) {
						
						__div = cast Browser.document.createElement ("div");
						__initializeElement (__div, renderSession);
						__style.setProperty ("cursor", "inherit", null);
						
					}
					
					// TODO: Handle ranges using span
					// TODO: Vertical align
					
					__div.innerHTML = __text;
					
					if (background) {
						
						__style.setProperty ("background-color", "#" + StringTools.hex (backgroundColor, 6), null);
						
					} else {
						
						__style.removeProperty ("background-color");
						
					}
					
					if (border) {
						
						__style.setProperty ("border", "solid 1px #" + StringTools.hex (borderColor, 6), null);
						
					} else {
						
						__style.removeProperty ("border");
						
					}
					
					__style.setProperty ("font", __getFont (__textFormat), null);
					__style.setProperty ("color", "#" + StringTools.hex (__textFormat.color, 6), null);
					
					if (autoSize != TextFieldAutoSize.NONE) {
						
						__style.setProperty ("width", "auto", null);
						
					} else {
						
						__style.setProperty ("width", __width + "px", null);
						
					}
					
					__style.setProperty ("height", __height + "px", null);
					
					switch (__textFormat.align) {
						
						case TextFormatAlign.CENTER:
							
							__style.setProperty ("text-align", "center", null);
						
						case TextFormatAlign.RIGHT:
							
							__style.setProperty ("text-align", "right", null);
						
						default:
							
							__style.setProperty ("text-align", "left", null);
						
					}
					
					__dirty = false;
					
				} else {
					
					if (__div != null) {
						
						renderSession.element.removeChild (__div);
						__div = null;
						
					}
					
				}
				
			}
			
			if (__div != null) {
				
				// TODO: Enable scrollRect clipping
				
				__applyStyle (renderSession, true, true, false);
				
			}
			
		} else {
			
			if (__div != null) {
				
				renderSession.element.removeChild (__div);
				__div = null;
				__style = null;
				
			}
			
		}
		
	}
	
	
	private function __renderText (text:String, format:TextFormat, offsetX:Float):Void {


		__context.font = __getFont (format);
		__context.textBaseline = "top";
		__context.fillStyle = "#" + StringTools.hex (format.color, 6);
		
		var lines = text.split("\n");
		var yOffset:Float = 0;
		
		for (line in lines) {
			
			switch (format.align) {
				
				case TextFormatAlign.CENTER:
					
					__context.textAlign = "center";
					__context.fillText (line, __width / 2, 2 + yOffset, __width - 4);
					
				case TextFormatAlign.RIGHT:
					
					__context.textAlign = "end";
					__context.fillText (line, __width - 2, 2 + yOffset, __width - 4);
					
				default:
					
					__context.textAlign = "start";
					__context.fillText (line, 2 + offsetX, 2 + yOffset, __width - 4);
					
			}
			
			yOffset += this.textHeight;
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize {
		
		if (value != autoSize) __dirty = true;
		return autoSize = value;
		
	}
	
	
	private function set_background (value:Bool):Bool {
		
		if (value != background) __dirty = true;
		return background = value;
		
	}
	
	
	private function set_backgroundColor (value:Int):Int {
		
		if (value != backgroundColor) __dirty = true;
		return backgroundColor = value;
		
	}
	
	
	private function set_border (value:Bool):Bool {
		
		if (value != border) __dirty = true;
		return border = value;
		
	}
	
	
	private function set_borderColor (value:Int):Int {
		
		if (value != borderColor) __dirty = true;
		return borderColor = value;
		
	}
	
	
	private function get_bottomScrollV ():Int {
		
		// TODO: Only return lines that are visible
		
		return numLines;
		
	}
	
	
	private function get_caretPos ():Int {
		
		return 0;
		
	}
	
	
	private function get_defaultTextFormat ():TextFormat {
		
		return __textFormat.clone ();
		
	}
	
	
	private function set_defaultTextFormat (value:TextFormat):TextFormat {
		
		//__textFormat = __defaultTextFormat.clone ();
		__textFormat.__merge (value);
		return value;
		
	}
	
	
	private override function get_height ():Float {
		
		return __height * scaleY;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (scaleY != 1 || value != __height) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleY = 1;
		return __height = value;
		
	}
	
	
	private function get_htmlText ():String {
		
		return __text;
		
		//return mHTMLText;
		
	}
	
	
	private function set_htmlText (value:String):String {
		
		if (!__isHTML || __text != value) __dirty = true;
		__ranges = null;
		__isHTML = true;
		
		if (#if dom false && #end __div == null) {
			
			value = new EReg ("<br>", "g").replace (value, "\n");
			value = new EReg ("<br/>", "g").replace (value, "\n");
			
			// crude solution
			
			var segments = value.split ("<font");
			
			if (segments.length == 1) {
				
				value = new EReg ("<.*?>", "g").replace (value, "");
				return __text = value;
				
			} else {
				
				value = "";
				__ranges = [];
				
				// crude search for font
				
				for (segment in segments) {
					
					if (segment == "") continue;
					
					var closeFontIndex = segment.indexOf ("</font>");
					
					if (closeFontIndex > -1) {
						
						var start = segment.indexOf (">") + 1;
						var end = closeFontIndex;
						var format = __textFormat.clone ();
						
						var faceIndex = segment.indexOf ("face=");
						var colorIndex = segment.indexOf ("color=");
						var sizeIndex = segment.indexOf ("size=");
						
						if (faceIndex > -1 && faceIndex < start) {
							
							format.font = segment.substr (faceIndex + 6, segment.indexOf ("\"", faceIndex));
							
						}
						
						if (colorIndex > -1 && colorIndex < start) {
							
							format.color = Std.parseInt ("0x" + segment.substr (colorIndex + 8, 6));
							
						}
						
						if (sizeIndex > -1 && sizeIndex < start) {
							
							format.size = Std.parseInt (segment.substr (sizeIndex + 6, segment.indexOf ("\"", sizeIndex)));
							
						}
						
						var sub = segment.substring (start, end);
						sub = new EReg ("<.*?>", "g").replace (sub, "");
						
						__ranges.push (new TextFormatRange (format, value.length, value.length + sub.length));
						value += sub;
						
						if (closeFontIndex + 7 < segment.length) {
							
							sub = segment.substr (closeFontIndex + 7);
							__ranges.push (new TextFormatRange (__textFormat, value.length, value.length + sub.length));
							value += sub;
							
						}
						
					} else {
						
						__ranges.push (new TextFormatRange (__textFormat, value.length, value.length + segment.length));
						value += segment;
						
					}
					
				}
				
			}
			
		}
		
		return __text = value;
		
	}
	
	
	private function get_maxScrollH ():Int { return 0; }
	private function get_maxScrollV ():Int { return 1; }
	
	
	private function get_numLines ():Int {
		
		if (text != "" && text != null) {
			
			var count = text.split ("\n").length;
			
			if (__isHTML) {
				
				count += text.split ("<br>").length - 1;
				
			}
			
			return count;
			
		}
		
		return 1;
		
	}
	
	
	public function get_text ():String {
		
		if (__isHTML) {
			
			
			
		}
		
		return __text;
		
	}
	
	
	public function set_text (value:String):String {

		this.__hiddenInput.value = value;
		return  setTextValue(value);
	}

	private function setTextValue(value:String):String {

		if (__isHTML || __text != value) __dirty = true;
		__ranges = null;
		__isHTML = false;

		return __text = value;
	}


	public function get_textColor ():Int {
		
		return __textFormat.color;
		
	}
	
	
	public function set_textColor (value:Int):Int {
		
		if (value != __textFormat.color) __dirty = true;
		
		if (__ranges != null) {

			for (range in __ranges) {
				
				range.format.color = value;
				
			}
			
		}
		
		return __textFormat.color = value;
		
	}
	
	
	public function get_textWidth ():Float {
		
		if (__canvas != null) {
			
			var sizes = __measureText ();
			var total:Float = 0;
			
			for (size in sizes) {
				
				total += size;
				
			}
			
			return total;
			
		} else if (__div != null) {
			
			return __div.clientWidth;
			
		} else {
			
			__measureTextWithDOM ();
			return __measuredWidth;
			
		}
		
	}
	
	
	public function get_textHeight ():Float {
		
		if (__canvas != null) {
			
			// TODO: Make this more accurate
			return __textFormat.size * 1.185;
			
		} else if (__div != null) {
			
			return __div.clientHeight;
			
		} else {
			
			__measureTextWithDOM ();
			
			// Add a litte extra space for descenders...
			return __measuredHeight + __textFormat.size * 0.185;
			
		}
		
	}
	
	
	public function set_type (value:TextFieldType):TextFieldType {
		
		if(value == TextFieldType.INPUT)
		{
			setupTextInput();
		}
		else
		{
			unsetTextInput();
		}
		if (value != type) __dirty = true;
		return type = value;
		
	}
	
	
	override public function get_width ():Float {
		
		if (autoSize == TextFieldAutoSize.LEFT) {
			
			//return __width * scaleX;
			return (textWidth + 4) * scaleX;
			
		} else {
			
			return __width * scaleX;
			
		}
		
	}
	
	
	override public function set_width (value:Float):Float {
		
		if (scaleX != 1 || __width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleX = 1;
		return __width = value;
		
	}
	
	
	public function get_wordWrap ():Bool {
		
		return wordWrap;
		
	}
	
	
	public function set_wordWrap (value:Bool):Bool {
		
		//if (value != wordWrap) __dirty = true;
		return wordWrap = value;
		
	}
	
	
}


class TextFormatRange {
	
	
	public var end:Int;
	public var format:TextFormat;
	public var start:Int;
	
	
	public function new (format:TextFormat, start:Int, end:Int) {
		
		this.format = format;
		this.start = start;
		this.end = end;
		
	}
	
	
}