namespace Renarelle;


using System;
using System.Collections;
using System.Math;


extension UI
{
	public enum Overflow : uint8
	{
		//None,
		//Auto,
		//Scroll,
		//Hidden,
		//Clamp,


		/**
		 * Overflow content is not clipped and may be visible
		 * outside the element's padding box. Default value.
		 */
		Visible,

		/**
		 * Overflow content is clipped and is not visible,
		 * but the content still exists. Scroll bars do not
		 * appear, but content can be scrolled programatically.
		 */
		Hidden,

		/**
		 * Overflow content is clipped and is not visible,
		 * but content can be scrolled using scroll bars.
		 * Scroll bars always present.
		 */
		Scroll,

		/**
		 * Overflow content is clipped and can be scrolled
		 * into view using scroll bars. Scroll bars only
		 * appear, when content is overflowing.
		 */
		Auto,
	}
}