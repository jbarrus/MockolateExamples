package examples
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class Car
	{
		
		[Inject]
		public var engine:Engine;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function Car()
		{
		
		}
		
		public function start():Boolean
		{
			engine.start();
			
			dispatcher.dispatchEvent( new CarUpdatedEvent( CarUpdatedEvent.CAR_STARTED, this ));
			
			return isRunning;
		}
		
		public function stop():void
		{
			engine.stop();
			
			dispatcher.dispatchEvent( new CarUpdatedEvent( CarUpdatedEvent.CAR_STOPPED, this ));
		}
		
		public function get isRunning():Boolean
		{
			return engine.isRunning;
		}
		
		public function testDispatch():void
		{
			dispatcher.dispatchEvent( new TestCallbackEvent( TestCallbackEvent.TEST_CALLBACK, testCallback ));
		}
		
		private function testCallback():void
		{
			trace( "callback called" );
		}
	}
}
