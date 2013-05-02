// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.operations
{
	import core.app.core.operations.IUndoableOperation;
	import core.app.managers.DependencyManager;

	public class RemoveDependencyOperation implements IUndoableOperation
	{
		protected var dependant			:Object;
		protected var dependency		:Object;
		protected var dependencyManager	:DependencyManager;
		
		public function RemoveDependencyOperation( dependant:Object, dependency:Object, dependencyManager:DependencyManager )
		{
			this.dependant = dependant;
			this.dependency = dependency;
			this.dependencyManager = dependencyManager;
		}

		public function execute():void
		{
			dependencyManager.removeDependency( dependant, dependency );
		}
		
		public function undo():void
		{
			dependencyManager.addDependency( dependant, dependency );
		}
		
		public function get label():String
		{
			return "Remove dependency";
		}
	}
}