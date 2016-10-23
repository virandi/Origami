
package com.virandi.base
{
	import flash.display.TriangleCulling;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class CMath
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public const ANGLE_90:Number = CMath.AngleDegreeToRadian (90.0);
		
		static public const ANGLE_180:Number = CMath.AngleDegreeToRadian (180.0);
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public const ANGLE_DEGREE_TO_RADIAN:Number = (Math.PI / 180.0);
		
		static public const ANGLE_RADIAN_TO_DEGREE:Number = (180.0 / Math.PI);
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public function AngleDegreeToRadian (a:Number) : Number
		{
			return (a * CMath.ANGLE_DEGREE_TO_RADIAN);
		}
		
		static public function AngleRadianToDegree (a:Number) : Number
		{
			return (a * CMath.ANGLE_RADIAN_TO_DEGREE);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public function Add3D (a:Object, b:Object) : Object
		{
			return {x:(a.x + b.x), y:(a.y + b.y), z:(a.z + b.z)};
		}
		
		static public function Cross3D (a:Object, b:Object, c:Object) : Object
		{
			var v0:Object = ((a == null) ? b : CMath.Minus3D (b, a));
			var v1:Object = ((a == null) ? c : CMath.Minus3D (c, a));
			
			return CMath.Normalize3D ({x:((v0.z * v1.y) - (v0.y * v1.z)), y:((v0.x * v1.z) - (v0.z * v1.x)), z:((v0.y * v1.x) - (v0.x * v1.y))});
		}
		
		static public function Dot3D (a:Object, b:Object) : Object
		{
			return ((a.x * b.x) + (a.y * b.y) + (a.z * b.z));
		}
		
		static public function Length (a:Object, b:Object) : Object
		{
			return Math.sqrt (Math.pow ((b.x - a.x), 2.0) + Math.pow ((b.y - a.y), 2.0));
		}
		
		static public function Minus3D (a:Object, b:Object) : Object
		{
			return {x:(a.x - b.x), y:(a.y - b.y), z:(a.z - b.z)};
		}
		
		static public function Normalize3D (a:Object) : Object
		{
			var l:Number = Math.sqrt ((a.x * a.x) + (a.y * a.y) + (a.z * a.z));
			
			return {x:(a.x / l), y:(a.y / l), z:(a.z / l)};
		}
		
		static public function Zero (a:Number) : Boolean
		{
			return (Math.abs (a) <= 0.000000001);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public function Random (min:int, max:int) : int
		{
			return (int (Math.random () * ((max + 1) - min)) + min);
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		static public function IntersectionLine (v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D, x:Boolean) : Vector3D
		{
			var a:Number = 0.0;
			
			var b:Number = 0.0;
			
			var d:Number = 0.0;
			
			var s:Number = 0.0;
			
			var t:Number = 0.0;
			
			var vA:Vector3D = v1.subtract (v0);
			
			var vB:Vector3D = v3.subtract (v2);
			
			var vX:Vector3D = null;
			
			d = ((vA.x * vB.y) - (vA.y * vB.x));
			
			if (CMath.Zero (d) == false)
			{
				a = (v2.x - v0.x);
				
				b = (v2.y - v0.y);
				
				s = (((b * vA.x) - (a * vA.y)) / -d);
				
				t = (((a * vB.y) - (b * vB.x)) / d);
				
				vX = new Vector3D ((v0.x + (vA.x * t)), (v0.y + (vA.y * t)), 0.0, 0.0);
				
				if (x == false)
				{
				}
				else
				{
					if ((s < 0.0) || (s > 1.0) || (t < 1.0) || (t > 1.0))
					{
						vX = null;
					}
				}
			}
			
			return vX;
		}
		
		static public function MirrorVector (vector:Vector3D, v0:Vector3D, v1:Vector3D) : Vector3D
		{
			//return CMath.RotateVector (-(Vector3D.angleBetween (vector.subtract (v0), v1.subtract (v0)) * 2.0), v0, vector);
			
			var v:Vector3D = null;
			
			v = v1.subtract (v0);
			{
				v.scaleBy ((vector.subtract (v0).dotProduct (v) / ((v.x * v.x) + (v.y * v.y))));
			}
			v = v.add (v0);
			
			return v.subtract (vector).add (v);
		}
		
		static public function ParallelLine (v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D) : Boolean
		{
			return CMath.Zero (((v1.y - v0.y) / (v1.x - v0.x)) - ((v3.y - v2.y) / (v3.x - v2.x)));
		}
		
		static public function RotatePoint (angle:Number, origin:Point, point:Point) : Point
		{
			var cos:Number = Math.cos (angle);
			
			var sin:Number = Math.sin (angle);
			
			var x:Number = (((cos * (point.x - origin.x)) - (sin * (point.y - origin.y))) + origin.x);
			
			var y:Number = (((sin * (point.x - origin.x)) + (cos * (point.y - origin.y))) + origin.y);
			
			return new Point (x, y);
		}
		
		static public function RotateVector (angle:Number, origin:Vector3D, vector:Vector3D) : Vector3D
		{
			var cos:Number = Math.cos (angle);
			
			var sin:Number = Math.sin (angle);
			
			var v:Vector3D = vector.subtract (origin);
			
			v.setTo ((((cos * v.x) - (sin * v.y)) + origin.x), (((sin * v.x) + (cos * v.y)) + origin.y), 0.0);
			
			return v;
		}
		
		static public function Winding (x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number) : String
		{
			var z:Number = CMath.Cross3D ({x:x0, y:y0, z:0.0}, {x:x1, y:y1, z:0.0}, {x:x2, y:y2, z:0.0}).z;
			
			return ((isNaN (z) == true) ? TriangleCulling.NEGATIVE : ((z <= 0.0) ? TriangleCulling.NEGATIVE : TriangleCulling.POSITIVE));
		}
		
		////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}
