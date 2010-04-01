<!---
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 
Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.
 
The Original Code is comprised of the ADF directory
 
The Initial Developer of the Original Code is
PaperThin, Inc. Copyright(C) 2010.
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
Custom Field Type:
	Photo Size Select Metadata Form Field Render
Name:
	photo_size_select_metadata_form_field_render.cfm
Summary:
	Selection field for the Photo Size CE records.
	
	TO BE USED ONLY IN A METADATA FORM!
ADF Requirements:
	csData_1_0
	scripts_1_0
History:
	2010-04-01 - MFC - Created
--->
<cfscript>
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	// Get the description message
	xparams.desc = attributes.fields.DESCRIPTION;

	// Load JQuery to the script
	application.ptPhotoGallery.scripts.loadJQuery("1.3.2");
	
	// Get the data records
	ceDataArray = application.ptPhotoGallery.cedata.getCEData("Photo Size");	
</cfscript>
<cfoutput>
	<script>
		// javascript validation to make sure they have text to be converted
		#fqFieldName# = new Object();
		#fqFieldName#.id = '#fqFieldName#';
		//#fqFieldName#.tid = #rendertabindex#;
		#fqFieldName#.validator = "validate_#fqFieldName#()";
		#fqFieldName#.msg = "Please select a value for the #xparams.label# field.";
		// Check if the field is required
		if ( '#xparams.req#' == 'Yes' ){
			// push on to validation array
			vobjects_#attributes.formname#.push(#fqFieldName#);
		}
		
		function validate_#fqFieldName#()
		{
			//alert(fieldLen);
			if (jQuery("input[name=#fqFieldName#]").val() != '')
			{
				return true;
			}
			else
			{
				alert(#fqFieldName#.msg);
				return false;
			}
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
			<div id="#fqFieldName#_renderSelect">
				<select name='#fqFieldName#' id='#fqFieldName#'>
		 			<option value=''> - Select - </option>
		 			<cfloop index="cfs_i" from="1" to="#ArrayLen(ceDataArray)#">
						<cfif ceDataArray[cfs_i].Values.sizeID EQ currentValue>
							<cfset isSelected = true>
						<cfelse>
							<cfset isSelected = false>
						</cfif>
						<option value="#ceDataArray[cfs_i].Values.sizeID#" <cfif isSelected>selected</cfif>>#ceDataArray[cfs_i].Values.title#
					</cfloop>
		 		</select>
			</div>
		</td>
	</tr>
	<tr>
		<td></td>
		<td style="color: rgb(0, 0, 0); font-size: xx-small;">
			#xparams.desc#
		</td>
	</tr>
</cfoutput>