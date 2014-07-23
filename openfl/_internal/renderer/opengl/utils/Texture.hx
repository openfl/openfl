package openfl._internal.renderer.opengl.utils;


import openfl.errors.Error;
import openfl.geom.Rectangle;
import openfl._internal.renderer.opengl.GLRenderer;


class Texture {
	
	
	public static var texturesToUpdate = [];
	public static var texturesToDestroy = [];
	
	public var baseTexture:Dynamic;
	public var frame:Rectangle;
	public var noFrame:Bool;
	public var scope:Dynamic;
	public var trim:Rectangle;
	public var _uvs:TextureUvs;
	public var valid:Bool;
	public var width:Float;
	public var height:Float;
	public var crop:Rectangle;
	
	
	public function new (baseTexture:Dynamic, frame:Rectangle = null)
	{
		//PIXI.EventTarget.call( this );

		/**
		* Does this Texture have any frame data assigned to it?
		*
		* @property noFrame
		* @type Boolean
		*/
		this.noFrame = false;

		if (frame == null)
		{
		this.noFrame = true;
		frame = new Rectangle(0,0,1,1);
		}

		if (Std.is (baseTexture, Texture))
		{
		baseTexture = baseTexture.baseTexture;
		}

		/**
		* The base texture that this texture uses.
		*
		* @property baseTexture
		* @type BaseTexture
		*/
		this.baseTexture = baseTexture;

		/**
		* The frame specifies the region of the base texture that this texture uses
		*
		* @property frame
		* @type Rectangle
		*/
		this.frame = frame;

		/**
		* The trim point
		*
		* @property trim
		* @type Rectangle
		*/
		this.trim = null;
		
		/**
		* This will let the renderer know if the texture is valid. If its not then it cannot be rendered.
		*
		* @property valid
		* @type Boolean
		*/
		this.valid = false;

		/**
		* The context scope under which events are run.
		*
		* @property scope
		* @type Object
		*/
		this.scope = this;

		/**
		* The WebGL UV data cache.
		*
		* @private
		* @property _uvs
		* @type Object
		*/
		this._uvs = null;
		
		/**
		* The width of the Texture in pixels.
		*
		* @property width
		* @type Number
		*/
		this.width = 0;

		/**
		* The height of the Texture in pixels.
		*
		* @property height
		* @type Number
		*/
		this.height = 0;

		/**
		* This is the area of the BaseTexture image to actually copy to the Canvas / WebGL when rendering,
		* irrespective of the actual frame size or placement (which can be influenced by trimmed texture atlases)
		*
		* @property crop
		* @type Rectangle
		*/
		this.crop = new Rectangle(0, 0, 1, 1);

		if (baseTexture.hasLoaded)
		{
		if (this.noFrame) frame = new Rectangle(0, 0, baseTexture.width, baseTexture.height);
		this.setFrame(frame);
		}
		else
		{
		var scope = this;
		baseTexture.addEventListener('loaded', function(){ scope.onBaseTextureLoaded(); });
		}
	}

	public function onBaseTextureLoaded ()
	{
		var baseTexture = this.baseTexture;
		//baseTexture.removeEventListener('loaded', this.onLoaded);

		if (this.noFrame) this.frame = new Rectangle(0, 0, baseTexture.width, baseTexture.height);
		
		this.setFrame(this.frame);

		//this.scope.dispatchEvent( { type: 'update', content: this } );
	}

	public function destroy (destroyBase)
	{
		if (destroyBase) this.baseTexture.destroy();

		this.valid = false;
	}

	public function setFrame (frame)
	{
		this.noFrame = false;

		this.frame = frame;
		this.width = frame.width;
		this.height = frame.height;

		this.crop.x = frame.x;
		this.crop.y = frame.y;
		this.crop.width = frame.width;
		this.crop.height = frame.height;

		if (this.trim == null && (frame.x + frame.width > this.baseTexture.width || frame.y + frame.height > this.baseTexture.height))
		{
		throw new Error('Texture Error: frame does not fit inside the base Texture dimensions ' + this);
		}

		this.valid = (frame != null && frame.width > 0 && frame.height > 0 && this.baseTexture.source != null && this.baseTexture.hasLoaded);

		if (this.trim != null)
		{
		this.width = this.trim.width;
		this.height = this.trim.height;
		this.frame.width = this.trim.width;
		this.frame.height = this.trim.height;
		}

		if (this.valid) Texture.frameUpdates.push(this);

	};

