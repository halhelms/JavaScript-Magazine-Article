<cfcomponent displayname="Customer" hint="I handle all Customer actions" extends="AbstractController">
    <!--- Only some of the CRUD actions are supplied for this example --->
   
	<cffunction name="CreateCustomer" access="remote" output="false" returnformat="json">
    	<cfargument name="eventObject" default="#defaultEventObject()#">
		      
		<cfset var event = defaultEvent('CustomerCreated')>

		<cfset var customer = CreateObject( 'component', application.appRoot & '.models.Customer').init( arguments.eventObject.firstName, arguments.eventObject.lastName )>
		<cfset event.name = "CustomerCreated">
	  	
	  	<cfreturn event>
	</cffunction>
   
   
   
   <cffunction name="NewCustomer" access="remote" output="true" returnformat="json">
   	<cfargument name="eventObject" default="#defaultEventObject()#">
      <cfset var event = defaultEvent( 'CustomerNew' )>
      
      <cfset var customer = CreateObject( 'component', '#application.appRoot#.models.Customer' ).init()>
      

		<cfreturn event>
   </cffunction>
   
   
   <cffunction name="AllCustomers" access="remote" output="false" returnformat="json">
		<cfargument name="eventObject" default="#defaultEventObject()#">
		
		<cfset var event = defaultEvent( 'CustomersAll' )>
		<cfset var customers = "">
		<cfquery datasource="#application.dsn#" name="customers">
			SELECT firstName, lastName, id, creditLimit FROM Customer ORDER BY lastName, firstName
		</cfquery>
		
		<cftry>
			<cfsavecontent variable="events.display">
				<cfinclude template="#application.appPath#/views/AllCustomers.cfm">
			</cfsavecontent>
			
			<cfcatch>
				<cfset event.success = "false">
				<cfset event.error = cfcatch.message>
			</cfcatch>
		</cftry>
		
		<cfreturn event>
   </cffunction>
</cfcomponent>