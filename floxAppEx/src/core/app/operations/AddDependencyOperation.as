// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.app.operations
{
	import core.app.core.operations.IUndoableOperation;
	import core.app.managers.DependencyManager;


	/**
	 * This Operation wraps up a call to the DependencyManager.addDependency() method, mirroring it with removeDependency()
	 * to make this undoable. 
	 * @author Jonathan
	 * 
	 */	
	public class AddDependencyOperation implements IUndoableOperation
	{
		protected var dependant			:Object;
		protected var dependency		:Object;
		protected var dependencyManager	:DependencyManager;
		
		public function AddDependencyOperation( dependant:Object, dependency:Object, dependencyManager:DependencyManager )
		{
			this.dependant = dependant;
			this.dependency = dependency;
			this.dependencyManager = dependencyManager;
		}

		public function execute():void
		{
			dependencyManager.addDependency( dependant, dependency );
		}
		
		public function undo():void
		{
			dependencyManager.removeDependency( dependant, dependency );
		}
		
		public function get label():String
		{
			return "Add dependency";
		}
		
	}
}