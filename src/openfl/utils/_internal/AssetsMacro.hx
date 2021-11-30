package openfl.utils._internal;

#if macro
import haxe.crypto.BaseCode;
import haxe.io.Bytes;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.File;

@SuppressWarnings("checkstyle:FieldDocComment")
class AssetsMacro
{
	private static var base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	private static var base64Encoder:BaseCode;
	#if 0
	private static var __suppressWarning:Array<Class<Dynamic>> = [Expr];
	#end

	private static function base64Encode(bytes:Bytes):String
	{
		var extension = (switch (bytes.length % 3)
		{
			case 1: "==";
			case 2: "=";
			default: "";
		});

		if (base64Encoder == null)
		{
			base64Encoder = new BaseCode(Bytes.ofString(base64Chars));
		}

		return base64Encoder.encodeBytes(bytes).toString() + extension;
	}

	macro public static function embedBitmap():Array<Field>
	{
		#if html5
		var fields = embedData(":bitmap", true);
		#else
		var fields = embedData(":bitmap");
		#end

		if (fields != null)
		{
			var constructor = macro
				{
					#if html5
					super(0, 0, transparent, fillRGBA);

					if (preload != null)
					{
						__fromImage(preload);
					}
					else
					{
						__loadFromBase64(haxe.Resource.getString(resourceName), resourceType).onComplete(function(b)
						{
							if (preload == null)
							{
								preload = b.image;
							}

							if (onload != null && Reflect.isFunction(onload))
							{
								onload(b);
							}
						});
					}
					#else
					super(0, 0, transparent, fillRGBA);

					var byteArray = openfl.utils.ByteArray.fromBytes(haxe.Resource.getBytes(resourceName));
					__fromBytes(byteArray);
					#end
				};

			var args = [
				{
					name: "width",
					opt: false,
					type: macro:Int,
					value: null
				},
				{
					name: "height",
					opt: false,
					type: macro:Int,
					value: null
				},
				{
					name: "transparent",
					opt: true,
					type: macro:Bool,
					value: macro true
				},
				{
					name: "fillRGBA",
					opt: true,
					type: macro:Int,
					value: macro 0xFFFFFFFF
				}
			];

			#if html5
			args.push({
				name: "onload",
				opt: true,
				type: macro:Dynamic,
				value: null
			});
			fields.push({
				kind: FVar(macro:lime.graphics.Image, null),
				name: "preload",
				doc: null,
				meta: [],
				access: [APublic, AStatic],
				pos: Context.currentPos()
			});
			#end

			fields.push({
				name: "new",
				access: [APublic],
				kind: FFun({
					args: args,
					expr: constructor,
					params: [],
					ret: null
				}),
				pos: Context.currentPos()
			});
		}

		return fields;
	}

	private static function embedData(metaName:String, encode:Bool = false):Array<Field>
	{
		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();
		var position = Context.currentPos();
		var fields = Context.getBuildFields();

		for (meta in metaData)
		{
			if (meta.name == metaName)
			{
				if (meta.params.length > 0)
				{
					switch (meta.params[0].expr)
					{
						case EConst(CString(filePath)):
							var path = filePath;
							if (!sys.FileSystem.exists(filePath))
							{
								path = Context.resolvePath(filePath);
							}
							var bytes = File.getBytes(path);
							var resourceName = "__ASSET__"
								+ metaName
								+ "_"
								+ (classType.pack.length > 0 ? classType.pack.join("_") + "_" : "")
								+ classType.name;

							if (encode)
							{
								var resourceType = "image/png";

								if (bytes.get(0) == 0xFF && bytes.get(1) == 0xD8)
								{
									resourceType = "image/jpg";
								}
								else if (bytes.get(0) == 0x47 && bytes.get(1) == 0x49 && bytes.get(2) == 0x46)
								{
									resourceType = "image/gif";
								}

								var fieldValue = {pos: position, expr: EConst(CString(resourceType))};
								fields.push({
									kind: FVar(macro:String, fieldValue),
									name: "resourceType",
									access: [APrivate, AStatic],
									pos: position
								});

								var base64 = base64Encode(bytes);
								Context.addResource(resourceName, Bytes.ofString(base64));
							}
							else
							{
								Context.addResource(resourceName, bytes);
							}

							var fieldValue = {pos: position, expr: EConst(CString(resourceName))};
							fields.push({
								kind: FVar(macro:String, fieldValue),
								name: "resourceName",
								access: [APrivate, AStatic],
								pos: position
							});

							return fields;

						default:
					}
				}
			}
		}

		return null;
	}

