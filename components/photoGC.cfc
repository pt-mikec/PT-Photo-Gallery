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
	PaperThin Inc.
	M. Carroll
Name:
	photoCategoryGC.cfc
Summary:
	Photo Category General Chooser
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-08-04 - MFC - Created
	2011-02-08 - MFC - Updated for v2.0
--->
<cfcomponent displayname="photoGC" extends="ADF.extensions.customfields.general_chooser.general_chooser">

<cfscript>
	// CUSTOM ELEMENT INFO
	variables.CUSTOM_ELEMENT = "Photo";
	variables.CE_FIELD = "photoID";
	variables.SEARCH_FIELDS = "title,caption,abstract";
	variables.ORDER_FIELD = "title";
	
	// STYLES
	//variables.MAIN_WIDTH = 400;
	//variables.SECTION1_WIDTH = 270;
	//variables.SECTION2_WIDTH = 270;
	//variables.SECTION3_WIDTH = 580;
	//variables.SELECT_BOX_HEIGHT = 150;
	//variables.SELECT_BOX_WIDTH = 170;
	variables.SELECT_ITEM_HEIGHT = 53;
	//variables.SELECT_ITEM_WIDTH = 130;
	variables.SELECT_ITEM_CLASS = "ui-state-default";
	variables.JQUERY_UI_THEME = "start";
	
	// ADDITIONS
	variables.SHOW_SEARCH = true;  // Boolean
	variables.SHOW_ALL_LINK = true;  // Boolean
	variables.SHOW_ADD_LINK = true;  // Boolean
	variables.SHOW_EDIT_DELETE_LINKS = false;  // Boolean
</cfscript>

