package examples
{
	import flash.events.Event;

	public class TestCallbackEvent extends Event
	{
		public static const TEST_CALLBACK:String = "testCallback";
		
		public var callback:Function;
		
		public function TestCallbackEvent( type:String, callback:Function )
		{
			super( type );
			
			this.callback = callback;
		}
	}
}