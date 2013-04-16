package com.cleversoap.airbrake
{
	public class AirBrakeXML extends AirBrake implements IAirBrake
	{
		public function AirBrakeXML($apiKey:String, $environment:String)
		{
			super($apiKey, $environment);
		}

		public function createErrorNotice($error:Error):URLRequest
		{
			return new URLRequest();
		}
	}
}
