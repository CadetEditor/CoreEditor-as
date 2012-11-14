// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.controllers
{
	import flox.app.FloxApp;
	import flox.app.core.contexts.IVisualContext;
	import flox.app.entities.Parameter;
	import flox.app.events.ContextManagerEvent;
	import flox.app.events.ResourceManagerEvent;
	import flox.app.events.SettingsManagerEvent;
	import flox.app.resources.CommandHandlerFactory;
	import flox.app.resources.IFactoryResource;
	import flox.app.resources.IResource;
	import flox.app.util.IntrospectionUtil;
	import flox.editor.FloxEditor;
	import flox.editor.commandHandlers.CreateVisualContextCommandHandler;
	import flox.editor.contexts.IEditorContext;
	import flox.editor.core.IGlobalViewContainer;
	import flox.editor.operations.AddContextOperation;
	import flox.editor.resources.ActionFactory;
	
	
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
			var visualContextFactories:Vector.<IFactoryResource> = FloxApp.resourceManager.getFactoriesForType(IVisualContext);
			for each( var visualContextFactory:IFactoryResource in visualContextFactories )
			{
				addVisualContextFactory( visualContextFactory );
			}
			
			FloxApp.resourceManager.addEventListener( ResourceManagerEvent.RESOURCE_ADDED, resourceAddedHandler );
			FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_ADDED, contextAddedHandler );
			FloxEditor.contextManager.addEventListener( ContextManagerEvent.CONTEXT_REMOVED, contextRemovedHandler );
			
			
			FloxEditor.settingsManager.addEventListener(SettingsManagerEvent.CHANGE, settingsManagerChangeHandler);
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
			var visualContextFactories:Vector.<IFactoryResource> = FloxApp.resourceManager.getFactoriesForType(IVisualContext);
			for each( var visualContextFactory:IFactoryResource in visualContextFactories )
			{
				var path:String = IntrospectionUtil.getClassPath( visualContextFactory.getInstanceType() ) + ".visible";
				if ( FloxEditor.settingsManager.getBoolean( path ) )
				{
					FloxEditor.operationManager.addOperation( new AddContextOperation( visualContextFactory ) );
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
			FloxApp.resourceManager.addResource( actionFactory );
			FloxApp.resourceManager.addResource( new CommandHandlerFactory( commandID, CreateVisualContextCommandHandler ) );
			
			updateFromSettings();
		}
		
		protected function contextAddedHandler( event:ContextManagerEvent ):void
		{
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IVisualContext) == false ) return;
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IEditorContext) ) return;
			
			FloxEditor.settingsManager.setBoolean( IntrospectionUtil.getClassPath( event.context ) + ".visible", true );
		}
		
		protected function contextRemovedHandler( event:ContextManagerEvent ):void
		{
			if ( IntrospectionUtil.doesTypeImplement(IntrospectionUtil.getType(event.context), IVisualContext) == false ) return;
			
			FloxEditor.settingsManager.setBoolean( IntrospectionUtil.getClassPath( event.context ) + ".visible", false );
		}
	}
}