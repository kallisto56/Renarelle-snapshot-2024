namespace System;


using System;


extension Compiler
{
	extension NewClassGenerator
	{
		const StringView[?] cDependencies = StringView[](
			"System",
			"System.Collections",
			"System.Diagnostics",
			"System.Interop",
			"System.Math",
			"System.Threading",
			"SDL3.Raw",
		);


		new override public void InitUI ()
		{
			AddEdit("name", "Class Name", "");
		}


		new override public void Generate (String outFileName, String outText, ref Flags generateFlags)
		{
			var className = mParams["name"];
			if (className.EndsWith(".bf", .OrdinalIgnoreCase))
				className.RemoveFromEnd(3);

			String inheritsFrom = scope String();

			// Inheritance
			if (className.Contains(":"))
			{
				inheritsFrom.Append(className.Substring(className.IndexOf(":")+1));
				inheritsFrom.Trim();
				className.RemoveToEnd(className.IndexOf(":"));
				className.Trim();
			}

			outFileName.Append(className);
			var type = "class";

			if (className[0] == 'I' && className[1].IsUpper)
				type = "interface";

			this.AppendHeader(outText);
			this.Generate(outText, className, inheritsFrom, type);
		}


		void Generate (String buffer, StringView className, StringView inheritsFrom, StringView type)
		{
			if (inheritsFrom.IsEmpty == false)
			{
				buffer.AppendF("{} {} : {}\n", type, className, inheritsFrom);
			}
			else
			{
				buffer.AppendF("{} {}\n", type, className);
			}

			buffer.Append("{\n\t\n");
			buffer.Append("}");
		}


		void AppendHeader (String buffer)
		{
			buffer.Append("namespace Renarelle;\n\n\n");

			for (var n = 0; n < cDependencies.Count; n++)
				buffer.AppendF("using {};\n", cDependencies[n]);

			buffer.Append("\n\n");
		}
	}
}