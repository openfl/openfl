package;

import format.abc.Data;
import format.swf.SWFRoot;
import lime.utils.Log;
using FrameScriptParser.AVM2;

class FrameScriptParser
{
	public static function getBaseClassName(swfData:SWFRoot, className:String):String
	{
		var classData = swfData.abcData.findClassByName(className);
		if (classData != null && classData.superclass != null)
		{
			var superClassName = swfData.abcData.resolveMultiNameByIndex(classData.superclass);
			switch (superClassName.nameSpace)
			{
				case NPublic(_) if (!~/^flash\./.match(superClassName.nameSpaceName)):
					if (superClassName.nameSpaceName != "")
					{
						return superClassName.nameSpaceName + "." + superClassName.name;
					}
					else
					{
						return superClassName.name;
					}
				default:
			}
		}
		return null;
	}

	public static function convertToJS(swfData:SWFRoot, className:String):Array<String>
	{
		var cls = swfData.abcData.findClassByName(className);
		var scripts = null;

		if (cls != null && cls.fields != null && cls.fields.length > 0)
		{
			for (field in cls.fields)
			{
				switch (field.kind)
				{
					case FMethod(var idx, _, _, _):
						var methodName = swfData.abcData.resolveMultiNameByIndex(field.name);
						if (AVM2.FRAME_SCRIPT_METHOD_NAME.match(methodName.name))
						{
							var frameNumOneIndexed = Std.parseInt(AVM2.FRAME_SCRIPT_METHOD_NAME.matched(1));
							// Log.info("", "frame script #" + frameNumOneIndexed);
							var pcodes:Array<OpCode> = swfData.pcode[idx.getIndex()];
							var js = "";
							var prop:MultiName = null;
							var stack:Array<Dynamic> = new Array();
							for (pcode in pcodes)
							{
								switch (pcode)
								{
									case OThis:
										stack.push("this");
									case OScope:
										stack.pop();
									case OFindPropStrict(nameIndex):
									//										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);
									case OGetLex(nameIndex):
										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

										var fullname = "";

										if (prop != null)
										{
											fullname += AVM2.getFullName(swfData.abcData, prop, cls);
											stack.push(fullname);
										}
									case OGetProp(nameIndex):
										var fullname = "";

										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

										if (prop != null)
										{
											fullname += stack.pop() + "." + AVM2.getFullName(swfData.abcData, prop, cls);
										}

										// Log.info("", "OGetProp fullname: " + fullname);

										stack.push(fullname);
									case OSetProp(nameIndex):
										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);
										// Log.info("", "OSetProp stack: " + prop + ", " + stack);

										var result = stack.pop();

										var name = null;

										if (prop != null)
										{
											if (prop.name != null)
											{
												name = "." + prop.name;
											}
											else
											{
												name = "[" + stack.pop() + "]";
											}
										}
										else
										{
											// Log.info("", "OSetProp stack prop is null");
											break;
										}

										var instance = stack.pop();

										if (instance != "this")
										{
											instance = "this" + "." + instance;
										}

										js += instance + name + " = " + result + ";\n";
									case OString(strIndex):
										var str = swfData.abcData.getStringByIndex(strIndex);
										stack.push("\"" + str + "\"");
									case OInt(i):
										stack.push(i);
										// Log.info("", "int: " + i);
									case OSmallInt(i):
										stack.push(i);
										// Log.info("", "smallint: " + i);
									case OCallPropVoid(nameIndex, argCount):
										var temp = AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack);

										if (stack.length > 0)
										{
											js += stack.pop() + ".";
										}
										else
										{
											js += "this" + ".";
										}

										js += temp;
										js += ";\n";
									case OCallProperty(nameIndex, argCount):
										// Log.info("", "OCallProperty stack: " + stack);

										stack.pop();
										if (prop != null)
										{
											stack.push(AVM2.getFullName(swfData.abcData, prop, cls)
												+ "."
												+ AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack));
										}
									case OConstructProperty(nameIndex, argCount):
										// Log.info("", "OConstructProperty stack: " + stack);

										var temp = "new ";
										temp += AVM2.parseFunctionCall(swfData.abcData, cls, nameIndex, argCount, stack);
										stack.push(temp);

										// Log.info("", "OConstructProperty value: " + temp);
									case OInitProp(nameIndex):
										// Log.info("", "OInitProp stack: " + stack);

										prop = swfData.abcData.resolveMultiNameByIndex(nameIndex);

										var temp = stack.pop();

										js += stack.pop() + "." + prop.name + " = " + Std.string(temp) + ";\n";
									case ODup:
										stack.push(stack[stack.length - 1]);
									case OArray(argCount):
										// Log.info("", "before array: " + stack);

										var str = "";
										var temp = [];
										for (i in 0...argCount)
										{
											temp.push(stack.pop());
										}
										temp.reverse();
										stack.push(temp);

										// Log.info("", "after array: " + stack);
									case ORetVoid:
									case ONull:
										stack.push(null);
									case OOp(op):
										var _operator = null;
										switch (op)
										{
											case OpMul:
												_operator = "*";
											case OpAdd:
												_operator = "+";
											default:
												// Log.info("", "OOp");
										}

										if (op == OpAs)
										{
											// Log.info("", "cast to " + stack.pop() + " is discarded");
										}

										if (_operator != null)
										{
											var temp = stack.pop();
											stack.push(Std.string(stack.pop()) + " " + _operator + " " + Std.string(temp));
										}
									case OJump(j, delta):
										switch (j)
										{
											case JNeq:
												// Log.info("", stack[0]);
												var temp = stack.pop();
												js += "if (" + Std.string(stack.pop()) + " == " + Std.string(temp) + ")\n";
											case JAlways:
												js += "else\n";
												// Log.info("", Std.string(delta));
											case JFalse:
												js += "if (" + Std.string(stack.pop()) + ")\n";
											default:
												// Log.info("", "OJump");
										}
									case OTrue:
										stack.push(true);
									case OFalse:
										stack.push(false);
									default:
										// TODO: throw() on unsupported pcodes
										// Log.info("", "pcode " + pcode);
								}
							}
							// Log.info("", "javascript:\n" + js);

							if (js != null && js.indexOf("null.") > -1)
							{
								// Log.info("", "Script appears to have been parsed improperly, discarding");
								js = null;
							}
							else
							{
								// store on SWFLite object for serialized .dat export
								if (scripts == null) scripts = [];
								scripts[frameNumOneIndexed - 1] = js;
							}
						}
					default:
				}
			}
		}

		return scripts;
	}
}

