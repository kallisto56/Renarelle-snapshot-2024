namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;

using SDL3.Raw;


extension RenderGraph
{
	public struct Chain
	{
		public StringView mName;
		public List<Command> mCommands;


		public this (StringView name, RenderGraph graph, int predictableCountOfCommands = 0)
		{
			this.mName = name;
			this.mCommands = graph.Allocate(predictableCountOfCommands);
		}


		public void Dispatch (uint32 groupCountX, uint32 groupCountY, uint32 groupCountZ)
		{
			this.mCommands.Add(.Dispatch(groupCountX, groupCountY, groupCountZ));
		}


		public void DispatchIndirect (Buffer indirectBuffer, uint32 offset)
		{
			this.mCommands.Add(.DispatchIndirect(indirectBuffer, offset));
		}


		public void DrawIndexed (uint32 indexCount, uint32 instanceCount, uint32 firstIndex, int32 vertexOffset, uint32 firstInstance)
		{
			this.mCommands.Add(.DrawIndexedPrimitives(indexCount, instanceCount, firstIndex, vertexOffset, firstInstance));
		}


		public void DrawPrimitivesIndirect (Buffer indirectBuffer, uint32 offset, uint32 drawCount)
		{
			this.mCommands.Add(.DrawPrimitivesIndirect(indirectBuffer, offset, drawCount));
		}


		public void DrawGPUIndexedPrimitivesIndirect (Buffer indirectBuffer, uint32 offset, uint32 drawCount)
		{
			this.mCommands.Add(.DrawGPUIndexedPrimitivesIndirect(indirectBuffer, offset, drawCount));
		}


		public void SetScissors (int x, int y, int width, int height)
		{
			this.mCommands.Add(.SetScissor(x, y, width, height));
		}


		public void SetScissors (Scissor scissor)
		{
			this.mCommands.Add(.SetScissor(scissor.mLeft, scissor.mTop, scissor.mWidth, scissor.mHeight));
		}

		
		public void SetViewport (int x, int y, int width, int height, float minDepth = 0F, float maxDepth = 1F)
		{
			this.mCommands.Add(.SetViewport(Viewport(x, y, width, height, minDepth, maxDepth)));
		}


		public void SetViewport (Viewport viewport)
		{
			this.mCommands.Add(.SetViewport(viewport));
		}


		public void BeginRenderPass (Window window, RenderPass renderPass)
		{
			this.mCommands.Add(.BeginRenderPass(window, renderPass));
		}


		public void EndRenderPass ()
		{
			this.mCommands.Add(.EndRenderPass);
		}


		public void SetIndexBuffer (Buffer buffer, Buffer.IndexFormat format = .UInt32)
		{
			this.mCommands.Add(.SetIndexBuffer(buffer, format));
		}


		public void SetVertexBuffer (uint32 index, SDL_GPUBufferBinding[] buffers)
		{
			this.mCommands.Add(.SetVertexBuffer(index, buffers));
		}


		public void SetPipeline (Pipeline pipeline)
		{
			this.mCommands.Add(.SetPipeline(pipeline));
		}


		public void SetFragmentSampler (int index, Texture texture)
		{
			this.mCommands.Add(.SetFragmentSampler(index, texture));
		}


		public void DrawPrimitives (int countVertices, int countInstances, int firstVertex, int firstInstanse)
		{
			this.mCommands.Add(.DrawPrimitives(countVertices, countInstances, firstVertex, firstInstanse));
		}


		public void WaitFor (StringView name, StringView value)
		{
			this.mCommands.Add(.WaitFor(name, value));
		}


		public void WaitFor (Variable variable)
		{
			this.mCommands.Add(.WaitFor(variable.mName, variable.mValue));
		}


		public void SetVariable (StringView name, StringView value)
		{
			this.mCommands.Add(.SetVariable(name, value));
		}


		public void SetVariable (Variable variable)
		{
			this.mCommands.Add(.SetVariable(variable.mName, variable.mValue));
		}
	}
}
