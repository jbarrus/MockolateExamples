package flexUnitTests
{
	import examples.Car;
	import examples.CarUpdatedEvent;
	import examples.Engine;
	import examples.TestCallbackEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mockolate.arg;
	import mockolate.expect;
	import mockolate.ingredients.Invocation;
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
	 * Test case to experiment with some of the features of mockolate
	 */
	public class ExperimentalTestCase
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
		/**
		 * Calls with invocation allows us to get a reference to the
		 * method that would have been invoked if the class were not
		 * mocked.
		 */
		public function testCallsWithInvocation():void
		{
			expect( mockDispatcher.dispatchEvent( arg( instanceOf( TestCallbackEvent ))))
				.callsWithInvocation( test );
			
			fixtureToTest.testDispatch();
		}
		
		private function test( inv:Invocation, ...rest ):void
		{
			TestCallbackEvent( inv.arguments[0] ).callback();
		}
	}
}