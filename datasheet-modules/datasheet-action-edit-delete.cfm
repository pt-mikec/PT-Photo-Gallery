<!---
/* ***************************************************************
/*
Author: 	
	PaperThin Inc.
	M. Carroll
Name:
	datasheet-action-edit-delete-view.cfm
Summary:
	Datasheet-module action column for edit, delete, and view  
Version:
	1.0.0
History:
	2009-11-05 - MFC - Created
--->
<!--- Set the profile view link --->
<cfscript>
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	application.ptPhotoGallery.scripts.loadADFLightbox();
	/* 
	// Get the element record for the profile
	profileData = application.ptProfile.cedata.getCEData("Profile", "uniqueid", request.datasheet.currentColumnValue);
	profilePageURL = "";
	
	if ( ArrayLen(profileData) )
	{
		// Create the project object
		profileObj = server.ADF.objectFactory.getBean("profile").initProfile(profileData[1].values.userid);
		profileRoles = profileObj.getRoles();
		
		if ( profileRoles['general'].permission )
			profilePageURL = profileRoles['general'].pageURL;
		else 
			profilePageURL = "";
	}
	
	// Check if an profile page exists
	if ( LEN(profilePageURL) ) {
		profileViewLink = "<a href='" & profilePageURL & "' target='_blank'>";
		profileViewLink = profileViewLink & "<div class='ds-icons ui-state-default ui-corner-all' title='view' ><div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-newwin'></div></div>";
		profileViewLink = profileViewLink & "</a>";
	} else {
		profileViewLink = "<div class='ds-icons ui-state-default ui-corner-all' title='no view page' ><div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-alert'></div></div>";
	} */
</cfscript>

<!--- Verify that the request.params.formid exists --->
<cfif (StructKeyExists(request.params, "formid"))>
<cfsavecontent variable="tdHTML">
	<cfoutput>
		<td align="center" valign="middle">
			<table> 
				<tr>
					<td>
						<!--- <div rel="#application.ADF.ajaxProxy#?bean=profileForms&method=profileEdit&formid=#request.datasheet.currentColumnValue#&dataPageId=#Request.DatasheetRow.pageid#&lbAction=refreshparent&width=#request.params.editLBWidth#&height=#request.params.editLBHeight#" title="Edit Photo" class="ADFLightbox">
							<div class='ds-icons ui-state-default ui-corner-all' title='edit' >
								<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-pencil'>
								</div>
							</div>
						</div> --->
						<div rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoEditForm&formid=#request.datasheet.currentColumnValue#&dataPageId=#Request.DatasheetRow.pageid#&width=600&height=600&title=Edit Photo" title="Edit Photo" class="ADFLightbox">
							<div class='ds-icons ui-state-default ui-corner-all' title='edit' >
								<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-pencil'>
								</div>
							</div>
						</div>
					</td>
					<td>	
						<!--- <div rel="#request.params.configStruct.DELETE_URL#?dataPageId=#Request.DatasheetRow.pageid#&width=400&height=300" title="Delete Photo" class="ADFLightbox">
							<div class='ds-icons ui-state-default ui-corner-all' title='delete' >
								<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-trash'>
								</div>
							</div>
						</div> --->
						<div rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoDeleteForm&formid=#request.datasheet.currentColumnValue#&dataPageId=#Request.DatasheetRow.pageid#&width=300&height=200&title=Delete Photo" title="Delete Photo" class="ADFLightbox">
							<div class='ds-icons ui-state-default ui-corner-all' title='delete' >
								<div style='margin-left:auto;margin-right:auto;' class='ui-icon ui-icon-trash'>
								</div>
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


