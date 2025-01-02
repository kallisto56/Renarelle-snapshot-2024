namespace System.Math;


using System;


struct Sphere
{
	public Vector3 mCenter;
	public float mRadius;


	public bool Raycast (Ray ray, out Vector3 pointOnSphere, out float distance)
	{
		distance = default;
		pointOnSphere = default;

		Vector3 m = ray.mOrigin - this.mCenter;
		float b = Vector3.Dot(m, ray.mDirection);
		float c = Vector3.Dot(m, m);

		if (c > 0.0F && b > 0.0F)
			return false;

		float discriminant = b * b - c;

		if (discriminant < 0.0F)
			return false;

		distance = -b - Math.Sqrt(discriminant);
		if (distance < 0.0F)
			distance = 0.0F;

		pointOnSphere = pointOnSphere + distance * ray.mDirection;

		return true;
	}
}