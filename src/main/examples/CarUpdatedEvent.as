package examples
{
	import flash.events.Event;
	
	public class CarUpdatedEvent extends Event
	{
		public static const CAR_STARTED:String = "carStarted";
		
		public static const CAR_STOPPED:String = "carStopped";
		
		public var car:Car;
		
		public function CarUpdatedEvent( type:String, car:Car )
		{
			super( type );
			
			this.car = car;
		}
	}
}
