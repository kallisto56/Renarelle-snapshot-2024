namespace Renarelle;


using System;


extension RenderGraph
{
	public struct Variable : IHashable
	{
		public readonly StringView mName;
		public StringView mValue;

		public readonly int mHashCode;
		public int GetHashCode () => this.mHashCode;


		public this (StringView name, StringView value)
		{
			this.mName = name;
			this.mValue = value;

			this.mHashCode = name.GetHashCode();
		}


		override public void ToString (String buffer)
		{
			buffer.AppendF("Variable(name: \"{}\", value: \"{}\")", this.mName, this.mValue);
		}
	}
}