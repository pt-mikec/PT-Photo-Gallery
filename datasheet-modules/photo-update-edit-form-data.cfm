<!---
/* ***************************************************************
/*
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
	0.9.1
History:
	2009-08-04 - MFC - Created
--->

<!--- Verify that the server ADF environment config is setup --->
<cfif StructKeyExists(server.ADF.environment[request.site.id],"ptPhotoGallery")
	AND StructKeyExists(server.ADF.environment[request.site.id]["ptPhotoGallery"],"CE_FORM_ID")>
	<cfset formId = server.ADF.environment[request.site.id]["ptPhotoGallery"]["CE_FORM_ID"]>
	<cfsavecontent variable="tdHTML">
		<!---<cfset application.ptPhotoGallery.scripts.loadADFLightbox()>--->
		<cfoutput>
			<td align="center" valign="top">
				<table width="100%"> 
					<tr width="100%">
						<td width="50%">
							<div rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoEditForm&formid=#formid#&dataPageId=#Request.DatasheetRow.pageid#&width=600&height=600&title=Edit Photo" title="Edit Photo" class="ADFLightbox">
								<div class='ds-icons ui-state-default ui-corner-all' title='edit' >
									<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-pencil'></div>
								</div>
							</div>
						</td>
						<td width="50%">	
							<div rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoDeleteForm&formid=#formid#&dataPageId=#Request.DatasheetRow.pageid#&width=300&height=200&title=Delete Photo" title="Delete Photo" class="ADFLightbox">
								<div class='ds-icons ui-state-default ui-corner-all' title='delete' >
									<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-trash'></div>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</cfoutput>
	</cfsavecontent>
</cfif>
<cfset request.datasheet.currentFormattedValue = tdHTML>