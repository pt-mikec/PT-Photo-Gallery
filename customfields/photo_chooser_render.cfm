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
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll 
Custom Field Type:
	photo_chooser_props.cfm
Name:
	photo_chooser_props.cfm
Summary:
	Photo Chooser field type.
ADF App
	PT Photo Gallery
Version:
	2.0.0
History:
	2009-10-16 - MFC - Created
	2010-08-19 - MFC - Updated the load JQuery and JQuery versions to use the global versioning.
	2010-11-09 - MFC - Changed the force params into the load scripts function calls.
	2011-03-31 - MFC - Updated with changes to the general chooser in ADF v1.5.
--->
<cfscript>
	// the fields current value
	currentValue = attributes.currentValues[fqFieldName];
	// the param structure which will hold all of the fields from the props dialog
	xparams = parameters[fieldQuery.inputID];
	
	// overwrite the field ID to be unique
	xParams.fieldID = #fqFieldName#;
	
	// Set the defaults
	if( StructKeyExists(xParams, "forceScripts") AND (xParams.forceScripts EQ "1") )
		xParams.forceScripts = true;
	else
		xParams.forceScripts = false;
	
	// find if we need to render the simple form field
	renderSimpleFormField = false;
	if ( (StructKeyExists(request, "simpleformexists")) AND (request.simpleformexists EQ 1) )
		renderSimpleFormField = true;
</cfscript>

