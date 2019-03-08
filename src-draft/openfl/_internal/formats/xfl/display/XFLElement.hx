package openfl.display;

import openfl.containers.ScrollPane;
import openfl.controls.CheckBox;
import openfl.controls.ComboBox;
import openfl.controls.RadioButton;
import openfl.controls.List;
import openfl.controls.ProgressBar;
import openfl.controls.ScrollBar;
import openfl.controls.UIScrollBar;
import openfl.controls.Slider;
import openfl.controls.TextArea;
import openfl.controls.TextInput;
import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.text.TextField;
import xfl.XFLSymbolArguments;

/**
 * XFL element
 */
interface XFLElement
{
	// xfl symbol arguments
	public var xflSymbolArguments(get, never):XFLSymbolArguments;
	// display object container
	public function addChild(child:DisplayObject):DisplayObject;
	// XFL elements
	public function getXFLElementUntyped(name:String):Dynamic;
	public function getXFLElement(name:String):XFLElement;
	public function getXFLMovieClip(name:String):XFLMovieClip;
	public function getXFLSprite(name:String):XFLSprite;
	public function getXFLDisplayObject(name:String):DisplayObject;
	public function getXFLDisplayObjectContainer(name:String):DisplayObjectContainer;
	public function getXFLTextField(name:String):TextField;
	public function getXFLTextArea(name:String):TextArea;
	public function getXFLTextInput(name:String):TextInput;
	public function getXFLSlider(name:String):Slider;
	public function getXFLComboBox(name:String):ComboBox;
	public function getXFLCheckBox(name:String):CheckBox;
	public function getXFLRadioButton(name:String):RadioButton;
	public function getXFLList(name:String):List;
	public function getXFLScrollBar(name:String):ScrollBar;
	public function getXFLUIScrollBar(name:String):UIScrollBar;
	public function getXFLUIComponent(name:String):UIComponent;
	public function getXFLScrollPane(name:String):ScrollPane;
	public function getXFLProgressBar(name:String):ProgressBar;
	// values
	public function removeValue(key:String):Void;
	public function addValue(key:String, value:Dynamic):Void;
	public function getValue(key:String):Dynamic;
}
