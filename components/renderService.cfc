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
	PaperThin Inc.
	M. Carroll
Name:
	renderService.cfc
Summary:
	Render Service for the Photo Gallery
ADF App:
	PT_Photo_Gallery
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfcomponent displayname="renderService" extends="ADF.apps.pt_photo_gallery.components.App">

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$getPhotoURL
Summary:
	Given the standard photoURL this function will return another size.

	default image path will contain /originial/
	this function replaces with: /small/, /large/ etc...
Returns:
	String imageURL
Arguments:
	String originalURL
	String requestedSize
History:
	2009-06-10 - MFC - Created
--->
<cffunction name="getPhotoURL" access="public" returntype="String" hint="Given the standard photoURL this function will return another size.">
	<cfargument name="originalURL" type="string" required="true">
	<cfargument name="requestedSize" type="string" required="true">
	
	<cfset var imageURL = arguments.originalURL>
	<cfset imageURL = replace(imageURL, "/original/", "/#arguments.requestedSize#/")>
	<cfreturn imageURL>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$FUNCTIONNAME
Summary:
	SUMMARY
Returns:
	ARGS
Arguments:
	ARGS
History:
	2009-00-00 - MFC - Created
--->
<cffunction name="getPhotoRenderImgSrcArray" access="public" returntype="array" hint="">
	<cfargument name="photoDataArray" type="array" required="true" hint="">
	<cfargument name="sizeID" type="any" required="false" default="0" hint="">
	
	<cfscript>
		var photoSrcArray = ArrayNew(1);
		var catData = StructNew();
		var dirName = "";
		var tmp = "";
	</cfscript>
	
	<cfloop index="photo_i" from="1" to="#ArrayLen(arguments.photoDataArray)#">
		<!--- Check if a metadata size was selected, Get the photo's category data to see if it matches the  --->
		<cfscript>
			if ( sizeID GT 0 )
			{	
				// Get the category data for the photo
				catData = application.ptPhotoGallery.photoService.loadCategoryData(arguments.photoDataArray[photo_i].Values.category);
//application.ADF.utils.dodump(catData, "catData", false);
				dirName = "";
				// Check if the value in the INITIALSIZEARRAY
				if ( ArrayLen(catData.INITIALSIZEARRAY) ) {
					// Loop over the array
					for (cat_i = 1; cat_i LTE ArrayLen(catData.INITIALSIZEARRAY); cat_i = cat_i + 1){
						// Check if this is the category we want, then get the directory name
						if ( catData.INITIALSIZEARRAY[cat_i].Values.sizeID EQ arguments.sizeID )
						{	
							dirName = catData.INITIALSIZEARRAY[cat_i].Values.directory;
							break;
						}
					}
				}
				// Check if the value in the RESIZEDIMENSIONARRAY
				if ( ArrayLen(catData.RESIZEDIMENSIONARRAY) AND (LEN(dirName) LTE 0) ) {
					// Loop over the array
					for (cat_i = 1; cat_i LTE ArrayLen(catData.RESIZEDIMENSIONARRAY); cat_i = cat_i + 1){
						// Check if this is the category we want, then get the directory name
						if ( catData.RESIZEDIMENSIONARRAY[cat_i].Values.sizeID EQ arguments.sizeID )
						{	
							dirName = catData.RESIZEDIMENSIONARRAY[cat_i].Values.directory;
							break;
						}
					}
				}
//application.ADF.utils.dodump(dirName, "dirName", false);
				// if we found a matching size, then get the right size photo
				if ( LEN(dirName))
					tmp = arrayAppend(photoSrcArray, application.ptPhotoGallery.renderService.getPhotoURL(arguments.photoDataArray[photo_i].Values.photo, dirName));
			}
			else
				tmp = arrayAppend(photoSrcArray, arguments.photoDataArray[photo_i].Values.photo);
		</cfscript>
	</cfloop>
	<cfreturn photoSrcArray>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$buildFlashVars
