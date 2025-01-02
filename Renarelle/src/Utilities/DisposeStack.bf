namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class DisposeStack<T> : IDisposable
{
	T[] mArray;
	int mIndex;


	public T Current
	{
		[Inline] get { return this.mArray[this.mIndex]; }
	}


	public int Capacity
	{
		[Inline] get { return this.mArray.Count; }
	}


	public int Count
	{
		[Inline] get { return this.mIndex; }
	}


	public this (int capacity)
	{
		this.mArray = new T[capacity];
	}


	public ~this ()
	{
		delete this.mArray;
	}


	public DisposeStack<T> Push (T value)
	{
		this.mIndex++;
		Debug.Assert(this.mIndex < this.mArray.Count);

		this.mArray[this.mIndex] = value;
		return this;
	}


	public void Pop ()
	{
		this.mIndex--;
		Debug.Assert(this.mIndex >= 0);
	}


	public void Clear ()
	{
		this.mIndex = 0;
	}


	public void Dispose ()
	{
		[Inline]this.Pop();
	}
}