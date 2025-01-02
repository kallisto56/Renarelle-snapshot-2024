namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Renderer2D
{
	public struct Batch
	{
		public int mIndex;
		public int mLength;
		public Texture mTexture;
		public Scissor mScissor;


		public this (Texture texture, Scissor scissor, int index, int length)
		{
			this.mTexture = texture;
			this.mScissor = scissor;
			this.mIndex = index;
			this.mLength = length;
		}


		public void Set (Texture texture, Scissor scissor, int index, int length) mut
		{
			this.mTexture = texture;
			this.mScissor = scissor;
			this.mIndex = index;
			this.mLength = length;
		}


		public bool IsBlank ()
		{
			return this.mTexture == null
				&& this.mScissor == default
				&& this.mLength == 0;
		}


		public bool Matches (Texture texture, Scissor scissor)
		{
			return this.mTexture == texture
				&& this.mScissor == scissor;
		}


		public bool Matches (Batch otherBatch)
		{
			return this.mTexture == otherBatch.mTexture
				&& this.mScissor == otherBatch.mScissor;
		}
	}
}
