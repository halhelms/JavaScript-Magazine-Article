<cfcomponent  displayname="AbstractController" hint="I am an abstract controller, not meant to be instantiated" output="false">

	<cfparam name="url.method" default="">
	<cfset response = {}>
		<cfset response.display	= "">
		<cfset response.title 	= url.method>

	<cfset action = url.method>

<cffunction name="init">
			<cfreturn this>
		</cffunction>




<cffunction name="_event" access="private" output="false" hint="I return a barebones event">
			<cfargument name="name" 				default="none">
			<cfargument name="displayContext" 	default="body">
			<cfargument name="displayAction"		default="replace">
			
			<cfset var event = {}>
				<cfset event[ 'name' ] 				= arguments.name>
				<cfset event[ 'displayContext' ] = arguments.displayContext>
				<cfset event[ 'displayAction' ] 	= arguments.displayAction>
				<cfset event[ 'display' ]			= response.display>
				<cfset event[ 'data' ]				= {}>
			
			<cfreturn event>
		</cffunction>
	
	
	
	
<cffunction name="expose" access="package" output="false" hint="I expose a variable to view files">
			<cfargument name="key">
			<cfargument name="value">
			
			<cfset response[ arguments.key ] = arguments.value>
			<cfreturn this>
		</cffunction>

	

<cffunction name="_renderContents" access="private" output="true">
		<cfargument name="viewFiles" default="#[]#">
		
			<cfset var specifiedViewFile = false>
			<cfif IsSimpleValue( arguments.viewFiles )>
				<cfset specifiedViewFile = true>
			</cfif>
		
			<!--- In case we were only given a single view file --->
			<cfif specifiedViewFile>
				<!--- In case the file being sent in is specified from application.appPath --->
				<cfif LCase( ListLast( arguments.viewFiles, ':' ) ) EQ "sic">
					<cfset arguments.viewFiles = ListFirst( arguments.viewFiles, ':')>
				<cfelse>
				
					<cfset var extensionStartsAt 				= REfindNoCase( "\.[^.]+$", arguments.viewFiles )>
					
					<cfif extensionStartsAt GT 0>
						<cfset var fileNameWithoutExtension	= Left( arguments.viewFiles, extensionStartsAt - 1)>
					<cfelse>
						<cfset var fileNameWithoutExtension	= arguments.viewFiles>
					</cfif>
					
					<cfset arguments.viewFiles 				= ['#application.appPath#/views/#Lcase( controller )#/#fileNameWithoutExtension#']>
				</cfif>
			<!--- No, we have multiple files --->
			<cfelse>
				<cfset var argFiles = arguments.viewFiles>
				<cfset arguments.viewFiles = []>
				
				<cfloop array = "#argFiles#" index="aFile">
					<!--- In case the file being sent in is specified from application.appPath --->
					<cfif LCase( ListLast( aFile, ':' ) ) EQ "sic">
						<cfset ArrayAppend( arguments.viewFiles, aFile )>
					<!--- No, this is just a normal file which we should strip the extension from --->
					<cfelse>
						<cfset var extensionStartsAt 				= REfindNoCase( "\.[^.]+$", aFile )>
						
						<cfif extensionStartsAt GT 0>
							<cfset var fileNameWithoutExtension	= Left( aFile, extensionStartsAt - 1)>
						<cfelse>
							<cfset var fileNameWithoutExtension	= aFile>
						</cfif>
						
						<cfset ArrayAppend( arguments.viewFiles, '#application.appPath#/views/#Lcase( controller )#/#fileNameWithoutExtension#' )>
					</cfif>
				</cfloop>			
			</cfif>
			
			<!--- Finally, if nothing was specified, try using the view file correspoding with the action name --->
			<cfif NOT ArrayLen( arguments.viewFiles )>
				<cfset arguments.viewFiles = [ '#application.appPath#/views/#LCase( controller )#/#action#' ]>
			</cfif>
			
			<!--- Populate response.display --->
			<cfset _display( arguments.viewFiles )>	
		</cffunction>




<cffunction name="_renderLayout" access="private" output="true">
			<cfargument name="layoutFile" default="#controller#">
			
				<!--- For the layout --we're going to let people pass in either a Boolean or "none" so this is going to get a little ugly --->
				<cftry>
				<cfif NOT arguments.layoutFile>
					<cfreturn this>
				</cfif>
					<cfcatch><!--- Fail silently ---></cfcatch>
				</cftry>
				
				<!--- Not a boolean, let's check as a string next --->
				<cfif LCase( arguments.layoutFile ) EQ "none" OR LCase( arguments.layoutFile ) EQ "false">
					<cfreturn this>
				</cfif>
				
				<cfset _layout( arguments.layoutFile )>
		</cffunction>


<cffunction name="renderAsHtml" access="private" output="true">
		<cfargument name="viewFiles"	default="#[]#">
		<cfargument name="layoutFile"	default="#controller#">
		<!--- Any other arguments will be treated as exposures --->
		
		<cfset var _viewFiles = arguments.viewFiles>
		<cfset var _layoutFile = arguments.layoutFile>
		
		<cfset StructDelete( arguments, 'viewFiles' )>
		<cfset StructDelete( arguments, 'layoutFile' )>
		
				
		<!--- Deal with exposures first --->
		<cfloop collection="#arguments#" item="key">
			<cfset response[ '#key#' ] = arguments[ key ]>
		</cfloop>
		
		<cfset _renderContents( _viewFiles )>
		<cfset _renderLayout( _layoutFile )>
		
		<cfreturn response.display>
	</cffunction>




