<cffunction name="test" access="remote">
	<cfloop collection="#arguments#" item="key">
	<cflog file="test" text="#key# : #arguments[key]#">
	</cfloop>
	<cfreturn "hello">
</cffunction>