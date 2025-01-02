namespace System.Diagnostics;


using System;


extension Debug
{
	static public void Report (Error error, bool bIsCritical = false)
	{
		var message = error.ToString(.. scope String());
		Debug.WriteLine(message);

		if (bIsCritical == true && Debug.IsDebuggerPresent == true)
			Debug.Break();
	}


	static public mixin Warning (StringView message)
	{
		String filePath = Compiler.CallerFilePath;
		String memberName = Compiler.CallerMemberName;
		int lineNumber = Compiler.CallerLineNum;
		int column = 0;

		Debug.WriteLine("WARNING: {} in {} at line {}:{} in {}", message, memberName, lineNumber, column, filePath);
	}


	static public mixin Error (StringView message)
	{
		String filePath = Compiler.CallerFilePath;
		String memberName = Compiler.CallerMemberName;
		int lineNumber = Compiler.CallerLineNum;
		int column = 0;

		Debug.WriteLine("WARNING: {} in {} at line {}:{} in {}", message, memberName, lineNumber, column, filePath);
	}
}