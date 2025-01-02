namespace Renarelle;


using System;
using System.Diagnostics;
using System.Math;


public class Transform : Component
{
	Vector3 mPosition = Vector3.Zero;
	Quaternion mRotation = Quaternion.Identity;
	Vector3 mScale = Vector3.One;

	public Vector3 WorldPosition
	{
		[Inline] get
		{
			Debug.Assert(this.bIsDirty == false);
			Debug.Assert(this.mOwner != null);

			if (this.mOwner.mParent == null)
				return this.LocalPosition;

			Transform parent = this.mOwner.mParent.Transform;
			return parent.LocalPosition + (parent.LocalRotation * (parent.LocalScale * this.LocalPosition));
		}
	}

	public Quaternion WorldRotation
	{
		get
		{
			Debug.Assert(this.bIsDirty == false);
			Debug.Assert(this.mOwner != null);

			if (this.mOwner.mParent == null)
				return this.LocalRotation;

			return this.mOwner.mParent.Transform.LocalRotation * this.LocalRotation;
		}
	}

	public Vector3 WorldScale
	{
		[Inline] get
		{
			Debug.Assert(this.bIsDirty == false);
			Debug.Assert(this.mOwner != null);

			if (this.mOwner.mParent == null)
				return this.LocalScale;

			return this.LocalRotation.mInverse * (this.mOwner.mParent.Transform.LocalScale * (this.LocalRotation * this.LocalScale));
		}
	}

	public Vector3 LocalPosition
	{
		get { return this.mPosition; }
		set { this.mPosition = value; this.bIsDirty = true; }
	}

	public Quaternion LocalRotation
	{
		get { return this.mRotation; }
		set { this.mRotation = value; this.bIsDirty = true; }
	}

	public Vector3 LocalScale
	{
		get { return this.mScale; }
		set { this.mScale = value; this.bIsDirty = true; }
	}

	public bool bIsDirty = true;
	public Matrix4x4 mWorldMatrix;

	[Inline] public Vector3 LocalForward => this.LocalRotation * Vector3.Forward;
	[Inline] public Vector3 LocalBack => this.LocalRotation * Vector3.Back;
	[Inline] public Vector3 LocalRight => this.LocalRotation * Vector3.Right;
	[Inline] public Vector3 LocalLeft => this.LocalRotation * Vector3.Left;
	[Inline] public Vector3 LocalUp => this.LocalRotation * Vector3.Up;
	[Inline] public Vector3 LocalDown => this.LocalRotation * Vector3.Down;

	[Inline] public Vector3 Forward => this.WorldRotation * Vector3.Forward;
	[Inline] public Vector3 Back => this.WorldRotation * Vector3.Back;
	[Inline] public Vector3 Right => this.WorldRotation * Vector3.Right;
	[Inline] public Vector3 Left => this.WorldRotation * Vector3.Left;
	[Inline] public Vector3 Up => this.WorldRotation * Vector3.Up;
	[Inline] public Vector3 Down => this.WorldRotation * Vector3.Down;


	public this (GameObject owner)
	{
		this.mOwner = owner;
	}


	public this (Vector3 position)
	{
		this.mPosition = position;
	}


	public this (Vector3 position, Quaternion rotation)
	{
		this.mPosition = position;
		this.mRotation = rotation;
	}


	public this (Vector3 position, Quaternion rotation, Vector3 scale)
	{
		this.mPosition = position;
		this.mRotation = rotation;
		this.mScale = scale;
	}


	public Matrix4x4 ComputeWorldMatrix ()
	{
		Debug.Assert(this.mOwner != null);

		if (this.bIsDirty == false)
			return this.mWorldMatrix;

		this.bIsDirty = false;

		// Calculating Translation-Rotation-Scale matrix
		this.mWorldMatrix = Matrix4x4.CreateTRS(this.LocalPosition, this.LocalRotation, this.LocalScale);

		// If this transform is a child of other transform, performing matrix-multiplication
		if (this.mOwner.mParent != null)
			this.mWorldMatrix = this.mOwner.mParent.Transform.mWorldMatrix * this.mWorldMatrix.mInverse;

		return this.mWorldMatrix;
	}


	public void LookAt (Vector3 target, Vector3 upwards)
	{
		this.LocalRotation = Quaternion(Matrix4x4.CreateLookAt(this.LocalPosition, target, upwards));
		this.bIsDirty = true;
	}


	public override void ToString(String strBuffer)
	{
		strBuffer.AppendF("Transform(\n	{0}, \n	{1}, \n	{2}\n);", this.LocalPosition, this.LocalRotation, this.LocalScale);
	}


	[Inline]
	static public Vector3 operator * (Transform transform, Vector3 p)
	{
		Debug.Assert(transform.bIsDirty == false);
		var v = (transform.mWorldMatrix * Vector4(p.mX, p.mY, p.mZ, 1.0F));
		return Vector3(v.mX, v.mY, v.mZ);
	}


}