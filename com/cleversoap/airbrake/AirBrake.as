package com.cleversoap.airbrake
{
	import flash.errors.IllegalOperationError;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	* Core AirBrake notifier functionality.
	*
	* @important	This class should not be instantiated!
	*/
	internal class AirBrake
	{
		//-------------------------------------------------------------[MEMBERS]

		// Several properties are common (and useful) to both API versions
		protected var _apiKey         :String;
		protected var _environment    :String;
		protected var _projectRoot    :String;
		protected var _projectVersion :String;

		// Notifier Data
		protected var _notifier       :Object;

		// URL Request Params
		protected var _contentType    :String;
		protected var _apiUrl         :String;

		//---------------------------------------------------------[CONSTRUCTOR]

		public function AirBrake($apiKey:String, $environment:String,
								 $projectVersion:String = "0.0", $projectRoot:String = "/")
		{
			_apiKey = $apiKey;
			_environment = $environment;
			_projectVersion = $projectVersion;
			_projectRoot = $projectRoot;

			// Define the notifier
			_notifier = {
				"name"    : "com.cleversoap.AirBrake",
				"version" : "0.3",
				"url"     : "https://github.com/cleversoap/as3-airbrake"
			};
		}

		//----------------------------------------------------------[PROPERTIES]

		public function get apiKey():String
		{
			return _apiKey;
		}

		public function get environment():String
		{
			return _environment;
		}

		public function get projectRoot():String
		{
			return _projectRoot;
		}

		public function get projectVersion():String
		{
			return _projectVersion;
		}

		//----------------------------------------------------[MEMBER FUNCTIONS] 

		protected function makeRequest($notice:*):URLRequest
		{
			var request:URLRequest = new URLRequest();
			request.method         = URLRequestMethod.POST;
			request.contentType    = _contentType;
			request.url            = _apiUrl;
			request.data           = $notice;
			return request;
		}

		protected function parseStackTrace($stackTrace:String):Array
		{
			var backTrace:Array = [];	

			var lineRegExp:RegExp = /at (?P<type>[\w\.:]+):*\/*(?P<method>\w+)?\(\)(\[(?P<file>.*):(?P<line>\d+)\])?/g;
			
			var match:Object;
			while (match = lineRegExp.exec($stackTrace))
			{
				backTrace.push(makeBackTraceLine(
					(match.file ? match.file : match.type),    // File
					uint(match.line ? match.line : 0),         // Line Number
					(match.method ? match.method : match.type) // Function
				));
			}

			return backTrace;

		}

		protected function makeBackTraceLine($file:String, $line:uint, $function:String):*
		{
			throw new IllegalOperationError("makeBackTraceLine must be called from child class implementation only");
		}
	}
}
