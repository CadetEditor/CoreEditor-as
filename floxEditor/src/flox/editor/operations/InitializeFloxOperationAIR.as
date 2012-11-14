// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package flox.editor.operations
{
	import flash.display.Stage;
	import flash.filesystem.File;
	
	import flox.app.FloxApp;
	import flox.editor.FloxEditor;
	import flox.editor.controllers.SettingsControllerAIR;
	import flox.editor.controllers.SystemWindowControllerAIR;
	import flox.editor.core.FloxEditorEnvironment;
	import flox.app.managers.fileSystemProviders.azureAIR.AzureFileSystemProviderAIR;
	import flox.app.managers.fileSystemProviders.local.LocalFileSystemProvider;
	
	public class InitializeFloxOperationAIR extends InitializeFloxOperation
	{
		public function InitializeFloxOperationAIR( stage:Stage, configURL:String)
		{
			super(stage, configURL, FloxEditorEnvironment.AIR);
		}
		
		override protected function addFileSystemProvider( node:XML ):void
		{
			super.addFileSystemProvider(node);
			
			var visible:Boolean = node.@visible == undefined || node.@visible == "true";
			
			if ( String(node.@type) == "local" )
			{
				//FloxApp.fileSystemProvider.registerFileSystemProvider( new LocalFileSystemProvider( node.@id, node.@label, File.documentsDirectory.resolvePath(node.@folderName) ), visible );
				FloxApp.fileSystemProvider.registerFileSystemProvider( new LocalFileSystemProvider( node.@id, node.@label, File.userDirectory, File.documentsDirectory.resolvePath(node.@folderName) ), visible );
			}
			else if ( String(node.@type) == "azureBlobStorageAIR" )
			{
				FloxApp.fileSystemProvider.registerFileSystemProvider( new  AzureFileSystemProviderAIR( node.@id, node.@label, node.@endPoint, node.sas.text() ), visible );
			}
		}
		
		override protected function initControllers():void
		{
			super.initControllers();
			new SettingsControllerAIR();
			new SystemWindowControllerAIR();
		}
	}
}