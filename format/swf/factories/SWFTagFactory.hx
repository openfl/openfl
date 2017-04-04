package format.swf.factories;

import format.swf.tags.ITag;
import format.swf.tags.Tag;
import format.swf.tags.TagCSMTextSettings;
import format.swf.tags.TagDebugID;
import format.swf.tags.TagDefineBinaryData;
import format.swf.tags.TagDefineBits;
import format.swf.tags.TagDefineBitsJPEG2;
import format.swf.tags.TagDefineBitsJPEG3;
import format.swf.tags.TagDefineBitsJPEG4;
import format.swf.tags.TagDefineBitsLossless;
import format.swf.tags.TagDefineBitsLossless2;
import format.swf.tags.TagDefineButton;
import format.swf.tags.TagDefineButton2;
import format.swf.tags.TagDefineButtonCxform;
import format.swf.tags.TagDefineButtonSound;
import format.swf.tags.TagDefineEditText;
import format.swf.tags.TagDefineFont;
import format.swf.tags.TagDefineFont2;
import format.swf.tags.TagDefineFont3;
import format.swf.tags.TagDefineFont4;
import format.swf.tags.TagDefineFontAlignZones;
import format.swf.tags.TagDefineFontInfo;
import format.swf.tags.TagDefineFontInfo2;
import format.swf.tags.TagDefineFontName;
import format.swf.tags.TagDefineMorphShape;
import format.swf.tags.TagDefineMorphShape2;
import format.swf.tags.TagDefineScalingGrid;
import format.swf.tags.TagDefineSceneAndFrameLabelData;
import format.swf.tags.TagDefineShape;
import format.swf.tags.TagDefineShape2;
import format.swf.tags.TagDefineShape3;
import format.swf.tags.TagDefineShape4;
import format.swf.tags.TagDefineSound;
import format.swf.tags.TagDefineSprite;
import format.swf.tags.TagDefineText;
import format.swf.tags.TagDefineText2;
import format.swf.tags.TagDefineVideoStream;
import format.swf.tags.TagDoABC;
import format.swf.tags.TagDoABCDeprecated;
import format.swf.tags.TagDoAction;
import format.swf.tags.TagDoInitAction;
import format.swf.tags.TagEnableDebugger;
import format.swf.tags.TagEnableDebugger2;
import format.swf.tags.TagEnableTelemetry;
import format.swf.tags.TagEnd;
import format.swf.tags.TagExportAssets;
import format.swf.tags.TagFileAttributes;
import format.swf.tags.TagFrameLabel;
import format.swf.tags.TagImportAssets;
import format.swf.tags.TagImportAssets2;
import format.swf.tags.TagJPEGTables;
import format.swf.tags.TagMetadata;
import format.swf.tags.TagNameCharacter;
import format.swf.tags.TagPlaceObject;
import format.swf.tags.TagPlaceObject2;
import format.swf.tags.TagPlaceObject3;
import format.swf.tags.TagPlaceObject4;
import format.swf.tags.TagProductInfo;
import format.swf.tags.TagProtect;
import format.swf.tags.TagRemoveObject;
import format.swf.tags.TagRemoveObject2;
import format.swf.tags.TagScriptLimits;
import format.swf.tags.TagSetBackgroundColor;
import format.swf.tags.TagSetTabIndex;
import format.swf.tags.TagShowFrame;
import format.swf.tags.TagSoundStreamBlock;
import format.swf.tags.TagSoundStreamHead;
import format.swf.tags.TagSoundStreamHead2;
import format.swf.tags.TagStartSound;
import format.swf.tags.TagStartSound2;
import format.swf.tags.TagSymbolClass;
import format.swf.tags.TagUnknown;
import format.swf.tags.TagVideoFrame;
import format.swf.tags.etc.TagSWFEncryptActions;
import format.swf.tags.etc.TagSWFEncryptSignature;
//import format.swf.tags.*;
//import format.swf.tags.etc.*;

class SWFTagFactory implements ISWFTagFactory
{
	public function new () {
		
	}
	
