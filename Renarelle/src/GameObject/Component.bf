namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


abstract public class Component
{
	public GameObject mOwner;
}


extension Component
{
	static List<Component> markedForDeletion;


	static this ()
	{
		Self.markedForDeletion = new List<Component>();
	}


	static ~this ()
	{
		delete Self.markedForDeletion;
	}


	static public void MarkForDeletion (Component component)
	{
		Self.markedForDeletion.Add(component);
	}


	static public void Cleanup ()
	{
		for (uint32 n = 0; n < Self.markedForDeletion.Count; n++)
			delete Self.markedForDeletion[n];

		Self.markedForDeletion.Clear();
	}
}