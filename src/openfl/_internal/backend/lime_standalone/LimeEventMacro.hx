package openfl._internal.backend.lime_standalone;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using haxe.macro.Tools;

class LimeEventMacro
{
	public static function build()
	{
		var typeArgs;
		var typeResult;

		switch (Context.follow(Context.getLocalType()))
		{
			case TInst(_, [Context.follow(_) => TFun(args, result)]):
				typeArgs = args;
				typeResult = result;

			case TInst(localType, _):
				Context.fatalError("Invalid number of type parameters for " + localType.toString(), Context.currentPos());
				return null;

			default:
				throw false;
		}

		var typeParam = TFun(typeArgs, typeResult);
		var typeString = "";

		if (typeArgs.length == 0)
		{
			typeString = "Void->";
		}
		else
		{
			for (arg in typeArgs)
			{
				typeString += arg.t.toString() + "->";
			}
		}

		typeString += typeResult.toString();
		typeString = StringTools.replace(typeString, "->", "_");
		typeString = StringTools.replace(typeString, ".", "_");
		typeString = StringTools.replace(typeString, "<", "_");
		typeString = StringTools.replace(typeString, ">", "_");

		var name = "_Event_" + typeString;

		try
		{
			Context.getType("openfl._internal.backend.lime_standalone." + name);
		}
		catch (e:Dynamic)
		{
			var pos = Context.currentPos();
			var fields = Context.getBuildFields();

			var args:Array<FunctionArg> = [];
			var argName, argNames = [];

			for (i in 0...typeArgs.length)
			{
				if (i == 0)
				{
					argName = "a";
				}
				else
				{
					argName = "a" + i;
				}

				argNames.push(Context.parse(argName, pos));
				args.push({name: argName, type: typeArgs[i].t.toComplexType()});
			}

			var dispatch = macro
				{
					canceled = false;

					var listeners = __listeners;
					var repeat = __repeat;
					var i = 0;

					while (i < listeners.length)
					{
						listeners[i]($a{argNames});

						if (!repeat[i])
						{
							this.remove(cast listeners[i]);
						}
						else
						{
							i++;
						}

						if (canceled)
						{
							break;
						}
					}
				}

			var i = 0;
			var field;

			while (i < fields.length)
			{
				field = fields[i];

				if (field.name == "__listeners" || field.name == "dispatch")
				{
					fields.remove(field);
				}
				else
				{
					i++;
				}
			}

			fields.push({
				name: "__listeners",
				access: [APublic],
				kind: FVar(TPath({pack: [], name: "Array", params: [TPType(typeParam.toComplexType())]})),
				pos: pos
			});
			fields.push({
				name: "dispatch",
				access: [APublic],
				kind: FFun({
					args: args,
					expr: dispatch,
					params: [],
					ret: macro:Void
				}),
				pos: pos
			});

			var meta:Array<MetadataEntry> = [
				{name: ":dox", params: [macro hide], pos: pos},
				{name: ":noCompletion", pos: pos}
			];

			Context.defineType({
				pos: pos,
				pack: ["openfl", "_internal", "backend", "lime_standalone"],
				name: name,
				kind: TDClass(),
				fields: fields,
				params: [{name: "T"}],
				meta: meta
			});
		}

		return TPath({pack: ["openfl", "_internal", "backend", "lime_standalone"], name: name, params: [TPType(typeParam.toComplexType())]}).toType();
	}
}
#end
