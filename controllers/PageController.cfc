<cfcomponent displayname="PageController" hint="I return full pages" extends="AbstractController" output="false">
	<cfset controller = "Page">
	
	<cffunction name="page" access="remote" output="true" hint="I return a named page">
		<cfargument name="pageName">
		<cfset renderAsHtml( [ arguments.pageName ] )>
		#response.contents#
	</cffunction>
	
	<cffunction name="onMissingMethod" access="remote" output="true" hint="I handle all page requests">
		<cfargument name="missingMethodName">
		<cfargument name="missingMethodArguments">
		<cfset renderAsHtml( arguments.missingMethodName )>
		<cfreturn response.contents>
	</cffunction>
</cfcomponent>