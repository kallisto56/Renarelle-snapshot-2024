namespace System;


using System;


class DescriptionGenerator : Compiler.Generator
{
	override public String Name => "struct Description"

	const StringView[?] cDependencies = StringView[](
		"System",
		"System.Collections",
		"System.Diagnostics",
		"System.Interop",
		"System.Math",
		"System.Threading",
		"SDL3.Raw",
	);


	override public void InitUI ()
	{
		AddEdit("className", "Class Name", "");
		AddEdit("structName", "Struct Name", "Description");
	}


	override public void Generate (String outFileName, String outText, ref Flags generateFlags)
	{
		var structName = mParams["structName"];
		if (structName.EndsWith(".bf", .OrdinalIgnoreCase))
			structName.RemoveFromEnd(3);

		var className = mParams["className"];
		if (className.EndsWith(".bf", .OrdinalIgnoreCase))
			className.RemoveFromEnd(3);

		outFileName.Append(className);
		outFileName.Append("_");
		outFileName.Append(structName);

		this.AppendHeader(outText);
		this.GenerateStructInsideClassExtension(outText, className, structName);
	}


	void GenerateClass (String buffer, StringView className)
	{
		
	}


	void GenerateStructInsideClassExtension (String buffer, StringView className, StringView structName)
	{
		buffer.AppendF("extension {}\n", className);
		buffer.Append("{\n\t");
		buffer.AppendF("public struct {}\n", structName);
		buffer.Append("\t{\n\n");
		buffer.Append("\t}\n");
		buffer.Append("}\n");
	}


	void AppendHeader (String buffer)
	{
		buffer.Append("namespace Renarelle;\n\n\n");

		for (var n = 0; n < cDependencies.Count; n++)
			buffer.AppendF("using {};\n", cDependencies[n]);

		buffer.Append("\n\n");
	}
}