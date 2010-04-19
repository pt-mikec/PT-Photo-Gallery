<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll 
Name:
	photo-image-preview-display.cfm
Summary:
	Renders a thumbnail for the photo.
ADF Requirements:
	Scripts_1_0
Version:
	1.2.0
History:
	2009-09-14 - GAC - Initial Version
	2010-04-19 - MFC - Added functionality to open the thumbnail in a lightbox with the full image.
--->
<cfif len(Request.Datasheet.CurrentColumnValue)>
	<!--- On the first column, load the app config data into request.params --->
	<cfif request.DatasheetRow.getRow() EQ 1>
		<cfscript>
			application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
			application.ptPhotoGallery.scripts.loadADFLightbox();
			request.params.appConfig = application.ptPhotoGallery.getAppConfig();
		</cfscript>
	</cfif>	
	
	<!--- Get the original images dimensions --->
	<cfimage structName="imgData" action="info" source="#ExpandPath(request.DatasheetRow.photo[request.DatasheetRow.getRow()])#">
	<!--- <cfdump var="#imgData#"> --->
	<cfif StructKeyExists(imgData, "width") AND StructKeyExists(imgData, "height")>
		<cfset imgWidth = imgData.width + 20>
		<cfset imgHeight = imgData.height + 50>
	<cfelse>
		<cfset imgWidth = "200">
		<cfset imgHeight = "200">
	</cfif>
	
	<cfsavecontent variable="variables.celldata">
		<cfoutput>
			<a href="javascript:;" rel="#request.params.appConfig.DISPLAY_URL#?imgsrc=#request.DatasheetRow.photo[request.DatasheetRow.getRow()]#&width=#imgWidth#&height=#imgHeight#&title=#request.DatasheetRow.title[request.DatasheetRow.getRow()]#" title="#request.DatasheetRow.title[request.DatasheetRow.getRow()]#" class="ADFLightbox">
				<img src='#application.ptPhotoGallery.renderService.getPhotoURL(Request.Datasheet.CurrentColumnValue,"_system_resize")#' style="border:none;">
			</a>
		</cfoutput>
	</cfsavecontent>
	<cfset Request.Datasheet.CurrentFormattedValue = "<td>#variables.celldata#</td>" />
</cfif>