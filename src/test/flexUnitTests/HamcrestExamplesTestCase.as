package flexUnitTests
{
	import flash.events.Event;
	
	import org.flexunit.assertThat;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.core.not;
	import org.hamcrest.number.between;
	import org.hamcrest.number.closeTo;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;

	/**
	 * A tour of hamcrest matchers
	 */
	public class HamcrestExamplesTestCase
	{
		[Test]
		public function testHasProperties():void
		{
			var event:Event = new Event( "test", true, true );
			
			assertThat( event, hasProperties( {
				type: "test",
				bubbles: true,
				cancelable: true
			}));
		}
		
		[Test]
		public function testHasPropertiesToMatchObjects():void
		{
			/* compare objects using hasProperties
			This is a more refactor-friendly version of the above example.
			*/
			
			var event1:Event = new Event( "test", true, true );
			var event2:Event = new Event( "test", true, true );
			
			assertThat( event1, hasProperties( event2 ));
		}
		
		[Test]
		public function testLogical():void
		{
			assertThat( "bob", anyOf( 
				equalTo( "frank" ),
				equalTo( "bob")));
			
			assertThat( "bob", not( equalTo( "frank" )));
			
			assertThat( "bob", allOf( 
				equalTo( "bob" ),
				notNullValue(),
				not( equalTo( "frank" ))
				));
		}
		
		[Test]
		public function testArray():void
		{
			var names:Array = ["frank", "bob"];
			
			assertThat( names, arrayWithSize( 2 ) );
			
			assertThat( names, hasItem( "bob" ));
			
			assertThat( names, hasItems( "bob", "frank" ) );
			
			assertThat( names, everyItem( notNullValue() ));
		}
		
		[Test]
		public function testNumbers():void
		{
			assertThat( 5, greaterThan( 4 ));
			
			assertThat( 4.51, closeTo( 4.5, .02 ));
			
			assertThat( 4, between( 3, 5 ));
		}
		
		[Test]
		public function testNestedMatchers():void
		{
			var test:Object = {
				event: new Event( "test", true, true ),
				name: "test",
				age: 5,
				items: [1, "two", 3, 4]
			};
			
			assertThat( test, hasProperties({
				event: allOf(
					instanceOf( Event ),
					hasProperties( {
						type: "test",
						bubbles: true,
						cancelable: true
					})),
				name: "test",
				age: between( 3, 7 ),
				items: allOf(
					hasItem( 1 ),
					hasItem( instanceOf( String )),
					arrayWithSize( 4 )
					)
			}));
		}
	}
}