package examples
{
	import flash.events.Event;
	
	public class ShowMessageEvent extends Event
	{
		public static const ERROR:String = "error";
		
		public var message:String;
		
		public function ShowMessageEvent( type:String, message:String )
		{
			super( type );
			
			this.message = message;
		}
	}
}
