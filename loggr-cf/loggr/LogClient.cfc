<!---
LogClient.cfc

Author: Neal Erickson
Email: neal@ink83.com

Copyright 2011, Neal Erickson
--->
<cfcomponent displayname="LogClient" extends="LoggrBase">
	
    <cfset variables.instance.logKey = "">
    <cfset variables.instance.apiKey = "">
    
	<cffunction name="init" output="false" returntype="any">
    	<cfargument name="logKey" required="yes" type="string">
        <cfargument name="apiKey" required="yes" type="string">        
        <cfscript>
			variables.instance.logKey = arguments.logKey;
			variables.instance.apiKey = arguments.apiKey;
			
			return this;
		</cfscript>
    </cffunction>
    
    <cffunction name="Post" output="false" returntype="void">
    	<cfargument name="event" required="yes" type="any">
        <cfargument name="async" required="no" type="boolean" default=true />
		<cfset loc = {}>

        <cfif arguments.async eq true>
	        <!--- Asynchronous Post --->
			<cfset loc.data = $CreateDataStruct(arguments.event)>        
            <cfset loc.data.apikey = variables.instance.apiKey>
            <cftry>
            <cfset asyncHTTP = createObject("component", "asyncHTTP.AsyncHTTP").init()>        
            <cfset asyncHTTP.post("http://post.loggr.net:80/1/logs/#variables.instance.logKey#/events", loc.data)>        
            <cfcatch type="any"></cfcatch>
            </cftry>
        <cfelse>        
			<!--- Synchronous Post --->
            <cfset loc.qs = $CreateQuerystring(arguments.event)>
            <cfset loc.data = "apikey=#variables.instance.apiKey#&" & loc.qs>
            <cfhttp url = "post.loggr.net/1/logs/#variables.instance.logKey#/events"
                    method = "POST"
                    port = "80"
                    throwOnError = "yes"
                    timeout = "30">            
                <cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded" />
                <cfhttpparam type="header" name="Content-Length" value="#Len(loc.data)#" />
                <cfhttpparam type="body" value="#loc.data#" />
            </cfhttp>
		</cfif>
	</cffunction>
    
    <cffunction name="$CreateDataStruct" output="false" access="private" returntype="any">
    	<cfargument name="event" required="yes" type="any">
        <cfscript>
		var loc = {};
		
		loc.res = {};
		
		loc.res.text = arguments.event.Text;
		
		if (Len(arguments.event.Source)) loc.res.source = arguments.event.Source;
		if (Len(arguments.event.User)) loc.res.user = arguments.event.User;
		if (Len(arguments.event.Link)) loc.res.link = arguments.event.Link;
		if (Len(arguments.event.Value)) loc.res.value = arguments.event.Value;
		if (Len(arguments.event.Tags)) loc.res.tags = arguments.event.Tags;
		if (Len(arguments.event.Geo)) loc.res.geo = arguments.event.Geo;
		
		if (Len(arguments.event.Data))
		{
			if (arguments.event.DataType == constants.DataType.html)
			{
				loc.res.data = "@html" & arguments.event.Data;
			}
			else
			{
				loc.res.data = arguments.event.Data;
			}
		}
		return loc.res;
		</cfscript>
	</cffunction>
    
    <cffunction name="$CreateQuerystring" output="false" access="private" returntype="any">
    	<cfargument name="event" required="yes" type="any">
        <cfscript>
		var loc = {};
		
		loc.res = "";
		loc.res &= "text=" & URLEncodedFormat(arguments.event.Text);
		
		if (Len(arguments.event.Source)) loc.res &= "&source=" & URLEncodedFormat(arguments.event.Source);
		if (Len(arguments.event.User)) loc.res &= "&user=" & URLEncodedFormat(arguments.event.User);
		if (Len(arguments.event.Link)) loc.res &= "&link=" & URLEncodedFormat(arguments.event.Link);
		if (Len(arguments.event.Value)) loc.res &= "&value=" & URLEncodedFormat(arguments.event.Value);
		if (Len(arguments.event.Tags)) loc.res &= "&tags=" & URLEncodedFormat(arguments.event.Tags);
		if (Len(arguments.event.Geo)) loc.res &= "&geo=" & URLEncodedFormat(arguments.event.Geo);

		if (Len(arguments.event.Data))
		{
			if (arguments.event.DataType == constants.DataType.html)
			{
				loc.res &= "&data=" & "@html" & URLEncodedFormat(arguments.event.Data);
			}
			else
			{
				loc.res &= "&data=" & URLEncodedFormat(arguments.event.Data);
			}
		}

		return loc.res;
		</cfscript>
	</cffunction>
</cfcomponent>
