<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	photoCategoryGC.cfc
Summary:
	Photo Category General Chooser
ADF App:
	pt_photo_gallery
Version:
	0.9.1
History:
	2009-08-04 - MFC - Created
--->
<cfcomponent displayname="photoGC" extends="ADF.extensions.customfields.general_chooser.general_chooser">

<cfscript>
	// CUSTOM ELEMENT INFO
	variables.CUSTOM_ELEMENT = "Photo";
	variables.CE_FIELD = "photoID";
	variables.SEARCH_FIELDS = "title,caption,abstract";
	variables.ORDER_FIELD = "title";
	
	// Layout Flags
	variables.SHOW_SECTION1 = true;  // Boolean
	variables.SHOW_SECTION2 = true;  // Boolean
	
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
	variables.SHOW_ALL_LINK = true;  // Boolean
	variables.ADD_NEW_FLAG = true;	// Boolean
	//variables.ADD_NEW_URL = "";
	variables.ADD_NEW_LB_WIDTH = 500;
	variables.ADD_NEW_LB_HEIGHT = 400; 
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
--->
<cffunction name="loadAddNewLink" access="private" returntype="string" hint="General Chooser - Add New Link HTML content.">
	
	<cfset var retAddLinkHTML = "">
	
	<!--- Check if we want to display show all link --->
	<cfif variables.ADD_NEW_FLAG EQ true>
		<cfset appConfig = application.ptPhotoGallery.getAppConfig()>
		
		<!--- Check that the server.ADF.envir vars are set and use them here --->
		<cfif (application.ptPhotoGallery.photoService.verifyAppEnvirConfig()) 
				AND (StructKeyExists(appConfig, "ADD_URL")) 
				AND (LEN(appConfig.ADD_URL))
				AND (StructKeyExists(appConfig, "CE_FORM_ID")) 
				AND (LEN(appConfig.CE_FORM_ID))>
			<!--- Set the form ID for the custom element --->
			<cfset ceFormID = appConfig.CE_FORM_ID>
			<!--- Render out the show all link to the field type --->
			<cfsavecontent variable="retAddLinkHTML">
				<cfoutput>
					<cfscript>
						// Load the ADF lightbox
						application.ptPhotoGallery.scripts.loadJQuery();
						application.ptPhotoGallery.scripts.loadADFLightbox();
					</cfscript>
					<div id="add-new-items">
						<a href="javascript:;" rel="#appConfig.ADD_URL#?formid=#ceFormID#&width=#variables.ADD_NEW_LB_WIDTH#&height=#variables.ADD_NEW_LB_HEIGHT#&lbaction=norefresh" title="Add New Photo" class="ADFLightbox">Add New Photo</a>
					</div>
				</cfoutput>
			</cfsavecontent>
		<cfelse>
			<cfthrow type="Application" detail="PT Photo Gallery config file missing ADDURL and/or CE_FORM_ID tag." message="Error with the PT_Photo_Gallery config file.">
		</cfif>
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
<cffunction name="loadSearchBox" access="private" returntype="string" hint="General Chooser - Search box HTML content.">
	<cfargument name="fieldName" type="String" required="true">
	
	<cfset var retSearchBoxHTML = "">
	<cfset var catDataArray = "">
	<cfset var cat_i = 1>
	
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
		<div>
			<!--- Render a select for the Event filter --->
			<cfset catDataArray = application.ptPhotoGallery.cedata.getCEData("Photo Category")>
			Category Filter: 
			<select id="#fieldName#_categorySelect" name="#fieldName#_categorySelect">
				<option value="" selected>All Categories
				<cfloop index="cat_i" from="1" to="#ArrayLen(catDataArray)#">
					<option value="#catDataArray[cat_i].Values.categoryID#">#catDataArray[cat_i].Values.title#
				</cfloop>
			</select>
			<br /><br />
		</div>
		<div id="search-chooser">
			<input type="text" class="searchFld-chooser" id="#arguments.fieldName#-searchFld" name="search-box" tabindex="1" onblur="this.value = this.value || this.defaultValue;" onfocus="this.value='';" value="Search" />
			<input type="button" id="#arguments.fieldName#-searchBtn" value="Search" style="width:60px;"> 
		</div>
		</cfoutput>
	</cfsavecontent>
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