<cfoutput>
	
	<cfscript>
		// Load the scripts
		application.ptPhotoGallery.scripts.loadJQuery(force=xParams.forceScripts);
		application.ptPhotoGallery.scripts.loadJQueryUI(force=xParams.forceScripts);
		application.ptPhotoGallery.scripts.loadADFLightbox();
		application.ptPhotoGallery.scripts.loadCFJS();
	
		// init Arg struct
		initArgs = StructNew();
		initArgs.fieldName = fqFieldName;
		initArgs.catIDFilter = xParams.defaultCatID;
		initArgs.renderCatFilter = xParams.renderCatFilter;
		
		// Build the argument structure to pass into the Run Command
		selectionsArg = StructNew();
		selectionsArg.item = currentValue;
		selectionsArg.queryType = "selected";
		selectionsArg.csPageID = request.page.id;
		selectionsArg.fieldID = xParams.fieldID;
		selectionsArg.catIDFilter = xParams.defaultCatID;
		selectionsArg.renderCatFilter = xParams.renderCatFilter;
	</cfscript>
	
	<script type="text/javascript">
		// javascript validation to make sure they have text to be converted
		#fqFieldName#=new Object();
		#fqFieldName#.id='#fqFieldName#';
		#fqFieldName#.tid=#rendertabindex#;
		
		var #xParams.fieldID#_ajaxProxyURL = "#application.ADF.ajaxProxy#";
		var #xParams.fieldID#currentValue = "#currentValue#";
		var #xParams.fieldID#searchValues = "";
		var #xParams.fieldID#queryType = "all";
		var #xParams.fieldID#catValue = "#xParams.defaultCatID#";
		
		jQuery(document).ready(function() {
			
			// Resize the window on the page load
			checkResizeWindow();
			
			// JQuery use the LIVE event b/c we are adding links/content dynamically		    
		    // click for show all not-selected items
		    jQuery('###fqFieldName#-showAllItems').live("click", function(event){
			  	#xParams.fieldID#catValue = jQuery("select###fqFieldName#_categorySelect").find(':selected').val();
			  	// Load all the not-selected options
			  	#xParams.fieldID#_loadTopics('notselected');
			});
		    
		    // JQuery use the LIVE event b/c we are adding links/content dynamically
		    jQuery('###fqFieldName#-searchBtn').live("click", function(event){
		  	//load the search field into currentItems
				#xParams.fieldID#searchValues = jQuery('input###fqFieldName#-searchFld').val();
				#xParams.fieldID#currentValue = jQuery('input###fqFieldName#').val();
				// Get the category filter
				#xParams.fieldID#catValue = jQuery("select###fqFieldName#_categorySelect").find(':selected').val();
				#xParams.fieldID#_loadTopics('search')
			});
			
			// Load the effects and lightbox - this is b/c we are auto loading the selections
			#xParams.fieldID#_loadEffects();
			// Re-init the ADF Lightbox
			initADFLB();
		});
		
		function #xParams.fieldID#_loadTopics(queryType) {
			// Put up the loading message
			if (queryType == "selected")
				jQuery("###xParams.fieldID#-sortable2").html("Loading ... <img src='/ADF/extensions/customfields/general_chooser/ajax-loader-arrows.gif'>");
			else
				jQuery("###xParams.fieldID#-sortable1").html("Loading ... <img src='/ADF/extensions/customfields/general_chooser/ajax-loader-arrows.gif'>");
			
			// load the initial list items based on the top terms from the chosen facet
			jQuery.get( #xParams.fieldID#_ajaxProxyURL,
			{ 	
				bean: '#xParams.chooserCFCName#',
				method: 'controller',
				chooserMethod: 'getSelections',
				item: #xParams.fieldID#currentValue,
				queryType: queryType,
				searchValues: #xParams.fieldID#searchValues,
				csPageID: '#request.page.id#',
				fieldID: '#xParams.fieldID#',
				catIDFilter: #xParams.fieldID#catValue
			},
			function(msg){
				if (queryType == "selected")
					jQuery("###xParams.fieldID#-sortable2").html(jQuery.trim(msg));
				else
					jQuery("###xParams.fieldID#-sortable1").html(jQuery.trim(msg));
					
				#xParams.fieldID#currentValue = "#currentValue#";
				#xParams.fieldID#_loadEffects();
				
				// Re-init the ADF Lightbox
				initADFLB();
			});
		}
		
		function #xParams.fieldID#_loadEffects() {
			jQuery("###xParams.fieldID#-sortable1, ###xParams.fieldID#-sortable2").sortable({
				connectWith: '.connectedSortable',
				stop: function(event, ui) { #xParams.fieldID#_serialize(); }
			}).disableSelection();
		}
		
		// serialize the selections
		function #xParams.fieldID#_serialize() {
			// get the serialized list
			var serialList = jQuery('###xParams.fieldID#-sortable2').sortable( 'toArray' );
			// Check if the serialList is Array
			if ( jQuery.isArray(serialList) ){
				serialList = jQuery.ArrayToList(serialList);
			}
			
			// load serial list into current values
			#xParams.fieldID#currentValue = serialList;
			// load current values into the form field
			jQuery("input###fqFieldName#").val(#xParams.fieldID#currentValue);
		}
		
		// Resize the window function
		function checkResizeWindow(){
			// Check if we are in a loader.cfm page
			if ( '#ListLast(cgi.SCRIPT_NAME,"/")#' == 'loader.cfm' ) {
				lbResizeWindow();
			}
		}
		
		function #xParams.fieldID#_formCallback(formData){
			// Reload the available selections
			#xParams.fieldID#_loadTopics("notselected");
			// Close the lightbox
			closeLB();
		}
	</script>
	<tr>
		<td class="cs_dlgLabelSmall" colspan="2">
			<div>
				#xparams.label#:
			</div>
			<div id="#xParams.fieldID#-gc-init-styles">
				<!--- Load the General Chooser Styles --->
				#application.ADF.utils.runCommand(beanName=xParams.chooserCFCName,
													methodName="loadStyles",
													args=initArgs)#
			</div>
			<div id="#xParams.fieldID#-gc-main-area">
				<div id="#xParams.fieldID#-gc-top-area">
					<!--- SECTION 1 - TOP LEFT --->
					<div id="#xParams.fieldID#-gc-section1">
						<!--- Load the Search Box --->
						#application.ADF.utils.runCommand(beanName=xParams.chooserCFCName,
															methodName="loadSearchBox",
															args=initArgs)#
					</div>									
					<!--- SECTION 2 - TOP RIGHT --->
					<div id="#xParams.fieldID#-gc-section2">
						<!--- Load the Add New Link --->
						#application.ADF.utils.runCommand(beanName=xParams.chooserCFCName,
															methodName="loadAddNewLink",
															args=initArgs)#
					</div>
				</div>
				<!--- SECTION 3 --->
				<div id="#xParams.fieldID#-gc-section3">
					<!--- Instructions --->
					<div id="#xParams.fieldID#-gc-top-area-instructions">
						Select the records you want to include in the selections by dragging 
							items into or out of the 'Available Items' list. Order the columns 
							within the datasheet by dragging items within the 'Selected Items' field.
					</div>
					<!--- Select Boxes --->
					<div id="#xParams.fieldID#-gc-select-left-box-label">
						<strong>Available Items</strong>
					</div>
					<div id="#xParams.fieldID#-gc-select-right-box-label">
						<strong>Selected Items</strong>
					</div>
					<div id="#xParams.fieldID#-gc-select-left-box">
						<ul id="#xParams.fieldID#-sortable1" class="connectedSortable">
							<!--- Auto load the available selections --->
							<cfscript>
								// Set the query type flag before running the command
								selectionsArg.queryType = "notselected";
							</cfscript>
							#application.ADF.utils.runCommand(beanName=xParams.chooserCFCName,
															methodName="getSelections",
															args=selectionsArg)#
						</ul>
					</div>
					
					<div id="#xParams.fieldID#-gc-select-right-box">
						<ul id="#xParams.fieldID#-sortable2" class="connectedSortable">
							<!--- Check if we have current values and load the selected data --->
							<cfif LEN(currentValue)>
								<cfscript>
									// Set the query type flag before running the command
									selectionsArg.queryType = "selected";
								</cfscript>
								#application.ADF.utils.runCommand(beanName=xParams.chooserCFCName,
																methodName="getSelections",
																args=selectionsArg)#
							</cfif>
						</ul>
					</div>
				</div>
			</div>	
			<input type="hidden" id="#fqFieldName#" name="#fqFieldName#" value="#currentValue#">
		</td>
	</tr>
	
	<!--- // include hidden field for simple form processing --->
	<cfif renderSimpleFormField>
		<input type="hidden" name="#fqFieldName#_FIELDNAME" id="#fqFieldName#_FIELDNAME" value="#ReplaceNoCase(xParams.fieldName, 'fic_','')#">
	</cfif>
</cfoutput>