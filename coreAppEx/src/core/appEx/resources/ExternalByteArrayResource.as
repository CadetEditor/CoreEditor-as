// Copyright (c) 2012, Unwrong Ltd. http://www.unwrong.com
// All rights reserved. 

package core.appEx.resources
{
	import flash.utils.ByteArray;
	
	import core.app.entities.URI;
	import core.app.resources.AbstractExternalResource;
	
	public class ExternalByteArrayResource extends AbstractExternalResource
	{
		private var bytes	:ByteArray;
		
		public function ExternalByteArrayResource( id:String, uri:URI )
		{
			super(id, uri);
			type = ByteArray;
		}
		
		override public function unload():void
		{
			bytes = null;
			super.unload();
		}
		
		override protected function parseBytes( bytes:ByteArray ):void
		{
			this.bytes = bytes;
		}
		
		override public function getInstance():Object
		{
			return bytes;
		}
	}
}