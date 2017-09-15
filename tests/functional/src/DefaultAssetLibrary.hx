package;

import lime.app.Future;
import lime.app.Promise;
import lime.media.AudioBuffer;
import lime.graphics.Image;
import lime.text.Font;
import lime.utils.Bytes;
import lime.Assets;


class DefaultAssetLibrary extends AssetLibrary {

	public function new () {

		super ();

	}


	public override function exists (id:String, type:String):Bool {

		return true;

	}


	public override function getAudioBuffer (id:String):AudioBuffer {

		return AudioBuffer.fromFile (id);

	}


	public override function getBytes (id:String):Bytes {

		return Bytes.readFile (id);

	}


	public override function getFont (id:String):Font {

		return Font.fromFile (id);

	}


	public override function getImage (id:String):Image {

		return Image.fromFile (id);

	}


	public override function getText (id:String):String {

		var bytes = getBytes (id);

		if (bytes == null) {

			return null;

		} else {

			return bytes.getString (0, bytes.length);

		}

	}


	public override function isLocal (id:String, type:String):Bool {

		return true;

	}


	public override function list (type:String):Array<String> {

		return [];

	}


	public override function loadAudioBuffer (id:String):Future<AudioBuffer> {

		var promise = new Promise<AudioBuffer> ();
		promise.completeWith (new Future<AudioBuffer> (function () return getAudioBuffer (id)));
		return promise.future;

	}


	public override function loadBytes (id:String):Future<Bytes> {

		var promise = new Promise<Bytes> ();
		promise.completeWith (new Future<Bytes> (function () return getBytes (id)));
		return promise.future;

	}


	public override function loadImage (id:String):Future<Image> {

		var promise = new Promise<Image> ();
		promise.completeWith (new Future<Image> (function () return getImage (id)));
		return promise.future;

	}


	public override function loadText (id:String):Future<String> {

		var promise = new Promise<String> ();
		promise.completeWith (loadBytes (id).then (function (bytes) {

			return new Future<String> (function () {

				if (bytes == null) {

					return null;

				} else {

					return bytes.getString (0, bytes.length);

				}

			});

		}));
		return promise.future;

	}


}
