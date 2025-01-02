namespace System.Math;


using System;


struct Plane
{
	public Vector3 mNormal;
	public float mDistance;
	public bool bIsFlipped;


	public this (Vector3 a, Vector3 b, Vector3 c)
	{
		this.mNormal = Vector3.Cross(b - a, c - a).mNormalized;
		this.mDistance = -Vector3.Dot(this.mNormal, a);
		this.bIsFlipped = false;
	}


	public bool Raycast (Ray ray, out float distance)
	{
		distance = default;

		float vdot = Vector3.Dot(ray.mDirection, this.mNormal);
		float ndot = -Vector3.Dot(ray.mOrigin, this.mNormal) - this.mDistance;

		if (Math.WithinEpsilon(vdot, 0) == true)
			return false;

		distance = ndot / vdot;
		return true;
	}


	public void Flip () mut
	{
		this.bIsFlipped = !this.bIsFlipped;
		this.mNormal = -this.mNormal;
		this.mDistance = -this.mDistance;
	}
}