package com.cleversoap.airbrake
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class AirBrake
	{
		protected var _apiKey      :String;
		protected var _environment :String;
		protected var _appVersion  :String;
		protected var _hostName    :String;

		public function AirBrake($apiKey:String, $environment:String, $appVersion:String, $hostName:String)
		{
			_apiKey      = $apiKey;
			_environment = $environment;
			_appVersion  = $appVersion;
			_hostName    = $hostName;
		}

		public function createErrorReport($error:Error):URLRequest
		{
			return generateRequest(generateXml($error));
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

		protected function generateRequest($errorXml:XML):URLRequest
		{
			var request:URLRequest = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.data = [$errorXml.toString()];
			request.url = "http://airbrake.io/notifier_api/v2/notices";
			return request;
		}

		protected function generateXml($error:Error):XML
		{
			return null;
		}
	}
}
