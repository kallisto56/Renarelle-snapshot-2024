namespace System.Math;


using System;


[CRepr]
struct Matrix4x4
{
	const public Matrix4x4 Identity = Matrix4x4(
		1F, 0F, 0F, 0F,
		0F, 1F, 0F, 0F,
		0F, 0F, 1F, 0F,
		0F, 0F, 0F, 1F
	);


	public float[16] mValues;


	public this (
		float m00, float m01, float m02, float m03,
		float m10, float m11, float m12, float m13,
		float m20, float m21, float m22, float m23,
		float m30, float m31, float m32, float m33
	)
	{
		this.mValues = float[16] (
			m00, m01, m02, m03,
			m10, m11, m12, m13,
			m20, m21, m22, m23,
			m30, m31, m32, m33
		);
	}


	public this (Quaternion q)
	{
		// Quaternion > Matrix3x2 > Matrix4x4
		float m00 = 1F - 2F * (q.mY * q.mY + q.mZ * q.mZ);
		float m01 = 2F * (q.mX * q.mY + q.mW * q.mZ);
		float m02 = 2F * (q.mX * q.mZ - q.mW * q.mY);
		float m10 = 2F * (q.mX * q.mY - q.mW * q.mZ);
		float m11 = 1F - 2F * (q.mX * q.mX + q.mZ * q.mZ);
		float m12 = 2F * (q.mY * q.mZ + q.mW * q.mX);
		float m20 = 2F * (q.mX * q.mZ + q.mW * q.mY);
		float m21 = 2F * (q.mY * q.mZ - q.mW * q.mX);
		float m22 = 1F - 2F * (q.mX * q.mX + q.mY * q.mY);

		this.mValues = float[16] (
			m00, m01, m02, 0F,
			m10, m11, m12, 0F,
			m20, m21, m22, 0F,
			0F, 0F, 0F, 1F
		);
	}


	public float m00 { [Inline] get { return this.mValues[00]; } [Inline] set mut { this.mValues[00] = value; } }
	public float m01 { [Inline] get { return this.mValues[01]; } [Inline] set mut { this.mValues[01] = value; } }
	public float m02 { [Inline] get { return this.mValues[02]; } [Inline] set mut { this.mValues[02] = value; } }
	public float m03 { [Inline] get { return this.mValues[03]; } [Inline] set mut { this.mValues[03] = value; } }

	public float m10 { [Inline] get { return this.mValues[04]; } [Inline] set mut { this.mValues[04] = value; } }
	public float m11 { [Inline] get { return this.mValues[05]; } [Inline] set mut { this.mValues[05] = value; } }
	public float m12 { [Inline] get { return this.mValues[06]; } [Inline] set mut { this.mValues[06] = value; } }
	public float m13 { [Inline] get { return this.mValues[07]; } [Inline] set mut { this.mValues[07] = value; } }

	public float m20 { [Inline] get { return this.mValues[08]; } [Inline] set mut { this.mValues[08] = value; } }
	public float m21 { [Inline] get { return this.mValues[09]; } [Inline] set mut { this.mValues[09] = value; } }
	public float m22 { [Inline] get { return this.mValues[10]; } [Inline] set mut { this.mValues[10] = value; } }
	public float m23 { [Inline] get { return this.mValues[11]; } [Inline] set mut { this.mValues[11] = value; } }

	public float m30 { [Inline] get { return this.mValues[12]; } [Inline] set mut { this.mValues[12] = value; } }
	public float m31 { [Inline] get { return this.mValues[13]; } [Inline] set mut { this.mValues[13] = value; } }
	public float m32 { [Inline] get { return this.mValues[14]; } [Inline] set mut { this.mValues[14] = value; } }
	public float m33 { [Inline] get { return this.mValues[15]; } [Inline] set mut { this.mValues[15] = value; } }


	public Matrix4x4 mTransposed
	{
		[Inline] get
		{
			return Matrix4x4(
				m00, m10, m20, m30,
				m01, m11, m21, m31,
				m02, m12, m22, m32,
				m03, m13, m23, m33
			);
		}
	}


	public float mDeterminant
	{
		[Inline] get
		{
			return
				m00 * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13)) -
				m10 * (m01 * (m22 * m33 - m32 * m23) - m21 * (m02 * m33 - m32 * m03) + m31 * (m02 * m23 - m22 * m03)) +
				m20 * (m01 * (m12 * m33 - m32 * m13) - m11 * (m02 * m33 - m32 * m03) + m31 * (m02 * m13 - m12 * m03)) -
				m30 * (m01 * (m12 * m23 - m22 * m13) - m11 * (m02 * m23 - m22 * m03) + m21 * (m02 * m13 - m12 * m03))
				;
		}
	}

	public Matrix4x4 mAdjugate
	{
		[Inline] get
		{
			return Matrix4x4(
				+m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13),
				-m01 * (m22 * m33 - m32 * m23) + m21 * (m02 * m33 - m32 * m03) - m31 * (m02 * m23 - m22 * m03),
				+m01 * (m12 * m33 - m32 * m13) - m11 * (m02 * m33 - m32 * m03) + m31 * (m02 * m13 - m12 * m03),
				-m01 * (m12 * m23 - m22 * m13) + m11 * (m02 * m23 - m22 * m03) - m21 * (m02 * m13 - m12 * m03),
				-m10 * (m22 * m33 - m32 * m23) + m20 * (m12 * m33 - m32 * m13) - m30 * (m12 * m23 - m22 * m13),
				+m00 * (m22 * m33 - m32 * m23) - m20 * (m02 * m33 - m32 * m03) + m30 * (m02 * m23 - m22 * m03),
				-m00 * (m12 * m33 - m32 * m13) + m10 * (m02 * m33 - m32 * m03) - m30 * (m02 * m13 - m12 * m03),
				+m00 * (m12 * m23 - m22 * m13) - m10 * (m02 * m23 - m22 * m03) + m20 * (m02 * m13 - m12 * m03),
				+m10 * (m21 * m33 - m31 * m23) - m20 * (m11 * m33 - m31 * m13) + m30 * (m11 * m23 - m21 * m13),
				-m00 * (m21 * m33 - m31 * m23) + m20 * (m01 * m33 - m31 * m03) - m30 * (m01 * m23 - m21 * m03),
				+m00 * (m11 * m33 - m31 * m13) - m10 * (m01 * m33 - m31 * m03) + m30 * (m01 * m13 - m11 * m03),
				-m00 * (m11 * m23 - m21 * m13) + m10 * (m01 * m23 - m21 * m03) - m20 * (m01 * m13 - m11 * m03),
				-m10 * (m21 * m32 - m31 * m22) + m20 * (m11 * m32 - m31 * m12) - m30 * (m11 * m22 - m21 * m12),
				+m00 * (m21 * m32 - m31 * m22) - m20 * (m01 * m32 - m31 * m02) + m30 * (m01 * m22 - m21 * m02),
				-m00 * (m11 * m32 - m31 * m12) + m10 * (m01 * m32 - m31 * m02) - m30 * (m01 * m12 - m11 * m02),
				+m00 * (m11 * m22 - m21 * m12) - m10 * (m01 * m22 - m21 * m02) + m20 * (m01 * m12 - m11 * m02)
			);
		}
	}


	public Matrix4x4 mInverse
	{
		[Inline] get { return this.mAdjugate / this.mDeterminant; }
	}
}