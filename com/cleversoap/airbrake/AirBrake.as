package com.cleversoap.airbrake
{
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
		protected var _notifier    :Object;

		//---------------------------------------------------------[CONSTRUCTOR]

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
				
		}
	}
}
