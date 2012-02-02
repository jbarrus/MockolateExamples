package flexUnitTests
{
	import examples.Car;
	import examples.CarUpdatedEvent;
	import examples.Engine;
	
	import flash.events.EventDispatcher;
	
	import mockolate.arg;
	import mockolate.expect;
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.verify;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.instanceOf;

	/**
	 * verify() is always called on expect() and mock().
	 * It will not call it on stub().
	 */ 
	public class CarTestCase
	{
		[Rule]
		public var mockolate:MockolateRule = new MockolateRule();
		
		[Mock]
		public var mockEngine:Engine;
		
		[Mock]
		public var mockDispatcher:EventDispatcher;
		
		private var fixtureToTest:Car = new Car();
		
		[Before]
		public function setUp():void
		{
			fixtureToTest.engine = mockEngine;
			fixtureToTest.dispatcher = mockDispatcher;
		}
		
		[Test]
		public function testStart_engine_started():void
		{
			expect( mockEngine.start() );
			expect( mockEngine.isRunning ).returns( true );
			
			var result:Boolean = fixtureToTest.start();
			
			assertThat( result );
			
			//implied - verify( mockEngine );
		}
		
		[Test]
		/**
		 * Using hamcrest matchers in arg expectations.
		 * Notice arg(), allOf(), instanceOf(), and hasProperty()
		 */
		public function testStart_engine_dispatchesEvent():void
		{
			expect( mockDispatcher.dispatchEvent( arg( 
				allOf(
					instanceOf( CarUpdatedEvent ),
					hasProperty( "type", CarUpdatedEvent.CAR_STARTED )
					))));
			
			fixtureToTest.start();
		}
		
		[Test]
		public function testStop_engine_stopped():void
		{
			expect( mockEngine.stop() );
			
			fixtureToTest.stop();
			
			//implied - verify( mockEngine );
		}
		
		[Test(async)]
		/**
		 * Use Async.handleEvent instead of mockDispatcher this time.
		 */
		public function testStop_engine_dispatchesEvent():void
		{
			fixtureToTest.dispatcher = new EventDispatcher();
			
			Async.handleEvent( this, fixtureToTest.dispatcher, CarUpdatedEvent.CAR_STOPPED, checkCarStoppedEvent );
			
			fixtureToTest.stop();
		}
		
		private function checkCarStoppedEvent( event:CarUpdatedEvent, passThroughData:Object ):void
		{
			assertThat( event.car, equalTo( fixtureToTest ));
		}
		
		[Test]
		/**
		 * This demonstrates the alternative to expect().  It has the
		 * disadvantage of using a string value for the method instead
		 * of calling the actual method (IDE refactoring will miss it).
		 */
		public function testIsRunning_callsEngineIsRunning():void
		{
			//use getter(), setter(), or method(), this time it is a getter
			mock( mockEngine ).getter( "isRunning" ).returns( true );
			
			assertThat( fixtureToTest.isRunning );
			
			//implied - verify( mockEngine )
		}
	}
}