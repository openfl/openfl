/*
 * format - Haxe File Formats
 *
 * Copyright (c) 2008, The Haxe Project Contributors
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE HAXE PROJECT CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE HAXE PROJECT CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */

package openfl.utils._internal.format.amf3;

import openfl.Vector;
import openfl.utils.ByteArray;
import openfl.utils.IExternalizable;

enum AMF3Value
{
	AUndefined;
	ANull;
	ABool(b:Bool);
	AInt(i:Int);
	ANumber(f:Float);
	AString(s:String);
	ADate(d:Date);
	AObject(fields:Map<String, AMF3Value>, ?size:Int, ?className:String);
	AExternal(o:IExternalizable);
	AArray(values:Array<AMF3Value>, ?extra:Map<String, AMF3Value>);
	AIntVector(v:Vector<Int>);
	AFloatVector(v:Vector<Float>);
	AObjectVector(v:Vector<AMF3Value>, ?type:String);
	AXml(x:Xml);
	AByteArray(ba:ByteArray);
	AMap(m:Map<AMF3Value, AMF3Value>);
}
