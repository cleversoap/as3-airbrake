package com.cleversoap
{
	internal class AirBrake
	{
		// Several properties are common to both API versions
		protected var _apiKey      :String;
		protected var _environment :String;
		protected var _projectRoot :String;
		protected var _appVersion  :String;

		public function AirBrake($apiKey:String)
		{
			_apiKey = $apiKey;
		}

		public function get apiKey():String
		{
			return _apiKey;
		}
	}
}
