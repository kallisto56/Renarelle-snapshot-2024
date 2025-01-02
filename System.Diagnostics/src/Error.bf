namespace System;


using System;
using System.Diagnostics;
using System.Collections;


class Error
{
	static public List<Error> sCollection = new List<Error>() ~ DeleteContainerAndItems!(_);


	public Error mUnderlyingError;
	public String mMessage;

	public String mFilePath;
	public String mMemberName;
	public uint32 mLineNumber;
	public uint32 mColumn;


	public this (Error underlyingError = null, String filePath = Compiler.CallerFilePath, String methodName = Compiler.CallerMemberName, int lineNumber = Compiler.CallerLineNum, int column = 0)
	{
		this.mMessage = new String();

		this.mUnderlyingError = underlyingError;

		this.mFilePath = filePath;
		this.mMemberName = methodName;
		this.mLineNumber = uint32(lineNumber);
		this.mColumn = uint32(column);

		Self.sCollection.Add(this);

#if DEBUG
		Debug.Report(this);
		Debug.Break();
#endif
	}


	public ~this ()
	{
		delete this.mMessage;
		this.mMessage = null;
	}


	[Inline]
	public void AppendCStr (char8* message)
	{
		this.mMessage.Append(StringView(message));
	}


	[Inline]
	public void Append (StringView message)
	{
		this.mMessage.Append(message);
	}


	[Inline]
	public void AppendF (StringView format, params Object[] args)
	{
		this.mMessage.AppendF(format, params args);
	}


	override public void ToString (String buffer)
	{
		if (this.mUnderlyingError != null)
		{
			this.mUnderlyingError.ToString(buffer);
			buffer.Append("\n");
		}

		// First error gets prepended with 'ERROR: '
		// Subsequent errors get prepended with '  > '
		if (this.mUnderlyingError == null)
			buffer.Append("ERROR: ");
		else
			buffer.Append("  > ");

		String message = this.mMessage.IsEmpty == false
			? this.mMessage
			: "...";

		buffer.AppendF(
			"{} in {} at line {}:{} in {}",
			message,
			this.mMemberName,
			this.mLineNumber,
			this.mColumn,
			this.mFilePath
		);
	}
}