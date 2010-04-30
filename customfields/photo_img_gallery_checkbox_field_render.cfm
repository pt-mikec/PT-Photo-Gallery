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
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Custom Field Type:
	Photo Image Gallery Checkbox Field
Name:
	photo_img_gallery_checkbox_field_render.cfm
Summary:
	Custom select field to select the custom element fields for the
		option id and name values.
	Added Properties to set the field name value, default field value, and field visibility.
ADF Requirements:
	CSData_1_0
	Scripts_1_0
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
	// Load JQuery to the script
	server.ADF.objectFactory.getBean("scripts_1_0").loadJQuery("1.3.2");
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	// Set the field ID
	if ( (NOT StructKeyExists(xparams, "fldName")) OR (LEN(xparams.fldName)) )
		fieldIDVal = xparams.fldName;
	else
		fieldIDVal = fqFieldName;
	
	// Check the default value
	if ( LEN(currentValue) LTE 0 ) {
		currentValue = 'no';
		// If defaulted to checked
		if ( xparams.defaultVal EQ "yes" )
			currentValue = 'yes';
	}
	// Load jQuery
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");	
</cfscript>
<!--- <cfdump var="#xparams#"> --->
<cfoutput>
	<script>
		// javascript validation to make sure they have text to be converted
		#fqFieldName# = new Object();
		#fqFieldName#.id = '#fqFieldName#';
		//#fqFieldName#.tid = #rendertabindex#;
		//#fqFieldName#.validator = "validateLength()";
		//#fqFieldName#.msg = "Please upload a document.";
		// push on to validation array
		//vobjects_#attributes.formname#.push(#fqFieldName#);
	
		jQuery(document).ready(function(){
			
			// Check if we want to hide the field
			// Check if we are rendering the field 
			if ( '#xparams.renderField#' == 'yes' ) {
			
				// Set the value of the checkbox
				if ( jQuery('input[name=#fqFieldName#]').val() == 'yes' ) {
					jQuery('###fqFieldName#_checkbox').attr('checked', 'checked');
				}
							
				// On Change Action
				jQuery('###fqFieldName#_checkbox').change( function(){
					// Check the checkbox status
					if ( jQuery('###fqFieldName#_checkbox:checked').val() == 'yes' )
						currVal = "yes";
					else
						currVal = "no";
					// Set the form field
					jQuery('input[name=#fqFieldName#]').val(currVal);
				});
			}
			else {
				// Hide the field row
				jQuery("###fqFieldName#_fieldRow").hide();
			}
		});
		
		function setImgGalPageID(pageid) {
			// if the photo was stored into the image gallery, then store the page id
			if ( pageid > 0 )
			{
				// Sets value for hidden Image Gallery PageID field
				jQuery('###xparams.imgGalleryPageIDFldName#').val(pageid);
			}
		}
		function getImgGalPageID() {
			// Get value for hidden Image Gallery PageID field
			return jQuery('###xparams.imgGalleryPageIDFldName#').val();
		}
		
		// Function to set the field as disabled
		function #fieldIDVal#_disableFld(){
			jQuery('###fqFieldName#_checkbox').attr('disabled', true);
		}
		// Function to set the field as enabled
		function #fieldIDVal#_enableFld(){
			jQuery('###fqFieldName#_checkbox').attr('disabled', false);
		}
		
	</script>
	
	<cfscript>
		if ( structKeyExists(request, "element") )
		{
			labelText = '<span class="CS_Form_Label_Baseline"><label for="#fqFieldName#">#xParams.label#:</label></span>';
			tdClass = 'CS_Form_Label_Baseline';
		}
		else
		{
			labelText = '<label for="#fqFieldName#">#xParams.label#:</label>';
			tdClass = 'cs_dlgLabel';
		}
	</cfscript>
	<tr id="#fqFieldName#_fieldRow">
		<td class="#tdClass#" valign="top">
			<font face="Verdana,Arial" color="##000000" size="2">
				<cfif xparams.req eq "Yes"><strong></cfif>
				#labelText#
				<cfif xparams.req eq "Yes"></strong></cfif>
			</font>
		</td>
		<td class="cs_dlgLabelSmall">
			<div id="#fqFieldName#_renderCheckbox">
				<input type='checkbox' name='#fqFieldName#_checkbox' id='#fqFieldName#_checkbox' value='yes'>
			</div>
			
			<cfscript>
				// Get the list permissions and compare
				commonGroups = server.ADF.objectFactory.getBean("data_1_0").ListInCommon(request.user.grouplist, xparams.pedit);
				// Set the read only
				readOnly = true;
				// Check if the user does have edit permissions
				if ( (xparams.UseSecurity EQ 0) OR ( (xparams.UseSecurity EQ 1) AND (ListLen(commonGroups)) ) )
					readOnly = false;
			</cfscript>
		</td>
	</tr>
	<!--- hidden field to store the value --->
	<input type='hidden' name='#fqFieldName#' id='#fieldIDVal#' value='#currentValue#'>
	<!--- // include hidden field for simple form processing --->
	<input type="hidden" name="#fqFieldName#_FIELDNAME" id="#fqFieldName#_FIELDNAME" value="#listLast(xParams.fieldName, "_")#">
</cfoutput>