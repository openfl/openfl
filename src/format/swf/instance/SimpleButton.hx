package format.swf.instance;


import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.events.Event;
import flash.Lib;
import format.swf.data.SWFButtonRecord;
import format.swf.SWFTimelineContainer;
import format.swf.tags.IDefinitionTag;
import format.swf.tags.TagDefineBits;
import format.swf.tags.TagDefineBitsLossless;
import format.swf.tags.TagDefineButton2;
import format.swf.tags.TagDefineEditText;
import format.swf.tags.TagDefineFont;
import format.swf.tags.TagDefineShape;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagDefineText;
import format.swf.tags.TagPlaceObject;
import format.swf.timeline.FrameObject;


class SimpleButton extends flash.display.SimpleButton {
	
	
	@:noCompletion private var data:SWFTimelineContainer;
	@:noCompletion private var tag:TagDefineButton2;
	
	//TODO: Check why BlendModes in the SWF spec follow this order, and why the difference between cpp and flash order
	@:noCompletion static private var blendModes:Array<BlendMode> = [BlendMode.NORMAL, BlendMode.NORMAL, BlendMode.LAYER, BlendMode.MULTIPLY, BlendMode.SCREEN, BlendMode.LIGHTEN, BlendMode.DARKEN, BlendMode.DIFFERENCE, BlendMode.ADD, 	BlendMode.SUBTRACT,	BlendMode.INVERT, BlendMode.ALPHA, BlendMode.ERASE, BlendMode.OVERLAY, BlendMode.HARDLIGHT #if flash, BlendMode.SHADER #end];
	
	public function new (data:SWFTimelineContainer, tag:TagDefineButton2) {
		
		super ();
		
		this.data = data;
		this.tag = tag;
		
		var displayObject:DisplayObject;
		var stateSprite:Sprite = null;
		var rec:SWFButtonRecord;
		for (i in 0...tag.characters.length) {
			rec = tag.characters[i];
			//trace(i + ": " + rec);
			
			if (rec.stateUp) {
				/*if (this.upState == null)*/ this.upState = new Sprite();
				displayObject = getDisplayObject(rec.characterId);
				trace (displayObject);
				if (displayObject != null) placeButtonRecord(displayObject, rec, this.upState);
				#if (mobile) if (this.overState == null) this.overState = this.upState; #end
			}
			#if !(mobile)
			if (rec.stateOver) {
				/*if (this.overState == null)*/ this.overState = new Sprite();
				displayObject = getDisplayObject(rec.characterId);
				if (displayObject != null)  placeButtonRecord(displayObject, rec, this.overState);
			}
			#end
			if (rec.stateDown) {
				/*if (this.downState == null)*/ this.downState = new Sprite();
				displayObject = getDisplayObject(rec.characterId);
				if (displayObject != null)  placeButtonRecord(displayObject, rec, this.downState);
			}
			if (rec.stateHitTest) {
				/*if (this.hitTestState == null)*/ this.hitTestState = new Sprite();
				displayObject = getDisplayObject(rec.characterId);
				if (displayObject != null)  placeButtonRecord(displayObject, rec, this.hitTestState);
			}
			
		}
	}
	
	@:noCompletion private inline function getDisplayObject(charId:Int):DisplayObject {
		var symbol = data.getCharacter (charId);
		//var grid = data.getScalingGrid (charId);
		var displayObject:DisplayObject = null;
		
		if (Std.is (symbol, TagDefineSprite)) {
			
			displayObject = new MovieClip (cast symbol);
			
		} else if (Std.is (symbol, TagDefineBitsLossless) || Std.is (symbol, TagDefineBits)) {
			
			displayObject = new Bitmap (cast symbol);
			
		} else if (Std.is (symbol, TagDefineShape)) {
			
			displayObject = new Shape (data, cast symbol);
			
		} else if (Std.is (symbol, TagDefineText)) {
			
			displayObject = new StaticText (data, cast symbol);
			
		} else if (Std.is (symbol, TagDefineEditText)) {
			
			displayObject = new DynamicText (data, cast symbol);
			
		} else if (Std.is (symbol, TagDefineButton2)) {
			displayObject = new SimpleButton(data, cast symbol);
		}
		
		if (displayObject != null) {
			
			//if (grid != null) {
				//
				//displayObject.scale9Grid = grid.splitter.rect.clone ();
				//
			//}
		}
		
		return displayObject;
		
		
	}
	
	@:noCompletion private inline function placeButtonRecord(displayObject:DisplayObject, record:SWFButtonRecord, container:DisplayObject) :Void {
		if (record.placeMatrix != null) {
			displayObject.transform.matrix = new Matrix(record.placeMatrix.matrix.a, record.placeMatrix.matrix.b, record.placeMatrix.matrix.c, record.placeMatrix.matrix.d, record.placeMatrix.matrix.tx / 20, record.placeMatrix.matrix.ty / 20);
		}
		
		if (record.hasFilterList) {
			var filters:Array<BitmapFilter> = [];
			
			for (i in 0...record.filterList.length) {
				filters.push(record.filterList[i].filter);
			}
			displayObject.filters = filters;
		}
		
		if (record.hasBlendMode) {
			
			//trace("blendMode :" + record.blendMode);
			//
			//trace("NORMAL: " + Type.enumIndex(BlendMode.NORMAL));
			//trace("LAYER: " + Type.enumIndex(BlendMode.LAYER));
			//trace("MULTIPLY: " + Type.enumIndex(BlendMode.MULTIPLY));
			//trace("SCREEN: " + Type.enumIndex(BlendMode.SCREEN));
			//trace("LIGHTEN: " + Type.enumIndex(BlendMode.LIGHTEN));
			//trace("DARKEN: " + Type.enumIndex(BlendMode.DARKEN));
			//trace("DIFFERENCE: " + Type.enumIndex(BlendMode.DIFFERENCE));
			//trace("ADD: " + Type.enumIndex(BlendMode.ADD));
			//trace("SUBTRACT: " + Type.enumIndex(BlendMode.SUBTRACT));
			//trace("INVERT: " + Type.enumIndex(BlendMode.INVERT));
			//trace("ALPHA: " + Type.enumIndex(BlendMode.ALPHA));
			//trace("ERASE: " + Type.enumIndex(BlendMode.ERASE));
			//trace("OVERLAY: " + Type.enumIndex(BlendMode.OVERLAY));
			//trace("HARDLIGHT: " + Type.enumIndex(BlendMode.HARDLIGHT));
			//trace("SHADER: " + Type.enumIndex(BlendMode.SHADER));
			
			//var arr = Type.getEnumConstructs(BlendMode);
			//for (i in 0...arr.length) {
				//trace(i + ") " + arr[i] + ": " + Type.enumIndex(Type.createEnum(BlendMode, arr[i])));
			//}
			//trace("Constrs:" + Type.getEnumConstructs(BlendMode));
			//displayObject.blendMode = Type.createEnumIndex(BlendMode, record.blendMode - 1);
			
			displayObject.blendMode = blendModes[record.blendMode];
			
		}
		
		if (record.colorTransform != null) {
			displayObject.transform.colorTransform = record.colorTransform.colorTransform;
		}
		var spr:Sprite = cast(container, Sprite);
		spr.addChildAt(displayObject, (spr.numChildren < record.placeDepth)? spr.numChildren : record.placeDepth - 1);
		//cast(container, Sprite).addChild(displayObject);
	}
	
}