<cffunction name="renderAsEvent" access="private" output="false" hint="I return an event with display rendered">
		<cfargument name="viewFiles"			default="#[]#">
		<cfargument name="layoutFile" 		default=false>	
		<cfargument name="name" 				default="Unspecified">
		<cfargument name="displayContext"	default="body">
		<cfargument name="displayAction"		default="replace">
		
		<!--- Any other arguments will be treated as exposures --->
		
		<cfset var _viewFiles = arguments.viewFiles>
		<cfset var _layoutFile = arguments.layoutFile>
		
		<cfset StructDelete( arguments, 'viewFiles' )>
		<cfset StructDelete( arguments, 'layoutFile' )>	
		
		<!--- Deal with exposures first --->
		<cfloop collection="#arguments#" item="key">
			<cfset response[ '#key#' ] = arguments[ key ]>
		</cfloop>			
		
		<cfset _renderContents( _viewFiles )>
		<cfset _renderLayout( _layoutFile )>
		
		<cfset var event = _event( argumentcollection = { name = arguments.name, displayContext = arguments.displayContext, displayAction = arguments.displayAction } )>
		<cfreturn SerializeJSON( event )>
	</cffunction>

	
	
	
<cffunction name="_display" access="private" output="false" hint="I handle creating response.display">
			<cfargument name="viewFiles">
			
			<!--- Loop over the view files, putting them into response.display --->
			<cfset var tmp = "">
			<cfloop array="#arguments.viewFiles#" index="aView">
			
				<!--- Fully specified file? --->
				<cfif Lcase( ListLast( aView, ':' ) ) EQ "sic">
					<cftry>
						<cfsavecontent variable="tmp">
							<cfinclude template="#application.appPath##ListFirst( aView, ':' )#">
						</cfsavecontent>
						<cfset response.display &= tmp>
						<cfcatch><cfcontinue></cfcatch>
					</cftry>
				<!--- No, not fully specified file --->
				<cfelse>
					<cflog file="test" application="false" text="aView is : #aView#">
					<cftry>
						<cfsavecontent variable="tmp">
							<cfinclude template="#aView#.cfm">
						</cfsavecontent>
						<cfset response.display &= tmp>
						<cflog file="test" application="false" text="In response.display : #response.display#">
						<!--- Continue the loop if there's a problem --->
						<cfcatch><cflog file="test" application="false" text="ERROR : #cfcatch.Message#"><cfcontinue></cfcatch>
					</cftry>
		
					<cftry>
						<cfsavecontent variable="tmp">
							<cfinclude template="#aView#.js">
						</cfsavecontent>
						<cfset response.display &= tmp>
						<cflog file="test" application="false" text="In response.display : #response.display#">				
						<cfcatch><cflog file="test" application="false" text="ERROR : #cfcatch.Message#"><cfcontinue></cfcatch>
					</cftry>
				</cfif>
			</cfloop>
			
			<cflog file="test" application="false" text="After view files : #response.display#">
			
		</cffunction>
	
	
	
	
<cffunction name="_layout" access="private" output="false" hint="I handle wrapping response.display in layout/s">
		<cfargument name="layoutFile">

		<!--- If a layout was specified, use that --->
		<cftry>
			<cfset var extensionStartsAt = REfindNoCase( "\.[^.]+$", arguments.layoutFile )>
			<cfif extensionStartsAt GT 0>
				<cfset arguments.layoutFile = Left( arguments.layoutFile, extensionStartsAt - 1)>
			</cfif>
			
			<cfsavecontent variable="tmp">
				<cfinclude template="#application.appPath#/layouts/#arguments.layoutFile#.cfm">
			</cfsavecontent>
			<cfset response.display = tmp>
			<cflog file="test" application="false" text="With specified Layout : #tmp#">
			<!--- Nothing specified? then try using the controller's layout --->
			<cfcatch>
				<cftry>
					<cfsavecontent variable="tmp">
						<cfinclude template="#application.appPath#/layouts/#controller#Layout.cfm">
					</cfsavecontent>
					
					<cfset response.display = tmp>
					<cflog file="test" application="false" text="With controller layout : #tmp#">
					<!--- Nothing found? Then we'll just use the general layout --->
					<cfcatch><cflog file="test" application="false" text="ERROR : #cfcatch.Message#"></cfcatch>
				</cftry>
			</cfcatch>
		</cftry>
		<cflog file="test" application="false" text="Before applying application layout : #response.display#">
		<!--- Use application layout? --->
		<cfsavecontent variable="tmp">
			<cftry>
				<cfinclude template="#application.appPath#/layouts/ApplicationLayout.cfm">
				<cfcatch>
					Missing application layout<br />
					<cfoutput>#cfcatch.Message#</cfoutput>
				</cfcatch>
			</cftry>		
		</cfsavecontent>
		<cflog file="test" application="false" text="With application layout : #tmp#">
		<cfset response.display = tmp>		
	</cffunction>
	
</cfcomponent>