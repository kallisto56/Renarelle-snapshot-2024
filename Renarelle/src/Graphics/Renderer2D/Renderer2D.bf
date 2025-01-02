namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;

using internal Renarelle.Renderer2D.Vertex2;


class Renderer2D
{
	const StringView cVertexShaderFileName = "./dist/shaders/renderer2d/pipeline.vertex.cso";
	const StringView cFragmentShaderFileName = "./dist/shaders/renderer2d/pipeline.fragment.cso";

	Window mWindow;
	RenderGraph mRenderGraph;
	RenderPass mRenderPass;
	Pipeline mPipeline;
	
	Buffer mVertexBuffer;
	Buffer mIndexBuffer;
	Texture mDummyTexture;

	FixedSizeList<uint32> mIndices;
	FixedSizeList<Vertex2> mVertices;

	DisposeStack<Matrix4x4> mMatrices;
	DisposeStack<Color> mColors;
	DisposeStack<Scissor> mScissors;
	DisposeStack<Font> mFonts;

	List<Batch> mBatches;


	public this ()
	{
		this.mRenderGraph = new RenderGraph();

		this.mMatrices = new DisposeStack<Matrix4x4>(16);
		this.mColors = new DisposeStack<Color>(16);
		this.mScissors = new DisposeStack<Scissor>(16);
		this.mFonts = new DisposeStack<Font>(16);

		this.mBatches = new List<Batch>();
	}


	public Response Initialize (Self.Description description)
	{
		this.mWindow = description.mWindow;
		this.mRenderPass = description.mRenderPass;

		this.mIndices = new FixedSizeList<uint32>(description.mMaxCountIndices);
		this.mVertices = new FixedSizeList<Vertex2>(description.mMaxCountVertices);

		this.RecreatePipeline().Resolve!();
		this.CreateIndexBuffer(description).Resolve!();
		this.CreateVertexBuffer(description).Resolve!();
		this.CreateDummyTexture().Resolve!();

		return .Ok;
	}


	public ~this ()
	{
		delete this.mRenderGraph;

		this.mIndexBuffer?.ReleaseRef();
		this.mVertexBuffer?.ReleaseRef();
		this.mPipeline?.ReleaseRef();
		this.mDummyTexture?.ReleaseRef();

		delete this.mMatrices;
		delete this.mColors;
		delete this.mScissors;
		delete this.mFonts;

		delete this.mBatches;
		delete this.mVertices;
		delete this.mIndices;
	}


	Response UpdateBuffers ()
	{
		this.mIndexBuffer.Update(this.mIndices.CArray(), this.mIndices.mSizeInBytes).Resolve!();
		this.mVertexBuffer.Update(this.mVertices.CArray(), this.mVertices.mSizeInBytes).Resolve!();

		return .Ok;
	}


	public void Prepare ()
	{
		this.mMatrices.Clear();
		this.mScissors.Clear();
		this.mFonts.Clear();

		this.mBatches.Clear();
		this.mVertices.Clear();
		this.mIndices.Clear();

		this.mRenderGraph.Clear();

		this.mMatrices.Push(Matrix4x4.CreateOrthographic(this.mWindow.mWidth, this.mWindow.mHeight, 0.0F, 1.0F));
		this.mScissors.Push(Scissor(0, 0, this.mWindow.mWidth, this.mWindow.mHeight));
	}


	public Response Flush ()
	{
		if (this.mBatches.Count == 0)
			return .Ok;

		this.UpdateBuffers().Resolve!();

		var cmd = RenderGraph.Chain("Renderer2D.Flush()", this.mRenderGraph);

		cmd.BeginRenderPass(this.mWindow, this.mRenderPass);

		cmd.SetVertexBuffer(0, scope SDL_GPUBufferBinding[] (SDL_GPUBufferBinding(this.mVertexBuffer, 0)));
		cmd.SetIndexBuffer(this.mIndexBuffer, .UInt32);

		cmd.SetScissors(0, 0, this.mWindow.mWidth, this.mWindow.mHeight);
		cmd.SetViewport(0, 0, this.mWindow.mWidth, this.mWindow.mHeight);

		cmd.SetPipeline(this.mPipeline);
		cmd.SetFragmentSampler(0, this.mDummyTexture);

		Batch previousBatch = default;
		for (var n = 0; n < this.mBatches.Count; n++)
		{
			Batch currentBatch = this.mBatches[n];
			if (previousBatch.mTexture != currentBatch.mTexture)
			{
				var texture = currentBatch.mTexture ?? this.mDummyTexture;
				cmd.SetFragmentSampler(0, texture);
			}

			if (currentBatch.mScissor != default)
			{
				cmd.SetScissors(currentBatch.mScissor);
			}
			else if (previousBatch.mScissor != default)
			{
				cmd.SetScissors(0, 0, this.mWindow.mWidth, this.mWindow.mHeight);
			}

			cmd.DrawPrimitives(currentBatch.mLength, 1, currentBatch.mIndex, 0);

			previousBatch = currentBatch;
		}

		cmd.EndRenderPass();

		this.mRenderGraph.Add(cmd);
		this.mRenderGraph.TopologicalSort().Resolve!();
		this.mRenderGraph.Execute().Resolve!();

		return .Ok;
	}


