// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.entities
{
	public class FloxEditorConfig
	{
		private var _applicationID		:String;
		private var _resourceURL		:String;		
	
		
		public function FloxEditorConfig( xml:XML )
		{
			_applicationID = xml.applicationID.text();
			_resourceURL = xml.resourceURL.text();
			/*
			else if ( assetURL.charAt(assetURL.length-1) != "/" )
			{
				assetURL = assetURL + "/";
			}
			*/
		}
		
		public function get applicationID():String { return _applicationID; }
		public function get resourceURL():String { return _resourceURL; }
	}
}