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
	[CRepr]
	public struct Vertex2
	{
		static internal SDL_GPUVertexAttribute[] sLayout => new SDL_GPUVertexAttribute[] (
			SDL_GPUVertexAttribute(0, 0, .SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2, offsetof(Self, mPosition)),
			SDL_GPUVertexAttribute(1, 0, .SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2, offsetof(Self, mUV)),
			SDL_GPUVertexAttribute(2, 0, .SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4, offsetof(Self, mColor)),
		);

		public Vector2 mPosition;
		public Vector2 mUV;
		public Color mColor;


		public this (Vector2 position, Color color = .White(1))
		{
			this.mPosition = position;
			this.mUV = default;
			this.mColor = color;
		}
	
	
		public this (Vector2 position, Vector2 uv, Color color = .White(1))
		{
			this.mPosition = position;
			this.mUV = uv;
			this.mColor = color;
		}
	}
}