namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class FixedSizeList<T>
{
	public T[] mData;
	public int mCount { get; protected set; }
	public int mCapacity => this.mData.Count;
	public int mSizeInBytes => (sizeof(T) * this.mCount);
	public void* CArray() => this.mData.CArray();


	public this (int capacity)
	{
		this.mData = new T[capacity];
	}


	public ~this ()
	{
		delete this.mData;
	}


	public void Add (T value)
	{
		this.mCount++;
		Debug.Assert(this.mCount - 1 < this.mData.Count);
		this.mData[this.mCount - 1] = value;
	}


	public void Clear ()
	{
		this.mCount = 0;
	}


	public ref T this[int idx]
	{
		[Checked, Inline]
		get
		{
			return ref this.mData[idx];
		}
	}
}