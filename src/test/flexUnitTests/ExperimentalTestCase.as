package flexUnitTests
{
	import examples.Car;
	import examples.CarUpdatedEvent;
	import examples.Engine;
	import examples.TestCallbackEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mockolate.arg;
	import mockolate.capture;
	import mockolate.expect;
	import mockolate.expecting;
	import mockolate.ingredients.Capture;
	import mockolate.ingredients.Invocation;
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	import mockolate.verify;
	
	import mx.utils.UIDUtil;
	
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.core.anything;
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
		public var mockCar:Car;
		
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
		 * Capture allows us to capture params on methods.
		 */
		public function testCapture():void
		{
			var capt:Capture = new Capture();
			
			expect( mockDispatcher.dispatchEvent( arg( capture( capt ))));
			
			mockDispatcher.dispatchEvent( new Event( "asdf" ));
			
			assertThat( capt.value.type, equalTo( "asdf" ));
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
				.callsWithInvocation( function test( inv:Invocation, ...rest ):void
				{
					TestCallbackEvent( inv.arguments[0] ).callback();
				});
			
			fixtureToTest.testDispatch();
		}
		
//		commented out to prevent it messing up other tests
//		[Test(order="1", expects="mockolate.errors.InvocationError")]
//		/**
//		 * Throws an error because expect() doesn't work with a strict.
//		 * This has to be run last because of a bug in Mockolate where
//		 * the expectation gets carried over.
//		 * 
//		 * This will also cause testcases run after this to fail in some instances.
//		 */
//		public function testExpectStrict():void
//		{
//			var strictDispatcher:EventDispatcher = strict( EventDispatcher );
//			
//			expect( strictDispatcher.dispatchEvent( arg( anything() )));
//		}
		
		[Test]
		/**
		 * Strict can be used with expect() if wrapped in expecting()
		 */
		public function testExpectStrictInExpecting():void
		{
			var strictDispatcher:EventDispatcher = strict( EventDispatcher );
		
			expecting( function():void {
				expect( strictDispatcher.dispatchEvent( arg( anything() )));
			});
			
			strictDispatcher.dispatchEvent( new Event( "nothing" ) );
		}
		
		/////////////////////////////////////////////////////////
		// SOME TESTS RELATED TO times(),once(),twice()...
		/////////////////////////////////////////////////////////
		
		[Test]
		public function testExpectNiceNumbersOfTimesFail():void
		{
			expect( mockDispatcher.dispatchEvent( arg( anything())))
				.once();
			
			fixtureToTest.testDispatch();
		}
		
		[Test(expects="mockolate.errors.InvocationError")]
		/**
		 * This works, will throw an error.
		 */
		public function testMockStrictNumbersOfTimesFail():void
		{
			var strictDispatcher:EventDispatcher = strict( EventDispatcher );
			
			mock( strictDispatcher )
				.method( "dispatchEvent" )
				.once();
				
			fixtureToTest.dispatcher = strictDispatcher;
			
			fixtureToTest.testDispatch();
			fixtureToTest.testDispatch();
		}
		
		[Test(expects="org.hamcrest.AssertionError")]
		/**
		 * This works, will throw error.
		 */
		public function testRecievedNumbersOfTimes():void
		{
			fixtureToTest.testDispatch();
			fixtureToTest.testDispatch();
			
			assertThat( mockDispatcher, 
				received().method( "dispatchEvent" ).times( 1 ));
		}
	}
}