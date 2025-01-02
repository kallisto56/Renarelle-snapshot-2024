namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class DependencyNode
	{
		public UI.Element mDependant;
		public CompactList<UI.Element> mDependencies;


		public this (UI.Element dependant)
		{
			this.mDependant = dependant;

			CollectDependencies(this);
		}


		public ~this ()
		{
			this.mDependencies.Dispose();
		}


		static void CollectDependencies (DependencyNode node)
		{
			var parent = node.mDependant;

			while (parent != null)
			{
				var dependency = parent.mParent;
				if (dependency != null && dependency.mPositioning != .Default)
					node.mDependencies.Add(dependency);

				parent = dependency;
			}
		}
	}
}