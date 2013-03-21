// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.entities
{
	public class CoreEditorConfig
	{
		private var _applicationID		:String;
		private var _resourceURL		:String;		
	
		
		public function CoreEditorConfig( xml:XML )
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