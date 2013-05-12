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
		* Initialises an AirBrake XML Notifier for a specific project.
		*
		* @param $apiKey         AirBrake API key for your project.
		* @param $environment    Reporting environment such as "staging" or "production".
		* @param $projectVersion Version of project to report errors for.
		* @param $projectRoot    Root of the project and where the files are located.*
		*/
		public function AirBrakeXML($apiKey:String, $environment:String,
		                            $projectVersion:String = "0.0", $projectRoot:String = "./")
		{
			super($apiKey, $environment, $projectVersion, $projectRoot);

			_notifier.name += "XML";

			_contentType = "text/xml";
			_apiUrl = "http://api.airbrake.io/notifier_api/v2/notices";
		}

		//----------------------------------------------------[PUBLIC FUNCTIONS]

		/**
		* Create an error notice for the AirBrake XML API (v2)
		*
		* @param $error The error object to parse and report.
		*/
		public function createErrorNotice($error:Error, $params:Object = null, $url:String = null):URLRequest
		{
			return makeRequest(makeNotice($error, $params, $url)); 
		}

		//----------------------------------------------------[MEMBER FUNCTIONS] 

		/**
		* Create the entirety of the notice XML to send to AirBrake.
		*/
		protected function makeNotice($error:Error, $params:Object, $url:String):XML
		{
			// The request node should only be dynamically built
			// if it will contain data. This means that either the
			// URL or params must be passed otherwise no request
			// node will be created.
			var reqNode:XML = <request/>

			// URL
			if ($url)
				reqNode.appendChild(<url>{$url}</url>);

			// Parameters
			if ($params)
			{
				var paramsNode:XML = <params/>;

				for (var param:String in $params)
					paramsNode.appendChild(<var key={param}>{$params[param]}</var>);

				if (paramsNode.children().length() > 0)
					reqNode.appendChild(paramsNode);
			}

			// If there is at least one entry in the back trace
			// then extract it the first one and use it to describe the component action
            var stackTrace:String = $error.getStackTrace();
            var component:String = parseComponent(stackTrace);
            if (component)
            {
                reqNode.appendChild(<component>{component}</component>);
            }

			var backTrace:XML = makeBackTrace(stackTrace);
			if (backTrace.children().length() > 0)
			{
				reqNode.appendChild(<action>{backTrace.children()[0].@method}</action>);
			}

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
						<hostname>{_environment}</hostname>
					</server-environment>
					{reqNode.children().length() > 0 ? reqNode : ""}	
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
