__author__ = 'lucidtech'

import SOAPpy
import cgi
import xml.etree.ElementTree as ET

x = '<?xml version="1.0" encoding="utf-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/1999/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/1999/XMLSchema" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
	<SOAP-ENV:Body>
		<getVersionResponse SOAP-ENC:root="1">
			<Result xmlns:tns="http://schemas.microsoft.com/2003/10/Serialization/" xmlns:xs="http://www.w3.org/2001/XMLSchema" SOAP-ENC:arrayType="xs:anyType[]" xsi:type="SOAP-ENC:Array">
				<item xsi:type="xsd:int">0</item>
				<item xsi:type="xsd:string"/>
				<item xsi:type="xsd:string">2.0.0.299</item>
			</Result>
		</getVersionResponse>
	</SOAP-ENV:Body>
</SOAP-ENV:Envelope>'