/**
 * AVM2 ActionScript3 Byte Code (ABC) Instruction Traversal
 */
typedef MultiName =
{
	var name:String;
	var nameIndex:Index<Name>;
	var nameSpace:Namespace;
	var nameSpaceName:String;
}

class AVM2
{
	public static var FRAME_SCRIPT_METHOD_NAME = ~/frame(\d+)/;

	public static function getIndex<T>(idx:Index<T>):Int
	{
		#if (haxe4 || (format > "3.4.2"))
		return idx.asInt();
		#else
		return switch (idx)
		{
			case Idx(i): i;
		};
		#end
	}

	public static function getMultiNameByIndex(abcData:ABCData, i:Index<Name>):Name
	{
		return abcData.names[i.getIndex() - 1];
	}

	public static function getStringByIndex(abcData:ABCData, i:Index<String>):String
	{
		return abcData.strings[i.getIndex() - 1];
	}

	public static function getNameSpaceByIndex(abcData:ABCData, i:Index<Namespace>):Namespace
	{
		return abcData.namespaces[i.getIndex() - 1];
	}

	public static function getFunctionByIndex(abcData:ABCData, i:Index<MethodType>):Function
	{
		return abcData.functions[i.getIndex()];
	}

	public static function resolveMultiNameByIndex(abcData:ABCData, i:Index<Name>):MultiName
	{
		var multiName = abcData.getMultiNameByIndex(i);
		switch (multiName)
		{
			case NName(nameIndex, nsIndex): // a.k.a. QName
				var nameSpace = abcData.getNameSpaceByIndex(nsIndex);
				switch (nameSpace)
				{
					case NPublic(nsNameIndex) | NInternal(nsNameIndex) | NPrivate(nsNameIndex): // a.k.a. PackageNamespace, PackageInternalNS
						return {
							name: abcData.getStringByIndex(nameIndex),
							nameIndex: i,
							nameSpace: nameSpace,
							nameSpaceName: abcData.getStringByIndex(nsNameIndex)
						}
					default:
						// Log.info("", "other type of namespace");
				}
			case NMulti(nameIndex, nsIndexSet):
				return {
					name: abcData.getStringByIndex(nameIndex),
					nameIndex: i,
					nameSpace: null,
					nameSpaceName: null
				}
			case NMultiLate(nset):
				return {
					name: null,
					nameIndex: i,
					nameSpace: null,
					nameSpaceName: null
				}
			default:
				// Log.info("", "other type of name");
		}
		return null;
	}

