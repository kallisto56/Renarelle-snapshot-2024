namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


public class GameObject
{
	public bool bIsEnabled = true;
	public GameObject mParent;
	public List<GameObject> mChildren;
	public List<Component> mComponents;

	public Transform Transform
	{
		[Inline] get { return this.mTransform; }
	}
	public Transform mTransform;
	
	//public MeshComponent meshComponent { [Inline] get { return this.Get<MeshComponent>(); } }


	public this (GameObject owner = null)
	{
		this.mParent = owner;
		this.mChildren = new List<GameObject>();
		this.mComponents = new List<Component>();
		this.mTransform = new Transform(this);
	}


	public ~this ()
	{
		if (this.mTransform.mOwner == this)
			delete this.mTransform;

		for (uint32 n = 0; n < this.mChildren.Count; n++)
		{
			if (this.mChildren[n].mParent == this)
				delete this.mChildren[n];
		}

		for (uint32 n = 0; n < this.mComponents.Count; n++)
		{
			if (this.mComponents[n].mOwner == this)
				delete this.mComponents[n];
		}

		delete this.mChildren;
		delete this.mComponents;
	}


}