Summary:
	Returns XML for the Banner Photos Flash RH
Returns:
	XML
Arguments:
	String - photoIDList - List of the photo uuid's
	Numeric - imageWidth
History:
	2009-07-28 - MFC - Created
--->
<cffunction name="buildFlashVars" access="remote" returntype="xml" returnformat="plain" hint="">
	<cfargument name="photoIDList" type="string" required="true" hint="">
	<cfargument name="imgWidth" type="numeric" required="false" default="100" hint="">
	<cfargument name="imgHeight" type="numeric" required="false" default="100" hint="">
	
	<cfscript>
		var xmlVars = "";
		var i = 1;
		// Get the data from CEData
		if( ListLen(arguments.photoIDList) )
			photoDataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", arguments.photoIDList, "selected");
		// Build out the XML
		xmlVars = XmlNew();
		xmlVars.xmlRoot = XmlElemNew(xmlVars,"gallery");
		xmlVars.gallery.XmlChildren[1] = XmlElemNew(xmlVars,"globals");
		xmlVars.gallery.XmlChildren[1].XmlAttributes.currentitem="0";
		xmlVars.gallery.XmlChildren[1].XmlAttributes.timer="5";
		xmlVars.gallery.XmlChildren[1].XmlAttributes.radius="6";
		xmlVars.gallery.XmlChildren[1].XmlAttributes.imagewidth= arguments.imgWidth;
		xmlVars.gallery.XmlChildren[1].XmlAttributes.imageheight= arguments.imgHeight;
	   	for (i = 1; i LTE arraylen(photoDataArray); i = i + 1)
	    {
			xmlVars.gallery.XmlChildren[i+1] = XmlElemNew(xmlVars,"item");
			xmlVars.gallery.item[i].XmlChildren[1] = XmlElemNew(xmlVars,"name");
			xmlVars.gallery.item[i].XmlChildren[1].XmlText = photoDataArray[i].values.title;
			xmlVars.gallery.item[i].XmlChildren[2] = XmlElemNew(xmlVars,"description");
			xmlVars.gallery.item[i].XmlChildren[2].XmlText = photoDataArray[i].values.caption;
			xmlVars.gallery.item[i].XmlChildren[3] = XmlElemNew(xmlVars,"title");
			xmlVars.gallery.item[i].XmlChildren[3].XmlText = photoDataArray[i].values.title;
			xmlVars.gallery.item[i].XmlChildren[4] = XmlElemNew(xmlVars,"content");
			xmlVars.gallery.item[i].XmlChildren[4].XmlText = photoDataArray[i].values.abstract;
			xmlVars.gallery.item[i].XmlChildren[5] = XmlElemNew(xmlVars,"image");
			xmlVars.gallery.item[i].XmlChildren[5].XmlText = photoDataArray[i].values.photo;
			xmlVars.gallery.item[i].XmlChildren[6] = XmlElemNew(xmlVars,"url");
			xmlVars.gallery.item[i].XmlChildren[6].XmlText = "";
			xmlVars.gallery.item[i].XmlChildren[7] = XmlElemNew(xmlVars,"target");
			xmlVars.gallery.item[i].XmlChildren[7].XmlText = "";
		}
	</cfscript>
	<cfreturn xmlVars>
</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$processRHMetadata
Summary:
	Returns the directory names for the Photo Render Size metadata form.
Returns:
	Struct
		rhData.detailSize
		rhData.photoSizeSelect
Arguments:
	Struct - metadataForm - Metadata form data
History:
	2010-04-01 - MFC - Created
