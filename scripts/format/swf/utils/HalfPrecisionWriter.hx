/******************************************************************************
 * This file contains code licensed for use under the BSD license, and was
 * modified from the original  C source by James Tursa as provided at the
 * MatLab Central site here:
 * 
 *   http://www.mathworks.com/matlabcentral/fileexchange/23173
 * 
 * It has been modified to compile under ActionScript 3 for handling the
 * FLOAT16 data format used in Adobe's SWF file format, which is the same
 * as the IEEE 754r Half Precision format implemented by Mr. Tursa in the
 * original source.   
 * 
 * The original license follows:
 *  
 * Copyright (c) 2009, James Tursa
 * All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted provided that the following conditions are 
 *  met:
 *
 *     * Redistributions of source code must retain the above copyright 
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright 
 *       notice, this list of conditions and the following disclaimer in 
 *       the documentation and/or other materials provided with the distribution
 *      
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 *  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 *  POSSIBILITY OF SUCH DAMAGE.
 */
package format.swf.utils;

import format.swf.SWFData;

class HalfPrecisionWriter
{
	
	public static function write(value:Float, data:SWFData):Void
	{
		
		data.resetBitsPending();
		
		var dword:Int;
		var sign:Int;
		var exponent:Int;
		var significand:Int;
		var halfSignificand:Int;
		var signedExponent:Int;
		var result:Int = 0;			
		var p:Int;
		
		p = data.position;
		data.writeDouble(value);
		data.position -= 4;
		dword = data.readUnsignedInt();
		data.position = p;
		
		#if (neko && !neko_v2)
		result = dword >> 16;
		#else
		if ((dword & 0x7FFFFFFF) == 0) {												// Signed zero
			result = dword >> 16;	
		}
		else {
			
			sign        = dword & 0x80000000;
			exponent    = dword & 0x7FF00000;
			significand = dword & 0x000FFFFF;
			
			if (exponent == 0) {														// Denormal will underflow, signed zero
				result = sign >> 16;
			}
			else if (exponent == 0x7FF00000) {											// Infinity or NaN (all exponent bits set)
				if (significand == 0) {
					result = ((sign >> 16) | 0x7C00);									// Signed infinity
				}	
				else {
					result = 0xFE00;													// NaN, only 1st mantissa bit is set
				}
			}
			else {																		// Normalized number
				sign = sign >> 16;
				signedExponent = (exponent >> 20) - 1023 + 15;							// Reset the bias to half-precision
				if (signedExponent >= 0x1F) {											// Overflow
					result = ((significand >> 16) | 0x7C00);							// Signed infinity
				}
				else if (signedExponent <= 0) {											// Underflow
					if ((10 - signedExponent) > 21) {									// Significand shifted off and no rounding possible
						halfSignificand = 0;	
					}
					else {
						significand |= 0x00100000;										// Add leading bit
						halfSignificand = (significand >> (11 - signedExponent));
						if ((significand >> (10 - signedExponent)) & 0x00000001 > 0) {		// Check for rounding
							halfSignificand += 1;										// Round, might overflow into exponent (okay)
						}
					}
					result = (sign | halfSignificand);
				}
				else {
					exponent = signedExponent << 10;
					halfSignificand = significand >> 10; 
					if (significand & 0x00000200 > 0) {										// Check for rounding
						result = (sign | exponent | halfSignificand) + 1;				// Round, may overflow to infinity (okay)
					}
					else {
						result = (sign | exponent | halfSignificand);
					}
				}
			}
		}
		#end
		
		data.writeShort(result);		
		//data.length = p + 2;
		
	}
	
}