namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


extension UI
{
	public struct Value
	{
		public int mDesired;
		public int mCalculated;


		public this (int desired)
		{
			this.mDesired = desired;
			this.mCalculated = int.MinValue;
		}


		static public implicit operator Value (int value)
		{
			return Value(value);
		}


		static public implicit operator Value (float value)
		{
			return Value(int(value));
		}
	}
}