	macro public static function embedFile():Array<Field>
	{
		var fields = embedData(":file");

		if (fields != null)
		{
			var constructor = macro
				{
					super();

					__fromBytes(haxe.Resource.getBytes(resourceName));
				};

			var args = [
				{
					name: "size",
					opt: true,
					type: macro:Int,
					value: macro 0
				}
			];
			fields.push({
				name: "new",
				access: [APublic],
				kind: FFun({
					args: args,
					expr: constructor,
					params: [],
					ret: null
				}),
				pos: Context.currentPos()
			});
		}

		return fields;
	}

	macro public static function embedFont():Array<Field>
	{
		var fields = null;

		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();
		var position = Context.currentPos();
		var fields = Context.getBuildFields();

		var path = "";

		for (meta in metaData)
		{
			if (meta.name == ":font")
			{
				if (meta.params.length > 0)
				{
					switch (meta.params[0].expr)
					{
						case EConst(CString(filePath)):
							path = filePath;
							if (!sys.FileSystem.exists(filePath))
							{
								path = Context.resolvePath(filePath);
							}

						default:
					}
				}
			}
		}

		if (path != null && path != "")
		{
			#if html5
			Sys.command("haxelib", ["run", "openfl", "generate", "-font-hash", sys.FileSystem.fullPath(path)]);
			path += ".hash";
			#end

			var bytes = File.getBytes(path);
			var resourceName = "NME_font_" + (classType.pack.length > 0 ? classType.pack.join("_") + "_" : "") + classType.name;

			Context.addResource(resourceName, bytes);

			var fieldValue = {pos: position, expr: EConst(CString(resourceName))};
			fields.push({
				kind: FVar(macro:String, fieldValue),
				name: "resourceName",
				access: [APublic, AStatic],
				pos: position
			});

			// var constructor = macro {
			//
			// super();
			//
			// fontName = resourceName;
			//
			// };
			//
			// fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: constructor, params: [], ret: null }), pos: Context.currentPos() });

			return fields;
		}

		return fields;
	}

	macro public static function embedSound():Array<Field>
	{
		var fields = embedData(":sound");

		if (fields != null)
		{
			// CFFILoader.h(248) : NOT Implemented:api_buffer_data
			#if (!html5)
			var constructor = macro
				{
					super();

					var byteArray = openfl.utils.ByteArray.fromBytes(haxe.Resource.getBytes(resourceName));
					loadCompressedDataFromByteArray(byteArray, byteArray.length);
				};

			var args = [
				{
					name: "stream",
					opt: true,
					type: macro:openfl.net.URLRequest,
					value: null
				},
				{
					name: "context",
					opt: true,
					type: macro:openfl.media.SoundLoaderContext,
					value: null
				}
			];
			fields.push({
				name: "new",
				access: [APublic],
				kind: FFun({
					args: args,
					expr: constructor,
					params: [],
					ret: null
				}),
				pos: Context.currentPos()
			});
			#end
		}

		return fields;
	}

	macro public static function initBinding():Array<Field>
	{
		var classType = Context.getLocalClass().get();
		var metaData = classType.meta.get();

		for (meta in metaData)
		{
			if (meta.name == ":bind")
			{
				var fields = Context.getBuildFields();
				var position = Context.currentPos();

				for (field in fields)
				{
					if (field.name == "new")
					{
						var className = null;

						for (meta in metaData)
						{
							if (meta.name == ":native" && meta.params.length > 0)
							{
								switch (meta.params[0].expr)
								{
									case EConst(CString(nativePath)):
										className = nativePath;
									default:
								}
								break;
							}
						}

						if (className == null)
						{
							className = (classType.pack.length > 0 ? classType.pack.join(".") + "." : "") + classType.name;
						}

						var exprs:Array<Expr> = [];
						exprs.push(macro openfl.utils.Assets.initBinding($v{className}, this));

						var expr = macro $b{exprs};
						expr.pos = position;

						switch (field.kind)
						{
							case FFun(f):
								exprs.push(f.expr);
								field.kind = FFun({
									args: f.args,
									expr: expr,
									params: f.params,
									ret: f.ret
								});
							default:
						}
						return fields;
					}
				}

				break;
			}
		}

		return null;
	}
}
#end
