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
		<!--- #request.datasheetrow.photo[request.datasheetrow.currentrow]# --->
		<!--- <a href='#Request.Datasheet.CurrentColumnValue#' title='#request.datasheetrow.title[request.datasheetrow.currentrow]#' class='thickbox'><img src='#Request.Datasheet.CurrentColumnValue#' width='50' height='50' hspace="5"></a> --->
		<!--- <a href='#Request.Datasheet.CurrentColumnValue#' title='#request.datasheetrow.title[request.datasheetrow.currentrow]#' class='thickbox'>
			<img src='#application.ptPhotoGallery.renderService.getPhotoURL(Request.Datasheet.CurrentColumnValue,"small")#' width='50' height='50' hspace="5">
		</a> --->
		<img src='#application.ptPhotoGallery.renderService.getPhotoURL(Request.Datasheet.CurrentColumnValue,"small")#' width='50' height='50' hspace="5" rel="#Request.Datasheet.CurrentColumnValue#?width=650" class="ADFLightbox">
	</cfoutput>
	</cfsavecontent>
	<cfset Request.Datasheet.CurrentFormattedValue = "<td>#variables.celldata#</td>" />
</cfif>