	ref Batch GetBatch (Texture texture, Scissor scissor)
	{
		// We have a case, when we want to add new batch,
		// but at the time of insertion we do not know what
		// mode or texture it will have.
		if (this.mBatches.Count > 0)
		{
			Batch batch = this.mBatches.Back;
			if (batch.IsBlank() == true)
			{
				this.mBatches.Back.Set(texture, scissor, this.mIndices.mCount, 0);
				return ref this.mBatches.Back;
			}
		}

		// Returns new batch:
		// - when collection is empty
		// - when batch properties do not match requested properties
		if (this.mBatches.Count == 0 || !this.mBatches.Back.Matches(texture, scissor))
			this.mBatches.Add(Batch(texture, scissor, this.mIndices.mCount, 0));

		// ...
		return ref this.mBatches.Back;
	}


	Response RecreatePipeline ()
	{
		defer
		{
			if (@return case .Err)
			{
				vertexShader?.ReleaseRef();
				fragmentShader?.ReleaseRef();
				description.Dispose();
			}
		}

		Pipeline.Description description;
		Shader vertexShader = new Shader();
		Shader fragmentShader = new Shader();

		vertexShader.Initialize(Shader.Description() {
			mFileName = Self.cVertexShaderFileName,
			mStage = .SDL_GPU_SHADERSTAGE_VERTEX,
		}).Resolve!();

		fragmentShader.Initialize(Shader.Description() {
			mFileName = Self.cFragmentShaderFileName,
			mStage = .SDL_GPU_SHADERSTAGE_FRAGMENT,
			mCountSamples = 1,
		}).Resolve!();
		

		description = Pipeline.Description()
		{
			mVertexShader = vertexShader,
			mFragmentShader = fragmentShader,

			mVertexInputState = .() {
				mBuffers = new SDL_GPUVertexBufferDescription[](
					SDL_GPUVertexBufferDescription()
					{
						slot = 0,
						pitch = sizeof(Vertex2),
						input_rate = .SDL_GPU_VERTEXINPUTRATE_VERTEX,
						instance_step_rate = 1,
					},
				),
				mAttributes = Vertex2.sLayout,
			},
			mPrimitiveType = .SDL_GPU_PRIMITIVETYPE_TRIANGLELIST,
			mRasterizerState = SDL_GPURasterizerState()
			{
				fill_mode = .SDL_GPU_FILLMODE_FILL,
				cull_mode = .SDL_GPU_CULLMODE_NONE,
				front_face = .SDL_GPU_FRONTFACE_CLOCKWISE,
			},
			mMultisampleState = SDL_GPUMultisampleState()
			{
				sample_count = .SDL_GPU_SAMPLECOUNT_1,
			},
			mDepthStencilState = SDL_GPUDepthStencilState(),
			mTargetInfo = Pipeline.TargetInfo ()
			{
				mColorTargets = new SDL_GPUColorTargetDescription[] (
					SDL_GPUColorTargetDescription()
					{
						format = Renarelle.sGraphicsDevice.GetSwapchainTextureFormat().Resolve!(),
						blend_state = Pipeline.ColorTargetBlendState.AlphaBlend,
					}
				),
			},
		};

		this.mPipeline = new Pipeline();
		this.mPipeline.Initialize(description).Resolve!();

		return .Ok;
	}


	Response CreateDummyTexture ()
	{
		Texture.Description description = Texture.Description()
		{
			mWidth = 32,
			mHeight = 32,
			mSampler = Renarelle.sPointSampler,
		};

		this.mDummyTexture = new Texture();
		this.mDummyTexture.Initialize(description).Resolve!();

		var image = scope Image();
		image.Initialize(Image.BlankDescription() { mWidth = 32, mHeight = 32 }).Resolve!();
		image.FillColor(.White(1));
		/*for (var x = 0; x < image.mWidth; x++)
		{
			image.SetPixel(x, 0, .Transparent);
			image.SetPixel(x, image.mHeight - 1, .Transparent);
		}*/
		

		this.mDummyTexture.Write(image).Resolve!();

		return .Ok;
	}


	Response CreateIndexBuffer (Self.Description description)
	{
		this.mIndexBuffer = new Buffer();
		this.mIndexBuffer.Initialize(description.mMaxCountIndices * sizeof(uint32), .SDL_GPU_BUFFERUSAGE_INDEX).Resolve!();
		return .Ok;
	}


	Response CreateVertexBuffer (Self.Description description)
	{
		this.mVertexBuffer = new Buffer();
		this.mVertexBuffer.Initialize(description.mMaxCountVertices * sizeof(Vertex2), .SDL_GPU_BUFFERUSAGE_VERTEX).Resolve!();
		return .Ok;
	}
}