// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.managers
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import core.app.CoreApp;
	import core.appEx.core.contexts.IContext;
	import core.appEx.core.contexts.IVisualContext;
	import core.app.events.ResourceManagerEvent;
	import core.app.util.IntrospectionUtil;
	import core.editor.CoreEditor;
	import core.editor.contexts.IEditorContext;
	import core.editor.controllers.ViewContainerController;
	import core.editor.core.IGlobalViewContainer;
	import core.editor.core.IViewContainer;
	import core.editor.entities.Action;
	import core.editor.entities.Commands;
	import core.editor.events.GlobalViewContainerEvent;
	import core.editor.operations.RemoveContextOperation;
	import core.editor.resources.ActionFactory;
	import core.editor.utils.CoreEditorUtil;
	import core.ui.components.Application;
	import core.ui.managers.FocusManager;
	import core.ui.managers.PopUpManager;
	
	
	public class ViewManager
	{
		private var _application			:Application;
		private var stage					:Stage;
		
		private var globalViewContainer		:IGlobalViewContainer;
		private var globalViewController	:ViewContainerController;
		
		private var _viewContainerType		:Class;
		private var _editorContainerType	:Class;
		
		private var contextDictionary		:Dictionary;		// View is key
		private var controllerDictionary	:Dictionary;		// Context is key
		private var containerDictionary		:Dictionary;		// Context is key
		
		public function ViewManager( stage:Stage )
		{
			this.stage = stage;
			contextDictionary = new Dictionary();
			containerDictionary = new Dictionary();
			controllerDictionary = new Dictionary();
		}
		
		////////////////////////////////////////////////
		// Public methods
		////////////////////////////////////////////////
		
		public function init( globalViewContainerType:Class, viewContainerType:Class, editorContainerType:Class ):void
		{
			_application = new Application();
			stage.addChild(_application);
			
			if ( globalViewContainer )
			{
				throw( new Error( "ViewManager has already been initialised" ) );
				return;
			}
			
			_viewContainerType = viewContainerType;
			_editorContainerType = editorContainerType;
			
			globalViewContainer = new globalViewContainerType();
			globalViewContainer.addEventListener( GlobalViewContainerEvent.EDITOR_SHOWN, editorShownHandler );
			globalViewContainer.addEventListener( GlobalViewContainerEvent.EDITOR_HIDDEN, editorHiddenHandler );
			globalViewContainer.percentWidth = globalViewContainer.percentHeight = 100;
			
			_application.addChild( DisplayObject( globalViewContainer ) );
			
			globalViewController = new ViewContainerController(globalViewContainer.actionBar, globalViewContainer.menuBar);
			
			CoreApp.resourceManager.addEventListener(ResourceManagerEvent.RESOURCE_ADDED, resourceAddedHandler);
		}
		
		public function getContextForView( view:DisplayObject ):IVisualContext
		{
			return contextDictionary[view];
		}
		
		public function getContainerForContext( context:IVisualContext ):IViewContainer
		{
			return containerDictionary[context];
		}
		
		public function addVisualContext( context:IVisualContext ):void
		{
			contextDictionary[context.view] = context;
			
			var container:IViewContainer;
			if ( context is IEditorContext )
			{
				container = new _editorContainerType();
			}
			else
			{
				container = new _viewContainerType();
			}
			
			container.child = context.view;
			container.addEventListener(Event.CLOSE, closeViewContainerHandler);
			containerDictionary[context] = container;
			
			globalViewContainer.addViewContainer( container );
			globalViewContainer.showViewContainer( container );
			
			var controller:ViewContainerController = new ViewContainerController( container.actionBar, container.menuBar );
			controllerDictionary[context] = controller;
			
			var resources:Array = CoreEditorUtil.getTargetedResources(context);
			for each ( var resource:Object in resources )
			{
				var actionFactory:ActionFactory = resource as ActionFactory;
				if ( !actionFactory ) continue;
				controller.addAction(Action(actionFactory.getInstance()));
			}
		}
		
		public function removeVisualContext( context:IVisualContext ):void
		{
			var container:IViewContainer = containerDictionary[context];
			container.removeEventListener(Event.CLOSE, closeViewContainerHandler);
			container.child = null;
			
			var controller:ViewContainerController = controllerDictionary[context];
			controller.dispose();
			delete contextDictionary[context.view];
			delete controllerDictionary[context];
			delete containerDictionary[context];
			
			globalViewContainer.removeViewContainer( container );
		}
		
		public function showVisualContext( visualContext:IVisualContext ):void
		{
			var viewContainer:IViewContainer = containerDictionary[visualContext];
			globalViewContainer.showViewContainer(viewContainer);
		}
		
		public function setProgress( label:String, value:Number, indeterminate:Boolean = false ):void
		{
			globalViewContainer.setProgress(label, value, indeterminate);
		}
		
		public function clearProgress():void
		{
			globalViewContainer.clearProgress();
		}
		
		public function addPopUp( popUp:DisplayObject, modal:Boolean = true, center:Boolean = true ):void
		{
			PopUpManager.addPopUp( popUp, modal, center );
		}
		
		public function removePopUp( popUp:DisplayObject ):void
		{
			if ( !_application.popUpContainer.contains( popUp ) ) return;
			PopUpManager.removePopUp(popUp);
		}
		
		public function get application():Application
		{
			return _application;
		}
		
		////////////////////////////////////////////////
		// Event handlers
		////////////////////////////////////////////////
				
		private function resourceAddedHandler( event:ResourceManagerEvent ):void
		{
			if ( event.resource is ActionFactory )
			{
				addAction( ActionFactory(event.resource) );
			}
		}
		
		private function closeViewContainerHandler( event:Event ):void
		{
			var viewContainer:IViewContainer = IViewContainer(event.target);
			var context:IContext = getContextForView(viewContainer.child);
			
			if ( context is IEditorContext )
			{
				CoreEditor.contextManager.setCurrentContext(context);
				CoreEditor.commandManager.executeCommand( Commands.CLOSE_FILE );
			}
			else
			{
				var operation:RemoveContextOperation = new RemoveContextOperation(context);
				operation.execute();
			}
		}
		
		private function editorShownHandler( event:GlobalViewContainerEvent ):void
		{
			var editorContext:IEditorContext = IEditorContext( getContextForView(event.view.child) );
			editorContext.enable();
			FocusManager.setFocus(containerDictionary[editorContext]);
			CoreEditor.contextManager.setCurrentContext(editorContext);
		}
		
		private function editorHiddenHandler( event:GlobalViewContainerEvent ):void
		{
			var editorContext:IEditorContext = IEditorContext( getContextForView(event.view.child) );
			editorContext.disable();
		}
		
		////////////////////////////////////////////////
		// Private methods
		////////////////////////////////////////////////
		
		private function addAction( actionFactory:ActionFactory ):void
		{
			if ( IntrospectionUtil.isRelatedTo( globalViewContainer, actionFactory.target ) )
			{
				globalViewController.addAction(Action(actionFactory.getInstance()));
				return;
			}
			
			for each ( var context:IVisualContext in contextDictionary )
			{
				if ( IntrospectionUtil.isRelatedTo( context, actionFactory.target ) )
				{
					var container:IViewContainer = IViewContainer(context.view.parent);
					var controller:ViewContainerController = controllerDictionary[context];
					controller.addAction(Action(actionFactory.getInstance()));
				}
			}
		}
	}
}