--->
<cffunction name="processRHMetadata" access="public" returntype="struct" output="false" hint="Returns the directory names for the Photo Render Size metadata form.">
	<cfargument name="metadataForm" type="struct" required="true" hint="Metadata form data">
	
	<cfscript>
		var rhData = StructNew();
		var sizeData = ArrayNew(1);
		
		rhData.detailSize = StructNew();
		rhData.photoSizeSelect = StructNew();
		
		if ( StructKeyExists(arguments.metadataForm, "PhotoRenderSize") ){
			// Get the detail size path
			if ( StructKeyExists(arguments.metadataForm.PhotoRenderSize, "detailSize") AND LEN(arguments.metadataForm.PhotoRenderSize.detailSize) ){
				sizeData = application.ptPhotoGallery.ceData.getCEData("Photo Size", "sizeid", arguments.metadataForm.PhotoRenderSize.detailSize);
				if ( ArrayLen(sizeData) )
					rhData.detailSize = sizeData[1].values;
			}
			
			// Get the photo size path
			if ( StructKeyExists(arguments.metadataForm.PhotoRenderSize, "photoSizeSelect") AND LEN(arguments.metadataForm.PhotoRenderSize.photoSizeSelect) ){
				sizeData = ArrayNew(1);
				sizeData = application.ptPhotoGallery.ceData.getCEData("Photo Size", "sizeid", arguments.metadataForm.PhotoRenderSize.photoSizeSelect);
				if ( ArrayLen(sizeData) )
					rhData.photoSizeSelect = sizeData[1].values;
			}
		}
	</cfscript>
	<cfreturn rhData>
</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$loadCycleScript
Summary:
	Loads the Photo Gallery Cycle RH scripts
Returns:
	ARGS
Arguments:
	ARGS
History:
	2010-04-01 - MFC - Created
--->
<cffunction name="loadCycleScript" access="public" returntype="void" hint="Loads the Photo Gallery Cycle RH scripts">
	
	<cfscript>
		application.ptPhotoGallery.scripts.loadJQuery();
		application.ptPhotoGallery.scripts.loadJCycle();
		application.ptPhotoGallery.scripts.loadDropCurves();
	</cfscript>
	<cfoutput>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			jQuery('##cycle').cycle({
				fx:         'fade',
				timeout:     3000,
				pager:      '##cycle_nav',
				//pagerEvent: 'mouseover',
				fastOnEvent: true,
				before:      onBefore  // transition callback (scope set to element that was shown):  function(currSlideElement, nextSlideElement, options, forwardFlag) 
			});
		});
		
		// Render the titles for the images
		//	2009-12-05 MFC
		function onBefore(curr, next, opts){
			// Get the ID for the current photo
			// Get the ID number after the ":", and build the jquery statement
			var idFld = jQuery(next).attr("id");
			var currNum = idFld.slice(idFld.indexOf(":") + 1, idFld.length);
			var pIDTag = "div.cycle_title div##" + currNum;
			
			// Hide all the titles
			jQuery(".carouselOverlay").hide();
			//console.log(currNum);
			
			// Show this p tag id
			jQuery(pIDTag).show();
		}
	</script>
	</cfoutput>

</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$loadCycleThumbNavScript
Summary:
	Loads the Photo Gallery Cycle RH scripts
Returns:
	ARGS
Arguments:
	ARGS
History:
	2010-04-01 - MFC - Created
--->
<cffunction name="loadCycleThumbNavScript" access="public" returntype="void" hint="Loads the Photo Gallery Cycle RH scripts">
	
	<cfscript>
		application.ptPhotoGallery.scripts.loadJQuery();
		application.ptPhotoGallery.scripts.loadJCycle();
		application.ptPhotoGallery.scripts.loadDropCurves();
	</cfscript>
	<cfoutput>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			jQuery('##cycle').cycle({ 
				fx:     'fade', 
				//speed:  'fast', 
				timeout: 0, 
				pager:  '##cycle_nav', 
				pagerAnchorBuilder: function(idx, slide) { 
					// return selector string for existing anchor 
					return '##cycle_nav li:eq(' + idx + ') a'; 
				} 
			});
		});
	</script>
	</cfoutput>

</cffunction>

</cfcomponent>