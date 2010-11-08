<!--- 
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is comprised of the PT Photo Gallery directory

The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2010.
All Rights Reserved.

By downloading, modifying, distributing, using and/or accessing any files 
in this directory, you agree to the terms and conditions of the applicable 
end user license agreement.
--->

<!---
/* *************************************************************** */
Author: 	PaperThin Inc.
			M. Carroll
Name:
	photo-update-edit-form-data.cfc
Summary:
	Datasheet-module action column for article page edit.  
	This element record is connected to a page metadata.  The page metadata is
	updated after the form is submitted and saved.
ADF App:
	pt_photo_gallery
Version:
	1.0.0
History:
	2009-08-04 - MFC - Created
	2010-06-14 - MFC - Removed IF block and added FORM ID variable from the App cfc.
--->
<cfscript>
	formID = application.ptPhotoGallery.getPhotoFormID();
	application.ptPhotoGallery.scripts.loadADFLightbox();
</cfscript>
<!--- Verify that the server ADF environment config is setup --->
<cfsavecontent variable="tdHTML">
	<cfoutput>
		<td align="center" valign="top">
			<a style="float: left;" rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoAddEdit&dataPageId=#Request.DatasheetRow.pageid#&title=Edit Photo&lbAction=refreshParent" class="ADFLightbox" title='Edit Photo'>			
				<div class='ds-icons ui-state-default ui-corner-all' title='edit' >
					<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-pencil'></div>
				</div>
			</a>
			<a style="float: left; margin-left: 3px; margin-right: 3px;" rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoDeleteForm&formid=#formid#&dataPageId=#Request.DatasheetRow.pageid#&width=300&height=200&title=Delete Photo&lbAction=refreshParent" class="ADFLightbox" title='Delete Photo'>
				<div class='ds-icons ui-state-default ui-corner-all' title='delete' >
					<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-trash'></div>
				</div>
			</a>
			<span style="clear: both;">&nbsp;</span>
		</td>
	</cfoutput>
</cfsavecontent>
<cfset request.datasheet.currentFormattedValue = tdHTML>