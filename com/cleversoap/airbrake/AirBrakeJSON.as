/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap.airbrake
{
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	* AirBrake API v3 JSON Notifier
	* http://help.airbrake.io/kb/api-2/notifier-api-v3
	*/
	public class AirBrakeJSON extends AirBrake implements IAirBrake
	{
		//-------------------------------------------------------------[MEMBERS]

		/// Project ID
		protected var _projectId   :String;

		//---------------------------------------------------------[CONSTRUCTOR]

		/**
		* Initialises an AirBrake JSON Notifier for a specific project.
		*
		* @param $apiKey         AirBrake API key for your project.
		* @param $environment    Reporting environment such as "staging" or "production".
		* @param $projectId      AirBrake Project ID key.
		* @param $projectVersion Version of project to report errors for.
		* @param $projectRoot    Root of the project and where the files are located.
		*/
		public function AirBrakeJSON($apiKey:String, $environment:String, $projectId:String,
		                             $projectVersion:String = "0.0", $projectRoot:String = "./")
		{
			// Build the generic airbrake notifier core first
			super($apiKey, $environment, $projectVersion, $projectRoot);

			// Append JSON to the notifier name
			_notifier.name += "JSON";

			// Set the project ID as this is needed by the JSON API only
			_projectId   = $projectId;
		}

		//----------------------------------------------------[PUBLIC FUNCTIONS]

		/**
		* Creates a URLRequest that will report an error to AirBrake
		* based on the passed Error object.
		*
		* @param $error	Error to report.
		*/
		public function createErrorNotice($error:Error):URLRequest
		{
			return makeRequest(JSON.stringify(makeNotice($error))); 
		}

		//----------------------------------------------------------[PROPERTIES] 

		/**
		* Airbrake Project ID
		*/
		public function get projectId():String
		{
			return _projectId;
		}

		//----------------------------------------------------[MEMBER FUNCTIONS] 

		/**
		* Make the notice object containing all the data needed to report.
		*
		* @param $error The error object to parse and report.
		*/
		protected function makeNotice($error:Error):Object
		{
			return {	
				"notifier" : _notifier, 
				"errors"   : [makeErrors($error)],
				"context"  : makeContext()
			};
		}

		/**
		* Make the error object and parse the stack trace.
		*
		* @param $error The error object to parse. 
		*/
		protected function makeErrors($error:Error):Object
		{
			return {
				"type"      : $error.name,
				"message"   : $error.message,
				"backtrace" : parseStackTrace($error.getStackTrace()),
				"context"   : makeContext()
			};
		}

		/**
		* Called when the base AirBrake class is parsing the stack trace to
		* output JSON elements for each entry.
		*/
		override protected function makeBackTraceLine($file:String, $line:uint, $function:String):*
		{
			return {
				"file"     : $file,
				"line"     : $line,
				"function" : $function
			};
		}
	
		/**
		* Optional context property creator.
		*/
		protected function makeContext():Object
		{
			return {
				"language"      : "Actionscript 3",
				"environment"   : _environment,
				"version"       : _projectVersion,
				"url"           : "www.example.com",
				"rootDirectory" : _projectRoot
			};
		}
	}
}
