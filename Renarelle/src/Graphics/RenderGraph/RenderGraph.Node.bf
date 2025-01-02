namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


extension RenderGraph
{
	public class Node
	{
		public String mName;
		public Node mParent;
		public List<Node> mChildren;

		public Command mCommand;

		public List<Variable> mResourcesToWaitFor;
		public List<Variable> mResourceToMakeAvailable;


		public this (Node parent, Command command)
		{
			this.mName = new String();
			this.mCommand = command;
			this.mParent = parent;
			this.mChildren = new List<Node>();
			this.mResourcesToWaitFor = new List<Variable>();
			this.mResourceToMakeAvailable = new List<Variable>();
		}


		public ~this ()
		{
			DeleteAndNullify!(this.mName);
			DeleteContainerAndItems!(this.mChildren);
			DeleteAndNullify!(this.mResourcesToWaitFor);
			DeleteAndNullify!(this.mResourceToMakeAvailable);
		}


		override public void ToString (String buffer)
		{
			buffer.AppendF("{}", this.mCommand);
		}
	}
}