	public static function findClassByName(abcData:ABCData, s:String):ClassDef
	{
		if (s == null) return null;

		var x = s.lastIndexOf(".");
		var pkgName = "";
		var clsName = s;
		if (-1 != x)
		{
			pkgName = s.substr(0, x);
			clsName = s.substr(x + 1);
		}
		for (cls in abcData.classes)
		{
			if (cls.isInterface) continue;

			var multiName = abcData.resolveMultiNameByIndex(cls.name);

			if (multiName != null)
			{
				if (clsName == multiName.name && pkgName == multiName.nameSpaceName)
				{
					return cls;
				}
			}
			else
			{
				// Log.info("", "multiname: " + multiName);
			}
		}

		return null;
	}

	public static function classHasField(abcData:ABCData, cls:ClassDef, name:String):Bool
	{
		var classHasField = false;

		for (field in cls.fields)
		{
			switch (field.kind)
			{
				case FMethod(var idx, _, _, _):
					var methodName = abcData.resolveMultiNameByIndex(field.name);
					if (methodName.name == name)
					{
						classHasField = true;
						break;
					}
				case FVar(_, _, _):
					var methodName = abcData.resolveMultiNameByIndex(field.name);
					if (methodName.name == name)
					{
						classHasField = true;
						break;
					}
				default:
			}
		}

		return classHasField;
	}

	public static function getFullName(abcData:ABCData, prop:MultiName, cls:ClassDef):String
	{
		var js = null;

		if (prop == null)
		{
			// Log.info("", "unable to get full name of property, prop = null");
			return "";
		}

		if (prop.nameSpace == null)
		{
			// Log.info("", "namespace is null");
			js = prop.name;
		}
		else
		{
			switch (prop.nameSpace)
			{
				case NPublic(_) if ("" != prop.nameSpaceName):
					js = prop.nameSpaceName + "_" + prop.name;
				case NInternal(_) if (cls.name == prop.nameIndex):
					js = "this." + prop.name;
				case NPublic(_):
					switch (prop.name)
					{
						case "trace":
							js = "console.log";
						default:
							//						var classHasField = classHasField(abcData, cls, prop.name);
							//
							//						if (classHasField)
							//						{
							//							js = "this." + prop.name;
							//						}
							//						else
							//						{
							js = prop.name;
							//						}
					}
				default:
					// TODO: throw() on unsupported namespaces
					// Log.info("", "unsupported namespace " + prop.nameSpace);
			}
		}

		return js;
	}

	public static function parseFunctionCall(abcData:ABCData, cls:ClassDef, nameIndex:IName, argCount:Int, stack:Array<Dynamic>):String
	{
		var prop = abcData.resolveMultiNameByIndex(nameIndex);

		if (prop == null)
		{
			// Log.info("", "parseFunctionCall is stopped, prop = null");
			return "";
		}

		var js = getFullName(abcData, prop, cls);
		// invoke function
		js += "(";

		var temp = [];
		for (i in 0...argCount)
		{
			//			if (i > 0) js += ", ";
			var arg = stack.pop();
			if (Std.is(arg, String))
			{
				//				js += arg;
				temp.push(arg);
			}
			else
			{
				//				js += haxe.Json.stringify(arg);
				temp.push(haxe.Json.stringify(arg));
			}
		}
		temp.reverse();
		js += temp.join(", ") + ")";

		return js;
	}
}
