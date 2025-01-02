namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;


class RenderGraph
{
	Node mRootNode;
	List<Command> mOrderedCommands;
	List<Node> mOrderedNodes;
	List<List<Command>> mAvailableLists;
	List<IResourceAlias> mResources;
	List<IResourceAlias> mInitiallyAvailableResources;


	public this ()
	{
		this.mRootNode = new Node(null, .Undefined);
		this.mOrderedCommands = new List<Command>();
		this.mOrderedNodes = new List<Node>();
		this.mAvailableLists = new List<List<Command>>();
		this.mResources = new List<IResourceAlias>();
		this.mInitiallyAvailableResources = new List<IResourceAlias>();
	}


	public ~this ()
	{
		DeleteAndNullify!(this.mRootNode);
		DeleteAndNullify!(this.mOrderedCommands);
		DeleteAndNullify!(this.mOrderedNodes);
		DeleteAndNullify!(this.mInitiallyAvailableResources);
		DeleteAndNullify!(this.mResources);

		//Debug.Warning!(scope $"Count of available lists at the end of the program: {this.mAvailableLists.Count}");
		DeleteContainerAndItems!(this.mAvailableLists);
	}


	public Response<ResourceAlias<T>> CreateResource<T> (StringView state, T resource, bool bMakeAvailableFromStart = false) where T : IResource
	{
		ResourceAlias<T> allocatedResourceAlias = this.mResources.Add(.. new ResourceAlias<T>(state, resource));

		if (bMakeAvailableFromStart == true)
			this.mInitiallyAvailableResources.Add(allocatedResourceAlias);

		return allocatedResourceAlias;
	}


	public List<Command> Allocate (int countCommands)
	{
		if (this.mAvailableLists.Count > 0)
		{
			var list = this.mAvailableLists.PopBack();

			if (countCommands != 0)
				list.Reserve(countCommands);

			return list;
		}

		var list = new List<Command>();
		if (countCommands != 0)
			list.Reserve(countCommands);

		return list;
	}


	public void Free (List<Command> list)
	{
		list.Clear();
		this.mAvailableLists.Add(list);
	}


	public void Add (Chain chain)
	{
		Node parent = this.mRootNode;
		Node previousParent = this.mRootNode;

		for (var command in chain.mCommands)
		{
			// EndRenderPass will be added when we encounter BeginRenderPass 
			// Chain of commands after BeginRenderPass can be very deep.
			if (command case .EndRenderPass)
				continue;

			// Search for identical node in the graph
			bool bIdenticalNodeFound = this.TryGet(parent, command, var identicalNode);

			// Case 1: identical node has been found, we can merge
			// Case 2: no identical node found, we can create new one
			if (bIdenticalNodeFound == true)
			{
				parent = identicalNode;
			}
            else
			{
				parent = parent.mChildren.Add(.. new Node(parent, command));
				parent.mName.Set(chain.mName);
			}

			// Add 'EndRenderPass' to the parent unless it already exists
			if (command case .BeginRenderPass && this.TryGet(previousParent, .EndRenderPass, var _) == false)
				previousParent.mChildren.Add(.. new Node(previousParent, .EndRenderPass));

			// ...
			previousParent = parent;
		}

		this.Free(chain.mCommands);
	}


	bool TryGet (Node node, Command command, out Node identical)
	{
		identical = default;

		for (var child in node.mChildren)
		{
			if (child.mCommand == command)
			{
				identical = child;
				return true;
			}
		}

		return false;
	}


	public Response TopologicalSort ()
	{
		// Construct state, that will act as a container for temporary data
		State e = scope State();
		e.mAwaitingNodes.AddRange(this.mRootNode.mChildren);

		for (var resourceAlias in this.mInitiallyAvailableResources)
			e.mAvailableResources.Add(resourceAlias.GetName(), resourceAlias.GetState());

		// Accumulate dependencies (resources that each node waits for and makes available)
		for (var node in e.mAwaitingNodes)
			this.AccumulateDependencies(node, node.mResourcesToWaitFor, node.mResourceToMakeAvailable);

		while (e.mAwaitingNodes.Count > 0)
		{
			let countAwaitingNodes = e.mAwaitingNodes.Count;

			for (var node in e.mAwaitingNodes)
			{
				if (e.AllResourcesAvailableFor(node) == false)
					continue;

				if (e.NodeCanSwitchState(node) == false)
					continue;

				e.SwitchState(node);
				this.mOrderedNodes.Add(node);
				@node.Remove();
			}

			if (countAwaitingNodes == e.mAwaitingNodes.Count)
				return .Err(new Error()..AppendF("ChainGraph was unable to perform topological sort. This is caused either by cyclic dependency or absence of chains, that make available certain resource, that other chains rely on."));
		}

		return .Ok;
	}


	void AccumulateDependencies (Node node, List<Variable> mResourcesToWaitFor, List<Variable> mResourceToMakeAvailable)
	{
		if (node.mCommand case .WaitFor(let name, let value))
		{
			mResourcesToWaitFor.Add(Variable(name, value));
		}
		else if (node.mCommand case .SetVariable(let name, let value))
		{
			mResourceToMakeAvailable.Add(Variable(name, value));
		}

		for (var child in node.mChildren)
			AccumulateDependencies(child, mResourcesToWaitFor, mResourceToMakeAvailable);
	}


