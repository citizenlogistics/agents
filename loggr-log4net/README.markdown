## Log4Net Loggr Agent

A log4net "appender" for logging to Loggr. You should be able to drop in the binaries and configure the appender and log4net will automatically log to your Loggr log.

**NOTICE: This agent requires the full version of the .Net Framework, client profiles will not work**

## Installation  

* Drop the binaries in the /bin folder of your app (if you already have the log4net.dll, you don't need to copy that)
* Add lines to your web.config or app.config

Sample lines for your *.config file

	<configuration>
	  <configSections>
		<sectionGroup name="loggr">
		  <section name="log" type="System.Configuration.NameValueSectionHandler"/>
		</sectionGroup>
	  </configSections>
	  
	  ...
	  
	  <loggr>
		<log>
		  <add key="logKey" value="#####"/>
		  <add key="apiKey" value="#####"/>

		  <!-- OPTIONAL
		    -- tags: allows you to specify additional tags to add for each event (space delimited)
			-- source: allows you to specify a default source if event is missing one 
		  <add key="tags" value="#####"/>
		  <add key="source" value="######"/>
		  -->
		</log>
	  </loggr>
	  
	  ...
	  
	</configuration>

Sample log4net config to use the Appender (add to log4net section)

	<log4net>
	  <appender name="LoggrAppender" type="Loggr.Log4Net.Appender,loggr-log4net"></appender>

	  ...

	  <root>

	    ...

	    <appender-ref ref="LoggrAppender" />
	  </root>
	</log4net>

## How To Use

When properly configured you shouldn't have to change your logging code. This Appender includes the loggr-dotnet agent, so you can add a reference to that and make better use of the Loggr posting API.


## More Information

For more details, see http://loggr.net/docs




