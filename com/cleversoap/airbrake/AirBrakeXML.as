/**
* Written by Cleversoap (clever@cleversoap.com)
* https://github.com/cleversoap/as3-airbrake
* MIT License (http://opensource.org/licenses/MIT)
*/
package com.cleversoap.airbrake
{
	import flash.net.URLRequest;

	/**
	* AirBrake API v2 XML Notifier
	* http://airbrake.io/airbrake_2_3.xsd
	*/
	public class AirBrakeXML extends AirBrake implements IAirBrake
	{
		//---------------------------------------------------------[CONSTRUCTOR]

		/**
		*
		*/
		public function AirBrakeXML($apiKey:String, $environment:String,
		                            $projectVersion:String = "0.0", $projectRoot:String = "/")
		{
			super($apiKey, $environment, $projectVersion, $projectRoot);

			_notifier.name += "XML";

			_contentType = "text/xml";
			_apiUrl = "http://api.airbrake.io/notifier_api/v2/notices";
		}

		//----------------------------------------------------[PUBLIC FUNCTIONS]

		/**
		* Create an error notice for the AirBrake XML API (v2)
		*/
		public function createErrorNotice($error:Error):URLRequest
		{
			return makeRequest(makeNotice($error)); 
		}

		//----------------------------------------------------[MEMBER FUNCTIONS] 

		/**
		* Create the entirety of the notice XML to send to AirBrake.
		*/
		protected function makeNotice($error:Error):XML
		{
			return(

				<notice version="2.3">
					<api-key>{_apiKey}</api-key>
					<notifier>
						<name>{_notifier.name}</name>
						<version>{_notifier.version}</version>
						<url>{_notifier.url}</url>
					</notifier>
					<error>
						<class>{$error.name}</class>
						<message>{$error.message}</message>
						{makeBackTrace($error.getStackTrace())}
					</error>
					<server-environment>
						<project-root>{_projectRoot}</project-root>
						<environment-name>{_environment}</environment-name>
						<app-version>{_projectVersion}</app-version>
					</server-environment>
				</notice>

			);
		}

		/**
		* Called when the base AirBrake class is parsing the stack trace to
		* output XML elements for each entry.
		*/
		override protected function makeBackTraceLine($file:String, $line:uint, $function:String):*
		{
			var lineNode:XML = <line/>
			lineNode.@method = $function;
			lineNode.@file   = $file;
			lineNode.@number = $line;
			return lineNode;
		}

		/**
		* Turn the array of back trace entries into an XML element.
		*/
		protected function makeBackTrace($stackTrace:String):XML
		{
			var backTraceNode:XML = <backtrace/>;

			var backTrace:Array = parseStackTrace($stackTrace);

			var i:int = 0;
			for (; i < backTrace.length; ++i)
			{
				backTraceNode.appendChild(backTrace[i]);
			}

			backTrace.splice();
			backTrace = null;

			return backTraceNode;
		}
	}
}
