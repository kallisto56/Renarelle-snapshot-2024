#if BF_PLATFORM_WINDOWS
namespace System;


using System;
using System.Collections;
using System.Diagnostics;


extension MessageBox
{
	[Import("USER32.LIB"), CLink, CallingConvention(.Stdcall)]
	static extern MESSAGEBOX_RESULT MessageBoxA(System.Windows.Handle hWnd, char8* lpText, char8* lpCaption, MESSAGEBOX_STYLE uType);

	


	override public Self.Response Show () mut
	{
		MESSAGEBOX_STYLE flags = MESSAGEBOX_STYLE.MB_TASKMODAL;

		flags |= GetValue(this.mStyle);
		flags |= GetValue(this.mButtons);

		var response = MessageBoxA(default, this.mMessage.ToScopeCStr!(), this.mTitle.ToScopeCStr!(), flags);
		this.mResponse = Self.ParseResponse(response, this.mButtons);

		return this.mResponse;
	}


	override static public Self.Response Show (StringView title, StringView message, Style style, Buttons buttons)
	{
		MESSAGEBOX_STYLE flags = MESSAGEBOX_STYLE.MB_TASKMODAL;
		
		flags |= GetValue(style);
		flags |= GetValue(buttons);
		
		var response = MessageBoxA(default, message.ToScopeCStr!(), title.ToScopeCStr!(), flags);
		return Self.ParseResponse(response, buttons);
	}


	static MESSAGEBOX_STYLE GetValue (Style style)
	{
	   switch (style)
	   {
		   case .Info: return .MB_ICONINFORMATION;
		   case .Warning: return .MB_ICONWARNING;
		   case .Error: return .MB_ICONERROR;
		   case .Question: return .MB_ICONQUESTION;
		   default: return .MB_ICONINFORMATION;
	   }
	}


	static MESSAGEBOX_STYLE GetValue (Buttons input)
	{
		switch (input)
		{
			// There is no 'Quit' button on Windows :(
			case .Ok, .Quit: return .MB_OK;
			case .OkCancel: return .MB_OKCANCEL;
			case .YesNo: return .MB_YESNO;
			default: return .MB_OK;
		}
	}


	static Self.Response ParseResponse (MESSAGEBOX_RESULT response, Buttons buttons)
	{
	   switch (response)
	   {
		   case .IDOK: return buttons == .Quit ? .Quit : .Ok;
		   case .IDCANCEL: return .Cancel;
		   case .IDYES: return .Yes;
		   case .IDNO: return .No;
		   default: return .None;
	   }
	}


	[AllowDuplicates]
	public enum MESSAGEBOX_RESULT : int32
	{
		IDOK = 1,
		IDCANCEL = 2,
		IDABORT = 3,
		IDRETRY = 4,
		IDIGNORE = 5,
		IDYES = 6,
		IDNO = 7,
		IDCLOSE = 8,
		IDHELP = 9,
		IDTRYAGAIN = 10,
		IDCONTINUE = 11,
		IDASYNC = 32001,
		IDTIMEOUT = 32000,
	}


	[AllowDuplicates]
	public enum MESSAGEBOX_STYLE : uint32
	{
		MB_ABORTRETRYIGNORE = 2,
		MB_CANCELTRYCONTINUE = 6,
		MB_HELP = 16384,
		MB_OK = 0,
		MB_OKCANCEL = 1,
		MB_RETRYCANCEL = 5,
		MB_YESNO = 4,
		MB_YESNOCANCEL = 3,
		MB_ICONHAND = 16,
		MB_ICONQUESTION = 32,
		MB_ICONEXCLAMATION = 48,
		MB_ICONASTERISK = 64,
		MB_USERICON = 128,
		MB_ICONWARNING = 48,
		MB_ICONERROR = 16,
		MB_ICONINFORMATION = 64,
		MB_ICONSTOP = 16,
		MB_DEFBUTTON1 = 0,
		MB_DEFBUTTON2 = 256,
		MB_DEFBUTTON3 = 512,
		MB_DEFBUTTON4 = 768,
		MB_APPLMODAL = 0,
		MB_SYSTEMMODAL = 4096,
		MB_TASKMODAL = 8192,
		MB_NOFOCUS = 32768,
		MB_SETFOREGROUND = 65536,
		MB_DEFAULT_DESKTOP_ONLY = 131072,
		MB_TOPMOST = 262144,
		MB_RIGHT = 524288,
		MB_RTLREADING = 1048576,
		MB_SERVICE_NOTIFICATION = 2097152,
		MB_SERVICE_NOTIFICATION_NT3X = 262144,
		MB_TYPEMASK = 15,
		MB_ICONMASK = 240,
		MB_DEFMASK = 3840,
		MB_MODEMASK = 12288,
		MB_MISCMASK = 49152,
	}
}
#endif