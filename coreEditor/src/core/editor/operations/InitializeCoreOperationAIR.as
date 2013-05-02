// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.editor.operations
{
	import flash.display.Stage;
	import flash.filesystem.File;
	
	import core.app.CoreApp;
	import core.editor.controllers.SettingsControllerAIR;
	import core.editor.controllers.SystemWindowControllerAIR;
	import core.editor.core.CoreEditorEnvironment;
	import core.appEx.managers.fileSystemProviders.azureAIR.AzureFileSystemProviderAIR;
	import core.app.managers.fileSystemProviders.local.LocalFileSystemProvider;
	
	public class InitializeCoreOperationAIR extends InitializeCoreOperation
	{
		public function InitializeCoreOperationAIR( stage:Stage, configURL:String)
		{
			super(stage, configURL, CoreEditorEnvironment.AIR);
		}
		
		override protected function addFileSystemProvider( node:XML ):void
		{
			super.addFileSystemProvider(node);
			
			var visible:Boolean = node.@visible == undefined || node.@visible == "true";
			
			if ( String(node.@type) == "local" )
			{
				//CoreApp.fileSystemProvider.registerFileSystemProvider( new LocalFileSystemProvider( node.@id, node.@label, File.documentsDirectory.resolvePath(node.@folderName) ), visible );
				CoreApp.fileSystemProvider.registerFileSystemProvider( new LocalFileSystemProvider( node.@id, node.@label, File.userDirectory, File.documentsDirectory.resolvePath(node.@folderName) ), visible );
			}
			else if ( String(node.@type) == "azureBlobStorageAIR" )
			{
				CoreApp.fileSystemProvider.registerFileSystemProvider( new  AzureFileSystemProviderAIR( node.@id, node.@label, node.@endPoint, node.sas.text() ), visible );
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