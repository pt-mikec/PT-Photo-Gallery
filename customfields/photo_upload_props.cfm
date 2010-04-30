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
	Photo Upload
Name:
	photo_upload_props.cfm
Summary:
	Photo upload field for the PT_Photo_Gallery custom application.
ADF Requirements:
	lib\cedata\CEDATA_1_0
Version:
	1.0.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;

	if( not structKeyExists(currentValues, "photoCategory") )
		currentValues.photoCategory = "";
	if( not structKeyExists(currentValues, "catFldName") )
		currentValues.catFldName = "";
	if( not structKeyExists(currentValues, "includeImgGalleryFldName") )
		currentValues.includeImgGalleryFldName = "";
</cfscript>

<!--- get the data for the Photo Categories --->
<cfscript>
	photoCatDataArray = application.ptPhotoGallery.cedata.getCEData("Photo_Category", "categoryID", "", "notselected");
</cfscript>
<!--- <cfdump var="#photoCatDataArray#"> --->

<cfoutput>
	<script type="text/javascript"]>
		fieldProperties['#typeid#'].paramFields = "#prefix#photoCategory,#prefix#catFldName,#prefix#includeImgGalleryFldName";
		// allows this field to support the orange icon (copy down to label from field name)
		fieldProperties['#typeid#'].jsLabelUpdater = '#prefix#doLabel';
		// allows this field to have a common onSubmit Validator
		fieldProperties['#typeid#'].jsValidator = '#prefix#doValidate';
		// handling the copy label function
		function #prefix#doLabel(str)
		{
			document.#formname#.#prefix#label.value = str;
		}
		function #prefix#doValidate()
		{
			if( (document.getElementById('#prefix#photoCategory').value.length == 0) && (document.getElementById('#prefix#catFldName').value.length == 0) )
			{
				alert('Please select a Default Photo Category or specify the Photo Category Field Name');
				return false;
			}
			if( (document.getElementById('#prefix#photoCategory').value.length > 0) && (document.getElementById('#prefix#catFldName').value.length == 0) )
			{
				alert('Please enter the Photo Category Field Name');
				return false;
			}
			
			return true;
		}
	</script>
<table>
	<tr>
		<td class="cs_dlgLabelSmall">Default Photo Category:</td>
		<td class="cs_dlgLabelSmall">
			<select name="#prefix#photoCategory" id="#prefix#photoCategory">
				<option value="" selected> - Select - </option>
				<cfloop index="i" from="1" to="#ArrayLen(photoCatDataArray)#">
					 <option value="#photoCatDataArray[i].Values.categoryid#" <cfif currentValues.photoCategory eq photoCatDataArray[i].Values.categoryid>selected</cfif>>#photoCatDataArray[i].Values.title#</option> 
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Photo Category Field Name:</td>
		<td class="cs_dlgLabelSmall"><input type="text" name="#prefix#catFldName" id="#prefix#catFldName" class="cs_dlgControl" value="#currentValues.catFldName#" size="60">
		<br/><span>Please enter the category field name in the Element.</span></td>
	</tr>
	<tr><td><br /></td></tr>
	<tr>
		<td class="cs_dlgLabelSmall">Include Image Gallery Field Name:</td>
		<td class="cs_dlgLabelSmall"><input type="text" name="#prefix#includeImgGalleryFldName" id="#prefix#includeImgGalleryFldName" class="cs_dlgControl" value="#currentValues.includeImgGalleryFldName#" size="60">
		<br/><span>If using the Image Gallery, enter the field name for the Include in Image Gallery field.</span></td>
	</tr>
</table>
</cfoutput>