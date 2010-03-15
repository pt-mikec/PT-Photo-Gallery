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


</cfcomponent>