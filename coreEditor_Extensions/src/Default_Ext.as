// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package
{
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	
	import core.app.CoreApp;
	import core.appEx.entities.KeyModifier;
	import core.app.managers.ResourceManager;
	import core.app.resources.FactoryResource;
	import core.appEx.resources.KeyBinding;
	import core.appEx.resources.PropertyInspectorItemEditorFactory;
	import core.editor.commandHandlers.CloseApplicationCommandHandler;
	import core.editor.commandHandlers.CloseFileCommandHandler;
	import core.editor.commandHandlers.CopyFileCommandHandler;
	import core.editor.commandHandlers.CutFileCommandHandler;
	import core.editor.commandHandlers.DeleteFileCommandHandler;
	import core.editor.commandHandlers.NewFileCommandHandler;
	import core.editor.commandHandlers.NewFolderCommandHandler;
	import core.editor.commandHandlers.OpenFileCommandHandler;
	import core.editor.commandHandlers.PasteFileCommandHandler;
	import core.editor.commandHandlers.PublishCommandHandler;
	import core.editor.commandHandlers.RedoCommandHandler;
	import core.editor.commandHandlers.RefreshCommandHandler;
	import core.editor.commandHandlers.RevertFileCommandHandler;
	import core.editor.commandHandlers.SaveFileAsCommandHandler;
	import core.editor.commandHandlers.SaveFileCommandHandler;
	import core.editor.commandHandlers.UndoCommandHandler;
	import core.editor.contexts.FileExplorerContext;
	import core.editor.contexts.PropertiesPanelContext;
	import core.editor.core.IGlobalViewContainer;
	import core.editor.entities.Commands;
	import core.editor.icons.CoreEditorIcons;
	import core.editor.resources.ActionFactory;
	import core.editor.ui.components.ResourceItemEditor;
	
	public class Default_Ext extends Sprite
	{
		public function Default_Ext()
		{
			var rm:ResourceManager = CoreApp.resourceManager;
			
			// Common
			rm.addResource( new KeyBinding( Commands.REFRESH, 		Keyboard.F5 ) );
			rm.addResource( new KeyBinding( Commands.COPY, 		67, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.PASTE, 	86, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.CUT, 		88, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.DELETE, 	Keyboard.DELETE ) );
			rm.addResource( new KeyBinding( Commands.DELETE, 	Keyboard.BACKSPACE ) );
			rm.addResource( new KeyBinding( Commands.UNDO, 		90, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.REDO, 		89, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.REDO, 		90, KeyModifier.CTRL | KeyModifier.SHIFT ) );
			
			// Add dummy actions to enforce a menu bar order.
			rm.addResource( new ActionFactory( IGlobalViewContainer, null, "", "", "File/_" ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, null, "", "", "Edit/_" ) );
			//rm.addResource( new ActionFactory( IGlobalViewContainer, null, "", "", "Modify/_" ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, null, "", "", "Project/_" ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, null, "", "", "Window/_" ) );
			
			// File Actions
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.NEW_FILE, "New...", "file", "File/file", CoreEditorIcons.NewFile ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.OPEN_FILE, "Open...", "file", "File/file", CoreEditorIcons.OpenFile ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SAVE_FILE, "Save", "file", "File/file", CoreEditorIcons.Save ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SAVE_FILE_AS, "Save As...", "", "File/file", CoreEditorIcons.Save ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.PUBLISH_FILE, "Publish", "file", "File/file", CoreEditorIcons.Publish ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.CLOSE_FILE, "Close", "", "File/file") );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.REVERT, "Revert", "", "File/file") );
			
			// Edit Actions
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.UNDO, "Undo", "history", "Edit/history", CoreEditorIcons.Undo ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.REDO, "Redo", "history", "Edit/history", CoreEditorIcons.Redo ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.CUT, "Cut", "", "Edit/edit", CoreEditorIcons.Cut ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.COPY, "Copy", "", "Edit/edit", CoreEditorIcons.Copy ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.PASTE, "Paste", "", "Edit/edit", CoreEditorIcons.Paste ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.DELETE, "Delete", "", "Edit/edit", CoreEditorIcons.Bin ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SELECT_ALL, "Select All", "", "Edit/edit" ) );
			
			rm.addResource( CloseApplicationCommandHandler.getFactory() );
			rm.addResource( RefreshCommandHandler.getFactory() );
			rm.addResource( UndoCommandHandler.getFactory() );
			rm.addResource( RedoCommandHandler.getFactory() );
			
			rm.addResource( NewFileCommandHandler.getFactory() );
			rm.addResource( NewFolderCommandHandler.getFactory() );
			rm.addResource( OpenFileCommandHandler.getFactory() );
			rm.addResource( PublishCommandHandler.getFactory() );
			rm.addResource( SaveFileCommandHandler.getFactory() );
			rm.addResource( SaveFileAsCommandHandler.getFactory() );
			rm.addResource( CloseFileCommandHandler.getFactory() );
			rm.addResource( DeleteFileCommandHandler.getFactory() );
			rm.addResource( RevertFileCommandHandler.getFactory() );
			rm.addResource( CopyFileCommandHandler.getFactory() );
			rm.addResource( CutFileCommandHandler.getFactory() );
			rm.addResource( PasteFileCommandHandler.getFactory() );
			
			rm.addResource( new KeyBinding( Commands.NEW_FILE, 78, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.OPEN_FILE, 79, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.SAVE_FILE, 83, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.SAVE_FILE_AS, 83, KeyModifier.SHIFT | KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.CLOSE_FILE, 87, KeyModifier.CTRL ) );
			rm.addResource( new KeyBinding( Commands.REVERT, 82, KeyModifier.CTRL ) );
			
			// Visual Contexts
			rm.addResource( new FactoryResource( PropertiesPanelContext, "Properties", CoreEditorIcons.PropertyInspector ) );
			//rm.addResource( new FactoryResource( HistoryInspectorContext, "History", CoreEditorIcons.History ) );
			rm.addResource( new FactoryResource( FileExplorerContext, "File Explorer", CoreEditorIcons.FileExplorer ) );
			//rm.addResource( new FactoryResource( ResourcesContext, "Resources", CoreEditorIcons.Resource ) );
			
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.NEW_FILE, "New File", "file", "", CoreEditorIcons.NewFile ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.NEW_FOLDER, "New Folder", "file", "", CoreEditorIcons.NewFolder ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.DELETE, "Delete selected file/folder", "file", "", CoreEditorIcons.Bin ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.REFRESH, "Refresh", "view", "", CoreEditorIcons.Refresh ) );
		
			rm.addResource( new PropertyInspectorItemEditorFactory( "ResourceItemEditor", ResourceItemEditor, "value", "itemsBeingEdited", "propertyOnItemsBeingEdited", false ) );
		}
		
	}
}