	public function create(type:Int):ITag
	{
		switch(type) {
			/*   0 */ case TagEnd.TYPE: return createTagEnd();
			/*   1 */ case TagShowFrame.TYPE: return createTagShowFrame();
			/*   2 */ case TagDefineShape.TYPE: return createTagDefineShape();
			/*   4 */ case TagPlaceObject.TYPE: return createTagPlaceObject();
			/*   5 */ case TagRemoveObject.TYPE: return createTagRemoveObject();
			/*   6 */ case TagDefineBits.TYPE: return createTagDefineBits();
			/*   7 */ case TagDefineButton.TYPE: return createTagDefineButton();
			/*   8 */ case TagJPEGTables.TYPE: return createTagJPEGTables();
			/*   9 */ case TagSetBackgroundColor.TYPE: return createTagSetBackgroundColor();
			/*  10 */ case TagDefineFont.TYPE: return createTagDefineFont();
			/*  11 */ case TagDefineText.TYPE: return createTagDefineText();
			/*  12 */ case TagDoAction.TYPE: return createTagDoAction();
			/*  13 */ case TagDefineFontInfo.TYPE: return createTagDefineFontInfo();
			/*  14 */ case TagDefineSound.TYPE: return createTagDefineSound();
			/*  15 */ case TagStartSound.TYPE: return createTagStartSound();
			/*  17 */ case TagDefineButtonSound.TYPE: return createTagDefineButtonSound();
			/*  18 */ case TagSoundStreamHead.TYPE: return createTagSoundStreamHead();
			/*  19 */ case TagSoundStreamBlock.TYPE: return createTagSoundStreamBlock();
			/*  20 */ case TagDefineBitsLossless.TYPE: return createTagDefineBitsLossless();
			/*  21 */ case TagDefineBitsJPEG2.TYPE: return createTagDefineBitsJPEG2();
			/*  22 */ case TagDefineShape2.TYPE: return createTagDefineShape2();
			/*  23 */ case TagDefineButtonCxform.TYPE: return createTagDefineButtonCxform();
			/*  24 */ case TagProtect.TYPE: return createTagProtect();
			/*  26 */ case TagPlaceObject2.TYPE: return createTagPlaceObject2();
			/*  28 */ case TagRemoveObject2.TYPE: return createTagRemoveObject2();
			/*  32 */ case TagDefineShape3.TYPE: return createTagDefineShape3();
			/*  33 */ case TagDefineText2.TYPE: return createTagDefineText2();
			/*  34 */ case TagDefineButton2.TYPE: return createTagDefineButton2();
			/*  35 */ case TagDefineBitsJPEG3.TYPE: return createTagDefineBitsJPEG3();
			/*  36 */ case TagDefineBitsLossless2.TYPE: return createTagDefineBitsLossless2();
			/*  37 */ case TagDefineEditText.TYPE: return createTagDefineEditText();
			/*  39 */ case TagDefineSprite.TYPE: return createTagDefineSprite();
			/*  40 */ case TagNameCharacter.TYPE: return createTagNameCharacter();
			/*  41 */ case TagProductInfo.TYPE: return createTagProductInfo();
			/*  43 */ case TagFrameLabel.TYPE: return createTagFrameLabel();
			/*  45 */ case TagSoundStreamHead2.TYPE: return createTagSoundStreamHead2();
			/*  46 */ case TagDefineMorphShape.TYPE: return createTagDefineMorphShape();
			/*  48 */ case TagDefineFont2.TYPE: return createTagDefineFont2();
			/*  56 */ case TagExportAssets.TYPE: return createTagExportAssets();
			/*  57 */ case TagImportAssets.TYPE: return createTagImportAssets();
			/*  58 */ case TagEnableDebugger.TYPE: return createTagEnableDebugger();
			/*  59 */ case TagDoInitAction.TYPE: return createTagDoInitAction();
			/*  60 */ case TagDefineVideoStream.TYPE: return createTagDefineVideoStream();
			/*  61 */ case TagVideoFrame.TYPE: return createTagVideoFrame();
			/*  62 */ case TagDefineFontInfo2.TYPE: return createTagDefineFontInfo2();
			/*  63 */ case TagDebugID.TYPE: return createTagDebugID();
			/*  64 */ case TagEnableDebugger2.TYPE: return createTagEnableDebugger2();
			/*  65 */ case TagScriptLimits.TYPE: return createTagScriptLimits();
			/*  66 */ case TagSetTabIndex.TYPE: return createTagSetTabIndex();
			/*  69 */ case TagFileAttributes.TYPE: return createTagFileAttributes();
			/*  70 */ case TagPlaceObject3.TYPE: return createTagPlaceObject3();
			/*  71 */ case TagImportAssets2.TYPE: return createTagImportAssets2();
			/*  72 */ case TagDoABCDeprecated.TYPE: return createTagDoABCDeprecated();
			/*  73 */ case TagDefineFontAlignZones.TYPE: return createTagDefineFontAlignZones();
			/*  74 */ case TagCSMTextSettings.TYPE: return createTagCSMTextSettings();
			/*  75 */ case TagDefineFont3.TYPE: return createTagDefineFont3();
			/*  76 */ case TagSymbolClass.TYPE: return createTagSymbolClass();
			/*  77 */ case TagMetadata.TYPE: return createTagMetadata();
			/*  78 */ case TagDefineScalingGrid.TYPE: return createTagDefineScalingGrid();
			/*  82 */ case TagDoABC.TYPE: return createTagDoABC();
			/*  83 */ case TagDefineShape4.TYPE: return createTagDefineShape4();
			/*  84 */ case TagDefineMorphShape2.TYPE: return createTagDefineMorphShape2();
			/*  86 */ case TagDefineSceneAndFrameLabelData.TYPE: return createTagDefineSceneAndFrameLabelData();
			/*  87 */ case TagDefineBinaryData.TYPE: return createTagDefineBinaryData();
			/*  88 */ case TagDefineFontName.TYPE: return createTagDefineFontName();
			/*  89 */ case TagStartSound2.TYPE: return createTagStartSound2();
			/*  90 */ case TagDefineBitsJPEG4.TYPE: return createTagDefineBitsJPEG4();
			/*  91 */ case TagDefineFont4.TYPE: return createTagDefineFont4();
			
			/*  93 */ case TagEnableTelemetry.TYPE: return createTagEnableTelemetry();
			/*  94 */ case TagPlaceObject4.TYPE: return createTagPlaceObject4();
			
			/* 253 */ case TagSWFEncryptActions.TYPE: return createTagSWFEncryptActions();
			/* 255 */ case TagSWFEncryptSignature.TYPE: return createTagSWFEncryptSignature();

			default: return createTagUnknown(type);
		}
	}
	
