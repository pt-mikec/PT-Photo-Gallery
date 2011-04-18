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
	Michael Carroll 
Custom Field Type:
	photo_chooser_props.cfm
Name:
	general_chooser_props.cfm
Summary:
	Photo Chooser field type.
ADF App
	PT Photo Gallery
Version:
	2.0.0
History:
	2009-05-29 - MFC - Created
	2011-03-20 - MFC - Updated component to simplify the customizations process and performance.
						Removed Ajax loading process.
--->
<cfscript>
	// initialize some of the attributes variables
	typeid = attributes.typeid;
	prefix = attributes.prefix;
	formname = attributes.formname;
	currentValues = attributes.currentValues;
	
	// check the values for defaults
	if( not structKeyExists(currentValues, "chooserCFCName") )
		currentValues.chooserCFCName = "";
	if( not structKeyExists(currentValues, "forceScripts") )
		currentValues.forceScripts = "0";
	if( not structKeyExists(currentValues, "defaultCatID") )
		currentValues.defaultCatID = "";
	if( not structKeyExists(currentValues, "renderCatFilter") )
		currentValues.renderCatFilter = "1";
</cfscript>
<cfoutput>
	
	<script language="JavaScript" type="text/javascript">
		// register the fields with global props object
		fieldProperties['#typeid#'].paramFields = '#prefix#chooserCFCName,#prefix#forceScripts,#prefix#defaultCatID,#prefix#renderCatFilter';
		// allows this field to support the orange icon (copy down to label from field name)
		fieldProperties['#typeid#'].jsLabelUpdater = '#prefix#doLabel';
		// allows this field to have a common onSubmit Validator
		fieldProperties['#typeid#'].jsValidator = '#prefix#doValidate';
		// handling the copy label function
		function #prefix#doLabel(str)
		{
			document.#formname#.#prefix#label.value = str;
		}
		function #prefix#doValidate(){
			
			// Check the chooserCFCName
			if ( document.getElementById('#prefix#chooserCFCName').value.length <= 0 ) {
				alert("Please enter the Chooser CFC Name property field.");
				return false;
			}
			// Everything is OK, submit form
			return true;
		}
	</script>
	<table>
		<tr valign="top">
			<td class="cs_dlgLabelSmall">Chooser Bean Name:</td>
			<td class="cs_dlgLabelSmall">
				<input type="text" id="#prefix#chooserCFCName" name="#prefix#chooserCFCName" value="#currentValues.chooserCFCName#" size="50"><br />
				Name of the Object Factory Bean that will be rendering and populating the chooser data. (i.e. profileGC). Note: Do NOT include ".cfc" in the name.
			</td>
		</tr>
		<tr valign="top">
			<td class="cs_dlgLabelSmall">Default Category:</td>
			<td class="cs_dlgLabelSmall">
				<!--- Get the category selections --->
				<cfset photoCatData = application.ptPhotoGallery.photoDAO.getCategories()>
				<select id="#prefix#defaultCatID" name="#prefix#defaultCatID">
					<option value=""> - Select Category - </option>
					<cfloop index="cat_i" from="1" to="#arrayLen(photoCatData)#">
						<option value="#photoCatData[cat_i].values.categoryID#" <cfif currentValues.defaultCatID EQ photoCatData[cat_i].values.categoryID>selected="selected"</cfif>>#photoCatData[cat_i].values.title#</option>
					</cfloop>
				</select>
				<br />
				Select the photo category for the available photo selections.<br />
				If no category is selected, then 'Render Category Filter Option' will be forced enabled.
			</td>
		</tr>
		<tr valign="top">
			<td class="cs_dlgLabelSmall">Render Category Filter Option:</td>
			<td class="cs_dlgLabelSmall">
				<input type="radio" id="#prefix#renderCatFilter" name="#prefix#renderCatFilter" value="1" <cfif currentValues.renderCatFilter EQ 1>checked="checked"</cfif>>Enabled<br />
				<input type="radio" id="#prefix#renderCatFilter" name="#prefix#renderCatFilter" value="0" <cfif currentValues.renderCatFilter EQ 0>checked="checked"</cfif>>Disabled<br />
				Option to enable/disable the photo category filter selection.
			</td>
		</tr>
		<tr valign="top">
			<td class="cs_dlgLabelSmall">Force Loading Scripts:</td>
			<td class="cs_dlgLabelSmall">
				Yes <input type="radio" id="#prefix#forceScripts" name="#prefix#forceScripts" value="1" <cfif currentValues.forceScripts EQ "1">checked</cfif>>&nbsp;&nbsp;&nbsp;
				No <input type="radio" id="#prefix#forceScripts" name="#prefix#forceScripts" value="0" <cfif currentValues.forceScripts EQ "0">checked</cfif>><br />
				Force the JQuery, JQuery UI, and Thickbox scripts to load on the chooser loading.
			</td>
		</tr>
	</table>
</cfoutput>