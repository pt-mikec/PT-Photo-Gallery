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
	photo_directory_render.cfm
Summary:
	Custom field for the photo directory field related to the title field.
History:
	2011-02-08 - MFC - Created
--->
<cfscript>
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	
	if ( NOT StructKeyExists(xparams, "titleFldID") )
		xparams.titleFldID = "";	
	if ( NOT StructKeyExists(xparams, "fldID") )
		xparams.fldID = fqFieldName;
	if ( NOT StructKeyExists(xparams, "fldClass") )
		xparams.fldClass = "";
	if ( not structKeyExists(xparams, "fldSize") )
		xparams.fldSize = "40";
	
	// Load JQuery 
	application.ptPhotoGallery.scripts.loadJQuery();
	
	// Determine if we have a value to make the field editable
	if ( LEN(currentValue) OR currentValue != '' )
		allowFieldEdit = false;
	else
		allowFieldEdit = true;
</cfscript>
<cfoutput>
	<script>
		// javascript validation to make sure they have text to be converted
		#fqFieldName#=new Object();
		#fqFieldName#.id='#fqFieldName#';
		#fqFieldName#.tid=#rendertabindex#;
		#fqFieldName#.msg="Please select a value for the #xparams.label# field.";
		#fqFieldName#.validator = "validate_#fqFieldName#()";

		//If the field is required
		if ( '#xparams.req#' == 'Yes' ){
			// push on to validation array
			vobjects_#attributes.formname#.push(#fqFieldName#);
		}

		//Validation function
		function validate_#fqFieldName#(){
			if (jQuery("input[name=#fqFieldName#]").val() != ''){
				return true;
			}else{
				return false;
			}
		}
	</script>
	
	<cfif allowFieldEdit>
		<script>	
			// Load JQuery
			jQuery(document).ready(function() {
				// Bind an off focus event to the title field.
				jQuery("input###xparams.titleFldID#").focusout(function() {
					// Get the value for the title
					cleanedTitleText = cleanText(jQuery("input###xparams.titleFldID#").val())
					jQuery("input###xparams.fldID#").val(cleanedTitleText);
				});
				
				// Bind off focus this directory field also, just to clean the text
				jQuery("input###xparams.fldID#").focusout(function() {
					// Get the value for the title
					cleanedTitleText = cleanText(jQuery("input###xparams.fldID#").val())
					jQuery("input###xparams.fldID#").val(cleanedTitleText);
				});
			});
			
			// Remove all special characters
			function cleanText(inString){
				return inString.replace(/[^a-zA-Z0-9]+/g,'').toLowerCase();
			}
		</script>
	</cfif>
	
	<!---
	This version is using the wrapFieldHTML functionality, what this does is it takes
	the HTML that you want to put into the TD of the right section of the display, you
	can optionally disable this by adding the includeLabel = false (fourth parameter)
	when false it simply creates a TD and puts your content inside it. This wrapper handles
	everything from description to simple form field handling.
--->
	<cfsavecontent variable="inputHTML">
		<cfoutput>
			<cfif allowFieldEdit>
				<input type="text" name="#fqFieldName#" value="#currentValue#" id="#xparams.fldID#" size="#xparams.fldSize#"<cfif LEN(TRIM(xparams.fldClass))> class="#xparams.fldClass#"</cfif> tabindex="#rendertabindex#" <cfif readOnly>readonly="true"</cfif>>
			<cfelse>
				<font face="Verdana,Arial" color="##000000" size="2">
					#currentValue#
				</font>
			</cfif>
		</cfoutput>
	</cfsavecontent>
	#application.ADF.forms.wrapFieldHTML(inputHTML,fieldQuery,attributes)#
</cfoutput>