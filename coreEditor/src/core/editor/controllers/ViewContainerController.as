// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import core.ui.components.Container;
	import core.ui.components.MenuBar;
	
	import core.editor.CoreEditor;
	import core.editor.entities.Action;
	
	/**
	 * This class is created by IBonesViewContainer's to delegate out some of the donkey work of managing their menu and action bars.
	 * This class further delegates out the work to the MenuBarActionController and ActionBarController.
	 * @author Jonathan
	 * 
	 */	
	public class ViewContainerController
	{
		private var actions				:Array;
		private var _resourceTarget		:Object;
		
		private var menuBarController	:MenuBarActionController;
		private var actionBarController	:ActionBarController;
		
		public function ViewContainerController( actionBar:Container, menuBar:MenuBar )
		{
			actions = [];
			
			menuBarController = new MenuBarActionController( menuBar );
			actionBarController = new ActionBarController( actionBar );
		}
		
		
		public function dispose():void
		{
			menuBarController.dispose();
			menuBarController = null;
			actionBarController.dispose();
			actionBarController = null;
		}
		
		public function addAction(action:Action):void
		{
			if (actions.indexOf(action) != -1) return
			actions.push(action);
			
			menuBarController.addAction(action);
			actionBarController.addAction(action);
			
			action.init( CoreEditor.commandManager );
		}
	}
}