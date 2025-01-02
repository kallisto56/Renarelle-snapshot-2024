namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class VertexFormat
{
	public Element[] mElements;


	public this (params Element[] elements)
	{
		this.mElements = new Element[elements.Count];
		elements.CopyTo(this.mElements);
	}


	public ~this ()
	{
		delete this.mElements;
	}


	public struct Element
	{
		public c_int mIndex;
		public VertexType mType;
		public bool bIsNormalized;
	}


	public enum VertexType
	{
		Undefined,

		Float,
		Float2,
		Float3,
		Float4,

		Int8x4,
		UInt8x4,

		Int16x2,
		UInt16x2,

		Int16x4,
		UInt16x4
	}
}