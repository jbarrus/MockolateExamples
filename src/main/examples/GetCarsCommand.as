package examples
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;

	public class GetCarsCommand
	{
		[Inject]
		public var carDelegate:CarDelegate;
		
		[Dispatcher]
		public var dispatcher:IEventDispatcher;
		
		public function GetCarsCommand()
		{
		}
		
		public function execute():void
		{
			var token:AsyncToken = carDelegate.getCars();
			
			token.addResponder( new Responder( resultHandler, faultHandler ) );
		}
		
		private function resultHandler( resultEvent:ResultEvent ):void
		{
			dispatcher.dispatchEvent( new GetCarsResultEvent( 
				GetCarsResultEvent.GET_CARS_RESULT, resultEvent.result as Array ));
		}
		
		private function faultHandler( faultEvent:FaultEvent ):void
		{
			dispatcher.dispatchEvent( new ShowMessageEvent( ShowMessageEvent.ERROR, "get cars failed" ));
		}
	}
}