	private function createTagEnd():ITag { return new TagEnd(); }
	private function createTagShowFrame():ITag { return new TagShowFrame(); }
	private function createTagDefineShape():ITag { return new TagDefineShape(); }
	private function createTagPlaceObject():ITag { return new TagPlaceObject(); }
	private function createTagRemoveObject():ITag { return new TagRemoveObject(); }
	private function createTagDefineBits():ITag { return new TagDefineBits(); }
	private function createTagDefineButton():ITag { return new TagDefineButton(); }
	private function createTagJPEGTables():ITag { return new TagJPEGTables(); }
	private function createTagSetBackgroundColor():ITag { return new TagSetBackgroundColor(); }
	private function createTagDefineFont():ITag { return new TagDefineFont(); }
	private function createTagDefineText():ITag { return new TagDefineText(); }
	private function createTagDoAction():ITag { return new TagDoAction(); }
	private function createTagDefineFontInfo():ITag { return new TagDefineFontInfo(); }
	private function createTagDefineSound():ITag { return new TagDefineSound(); }
	private function createTagStartSound():ITag { return new TagStartSound(); }
	private function createTagDefineButtonSound():ITag { return new TagDefineButtonSound(); }
	private function createTagSoundStreamHead():ITag { return new TagSoundStreamHead(); }
	private function createTagSoundStreamBlock():ITag { return new TagSoundStreamBlock(); }
	private function createTagDefineBitsLossless():ITag { return new TagDefineBitsLossless(); }
	private function createTagDefineBitsJPEG2():ITag { return new TagDefineBitsJPEG2(); }
	private function createTagDefineShape2():ITag { return new TagDefineShape2(); }
	private function createTagDefineButtonCxform():ITag { return new TagDefineButtonCxform(); }
	private function createTagProtect():ITag { return new TagProtect(); }
	private function createTagPlaceObject2():ITag { return new TagPlaceObject2(); }
	private function createTagRemoveObject2():ITag { return new TagRemoveObject2(); }
	private function createTagDefineShape3():ITag { return new TagDefineShape3(); }
	private function createTagDefineText2():ITag { return new TagDefineText2(); }
	private function createTagDefineButton2():ITag { return new TagDefineButton2(); }
	private function createTagDefineBitsJPEG3():ITag { return new TagDefineBitsJPEG3(); }
	private function createTagDefineBitsLossless2():ITag { return new TagDefineBitsLossless2(); }
	private function createTagDefineEditText():ITag { return new TagDefineEditText(); }
	private function createTagDefineSprite():ITag { return new TagDefineSprite(); }
	private function createTagNameCharacter():ITag { return new TagNameCharacter(); }
	private function createTagProductInfo():ITag { return new TagProductInfo(); }
	private function createTagFrameLabel():ITag { return new TagFrameLabel(); }
	private function createTagSoundStreamHead2():ITag { return new TagSoundStreamHead2(); }
	private function createTagDefineMorphShape():ITag { return new TagDefineMorphShape(); }
	private function createTagDefineFont2():ITag { return new TagDefineFont2(); }
	private function createTagExportAssets():ITag { return new TagExportAssets(); }
	private function createTagImportAssets():ITag { return new TagImportAssets(); }
	private function createTagEnableDebugger():ITag { return new TagEnableDebugger(); }
	private function createTagDoInitAction():ITag { return new TagDoInitAction(); }
	private function createTagDefineVideoStream():ITag { return new TagDefineVideoStream(); }
	private function createTagVideoFrame():ITag { return new TagVideoFrame(); }
	private function createTagDefineFontInfo2():ITag { return new TagDefineFontInfo2(); }
	private function createTagDebugID():ITag { return new TagDebugID(); }
	private function createTagEnableDebugger2():ITag { return new TagEnableDebugger2(); }
	private function createTagScriptLimits():ITag { return new TagScriptLimits(); }
	private function createTagSetTabIndex():ITag { return new TagSetTabIndex(); }
	private function createTagFileAttributes():ITag { return new TagFileAttributes(); }
	private function createTagPlaceObject3():ITag { return new TagPlaceObject3(); }
	private function createTagImportAssets2():ITag { return new TagImportAssets2(); }
	private function createTagDefineFontAlignZones():ITag { return new TagDefineFontAlignZones(); }
	private function createTagCSMTextSettings():ITag { return new TagCSMTextSettings(); }
	private function createTagDefineFont3():ITag { return new TagDefineFont3(); }
	private function createTagSymbolClass():ITag { return new TagSymbolClass(); }
	private function createTagMetadata():ITag { return new TagMetadata(); }
	private function createTagDefineScalingGrid():ITag { return new TagDefineScalingGrid(); }
	private function createTagDoABC():ITag { return new TagDoABC(); }
	private function createTagDoABCDeprecated():ITag { return new TagDoABCDeprecated(); }
	private function createTagDefineShape4():ITag { return new TagDefineShape4(); }
	private function createTagDefineMorphShape2():ITag { return new TagDefineMorphShape2(); }
	private function createTagDefineSceneAndFrameLabelData():ITag { return new TagDefineSceneAndFrameLabelData(); }
	private function createTagDefineBinaryData():ITag { return new TagDefineBinaryData(); }
	private function createTagDefineFontName():ITag { return new TagDefineFontName(); }
	private function createTagStartSound2():ITag { return new TagStartSound2(); }
	private function createTagDefineBitsJPEG4():ITag { return new TagDefineBitsJPEG4(); }
	private function createTagDefineFont4():ITag { return new TagDefineFont4(); }
	private function createTagEnableTelemetry():ITag { return new TagEnableTelemetry(); }
	private function createTagPlaceObject4():ITag { return new TagPlaceObject4(); }
	
	private function createTagSWFEncryptActions():ITag { return new TagSWFEncryptActions(); }
	private function createTagSWFEncryptSignature():ITag { return new TagSWFEncryptSignature(); }

	private function createTagUnknown(type:Int):ITag { return new TagUnknown(type); }
}
