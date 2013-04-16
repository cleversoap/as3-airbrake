package com.cleversoap.airbrake
{
	/**
	* Core AirBrake notifier functionality.
	*
	*/
	internal class AirBrake
	{
		// Several properties are common (and useful) to both API versions
		protected var _apiKey      :String;
		protected var _environment :String;
		protected var _projectRoot :String;
		protected var _appVersion  :String;

		// Notifier Data
		protected var _notifier    :Object;

		public function AirBrake($apiKey:String, $environment:String)
		{
			_apiKey = $apiKey;
			_environment = $environment;

			// Define the notifier
			_notifier = {
				"name"    : "com.cleversoap.AirBrake",
				"version" : "0.3",
				"url"     : "https://github.com/cleversoap/as3-airbrake"
			};
		}

		public function get apiKey():String
		{
			return _apiKey;
		}

		public function get environment():String
		{
			return _environment;
		}

		public function get notifier():Object
		{
			return _notifier;
		}
	}
}
