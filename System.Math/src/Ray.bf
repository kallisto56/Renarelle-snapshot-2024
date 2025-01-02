namespace System.Math;


using System;


struct Ray
{
	public Vector3 mOrigin;
	public Vector3 mDirection;


	public this (Vector3 origin, Vector3 direction)
	{
		this.mOrigin = origin;
		this.mDirection = direction;
	}
}