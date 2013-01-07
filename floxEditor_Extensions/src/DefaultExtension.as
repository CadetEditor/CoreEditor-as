// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package
{
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	
	import flox.app.FloxApp;
	import flox.app.entities.KeyModifier;
	import flox.app.managers.ResourceManager;
	import flox.app.resources.FactoryResource;
	import flox.app.resources.KeyBinding;
	import flox.app.resources.PropertyInspectorItemEditorFactory;
	import flox.editor.commandHandlers.*;
	import flox.editor.contexts.*;
	import flox.editor.core.IGlobalViewContainer;
	import flox.editor.entities.*;
	import flox.editor.icons.FloxEditorIcons;
	import flox.editor.resources.ActionFactory;
	import flox.editor.ui.components.ResourceItemEditor;
	
	public class DefaultExtension extends Sprite
	{
		public function DefaultExtension()
		{
			var rm:ResourceManager = FloxApp.resourceManager;
			
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
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.NEW_FILE, "New...", "file", "File/file", FloxEditorIcons.NewFile ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.OPEN_FILE, "Open...", "file", "File/file", FloxEditorIcons.OpenFile ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SAVE_FILE, "Save", "file", "File/file", FloxEditorIcons.Save ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SAVE_FILE_AS, "Save As...", "", "File/file", FloxEditorIcons.Save ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.CLOSE_FILE, "Close", "", "File/file") );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.REVERT, "Revert", "", "File/file") );
			
			// Edit Actions
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.UNDO, "Undo", "history", "Edit/history", FloxEditorIcons.Undo ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.REDO, "Redo", "history", "Edit/history", FloxEditorIcons.Redo ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.CUT, "Cut", "", "Edit/edit", FloxEditorIcons.Cut ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.COPY, "Copy", "", "Edit/edit", FloxEditorIcons.Copy ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.PASTE, "Paste", "", "Edit/edit", FloxEditorIcons.Paste ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.DELETE, "Delete", "", "Edit/edit", FloxEditorIcons.Bin ) );
			rm.addResource( new ActionFactory( IGlobalViewContainer, Commands.SELECT_ALL, "Select All", "", "Edit/edit" ) );
			
			rm.addResource( CloseApplicationCommandHandler.getFactory() );
			rm.addResource( RefreshCommandHandler.getFactory() );
			rm.addResource( UndoCommandHandler.getFactory() );
			rm.addResource( RedoCommandHandler.getFactory() );
			
			rm.addResource( NewFileCommandHandler.getFactory() );
			rm.addResource( NewFolderCommandHandler.getFactory() );
			rm.addResource( OpenFileCommandHandler.getFactory() );
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
			rm.addResource( new FactoryResource( PropertiesPanelContext, "Properties", FloxEditorIcons.PropertyInspector ) );
			//rm.addResource( new FactoryResource( HistoryInspectorContext, "History", BonesEditorIcons.History ) );
			rm.addResource( new FactoryResource( FileExplorerContext, "File Explorer", FloxEditorIcons.FileExplorer ) );
			//rm.addResource( new FactoryResource( ResourcesContext, "Resources", BonesEditorIcons.Resource ) );
			
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.NEW_FILE, "New File", "file", "", FloxEditorIcons.NewFile ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.NEW_FOLDER, "New Folder", "file", "", FloxEditorIcons.NewFolder ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.DELETE, "Delete selected file/folder", "file", "", FloxEditorIcons.Bin ) );
			rm.addResource( new ActionFactory( FileExplorerContext, Commands.REFRESH, "Refresh", "view", "", FloxEditorIcons.Refresh ) );
		
			rm.addResource( new PropertyInspectorItemEditorFactory( "ResourceItemEditor", ResourceItemEditor, "value", "itemsBeingEdited", "propertyOnItemsBeingEdited", false ) );
		}
		
	}
}