<!---
/* ***************************************************************
/*
Author: 	M Carroll
Name:
	$loadAddNewLink
Summary:
	General Chooser - Add New Link HTML content.
Returns:
	String html code
Arguments:
	None
History:
	2009-05-29 - MFC - Created
	2010-04-09 - MFC - Updated to use the getAppConfig function.
	2010-09-30 - MFC - Updated the add new link to use the Forms.
	2011-04-27 - MFC - Added category ID in the GC props to the ADD link.
--->
<cffunction name="loadAddNewLink" access="public" returntype="string" hint="General Chooser - Add New Link HTML content.">
	
	<cfset var retAddLinkHTML = "">
		
	<!--- Check if we want to display show all link --->
	<cfif variables.SHOW_ADD_LINK EQ true>
		<!--- Render out the show all link to the field type --->
		<cfsavecontent variable="retAddLinkHTML">
			<cfoutput>
				<div id="add-new-items">
					<a href="javascript:;" rel="#application.ADF.ajaxProxy#?bean=photoForms&method=photoAddEdit&lbaction=norefresh&callback=#arguments.fieldName#_formCallback&title=Add New Record&category=#arguments.CATIDFILTER#" class="ADFLightbox ui-state-default ui-corner-all #arguments.fieldName#-ui-buttons">Add New Item</a>
				</div>
			</cfoutput>
		</cfsavecontent>
	</cfif>
	<cfreturn retAddLinkHTML>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M Carroll
Name:
	$loadSearchBox
Summary:
	General Chooser - Search box HTML content.
	REQUIRED: 
		- Search button must have the ID field of: id="#arguments.fieldName#-searchBtn"
Returns:
	String html code
Arguments:
	String - fieldName - custom element unique fqFieldName
History:
	2009-10-16 - MFC - Created
--->
<cffunction name="loadSearchBox" access="public" returntype="string" hint="General Chooser - Search box HTML content.">
	<cfargument name="fieldName" type="String" required="true">
	
	<cfset var retSearchBoxHTML = "">
	<cfset var catDataArray = "">
	<cfset var cat_i = 1>
	
	<!--- Check the variable flags for rendering --->
	<cfif variables.SHOW_SEARCH EQ true>
		<!--- Render out the search box to the field type --->
		<cfsavecontent variable="retSearchBoxHTML">
			<cfoutput>
			<style>
				div###arguments.fieldName#-gc-top-area div##search-chooser {
					margin-bottom: 10px;
					border: none;
					width: 250px;
					height: 25px;
				}
				div###arguments.fieldName#-gc-main-area input {
					border-color: ##fff;
				}
			</style>
			<!--- Check if we want to render the category filter --->
			<cfif NOT arguments.renderCatFilter>
				<style>
					div.catFilterBlock {
						display: none;
					}
				</style>
			</cfif>
			<div class="catFilterBlock">
				<!--- Render a select for the Event filter --->
				<cfset catDataArray = application.ptPhotoGallery.cedata.getCEData("Photo Category")>
				Category Filter: 
				<select id="#fieldName#_categorySelect" name="#fieldName#_categorySelect">
					<option value="" selected>All Categories
					<cfloop index="cat_i" from="1" to="#ArrayLen(catDataArray)#">
						<option value="#catDataArray[cat_i].Values.categoryID#" <cfif arguments.catIDFilter EQ catDataArray[cat_i].Values.categoryID>selected="selected"</cfif>>#catDataArray[cat_i].Values.title#
					</cfloop>
				</select>
				<br /><br />
			</div>
			<div id="search-chooser">
				<input type="text" class="searchFld-chooser" id="#arguments.fieldName#-searchFld" name="search-box" tabindex="1" onblur="this.value = this.value || this.defaultValue;" onfocus="this.value='';" value="Search" />
				<input type="button" id="#arguments.fieldName#-searchBtn" value="Search" style="width:60px;"> 
			</div>
			</cfoutput>
			<cfif variables.SHOW_ALL_LINK EQ true>
				<!--- Render out the show all link to the field type --->
				<cfoutput>
					<div id="show-all-items">
						<a id="#arguments.fieldName#-showAllItems" href="javascript:;">Show All Items</a>
					</div>	
				</cfoutput>
			</cfif>
		</cfsavecontent>
	</cfif>
	<cfreturn retSearchBoxHTML>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M Carroll
Name:
	$getSelections
Summary:
	Wrapper to get the CE Data returned in HTML DIV Format.
	Returns the html code for the selections of the profile select custom element.
Returns:
	String html code
Arguments:
	Struct - inArgs - structure of arguments passed to AjaxService
History:
	2009-10-16 - MFC - Created
	2010-04-01 - MFC - Updated photo resize to return "_system_resize".
--->
<cffunction name="getSelections" access="public" returntype="string" hint="Returns the html code for the selections of the profile select custom element.">
	<cfargument name="item" type="string" required="false" default="">
	<cfargument name="queryType" type="string" required="false" default="selected">
	<cfargument name="searchValues" type="string" required="false" default="">
	<cfargument name="csPageID" type="numeric" required="false" default="">	
	<cfargument name="catIDFilter" type="string" required="false" default="">
		
	<cfscript>
		var retHTML = "";
		var i = 1;
		var ceDataArray = getChooserData(arguments.item, arguments.queryType, arguments.searchValues, arguments.csPageID);
		var renderRow = false;
	
		// Loop over the data 	
		for ( i=1; i LTE ArrayLen(ceDataArray); i=i+1) {
			renderRow = false;
			// Check if we have a length
			if ( LEN(ceDataArray[i].Values.title) ){
				// Check if we have an event filter and it matches
				if ( LEN(arguments.catIDFilter) ) {
					// Check the current rows category ID to the filter
					if ( ceDataArray[i].Values.category EQ arguments.catIDFilter )
						renderRow = true;
				}				
				else {
					renderRow = true;
				}
			}
			
			if ( renderRow ) {
				// determine if the user has a photo with the profile
				retHTMLImg = "";
				if ( ceDataArray[i].Values.photo neq "" ) {
					photoImgURL = application.ptPhotoGallery.renderService.getPhotoURL(ceDataArray[i].Values.photo, "_system_resize");
					retHTMLImg = "<img src='#photoImgURL#'>";
				}
				// Assemble the render HTML
				retHTML = retHTML & "<li id='#ceDataArray[i].Values.photoID#' class='#variables.SELECT_ITEM_CLASS#'><div class='itemCell'><div class='itemCellLeft'>#retHTMLImg#</div><div class='itemCellRight'>#LEFT(ceDataArray[i].Values.title,50)#</div></li>";
			}
		}
		
		// Check if we had any values
		if ( NOT LEN(retHTML) )
			retHTML = "No records to display.";
	</cfscript>
	<cfreturn retHTML>
</cffunction>

</cfcomponent>