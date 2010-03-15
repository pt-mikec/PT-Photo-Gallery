<!---
/* ***************************************************************
/*
Author: 	
	PaperThin, Inc.
	Michael Carroll 
Custom Field Type:
	Photo Upload Link Field
Name:
	photo_upload_link_props.cfm
Summary:
	Custom select field to render an upload link to the photo element.
ADF Requirements:
	Scripts_1_0
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;
	
	if( not structKeyExists(currentValues, "photoFieldID") )
		currentValues.photoFieldID = "";
</cfscript>

<cfoutput>
	
	<script language="JavaScript" type="text/javascript">
		// register the fields with global props object
		fieldProperties['#typeid#'].paramFields = '#prefix#photoFieldID';
		// allows this field to support the orange icon (copy down to label from field name)
		fieldProperties['#typeid#'].jsLabelUpdater = '#prefix#doLabel';
		// allows this field to have a common onSubmit Validator
		//fieldProperties['#typeid#'].jsValidator = '#prefix#doValidate';
		// handling the copy label function
		function #prefix#doLabel(str)
		{
			document.#formname#.#prefix#label.value = str;
		}
	/*	function #prefix#doValidate()
		{
			//set the default msgvalue
			document.#formname#.#prefix#msg.value = 'Please enter some text to be converted';
			if( document.#formname#.#prefix#foo.value.length == 0 )
			{
				alert('please Enter some data for foo');
				return false;
			}
			return true;
		}
	*/
	</script>
	<table>
		<tr valign="top">
			<td class="cs_dlgLabelSmall">Photo Field ID:</td>
			<td class="cs_dlgLabelSmall">
				<input type="text" id="#prefix#photoFieldID" name="#prefix#photoFieldID" value="#currentValues.photoFieldID#" size="50"><br />
				Custom element field ID for the Photo field.
			</td>
		</tr>
	</table>
</cfoutput>