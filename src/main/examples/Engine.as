package examples
{
	public class Engine
	{
		private var _isRunning:Boolean;
		
		public var size:String = "v8";
		
		public function Engine()
		{
		}
		
		public function start():void
		{
			_isRunning = true;
		}
		
		public function stop():void
		{
			_isRunning = false;
		}
		
		public function get isRunning():Boolean
		{
			return _isRunning;
		}
	}
}