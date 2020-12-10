/*
	Copyright (c) 2011, Adobe Systems Incorporated
	All rights reserved.
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are
	met:
	* Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.
	* Neither the name of Adobe Systems Incorporated nor the names of its
	contributors may be used to endorse or promote products derived from
	this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
	PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

package openfl.utils;

import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.Vector;

@SuppressWarnings("checkstyle:FieldDocComment")
class PerspectiveMatrix3D extends Matrix3D
{
	private var _x:Vector3D = new Vector3D();
	private var _y:Vector3D = new Vector3D();
	private var _z:Vector3D = new Vector3D();
	private var _w:Vector3D = new Vector3D();

	public function new(v:Vector<Float> = null)
	{
		super(v);
	}

	public function lookAtLH(eye:Vector3D, at:Vector3D, up:Vector3D):Void
	{
		_z.copyFrom(at);
		_z.subtract(eye);
		_z.normalize();
		_z.w = 0.0;

		_x.copyFrom(up);
		_crossProductTo(_x, _z);
		_x.normalize();
		_x.w = 0.0;

		_y.copyFrom(_z);
		_crossProductTo(_y, _x);
		_y.w = 0.0;

		_w.x = _x.dotProduct(eye);
		_w.y = _y.dotProduct(eye);
		_w.z = _z.dotProduct(eye);
		_w.w = 1.0;

		copyRowFrom(0, _x);
		copyRowFrom(1, _y);
		copyRowFrom(2, _z);
		copyRowFrom(3, _w);
	}

	public function lookAtRH(eye:Vector3D, at:Vector3D, up:Vector3D):Void
	{
		_z.copyFrom(eye);
		_z.subtract(at);
		_z.normalize();
		_z.w = 0.0;

		_x.copyFrom(up);
		_crossProductTo(_x, _z);
		_x.normalize();
		_x.w = 0.0;

		_y.copyFrom(_z);
		_crossProductTo(_y, _x);
		_y.w = 0.0;

		_w.x = _x.dotProduct(eye);
		_w.y = _y.dotProduct(eye);
		_w.z = _z.dotProduct(eye);
		_w.w = 1.0;

		copyRowFrom(0, _x);
		copyRowFrom(1, _y);
		copyRowFrom(2, _z);
		copyRowFrom(3, _w);
	}

	public function orthoLH(width:Float, height:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 / width, 0.0, 0.0, 0.0, 0.0, 2.0 / height, 0.0, 0.0, 0.0, 0.0, 1.0 / (zFar - zNear), 0.0, 0.0, 0.0, zNear / (zNear - zFar), 1.0
		]));
	}

	public function orthoOffCenterLH(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 / (right - left), 0.0, 0.0, 0.0, 0.0, 2.0 * zNear / (top - bottom), 0.0, 0.0, -1.0 - 2.0 * left / (right - left),
			1.0 + 2.0 * top / (bottom - top), 1.0 / (zFar - zNear), 0.0, 0.0, 0.0, zNear / (zNear - zFar), 1.0
		]));
	}

	public function orthoOffCenterRH(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 / (right - left), 0.0, 0.0, 0.0, 0.0, 2.0 * zNear / (top - bottom), 0.0, 0.0, -1.0 - 2.0 * left / (right - left),
			1.0 + 2.0 * top / (bottom - top), 1.0 / (zNear - zFar), 0.0, 0.0, 0.0, zNear / (zNear - zFar), 1.0
		]));
	}

	public function orthoRH(width:Float, height:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 / width, 0.0, 0.0, 0.0, 0.0, 2.0 / height, 0.0, 0.0, 0.0, 0.0, 1.0 / (zNear - zNear), 0.0, 0.0, 0.0, zNear / (zNear - zFar), 1.0
		]));
	}

	public function perspectiveFieldOfViewLH(fieldOfViewY:Float, aspectRatio:Float, zNear:Float, zFar:Float):Void
	{
		var yScale = 1.0 / Math.tan(fieldOfViewY / 2.0);
		var xScale = yScale / aspectRatio;

		this.copyRawDataFrom(Vector.ofArray([
			xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zFar / (zFar - zNear), 1.0, 0.0, 0.0, (zNear * zFar) / (zNear - zFar), 0.0
		]));
	}

	public function perspectiveFieldOfViewRH(fieldOfViewY:Float, aspectRatio:Float, zNear:Float, zFar:Float):Void
	{
		var yScale = 1.0 / Math.tan(fieldOfViewY / 2.0);
		var xScale = yScale / aspectRatio;

		this.copyRawDataFrom(Vector.ofArray([
			xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zFar / (zNear - zFar), -1.0, 0.0, 0.0, (zNear * zFar) / (zNear - zFar), 0.0
		]));
	}

	public function perspectiveOffCenterLH(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 * zNear / (right - left), 0.0, 0.0, 0.0, 0.0, -2.0 * zNear / (bottom - top), 0.0, 0.0, -1.0 - 2.0 * left / (right - left),
			1.0 + 2.0 * top / (bottom - top), -zFar / (zNear - zFar), 1.0, 0.0, 0.0, (zNear * zFar) / (zNear - zFar), 0.0
		]));
	}

	public function perspectiveLH(width:Float, height:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 * zNear / width, 0.0, 0.0, 0.0, 0.0, 2.0 * zNear / height, 0.0, 0.0, 0.0, 0.0, zFar / (zFar - zNear), 1.0, 0.0, 0.0,
			zNear * zFar / (zNear - zFar), 0.0
		]));
	}

	public function perspectiveOffCenterRH(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 * zNear / (right - left), 0.0, 0.0, 0.0, 0.0, -2.0 * zNear / (bottom - top), 0.0, 0.0, 1.0 + 2.0 * left / (right - left),
			-1.0 - 2.0 * top / (bottom - top), zFar / (zNear - zFar), -1.0, 0.0, 0.0, (zNear * zFar) / (zNear - zFar), 0.0
		]));
	}

	public function perspectiveRH(width:Float, height:Float, zNear:Float, zFar:Float):Void
	{
		this.copyRawDataFrom(Vector.ofArray([
			2.0 * zNear / width, 0.0, 0.0, 0.0, 0.0, 2.0 * zNear / height, 0.0, 0.0, 0.0, 0.0, zFar / (zNear - zFar), -1.0, 0.0, 0.0,
			zNear * zFar / (zNear - zFar), 0.0
		]));
	}

	private function _crossProductTo(a:Vector3D, b:Vector3D):Void
	{
		_w.x = a.y * b.z - a.z * b.y;
		_w.y = a.z * b.x - a.x * b.z;
		_w.z = a.x * b.y - a.y * b.x;
		_w.w = 1.0;
		a.copyFrom(_w);
	}
}
