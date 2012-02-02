package flexUnitTests
{
	import examples.Car;
	import examples.CarDelegate;
	import examples.GetCarsCommand;
	import examples.GetCarsResultEvent;
	import examples.ShowMessageEvent;
	
	import flash.events.EventDispatcher;
	
	import mockolate.decorations.rpc.FaultAnswer;
	import mockolate.decorations.rpc.ResultAnswer;
	import mockolate.expect;
	import mockolate.runner.MockolateRule;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	
	public class GetCarsCommandTestCase
	{
		
		[Rule]
		public var mockolate:MockolateRule = new MockolateRule();
		
		[Mock]
		public var mockCarDelegate:CarDelegate;
		
		public var fixtureToTest:GetCarsCommand = new GetCarsCommand();
		
		[Before]
		public function setUp():void
		{
			fixtureToTest.carDelegate = mockCarDelegate; 
			fixtureToTest.dispatcher = new EventDispatcher();
		}
		
		[Test(async)]
		public function testExecute_resultHandler_dispatchesEvent():void
		{
			var token:AsyncToken = new AsyncToken();
			
			var cars:Array = [new Car()];
			
			var resultEvent:ResultEvent = ResultEvent.createEvent( cars );
			
			expect( mockCarDelegate.getCars())
				.returns( token )
				.answers( new ResultAnswer( token, resultEvent ));
				
			Async.handleEvent( this, fixtureToTest.dispatcher, GetCarsResultEvent.GET_CARS_RESULT, 
				checkResultEvent, 500, cars );
			
			fixtureToTest.execute();
		}
		
		private function checkResultEvent( event:GetCarsResultEvent, cars:Array ):void
		{
			assertThat( event.cars, strictlyEqualTo( cars ));
			
			//or you could use matchers (just to show possible usages, you wouldn't do all of these )
			assertThat( event.cars, allOf(
				arrayWithSize( 1 ),
				hasItem( instanceOf( Car )),
				array( instanceOf( Car ))
				));
		}
		
		[Test(async)]
		public function testExecute_faultHandler_dispatchesEvent():void
		{
			var token:AsyncToken = new AsyncToken();
			
			expect( mockCarDelegate.getCars())
				.returns( token )
				.answers( new FaultAnswer( token, null )); //you can pass a fault event if needed with FaultEvent.createEvent(...)
			
			Async.handleEvent( this, fixtureToTest.dispatcher, ShowMessageEvent.ERROR, 
				checkFaultEvent );
			
			fixtureToTest.execute();
		}
		
		private function checkFaultEvent( event:ShowMessageEvent, passThroughData:Object ):void
		{
			assertThat( event.message, notNullValue());
		}
	}
}