	public function _updateWebGLuvs ()
	{
		if(this._uvs == null)this._uvs = new TextureUvs();

		var frame = this.crop;
		var tw = this.baseTexture.width;
		var th = this.baseTexture.height;

		this._uvs.x0 = frame.x / tw;
		this._uvs.y0 = frame.y / th;

		this._uvs.x1 = (frame.x + frame.width) / tw;
		this._uvs.y1 = frame.y / th;

		this._uvs.x2 = (frame.x + frame.width) / tw;
		this._uvs.y2 = (frame.y + frame.height) / th;

		this._uvs.x3 = frame.x / tw;
		this._uvs.y3 = (frame.y + frame.height) / th;

	};

	public static function fromImage (imageUrl:String, crossorigin, scaleMode)
	{
		var texture = Texture.TextureCache[imageUrl];

		if(texture == null)
		{
		texture = new Texture(BaseTexture.fromImage(imageUrl, crossorigin, scaleMode));
		Texture.TextureCache[imageUrl] = texture;
		}

		return texture;
	}

	public static function fromFrame (frameId)
	{
		var texture = TextureCache[frameId];
		if(texture == null) throw new Error('The frameId "' + frameId + '" does not exist in the texture cache ');
		return texture;
	}

	public static function fromCanvas (canvas:Dynamic, scaleMode)
	{
		var baseTexture = BaseTexture.fromCanvas(canvas, scaleMode);

		return new Texture( baseTexture );

	}


	public static function addTextureToCache (texture, id)
	{
		TextureCache[id] = texture;
	}

	public static function removeTextureFromCache (id)
	{
		var texture = TextureCache[id];
	// delete PIXI.TextureCache[id];
		//delete PIXI.BaseTextureCache[id];
		TextureCache[id] = null;
		BaseTextureCache[id] = null;
		return texture;
	}
	
	public static function createWebGLTexture (texture:BaseTexture, gl:Dynamic)
	{


		if(texture.hasLoaded)
		{
		texture._glTextures[GLRenderer.glContextId] = gl.createTexture();

		gl.bindTexture(gl.TEXTURE_2D, texture._glTextures[GLRenderer.glContextId]);
		gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, texture.premultipliedAlpha);

		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texture.source);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, (texture.scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, (texture.scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);

		// reguler...

		if(!texture._powerOf2)
		{
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		}
		else
		{
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
		}

		gl.bindTexture(gl.TEXTURE_2D, null);

		texture._dirty[GLRenderer.glContextId] = false;
		}

		return  texture._glTextures[GLRenderer.glContextId];
	}

	
	public static function updateWebGLTexture (texture:BaseTexture, gl:Dynamic)
	{
		if( texture._glTextures[GLRenderer.glContextId] )
		{
		gl.bindTexture(gl.TEXTURE_2D, texture._glTextures[GLRenderer.glContextId]);
		gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, texture.premultipliedAlpha);

		gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, texture.source);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, (texture.scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);
		gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, (texture.scaleMode == cast ScaleMode.LINEAR) ? gl.LINEAR : gl.NEAREST);

		// reguler...

		if(!texture._powerOf2)
		{
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		}
		else
		{
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
		}

		texture._dirty[GLRenderer.glContextId] = false;
		}
		
	}
	
	public static var TextureCache = new Map<String, Dynamic> ();
	public static var FrameCache:Dynamic = {};

	public static var TextureCacheIdGenerator = 0;
	
	
	public static var BaseTextureCache = new Map <String, Dynamic> ();
	public static var BaseTextureCacheIdGenerator = 0;

	// this is more for webGL.. it contains updated frames..
	public static var frameUpdates = [];
	
	
}


class TextureUvs{
	
	
	public var x0:Float = 0;
	public var x1:Float = 0;
	public var x2:Float = 0;
	public var x3:Float = 0;
	public var y0:Float = 0;
	public var y1:Float = 0;
	public var y2:Float = 0;
	public var y3:Float = 0;
	
	
	public function new() {
		
	}
	
	
}




/**
 * ...
 * @author ...
 */
