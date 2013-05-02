// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.events
{
	import flash.events.Event;

	public class FileSystemGetProjectsEvent extends Event
	{
		public static const GET_PROJECTS_COMPLETE		:String = "getProjectsComplete";
		
		private var _projects				:Array;
		
		public function FileSystemGetProjectsEvent( type:String, projects:Array )
		{
			super( type );
			_projects = projects;
		}
		
		public function get projects():Array { return _projects.slice(); }
		
	}
}