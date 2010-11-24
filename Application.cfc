<cfcomponent displayname="Application">
	<cfset this.name = "js-mag-artdfdicleaabcdasdfdsddaadaad">
	<cfset this.ormenabled = true>
	<cfset this.datasource = "jsmag">
	
	<cfset this.ormsettings.dbcreate = "update">
	<cfset this.ormsettings.dialect = "MySQL">
	<cfset this.ormsettings.cflocation = "models">
	

	<cffunction name="onApplicationStart">
		<cfinclude template="config/initialization.cfm">
	</cffunction>
	
	<cffunction name="onRequestStart">
		<cfif StructKeyExists( url, 'reload')>
			<cfset onApplicationStart()>
		</cfif>
	</cffunction>
	
	<cffunction name="x_onCFCRequest" access="public" output="true" hint="Here because onMissingMethod does not work with remote access">
		<cfargument name="component">
		<cfargument name="methodName">
		<cfargument name="methodArguments">
		
		<cftry>
			<cfinvoke component="#arguments.component#" method="#arguments.methodName#" argumentcollection="#arguments.methodArguments#" returnvariable="contents">
				#contents#
			<cfcatch>
				<cfset arguments.methodArguments.missingMethodName = arguments.methodName>
				<cfinvoke component="#arguments.component#" method="onMissingMethod" argumentcollection="#arguments.methodArguments#" returnvariable="contents">
			</cfcatch>
		</cftry>
	</cffunction>



</cfcomponent>