class BaseTexture{

	
	public var width:Float;
	public var height:Float;
	public var scaleMode:Int;
	public var hasLoaded:Bool;
	public var source:Dynamic;
	public var id:Int;
	public var premultipliedAlpha:Bool;
	public var imageUrl:String;
	public var _powerOf2:Bool;
	public var _glTextures:Array<Dynamic>;
	public var _dirty:Array<Dynamic>;
	
	
	public function new (source:Dynamic, scaleMode:Int)
	{
		//PIXI.EventTarget.call( this );

		/**
		* [read-only] The width of the base texture set when the image has loaded
		*
		* @property width
		* @type Number
		* @readOnly
		*/
		this.width = 100;

		/**
		* [read-only] The height of the base texture set when the image has loaded
		*
		* @property height
		* @type Number
		* @readOnly
		*/
		this.height = 100;

		/**
		* The scale mode to apply when scaling this texture
		* @property scaleMode
		* @type PIXI.scaleModes
		* @default PIXI.scaleModes.LINEAR
		*/
		this.scaleMode = scaleMode != null ? scaleMode : cast ScaleMode.DEFAULT;

		/**
		* [read-only] Describes if the base texture has loaded or not
		*
		* @property hasLoaded
		* @type Boolean
		* @readOnly
		*/
		this.hasLoaded = false;

		/**
		* The source that is loaded to create the texture
		*
		* @property source
		* @type Image
		*/
		this.source = source;

		//TODO will be used for futer pixi 1.5...
		this.id = Texture.BaseTextureCacheIdGenerator++;

		/**
		* Controls if RGB channels should be premultiplied by Alpha  (WebGL only)
		*
		* @property
		* @type Boolean
		* @default TRUE
		*/
		this.premultipliedAlpha = true;

		// used for webGL
		this._glTextures = [];
		
		// used for webGL teture updateing...
		this._dirty = [];
		
		if(source == null)return;

		if((this.source.complete || this.source.getContext != null) && this.source.width && this.source.height)
		{
		this.hasLoaded = true;
		this.width = this.source.width;
		this.height = this.source.height;

		Texture.texturesToUpdate.push(this);
		}
		else
		{

		var scope = this;
		this.source.onload = function() {

			scope.hasLoaded = true;
			scope.width = scope.source.width;
			scope.height = scope.source.height;

			for (i in 0...scope._glTextures.length)
			{
				scope._dirty[i] = true;
			}

			// add it to somewhere...
			//scope.dispatchEvent( { type: 'loaded', content: scope } );
		};
		this.source.onerror = function() {
			//scope.dispatchEvent( { type: 'error', content: scope } );
		};
		}

		this.imageUrl = null;
		this._powerOf2 = false;

		

	}
	
	
	public function destroy ()
	{
		if(this.imageUrl != null)
		{
		Texture.BaseTextureCache.remove (this.imageUrl);
		Texture.TextureCache.remove (this.imageUrl);
		this.imageUrl = null;
		this.source.src = null;
		}
		else if (this.source != null && this.source._pixiId != null)
		{
		Texture.BaseTextureCache.remove (this.source._pixiId);
		}
		this.source = null;
		Texture.texturesToDestroy.push(this);
	}

	public function updateSourceImage (newSrc)
	{
		this.hasLoaded = false;
		this.source.src = null;
		this.source.src = newSrc;
	}

	public static function fromImage (imageUrl:String, crossorigin, scaleMode)
	{
		#if js
		var baseTexture = Texture.BaseTextureCache.get (imageUrl);
		
		if(crossorigin == null && imageUrl.indexOf('data:') == -1) crossorigin = true;

		if(baseTexture == null)
		{
		// new Image() breaks tex loading in some versions of Chrome.
		// See https://code.google.com/p/chromium/issues/detail?id=238071
		var image = new js.html.Image();//document.createElement('img');
		if (crossorigin)
		{
			image.crossOrigin = '';
		}
		image.src = imageUrl;
		baseTexture = new BaseTexture(image, scaleMode);
		baseTexture.imageUrl = imageUrl;
		Texture.BaseTextureCache.set (imageUrl, baseTexture);
		}

		return baseTexture;
		#else
		return null;
		#end
	}

	public static function fromCanvas (canvas, scaleMode)
	{
		if(canvas._pixiId == null)
		{
		canvas._pixiId = 'canvas_' + Texture.TextureCacheIdGenerator++;
		}

		var baseTexture = Texture.BaseTextureCache.get (canvas._pixiId);

		if(baseTexture == null)
		{
		baseTexture = new BaseTexture(canvas, scaleMode);
		Texture.BaseTextureCache.set (canvas._pixiId, baseTexture);
		}

		return baseTexture;
	}
	
	
}