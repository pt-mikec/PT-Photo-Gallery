<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2011.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

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
	2.0
History:
	2009-09-14 - GAC - Initial Version
	2010-04-19 - MFC - Added functionality to open the thumbnail in a lightbox with the full image.
--->
<!--- <cfdump var="#request.DatasheetRow#" expand="false"> --->
<cfif len(Request.Datasheet.CurrentColumnValue)>
	
	<!--- Check if the image file exists --->
	<cfif FileExists(ExpandPath(request.DatasheetRow.photo[request.DatasheetRow.getRow()]))>
	
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
	<cfelse>
		<cfset variables.celldata = "">
	</cfif>
	
	<cfset Request.Datasheet.CurrentFormattedValue = "<td>#variables.celldata#</td>" />
</cfif>