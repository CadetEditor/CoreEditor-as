// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flox.ui.components.Container;
	import flox.ui.components.MenuBar;
	
	import flox.editor.FloxEditor;
	import flox.editor.entities.Action;
	
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
			
			action.init( FloxEditor.commandManager );
		}
	}
}