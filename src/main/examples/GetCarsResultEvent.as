package examples
{
	import flash.events.Event;
	
	public class GetCarsResultEvent extends Event
	{
		public static const GET_CARS_RESULT:String = "getCarsResult";
		
		public var cars:Array;
		
		public function GetCarsResultEvent( type:String, cars:Array )
		{
			super( type );
			
			this.cars = cars;
		}
	}
}
