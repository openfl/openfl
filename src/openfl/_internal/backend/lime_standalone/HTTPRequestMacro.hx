package openfl._internal.backend.lime_standalone; #if macro

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

class HTTPRequestMacro
{
	private static function build()
	{
		var paramType;
		var type:BaseType, typeArgs;
		var stringAbstract = false;
		var bytesAbstract = false;

		switch (Context.follow(Context.getLocalType()))
		{
			case TInst(localType, [t]):
				paramType = t;

				switch (t)
				{
					case TInst(t, args):
						type = t.get();
						typeArgs = args;

					case TAbstract(t, args):
						type = t.get();
						typeArgs = args;

						stringAbstract = isStringAbstract(t.get());
						if (!stringAbstract) bytesAbstract = isBytesAbstract(t.get());

					case TType(t, args):
						type = t.get();
						typeArgs = args;

					case TMono(_):
						Context.fatalError("Invalid number of type parameters for " + localType.toString(), Context.currentPos());
						return null;

					case TDynamic(_):
						switch (Context.getType("haxe.io.Bytes"))
						{
							case TInst(t, args):
								type = t.get();
								typeArgs = args;

							default:
								throw false;
						}

					default:
						throw false;
				}

			default:
				throw false;
		}

		var typeString = type.module;

		if (type.name != type.module && !StringTools.endsWith(type.module, "." + type.name))
		{
			typeString += "." + type.name;
		}

		if (typeString == "String" || stringAbstract)
		{
			return TPath(
				{
					pack: ["openfl", "_internal", "backend", "lime_standalone"],
					name: "HTTPRequest",
					sub: "_HTTPRequest_String",
					params: [TPType(paramType.toComplexType())]
				}).toType();
		}
		else if (typeString == "haxe.io.Bytes" || bytesAbstract)
		{
			return TPath(
				{
					pack: ["openfl", "_internal", "backend", "lime_standalone"],
					name: "HTTPRequest",
					sub: "_HTTPRequest_Bytes",
					params: [TPType(paramType.toComplexType())]
				}).toType();
		}
		else
		{
			var typeParamString = typeString;

			if (typeArgs.length > 0)
			{
				typeParamString += "<";

				for (i in 0...typeArgs.length)
				{
					if (i > 0) typeParamString += ",";
					typeParamString += typeArgs[i].toString();
				}

				typeParamString += ">";
			}

			var flattenedTypeString = typeParamString;

			flattenedTypeString = StringTools.replace(flattenedTypeString, "->", "_");
			flattenedTypeString = StringTools.replace(flattenedTypeString, ".", "_");
			flattenedTypeString = StringTools.replace(flattenedTypeString, "<", "_");
			flattenedTypeString = StringTools.replace(flattenedTypeString, ">", "_");

			var name = "_HTTPRequest_" + flattenedTypeString;

			try
			{
				Context.getType("openfl._internal.backend.lime_standalone." + name);
			}
			catch (e:Dynamic)
			{
				var pos = Context.currentPos();

				var fields = [
					{
						name: "new",
						access: [APublic],
						kind: FFun(
							{
								args: [
									{name: "uri", type: macro:String, opt: true}],
								expr: macro
								{super(uri);},
								params: [],
								ret: macro:Void
							}),
						pos: Context.currentPos()
					},
					{
						name: "fromBytes",
						access: [APrivate, AOverride],
						kind: FFun(
							{
								args: [
									{name: "bytes", type: macro:haxe.io.Bytes}],
								expr: Context.parse("return " + typeString + ".fromBytes (bytes)", pos),
								params: [],
								ret: paramType.toComplexType()
							}),
						pos: pos
					}
				];

				var meta:Array<MetadataEntry> = [];

				Context.defineType(
					{
						name: name,
						pack: ["openfl", "_internal", "backend", "lime_standalone"],
						kind: TDClass(
							{
								pack: ["openfl", "_internal", "backend", "lime_standalone"],
								name: "HTTPRequest",
								sub: "_HTTPRequest_Bytes",
								params: [TPType(paramType.toComplexType())]
							}, null, false),
						fields: fields,
						pos: pos,
						meta: meta
					});
			}

			return TPath({pack: ["openfl", "_internal", "backend", "lime_standalone"], name: name, params: []}).toType();
		}
	}

	private static function isBytesAbstract(type:AbstractType):Bool
	{
		while (type != null)
		{
			switch (type.type)
			{
				case TInst(t, _):
					return t.get().module == "haxe.io.Bytes";

				case TAbstract(t, _):
					type = t.get();

				default:
					return false;
			}
		}

		return false;
	}

	private static function isStringAbstract(type:AbstractType):Bool
	{
		while (type != null)
		{
			switch (type.type)
			{
				case TInst(t, _):
					return t.get().module == "String";

				case TAbstract(t, _):
					type = t.get();

				default:
					return false;
			}
		}

		return false;
	}
}
#end