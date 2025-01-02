namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;

using SDL3.Raw;


extension RenderGraph
{
	public enum Command
	{
		case Undefined;
	
		case Dispatch (int groupCountX, int groupCountY, int groupCountZ);
		case DispatchIndirect (Buffer indirectBuffer, int offset);
		
		case DrawPrimitives (int countVertices, int countInstances, int firstVertex, int firstInstanse);
		case DrawIndexedPrimitives (int indexCount, int instanceCount, int firstIndex, int vertexOffset, int firstInstance);
		case DrawPrimitivesIndirect (Buffer buffer, int offset, int drawCount);
		case DrawGPUIndexedPrimitivesIndirect (Buffer indirectBuffer, int offset, int drawCount);
	
		case BeginRenderPass (Window window, RenderPass renderPass);
		case EndRenderPass;
		
		case SetIndexBuffer (Buffer buffer, Buffer.IndexFormat format);
		case SetVertexBuffer (int index, SDL_GPUBufferBinding[] buffers);
		case SetPipeline (Pipeline pipeline);

		case SetFragmentSampler (int index, Texture texture);
	
		case SetScissor (int x, int y, int width, int height);
		case SetViewport (Viewport viewport);
	
		case WaitFor (StringView name, StringView value);
		case SetVariable (StringView name, StringView value);
	
			
	
		override public void ToString (String buffer)
		{
			switch (this)
			{
				case Undefined:
					buffer.Append("Undefined");
					break;
	
				case WaitFor(let name, let value):
					buffer.AppendF("WaitFor({}=={})", name, value);
					break;

				case SetVariable(let name, let value):
					buffer.AppendF("MakeAvaialble({}=={})", name, value);
					break;
	
				case Dispatch:
					buffer.Append("Dispatch");
					break;
				case DispatchIndirect:
					buffer.Append("DispatchIndirect");
					break;
				
				case DrawPrimitives:
					buffer.Append("DrawPrimitives");
					break;
				case DrawIndexedPrimitives(let indexCount, let instanceCount, let firstIndex, let vertexOffset, let firstInstance):
					buffer.AppendF("DrawIndexed({}, {}, {}, {}, {})", indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);
					break;
				case DrawPrimitivesIndirect:
					buffer.Append("DrawIndexedIndirect");
					break;
				case DrawGPUIndexedPrimitivesIndirect:
					buffer.Append("DrawIndirect");
					break;

				case SetFragmentSampler:
					buffer.Append("SetFragmentSampler");
					break;
	
				case SetScissor:
					buffer.Append("SetScissors");
					break;
				case SetViewport:
					buffer.Append("SetViewport");
					break;
				case BeginRenderPass(let window, let renderPass):
					buffer.AppendF("BeginRenderPass({})", renderPass);
					break;
				case EndRenderPass:
					buffer.Append("EndRenderPass");
					break;
	
				case SetIndexBuffer:
					buffer.Append("SetIndexBuffer");
					break;
				case SetVertexBuffer:
					buffer.Append("SetVertexBuffer");
					break;
				case SetPipeline(Pipeline pipeline):
					buffer.AppendF("SetPipeline(pipeline: {})", pipeline);
					break;
			}
		}
	}
}