	class State
	{
		public Dictionary<StringView, StringView> mAvailableResources;
		public List<Node> mAwaitingNodes;


		public this ()
		{
			this.mAvailableResources = new Dictionary<StringView, StringView>();
			this.mAwaitingNodes = new List<RenderGraph.Node>();
		}


		public ~this ()
		{
			DeleteAndNullify!(this.mAvailableResources);
			DeleteAndNullify!(this.mAwaitingNodes);
		}


		public bool AllResourcesAvailableFor (Node node)
		{
			for (var variable in node.mResourcesToWaitFor)
				if (this.ContainsResourceAlias(variable) == false)
					return false;

			return true;
		}


		public bool ContainsResourceAlias (Variable variable)
		{
			if (this.mAvailableResources.TryGet(variable.mName, var matchKey, var value) == false)
				return false;

			return variable.mValue == value;
		}


		public bool NodeCanSwitchState (Node node)
		{
			if (node.mResourceToMakeAvailable.Count == 0)
				return true;

			for (var variable in node.mResourceToMakeAvailable)
			{
				if (this.mAvailableResources.TryGet(variable.mName, var resourceName, var value) == false)
					continue;

				if (this.AnyAwaitingNodesThatUse(node, resourceName, value) == true)
					return false;
			}

			return true;
		}


		public bool AnyAwaitingNodesThatUse (Node exclude, StringView name, StringView value)
		{
			for (var node in this.mAwaitingNodes)
			{
				if (exclude == node)
					continue;

				for (var dependency in node.mResourcesToWaitFor)
					if (dependency.mName == name && dependency.mValue == value)
						return true;
			}

			return false;
		}


		public void SwitchState (Node node)
		{
			if (node.mResourceToMakeAvailable.Count == 0)
				return;

			for (var variable in node.mResourceToMakeAvailable)
			{
				if (this.mAvailableResources.TryAdd(variable.mName, variable.mValue) == false)
					this.mAvailableResources[variable.mName] = variable.mValue;
			}
		}
	}


	public void Clear ()
	{
		this.mResources.ClearAndDeleteItems();
		this.mInitiallyAvailableResources.Clear();

		this.mRootNode.mChildren.ClearAndDeleteItems();
		this.mOrderedNodes.Clear();
	}


	public Response Execute ()
	{
		this.mOrderedCommands.Clear();
		
		CommandBuffer commandBuffer = Renarelle.sGraphicsDevice.AcquireCommandBuffer().Resolve!();

		for (var node in this.mOrderedNodes)
			this.Execute(node, commandBuffer).Resolve!();

		Renarelle.sGraphicsDevice.Submit(commandBuffer).Resolve!()
			.WaitFor().Resolve!();

		return .Ok;
	}


	Response Execute (Node node, CommandBuffer cmd)
	{
		this.RecordCommand(node.mCommand, cmd).Resolve!();

		for (var child in node.mChildren)
			this.Execute(child, cmd).Resolve!();

		return .Ok;
	}


	Response RecordCommand (Command command, CommandBuffer cmd)
	{
		this.mOrderedCommands.Add(command);

		switch (command)
		{
			case .Dispatch (int groupCountX, int groupCountY, int groupCountZ):
				return cmd.Dispatch(groupCountX, groupCountY, groupCountZ);

			case .DispatchIndirect (Buffer indirectBuffer, int offset):
				return cmd.DispatchIndirect(indirectBuffer, offset);

			case .DrawIndexedPrimitives (int indexCount, int instanceCount, int firstIndex, int vertexOffset, int firstInstance):
				return cmd.DrawIndexedPrimitives(indexCount, instanceCount, firstIndex, vertexOffset, firstInstance);

			case .DrawPrimitivesIndirect (Buffer buffer, int offset, int drawCount):
				return cmd.DrawPrimitivesIndirect(buffer, offset, drawCount);

			case .DrawGPUIndexedPrimitivesIndirect (Buffer indirectBuffer, int offset, int drawCount):
				return cmd.DrawGPUIndexedPrimitivesIndirect(indirectBuffer, offset, drawCount);

			case .BeginRenderPass (Window window, RenderPass renderPass):
				return cmd.BeginRenderPass(window, renderPass);

			case .EndRenderPass:
				return cmd.EndRenderPass();

			case .SetIndexBuffer (Buffer buffer, Buffer.IndexFormat format):
				return cmd.BindIndexBuffer(buffer, format);

			case .SetVertexBuffer (int firstSlot, SDL_GPUBufferBinding[] buffers):
				return cmd.BindVertexBuffers(firstSlot, params buffers);

			case .SetPipeline (Pipeline pipeline):
				return cmd.SetPipeline(pipeline);

			case .SetFragmentSampler(int index, Texture texture):
				 return cmd.BindFragmentSamplers(index, texture);

			case .DrawPrimitives(int countVertices, int countInstances, int firstVertex, int firstInstanse):
				 return cmd.DrawPrimitives(countVertices, countInstances, firstVertex, firstInstanse);

			case .SetScissor (int x, int y, int width, int height):
				return cmd.SetScissor(x, y, width, height);

			case .SetViewport (Viewport viewport):
				return cmd.SetViewport(viewport);

			case .Undefined, .WaitFor, .SetVariable:
				return .Ok;
		}
	}
}