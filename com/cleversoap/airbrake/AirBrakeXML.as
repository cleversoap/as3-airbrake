package com.cleversoap.airbrake
{
	import flash.net.URLRequest;

	public class AirBrakeXML extends AirBrake implements IAirBrake
	{
		public function AirBrakeXML($apiKey:String, $environment:String)
		{
			super($apiKey, $environment);

			_notifier.name += "XML";

			_contentType = "text/xml";
			_apiUrl = "http://api.airbrake.io/notifier_api/v2/notices";
		}

		public function createErrorNotice($error:Error):URLRequest
		{
			return makeRequest(makeNotice($error)); 
		}

		protected function makeNotice($error:Error):XML
		{
			return <notice version="2.3">
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
		}

		override protected function makeBackTraceLine($file:String, $line:uint, $function:String):*
		{
			var lineNode:XML = <line/>
			lineNode.@method = $function;
			lineNode.@file   = $file;
			lineNode.@number = $line;
			return lineNode;
		}

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
