package flexUnitTests
{
	import examples.Engine;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mockolate.arg;
	import mockolate.capture;
	import mockolate.expect;
	import mockolate.ingredients.Capture;
	import mockolate.ingredients.CaptureType;
	import mockolate.mock;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.strict;
	import mockolate.verify;
	
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	
	import spark.components.Application;

	public class ErrorsTestCase
	{
		[Rule]
		public var mockolate:MockolateRule = new MockolateRule();
		
		[Mock]
		public var mockEngine:Engine;
		
		[Mock]
		public var mockDispatcher:EventDispatcher;
		
		[Test(expects="org.flexunit.internals.runners.model.MultipleFailureException")]
		public function testMultipleError():void
		{
			expect( mockEngine.start() )
				.never();
			
			mockEngine.start();
		}
		
		[Test(expects="mockolate.errors.ExpectationError")]
		public function testTimesZero():void
		{
			expect( mockEngine.start() )
				.times( 0 );
			
			mockEngine.start();
		}
		
		[Test(expects="mockolate.errors.InvocationError")]
		public function testInvocationError():void
		{
			var strictEngine:Engine = strict( Engine );
			
			strictEngine.start();
		}
		
		[Test(expects="org.hamcrest.AssertionError")]
		public function testAssertionError():void
		{
			assertThat( 2, equalTo( 3 ));
		}
		
		[Test(expects="mockolate.errors.ExpectationError")]
		public function testExpectationError():void
		{
			expect( mockEngine.start() );
			
			assertThat( 1, equalTo( 1 ));
		}
		
		[Test(expects="mockolate.errors.VerificationError")]
		public function testVerificationError():void
		{
			mockEngine.stop();
			
			verify( mockEngine ).method( "start" );
		}
		
		[Test(expects="mockolate.errors.MockolateError")]
		public function testMockolateError():void
		{
			mock( Application );
		}
		
		[Test(expects="mockolate.errors.CaptureError")]
		public function testCaptureError():void
		{
			var capt:Capture = new Capture();
			
			capt.value;
		}
	}
}