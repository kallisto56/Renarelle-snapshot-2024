#if BF_PLATFORM_MACOS
namespace System;


using System;
using System.Collections;
using System.Diagnostics;


extension MessageBox
{
	override public Self.Response Show () mut
	{
		return this.mResponse;
	}


	override static public Self.Response Show (StringView title, StringView message, Style style, Buttons buttons)
	{
		return 0;
	}
}
#endif