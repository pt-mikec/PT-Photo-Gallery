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
Custom Field Type:
	Photo Size Select Metadata Form Field Props
Name:
	photo_size_select_metadata_form_field_props.cfm
Summary:
	Selection field for the Photo Size CE records.
	
	TO BE USED ONLY IN A METADATA FORM!
ADF Requirements:
	csData_1_0
	scripts_1_0
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2010-04-01 - MFC - Created
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;
</cfscript>
<cfoutput>
<script type="text/javascript">
	fieldProperties['#typeid#'].paramFields = "";
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
<cfset customElements = server.ADF.objectFactory.getBean("ceData_1_0").getAllCustomElements()>
<table>
	<tr>
		<td class="cs_dlgLabelSmall" colspan="2">No Properties</td>
	</tr>
</table>
</cfoutput>