<cfcomponent displayname="Customer" output="false" hint="I am a Customer">

   <cffunction name="init" access="public" output="false" hint="I am a constructor">
      <cfargument name="firstName" default="">
      <cfargument name="lastName" default="">
      <cfargument name="creditLimit" default="1000">
      
      <cfset this.id = CreateUUID()>
      <cfset this.firstName = arguments.firstName>
      <cfset this.lastName = arguments.lastName>
      <cfset this.creditLimit = arguments.creditLimit>

      <cfreturn this>
   </cffunction>
   
</cfcomponent>