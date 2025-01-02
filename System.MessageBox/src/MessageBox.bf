namespace System;


using System;
using System.Collections;
using System.Diagnostics;


struct MessageBox
{
	public StringView mTitle;
	public StringView mMessage;

	public Style mStyle;
	public Buttons mButtons;
	public Response mResponse;


	extern public Self.Response Show () mut;
	extern static public Self.Response Show (StringView title, StringView message, Style style, Buttons buttons);


	public enum Style : int32
	{
		Info,
		Warning,
		Error,
		Question,
	}


	public enum Buttons : int32
	{
		Ok,
		OkCancel,
		YesNo,
		Quit,
	}


	public enum Response : int32
	{
		Ok,
		Cancel,
		Yes,
		No,
		Quit,
		None,
		Error,
	}
}