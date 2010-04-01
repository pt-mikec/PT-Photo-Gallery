<!---
	$Id: photo-image-preview-display.cfm,v 0.1 2009/09/14 

	Description:
		
	Parameters:
		none
	Usage:

	Documentation:
		2009-09-14 gcronkright Initial Version
	Based on:
--->
<cfif len(Request.Datasheet.CurrentColumnValue)>
	<cfsavecontent variable="variables.celldata">
		<cfoutput>
			<img src='#application.ptPhotoGallery.renderService.getPhotoURL(Request.Datasheet.CurrentColumnValue,"_system_resize")#'>
		</cfoutput>
	</cfsavecontent>
	<cfset Request.Datasheet.CurrentFormattedValue = "<td>#variables.celldata#</td>" />
</cfif>