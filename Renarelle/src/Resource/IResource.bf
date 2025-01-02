namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


interface IResource : IHashable
{
	StringView GetName ();
}