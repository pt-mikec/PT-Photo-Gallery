<!---
The contents of this file are subject to the Mozilla Public License Version 1.1
(the "License"); you may not use this file except in compliance with the
License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 
Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.
 
The Original Code is comprised of the ADF directory
 
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
	photo_directory_props.cfm
Summary:
	Custom field for the photo directory field related to the title field.
History:
	2011-02-08 - MFC - Created
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;
	if( not structKeyExists(currentValues, "titleFldID") )
		currentValues.titleFldID = "";
	if( not structKeyExists(currentValues, "fldID") )
		currentValues.fldID = "";
	if( not structKeyExists(currentValues, "fldClass") )
		currentValues.fldClass = "";
	if( not structKeyExists(currentValues, "fldSize") )
		currentValues.fldSize = "40";
</cfscript>
<cfoutput>
	<script type="text/javascript">
		fieldProperties['#typeid#'].paramFields = "#prefix#titleFldID,#prefix#fldID,#prefix#fldClass,#prefix#fldSize";
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
<table>
	<tr>
		<td class="cs_dlgLabelSmall">Title Field ID:</td>
		<td class="cs_dlgLabelSmall">
			<input type="text" name="#prefix#titleFldID" id="#prefix#titleFldID" class="cs_dlgControl" value="#currentValues.titleFldID#" size="40">
			<br/><span>Please enter the title field ID property for the photo title.</span>
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Field ID:</td>
		<td class="cs_dlgLabelSmall">
			<input type="text" name="#prefix#fldID" id="#prefix#fldID" class="cs_dlgControl" value="#currentValues.fldID#" size="40">
			<br/><span>Please enter the field ID to be used via JavaScript.  If blank, will use default field name.</span>
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Class Name:</td>
		<td class="cs_dlgLabelSmall">
			<input type="text" name="#prefix#fldClass" id="#prefix#fldClass" class="cs_dlgControl" value="#currentValues.fldClass#" size="40">
			<br/><span>Please enter a class name to be used via JavaScript or CSS.  If blank, a class attribute will not be added.</span>
		</td>
	</tr>
	<tr>
		<td class="cs_dlgLabelSmall">Field Size:</td>
		<td class="cs_dlgLabelSmall">
			<input type="text" name="#prefix#fldSize" id="#prefix#fldSize" class="cs_dlgControl" value="#currentValues.fldSize#" size="40">
			<br/><span>Enter a display size for this field.</span>
		</td>
	</tr>
	
</table>
</cfoutput>