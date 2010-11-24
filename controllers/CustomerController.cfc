<cfcomponent displayname="CustomerController" hint="I handle all Customer actions" extends="AbstractController">
    <!--- Only some of the CRUD actions are supplied for this example --->
	 <cfset controller = "Customer">
   
	<cffunction name="CreateCustomer" access="remote" output="false" returnformat="json">
    	<cfargument name="eventObject" default="#defaultEventObject()#">
		      
		<cfset var event = defaultEvent('CustomerCreated')>

		<cfset var customer = CreateObject( application.appRoot & '.models.Customer').init( arguments.eventObject.firstName, arguments.eventObject.lastName )>
		<cfset event.name = "CustomerCreated">
	  	
	  	<cfreturn event>
	</cffunction>
   
   
   
   <cffunction name="NewCustomer" access="remote" output="true" returnformat="plain">
   	<cfargument name="displayContext" default="body">
   	<cfargument name="displayAction" default="replace">
   	<cfargument name="respondWith" default="html">
		
		<!--- create empty customer object for view --->
      <cfset expose( 'customer', CreateObject( '#application.appRoot#.models.Customer' ).init() )>

      <!--- respond with... --->      
      <cfswitch expression="#lcase( arguments.respondWith )#">
      	
      	<!--- respond with event --->
      	<cfcase value="event">
				<cfreturn renderAsEvent( argumentCollection = { layoutFile = false, name = "CustomerNew", displayContext = arguments.displayContext, displayAction = arguments.displayAction } )>  
      	</cfcase>
			
			<!--- respond with HTML --->
			<cfcase value="html">
				<cfoutput>#renderAsHTML( argumentcollection = { layoutFile = false, title = "New Customer" } )#</cfoutput>		
			</cfcase>
      </cfswitch>
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