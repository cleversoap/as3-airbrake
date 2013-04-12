package com.cleversoap.airbrake
{
	public class AirBrake
	{
		protected var _apiKey      :String;
		protected var _environment :String;
		protected var _appVersion  :String;
		protected var _hostName    :String;

		public function AirBrake($apiKey:String, $environment:String, $appVersion:String, $hostName:String)
		{

		}

		public function get apiKey():String
		{
			return _apiKey;
		}

		public function get environment():String
		{
			return _environment;
		}

		public function get appVersion():String
		{
			return _appVersion;
		}

		public function get hostName():String
		{
			return _hostName;
		}
	}
}
