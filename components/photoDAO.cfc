<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	photoDAO.cfc
Summary:
	Photo Gallery DAO Components
ADF App:
	pt_photo_gallery
Version:
	0.9.1
History:
	2009-08-04 - MFC - Created
--->
<cfcomponent displayname="PhotoDAO" extends="ADF.apps.pt_photo_gallery.components.App" hint="Photo Gallery DAO component for the Photo Gallery Application.">

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$photoCCAPI
Summary:
	Creates/Updates the Photo Element
Returns:
	Struct - CCAPI status
Arguments:
	Struct - dataValues - Data value struct to update the Photo element.
History:
	2009-07-07 - MFC - Created
--->
<cffunction name="photoCCAPI" access="public" returntype="Struct" hint="Creates/Updates the Photo Element">
	<cfargument name="dataValues" type="struct" required="true" hint="Data value struct to update the Photo element">
	
	<cfscript>
		var retStatusStruct = "failed";
		// Create the CS Content CFC
  		var csContent = server.ADF.objectFactory.getBean("CSContent_1_0");
//application.ADF.utils.doDump(arguments.dataValues,"arguments.dataValues", false);		
		// Create the page
 		retStatusStruct = csContent.populateContent("Photo", arguments.dataValues);
	</cfscript>
	<cfreturn retStatusStruct>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$imgGalleryUpload
Summary:
	Uploads a photo to the CS Image Gallery
Returns:
	Struct - CCAPI result
Arguments:
	String - imgDir - Photo directory path to upload.
History:
	2009-07-07 - MFC - Created
--->
<cffunction name="imgGalleryUpload" access="public" returntype="struct" hint="Uploads a photo to the CS Image Gallery">
	<cfargument name="imgDir" type="string" required="true" hint="Photo directory path to upload.">
	
	<cfscript>
		var pageResult = "";
		var dataStruct = StructNew();
		var binarydata = "";
	</cfscript>	
	<!--- // read in the contents of the image file --->
	<cffile action="READBINARY" file="#arguments.imgDir#" variable="binarydata">
	
	<cfscript>
		dataStruct.LocalFileName = "#arguments.imgDir#";
		dataStruct.public = "0";
		dataStruct.category = "Photo Gallery";
		// create the upload CFC
  		csUpload = server.ADF.objectFactory.getBean("CSUpload_1_0");
		// create the page
 		pageResult = csUpload.uploadImage(request.subsite.id, dataStruct, binarydata);
	</cfscript>
	<cfreturn pageResult>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$getDocPaths
Summary:
	Return the photo upload directory and URL path from the config file
Returns:
	Void
Arguments:
	Struct - configStruct - Config setting structure
History:
	2009-07-24 - MFC - Created
--->
<cffunction name="getDocPaths" access="public" returntype="struct" hint="">
	
	<cfscript>
		var configStruct = StructNew();
		configStruct.docPath = "#request.subsiteCache[1].dir#uploads/";
		configStruct.docURL = "#request.subsiteCache[1].url#uploads/";
		
		// Config - UPLOADPATH
		if ( (StructKeyExists(server.ADF.environment[request.site.id].ptPhotoGallery, "UPLOAD_PATH")) AND (LEN(server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_PATH)) )
			configStruct.docPath = server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_PATH;
		
		// Config - UPLOADURL
		if ( (StructKeyExists(server.ADF.environment[request.site.id].ptPhotoGallery, "UPLOAD_URL")) AND (LEN(server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_URL)) )
			configStruct.docURL = server.ADF.environment[request.site.id].ptPhotoGallery.UPLOAD_URL;
	</cfscript>
	<cfreturn configStruct>
</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$getCategories
Summary:
	Returns the CEData call to get all the Photo Category data.
Returns:
	ARGS
Arguments:
	ARGS
History:
	2009-12-15 - MFC - Created
--->
<cffunction name="getCategories" access="public" returntype="array" hint="">
	
	<cfreturn application.ptPhotoGallery.cedata.getCEData("Photo Category")>
	
</cffunction>

</cfcomponent>