namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


class ResourceAlias<T> : IResourceAlias where T : IResource
{
	public StringView mState;
	public T mResource;


	public this (StringView state, T resource)
	{
		this.mState = state;
		this.mResource = resource;
	}


	public StringView GetState ()
	{
		return this.mState;
	}


	public StringView GetName ()
	{
		return this.mResource.GetName();
	}


	override public void ToString (String buffer)
	{
		String typeName = scope String();
		this.mResource.GetType().GetName(typeName);
		buffer.AppendF("{}(\"{}\")", typeName, this.mState);
	}


	public int GetHashCode ()
	{
		return HashCode.Mix(HashCode.Generate(this.mState), HashCode.Generate(this.mResource));
	}
}
