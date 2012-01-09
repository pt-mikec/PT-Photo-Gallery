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
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Custom Field Type:
	Photo Image Gallery Checkbox Field
Name:
	photo_img_gallery_checkbox_field_props.cfm
Summary:
	Custom select field to select the custom element fields for the
		option id and name values.
	Added Properties to set the field name value, default field value, and field visibility.
ADF Requirements:
	CSData_1_0
	Scripts_1_0
Version:
	2.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;
	
	if( not structKeyExists(currentValues, "renderField") )
		currentValues.renderField = "no";
	if( not structKeyExists(currentValues, "defaultVal") )
		currentValues.defaultVal = "no";
	if( not structKeyExists(currentValues, "fldName") )
		currentValues.fldName = "";
	if( not structKeyExists(currentValues, "imgGalleryPageIDFldName") )
		currentValues.imgGalleryPageIDFldName = "";
</cfscript>

<cfoutput>
<script type="text/javascript">
	fieldProperties['#typeid#'].paramFields = "#prefix#renderField,#prefix#defaultVal,#prefix#fldName,#prefix#imgGalleryPageIDFldName";
	// allows this field to support the orange icon (copy down to label from field name)
	fieldProperties['#typeid#'].jsLabelUpdater = '#prefix#doLabel';
	// allows this field to have a common onSubmit Validator
	//fieldProperties['#typeid#'].jsValidator = '#prefix#doValidate';
	// handling the copy label function
	function #prefix#doLabel(str)
	{
		document.#formname#.#prefix#label.value = str;
	}

</script>
<!--- query to get the Custom Element List --->
<cfset customElements = server.ADF.objectFactory.getBean("cedata_1_0").getAllCustomElements()>
<table>
	<tr>
		<td class="cs_dlgLabelSmall">Field Name:</td>
		<td class="cs_dlgLabelSmall">
			<input type="text" name="#prefix#fldName" id="#prefix#fldName" value="#currentValues.fldName#" size="40">
			<br/><span>Please enter the field name to be used via JavaScript.  If blank, will use default name.</span>
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Field Display Type:</td>
		<td class="cs_dlgLabelSmall">
			<input type="radio" name="#prefix#renderField" id="#prefix#renderField" value="yes" <cfif currentValues.renderField eq 'yes'>checked</cfif>>Visible
			<input type="radio" name="#prefix#renderField" id="#prefix#renderField" value="no" <cfif currentValues.renderField eq 'no'>checked</cfif>>Hidden
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Default Field Value:</td>
		<td class="cs_dlgLabelSmall">
			<input type="radio" name="#prefix#defaultVal" id="#prefix#defaultVal" value="yes" <cfif currentValues.defaultVal eq 'yes'>checked</cfif>>Checked
			<input type="radio" name="#prefix#defaultVal" id="#prefix#defaultVal" value="no" <cfif currentValues.defaultVal eq 'no'>checked</cfif>>Unchecked
		</td>
	</tr>
	<tr><td><br /></td></tr>
	<tr>
		<td class="cs_dlgLabelSmall">Image Gallery PageID Field Name:</td>
		<td class="cs_dlgLabelSmall"><input type="text" name="#prefix#imgGalleryPageIDFldName" id="#prefix#imgGalleryPageIDFldName" class="cs_dlgControl" value="#currentValues.imgGalleryPageIDFldName#" size="60">
		<br/><span>If using the Image Gallery, enter the hidden field name for the Image Gallery PageID field.</span></td>
	</tr>
</table>
</cfoutput>