namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


public class CameraComponent : Component
{
	public float mNearPlane = 0.1F;
	public float mFarPlane = 100.0F;
	public float mFieldOfView = 90.0F;
	public float mOrthographicScale = 16.0F;

	public ProjectionType mProjectionType = .Perspective;

	Matrix4x4 mProjectionMatrix;
	Matrix4x4 mViewMatrix;
	Matrix4x4 mInverseViewMatrix;
	Matrix4x4 mViewProjectionMatrix;

	public Matrix4x4 ProjectionMatrix
	{
		[Inline] get { return this.mProjectionMatrix; }
	}

	public Matrix4x4 ViewMatrix
	{
		[Inline] get { return this.mViewMatrix; }
	}

	public Matrix4x4 InverseViewMatrix
	{
		[Inline] get { return this.mInverseViewMatrix; }
	}

	public Matrix4x4 ViewProjectionMatrix
	{
		[Inline] get { return this.mViewProjectionMatrix; }
	}


	public void ComputeMatrices (float aspectRatio)
	{
		// ...
		Transform transform = this.mOwner.Transform;
		transform.ComputeWorldMatrix();

		// Depending on the type of projection, create perspective or orthographic projection
		this.mProjectionMatrix = (this.mProjectionType == .Perspective)
			? this.CreatePerspectiveProjection(aspectRatio)
			: this.CreateOrthographicProjection(aspectRatio);

		// Calculating Translation-Rotation-Scale matrix and inverse of it
		this.mViewMatrix = Matrix4x4.CreateTRS(transform.WorldPosition, transform.WorldRotation, Vector3(+1, -1, +1));
		/*Matrix4x4 T = Matrix4x4.CreateTranslation(transform.WorldPosition);
		Matrix4x4 R = Matrix4x4.CreateRotation(transform.WorldRotation);
		Matrix4x4 S = Matrix4x4.CreateScale(Vector3(+1, -1, +1));
		this.mViewMatrix = T * R * S;*/

		this.mInverseViewMatrix = this.mViewMatrix.mInverse;

		// Calculate view-projection matrix, that will be used to create Model-View-Projection matrix
		this.mViewProjectionMatrix = this.mProjectionMatrix * this.mInverseViewMatrix;
	}


	Matrix4x4 CreatePerspectiveProjection (float aspectRatio)
	{
		float fovInRadians = Math.ToRadians(this.mFieldOfView);
		return Matrix4x4.CreatePerspective(fovInRadians, aspectRatio, this.mNearPlane, this.mFarPlane);
	}


	Matrix4x4 CreateOrthographicProjection (float aspectRatio)
	{
		float left = -aspectRatio;
		float right = +aspectRatio;
		float top = -1;
		float bottom = +1;

		return Matrix4x4.CreateOrthographic(left, right, top, bottom, this.mNearPlane, this.mFarPlane);
	}


	/*[Inline]
	public Matrix4x4 ComputeMVP (Transform transform)
	{
		Debug.Assert(transform != null);
		Debug.Assert(transform.bIsDirty == false);

		return this.mViewProjectionMatrix * transform.mWorldMatrix;
	}*/


	public Vector3 WorldToScreenSpace (Window window, Vector3 pointInSpace)
	{
		Vector4 pointOnScreen = this.mViewProjectionMatrix * Vector4(pointInSpace, 1.0F);
		Vector2 pixelCoords = Vector2(pointOnScreen.mX, pointOnScreen.mY) / pointOnScreen.mW;
		pixelCoords = pixelCoords * Vector2(0.5F) + Vector2(0.5F);
		pixelCoords = pixelCoords * Vector2(window.mWidth, window.mHeight);

		return Vector3(pixelCoords.mX, pixelCoords.mY, pointOnScreen.mZ);
	}


	public Vector2 WorldToScreen (Vector3 v)
	{
		Vector4 r = this.mViewProjectionMatrix * Vector4(v, 1);
		return Vector2(r.mX / r.mW, r.mY / r.mW);
	}


	/*public Ray CreateRay (Vector2 mousePosition, Viewport viewport)
	{
		// Converting pixel coordinates to uv-coordinates
		// NOTE: We are flipping y-axis
		float u = ((mousePosition.left - viewport.x) / viewport.width) * 2.0F - 1.0F;
		float v = -(((mousePosition.top - viewport.y) / viewport.height) * 2.0F - 1.0F);

		// Transforming point to world-space
		Vector4 unprojectedPoint = this.mProjectionMatrix.Inverse * Vector4(u, v, 0.0F, 1.0F);
		Vector4 pointInSpace = this.mOwner.Transform.mWorldMatrix * unprojectedPoint;
		pointInSpace /= pointInSpace.w;

		// Construction of ray
		Vector3 origin = this.mOwner.Transform.WorldPosition;
		Vector3 direction = (pointInSpace.xyz - origin).Normalized;

		// ...
		return Ray(origin, direction);
	}*/


	[Inline]
	static public Matrix4x4 operator * (CameraComponent camera, Transform transform)
	{
		return camera.mViewProjectionMatrix * transform.mWorldMatrix;
	}


}


enum ProjectionType
{
	Ortographic,
	Perspective,
}