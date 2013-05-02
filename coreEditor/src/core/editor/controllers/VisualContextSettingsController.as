// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.controllers
{
	import core.app.CoreApp;
	import core.appEx.core.contexts.IVisualContext;
	import core.appEx.entities.Parameter;
	import core.appEx.events.ContextManagerEvent;
	import core.app.events.ResourceManagerEvent;
	import core.appEx.events.SettingsManagerEvent;
	import core.appEx.resources.CommandHandlerFactory;
	import core.app.resources.IFactoryResource;
	import core.app.util.IntrospectionUtil;
	import core.editor.CoreEditor;
	import core.editor.commandHandlers.CreateVisualContextCommandHandler;
	import core.editor.contexts.IEditorContext;
	import core.editor.core.IGlobalViewContainer;
	import core.editor.operations.AddContextOperation;
	import core.editor.resources.ActionFactory;
	
	
	/**
	 * This global controller is created during initialisation.
	 * It performs two jobs (yeah, yeah, I know. One class, one responsibility...)
	 * Firstly, it creates and maintains a list of menu actions under 'Window' in the global view. One action for each registered VisualContext. These
	 * actions are used to toggle the visibility of VisualContexts off and on. (Note, it ignores IEditorContexts).
	 * Secondly, it saves which views are open via the SettingsManager. This is how BonesEditor remembers which views you had open last.
	 * @author Jonathan
	 * 
	 */	
	public class VisualContextSettingsController
	{
		public function VisualContextSettingsController()
		{
			var visualContextFactories:Vector.<IFactoryResource> = CoreApp.resourceManager.getFactoriesForType(IVisualContext);
			for each( var visualContextFactory:IFactoryResource in visualContextFactories )
			{
				addVisualContextFactory( visualContextFactory );
			}
			
			CoreApp.resourceManager.addEventListener( ResourceManagerEvent.RESOURCE_ADDED, resourceAddedHandler );
			CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
			CoreEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
			
			
			CoreEditor.settingsManager.addEventListener(SettingsManagerEvent.CHANGE, settingsManagerChangeHandler);
			updateFromSettings();
		}
		
		protected function resourceAddedHandler( event:ResourceManagerEvent ):void
		{
			if ( event.resource is IFactoryResource == false ) return;
			var factory:IFactoryResource = IFactoryResource(event.resource);
			
			addVisualContextFactory( factory );
		}
		
		protected function settingsManagerChangeHandler(event:SettingsManagerEvent):void
		{
			updateFromSettings();
		}

		protected function updateFromSettings():void
		{
			var visualContextFactories:Vector.<IFactoryResource> = CoreApp.resourceManager.getFactoriesForType(IVisualContext);
			for each( var visualContextFactory:IFactoryResource in visualContextFactories )
			{
				var path:String = IntrospectionUtil.getClassPath( visualContextFactory.getInstanceType() ) + ".visible";
				if ( CoreEditor.settingsManager.getBoolean( path ) )
				{
					CoreEditor.operationManager.addOperation( new AddContextOperation( visualContextFactory ) );
				}
			}
		}

		protected function addVisualContextFactory( factory:IFactoryResource ):void
		{
			if ( IntrospectionUtil.doesTypeImplement(factory.getInstanceType(), IVisualContext) == false ) return;
			if ( IntrospectionUtil.doesTypeImplement(factory.getInstanceType(), IEditorContext) == true ) return;
			
			var commandID:String = "createVisualContext_"+ IntrospectionUtil.getClassPath( factory.getInstanceType());
			
			var actionFactory:ActionFactory = new ActionFactory( IGlobalViewContainer, commandID, factory.getLabel(), "", "Window/views", Object(factory)["icon"] );
			actionFactory.parameters.push( new Parameter( "factory", factory ) );
			CoreApp.resourceManager.addResource( actionFactory );
			CoreApp.resourceManager.addResource( new CommandHandlerFactory( commandID, CreateVisualContextCommandHandler ) );
			
			updateFromSettings();
		}
		
		protected function contextAddedHandler( event:ContextManagerEvent ):void
		{
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IVisualContext) == false ) return;
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IEditorContext) ) return;
			
			CoreEditor.settingsManager.setBoolean( IntrospectionUtil.getClassPath( event.context ) + ".visible", true );
		}
		
		protected function contextRemovedHandler( event:ContextManagerEvent ):void
		{
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IVisualContext) == false ) return;
			
			CoreEditor.settingsManager.setBoolean( IntrospectionUtil.getClassPath( event.context ) + ".visible", false );
		}
	}
}