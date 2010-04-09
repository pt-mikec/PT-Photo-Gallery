<!---
/* *************************************************************** */
Author: 	PaperThin Inc.
			M. Carroll
Name:
	photoService.cfc
Summary:
	Photo Gallery Service Component
ADF App:
	pt_photo_gallery
Version:
	1.1.0
History:
	2009-08-04 - MFC - Created
	2010-04-09 - MFC - processPhotoResize
--->
<cfcomponent displayname="PhotoService" extends="ADF.apps.pt_photo_gallery.components.App" hint="Photo Gallery Services component for the Photo Gallery Application.">

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$loadCategoryData
Summary:
	Return structure of all size element data for the category ID.
Returns:
	Struct - Structures and strings for the size data for the category.
Arguments:
	String - categoryID - Category ID string to return the data.
History:
	2009-06-09 - MFC - Created
	2010-01-05 - MFC - Added the category Title and Directory values into the return structure.
--->
<cffunction name="loadCategoryData" access="public" returntype="struct" hint="Return structure of all size element data for the category ID.">
	<cfargument name="categoryID" type="string" required="true" hint="Category ID string to return the data.">
	<cfargument name="docPath" type="string" required="false" default="" hint="">
	<cfargument name="docURL" type="string" required="false" default="" hint="">
	
	<cfscript>
		var retStruct = StructNew();
		var initSize_i = 1;
		var reSize_i = 1;
		var categoryDataArray = ArrayNew(1);
		
		retStruct.photoDirList = ""; // Store all photo directories in a single list
		retStruct.initialSizeDirList = ""; // Store initial size directories in a single list
		retStruct.initialSizeArray = ArrayNew(1); 
		retStruct.resizeDimDirList = ""; // Store resize directories in a single list
		retStruct.resizeDimensionArray = ArrayNew(1); 
		retStruct.photoDirPath = "";
		retStruct.photoURLPath = "";
		retStruct.title = "";	// Title
		retStruct.directory = "";	// Directory
			
		// Get the category data
		categoryDataArray = application.ptPhotoGallery.cedata.getCEData("Photo_Category", "categoryID", arguments.categoryID, "selected");
		//application.ptPhotoGallery.utils.doDump(categoryDataArray,"categoryDataArray", false);
		if ( ArrayLen(categoryDataArray) )
		{
			// Set some data values into the return structure
			retStruct.title = categoryDataArray[1].Values.title;
			retStruct.directory = categoryDataArray[1].Values.directory;
			
			// Get the initial size requirements for the category
			retStruct.initialSizeArray = application.ptPhotoGallery.cedata.getCEData("Photo_Size", "sizeid", categoryDataArray[1].Values.reqSizeIDList, "selected");
			//application.ptPhotoGallery.utils.doDump(retStruct.initialSizeArray,"retStruct.initialSizeArray", false);			
			for (initSize_i = 1; initSize_i LTE arraylen(retStruct.initialSizeArray); initSize_i = initSize_i + 1) 
			{
				retStruct.initialSizeDirList = ListAppend(retStruct.initialSizeDirList,retStruct.initialSizeArray[initSize_i].Values.directory);
				retStruct.photoDirList = ListAppend(retStruct.photoDirList,retStruct.initialSizeArray[initSize_i].Values.directory);
			}
			// Check that we have a value for the resize dimensions
			if ( ListLen(categoryDataArray[1].Values.resizeSizeIDList) )
			{
				// Get the resize dimensions for the category
				retStruct.resizeDimensionArray = application.ptPhotoGallery.cedata.getCEData("Photo_Size", "sizeid", categoryDataArray[1].Values.resizeSizeIDList, "selected");
				//application.ptPhotoGallery.utils.doDump(retStruct.resizeDimensionArray,"retStruct.resizeDimensionArray", false);
				for (reSize_i = 1; reSize_i LTE arraylen(retStruct.resizeDimensionArray); reSize_i = reSize_i + 1)
				{
					retStruct.resizeDimDirList = ListAppend(retStruct.resizeDimDirList,retStruct.resizeDimensionArray[reSize_i].Values.directory);
					retStruct.photoDirList = ListAppend(retStruct.photoDirList,retStruct.resizeDimensionArray[reSize_i].Values.directory);
				}
			}
			
			// Set the photo directory path and URL
			retStruct.photoDirPath = "#arguments.docPath##retStruct.directory#/";
			retStruct.photoURLPath = "#arguments.docURL##retStruct.directory#/";
		}
	</cfscript>
	<cfreturn retStruct>
</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$processPhotoResize
Summary:
	Process the photo requirement and resizing process.
Returns:
	Struct - Fields contain any return info or error message.
Arguments:
	Struct - categoryData - Structure containing the category data for required and resize dimensions.
History:
	2009-06-09 - MFC - Created
	2009-09-30 - GAC - Added CSData CSFile function
	2010-04-01 - MFC - Added in resize processing for "_system_resize" size.
	2010-04-09 - MFC - Removed the "_resizework" directory for generating the resizes.
					 - Updated the variables to generate the "_system_resize" size when no resizes selected.
--->
<cffunction name="processPhotoResize" access="public" returntype="struct" hint="Process the photo requirement and resizing process.">
	<cfargument name="categoryData" type="struct" required="true" hint="Structure containing the category data for required and resize dimensions.">
	<cfargument name="tempPhotoDIR" type="string" required="true" hint="">
	
	<cfscript>
		var retDataStruct = StructNew();
		var photos_i = 1;
		var initSize_j = 1;
		var reSize_j = 1;
		var objImageInfo = StructNew();
		var filePath = "";
		var filename = "";
		var origDirPath = "";
		var origURLPath = "";
		var photoInitSizeMatch = false;
		var photoType = "";
		var fileOp = StructNew();
		var dirOp = StructNew();
		var resizeDirPath = ""; 
		var resizeTempFileName = "";
	</cfscript>
	
	<!--- // upload the document to a local file system --->
	<cftry>
		<!--- check if the directory exists or create --->
		<cfif not directoryExists(arguments.categoryData.photoDirPath)>
			<cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: arguments.categoryData.photoDirPath
						) />
		</cfif>
		<!--- ORIGINAL Folder --->	
		<cfif not directoryExists(arguments.categoryData.photoDirPath & "original/")>
			<cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: arguments.categoryData.photoDirPath & "original"
						) />
		</cfif>
		<!--- loop over all the directories uploading photos --->
		<cfloop index="photos_i" from="1" to="#ListLen(arguments.categoryData.photoDirList)#">
			<cfif not directoryExists("#arguments.categoryData.photoDirPath##ListGetAt(arguments.categoryData.photoDirList,photos_i)#/")>
				<cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: arguments.categoryData.photoDirPath & ListGetAt(arguments.categoryData.photoDirList,photos_i)
						) />
			</cfif>
		</cfloop>
		
		<!--- Move the file from the the temp directory --->
		<cfset filePath = movePhoto(arguments.tempPhotoDIR, "#arguments.categoryData.photoDirPath#original/")>
		<cfset fileName = ListLast(filePath, "/")>		
		
		<!--- // did the file get uploaded? --->
		<cfset origDirPath = "#arguments.categoryData.photoDirPath#original/#fileName#">
		<cfset origURLPath = "#arguments.categoryData.photoURLPath#original/#fileName#">
	
		<!--- Read in the image file. This will read in the binary --->
		<cfimage action="info" source="#origDirPath#" structName="objImageInfo">
		
		<!--- flag to know if the uploaded photo has a matching initial size --->
		<cfset photoInitSizeMatch = false>
		<!--- Loop over the Initial Size Requirements to find a match for the uploaded photo --->
		<cfloop index="initSize_j" from="1" to="#ArrayLen(arguments.categoryData.initialSizeArray)#">
			<!--- match the width and the height --->
			<cfif (objImageInfo.width eq arguments.categoryData.initialSizeArray[initSize_j].Values.width) AND
					(objImageInfo.height eq arguments.categoryData.initialSizeArray[initSize_j].Values.height)>
				<!--- store the image in the initial size directory  --->
				
				<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
							action: "copy",
							source: origDirPath,
							destination: "#arguments.categoryData.photoDirPath##arguments.categoryData.initialSizeArray[initSize_j].Values.directory#/#fileName#"
						) />
				
				<cfset resizeTempFileName = arguments.categoryData.initialSizeArray[initSize_j].Values.directory & "-#fileName#" />
				<cfset photoInitSizeMatch = true>
				<cfset photoType = arguments.categoryData.initialSizeArray[initSize_j].Values.type>
				<cfbreak> <!--- found the photo match, exit the loop --->
			</cfif>
		</cfloop>
		<!--- found a matching size, and do photo operations --->
		<cfif photoInitSizeMatch>
			
			<!--- Loop over the resize dimensions array --->
			<cfloop index="reSize_j" from="1" to="#arraylen(arguments.categoryData.resizeDimensionArray)#">
				<!--- check if this is the correct type that we are working with, or if empty --->
				<cfif (photoType eq "") OR (photoType eq arguments.categoryData.resizeDimensionArray[reSize_j].Values.type)>
					
					<cfset resizeDirName = arguments.categoryData.resizeDimensionArray[reSize_j].Values.directory>
					
					<!--- // Resize Image and store in the size directory --->						
					<cfimage action = "resize"
						width = "#arguments.categoryData.resizeDimensionArray[reSize_j].Values.width#"
						height = "#arguments.categoryData.resizeDimensionArray[reSize_j].Values.height#"
						source = "#origDirPath#"
						destination = "#arguments.categoryData.photoDirPath##resizeDirName#/#fileName#"
						overwrite="yes" />
				</cfif>
			</cfloop>
			
			
			<!--- Create the "_system_resize" size for datasheets and choosers --->
			<cfif not directoryExists("#arguments.categoryData.photoDirPath#_system_resize/")>
				<cfset dirOp = application.ptPhotoGallery.csdata.CSFile(
							action: "MkDir",
							directory: arguments.categoryData.photoDirPath & "_system_resize") />
			</cfif>
			<!--- // Resize Image and store in the size directory --->						
			<cfimage action = "resize"
				width = "50"
				height = "50"
				source = "#origDirPath#"
				destination = "#arguments.categoryData.photoDirPath#_system_resize/#fileName#"
				overwrite="yes" />	
			
			
			<!--- Photo operations success, pass the values back --->
			<cfscript>
				retDataStruct.error = false;
				retDataStruct.originalURLPath = origURLPath;
				retDataStruct.originalDirPath = origDirPath;
			</cfscript>
			
		<cfelse> <!--- no match found, alert the user of the initial size reqs --->
			<!--- Delete the uploaded image --->
			<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
									action: "delete",
									file: origDirPath
								) />
			<cfscript>
				retDataStruct.error = true;
				retDataStruct.errorMsg = "";
			</cfscript>
			<!--- message to the user --->
			<cfsavecontent variable="retDataStruct.errorMsg">
				<cfoutput>
					The uploaded photo does not meet any of the dimension requirements. <br /><br />
					Possible photo upload dimensions are the following:<br />
					<cfloop index="initSize_l" from="1" to="#arraylen(arguments.categoryData.initialSizeArray)#">
						&nbsp;&nbsp;&nbsp;#arguments.categoryData.initialSizeArray[initSize_l].Values.title# = #arguments.categoryData.initialSizeArray[initSize_l].Values.width# X #arguments.categoryData.initialSizeArray[initSize_l].Values.height#<br />
					</cfloop>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		<!--- Catch any errors with the processing --->
		<cfcatch>
			<cfscript>
				retDataStruct.error = true;
				retDataStruct.errorMsg = cfcatch.message;
			</cfscript>
			<!--- <cfsavecontent variable="retDataStruct.errorMsg">
				<cfdump var="#cfcatch#">
			</cfsavecontent> --->
			<cfset retDataStruct.errorMsg = cfcatch>
		</cfcatch>
	</cftry>
	<cfreturn retDataStruct>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$verifyPhotoExists
Summary:
	Verify the uploaded file exists on the server.
Returns:
	Boolean - T/F for the status of the file exists.
Arguments:
	Structure - inArgs - Argument structure passed from the Ajax Service.
History:
	2009-06-10 - MFC - Created
--->
<cffunction name="verifyPhotoExists" access="public" returntype="boolean" hint="Verify the uploaded file exists on the server.">
	<cfargument name="inArgs" type="struct" required="true" hint="Argument structure passed from the Ajax Service.">

	<cfscript>
		// check if the file exists 
		if ( FileExists(expandpath(arguments.inArgs.inFile)) )
			return true;
		else
			return false;
	</cfscript>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$deletePhoto
Summary:
	Delete the uploaded photo file and all categories related to it.
Returns:
	Boolean - T/F for the status of the file deletion.
Arguments:
	Structure - inArgs - Argument structure passed from the Ajax Service.
History:
	2009-06-10 - MFC - Created
	2009-09-30 - GAC - Added CSData CSFile function 
--->
<cffunction name="deletePhoto" access="public" returntype="boolean" hint="Delete the uploaded photo file and all categories related to it.">
	<cfargument name="inArgs" type="struct" required="true" hint="Argument structure passed from the Ajax Service.">
	
	<cfset var retStatus = true>
	<cfset var filePath = "">
	<cfset var categoryData = "">
	<cfset var dirList = "">
	<cfset var deleteData = StructNew()>
	<cfset var fileOp = StructNew()>
	<cftry>
		<!--- Get the category data for the fields --->
		<cfset categoryData = loadCategoryData(arguments.inArgs.categoryID)>	
		<cfset dirList = categoryData.photoDirList>
		<!--- Check if the ORIGINAL exists and delete --->
		<cfif FileExists(expandpath(arguments.inArgs.inFile))>
			<!--- delete the file from the server --->
			<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
								action: "delete",
								file: expandpath(arguments.inArgs.inFile)
							) />
			<!--- <cffile action="delete" file="#expandpath(arguments.inArgs.inFile)#"> --->
		</cfif>
		<!--- Loop over the directory lists to delete the files --->
		<cfloop index="delete_i" from="1" to="#ListLen(dirList)#">
			<cfset filePath = Replace(arguments.inArgs.inFile,'original',ListGetAt(dirList,delete_i))>
			<!--- Verify the file exists --->
			<cfif FileExists(expandpath(filePath))>
				<!--- delete the file from the server --->
				<cfset fileOp = application.ptPhotoGallery.csdata.CSFile(
									action: "delete",
									file: expandpath(filePath)
								) />
				<!--- <cffile action="delete"	file="#expandpath(filePath)#"> --->
			</cfif>
		</cfloop>
		<!--- Delete the Image Gallery Page ID --->
		<!--- <cfif arguments.inArgs.imgGalPageID GT 0>
			<cfscript>
				// Get the subsiteID for the page ID
				deleteData.subsiteid = application.ptPhotoGallery.csdata.getSubsiteIDByPageID(arguments.inArgs.imgGalPageID);
				deleteData.pageid = arguments.inArgs.imgGalPageID;
				// Create the Page CFC
		  		csPage = server.ADF.objectFactory.getBean("CSPage_1_0");
				// Create the page
		 		csPage.deletePage(deleteData);
		 		// Delete the page from the Image Gallery
		 		inactivateImageGalleryPageID(arguments.inArgs.imgGalPageID);
			</cfscript>
		</cfif> --->
		<cfcatch>
			<cfset retStatus = false>
		</cfcatch>
	</cftry>
	<cfreturn retStatus>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$inactivateImageGalleryPageID
Summary:
	
Returns:
	
Arguments:
	
History:
	2009-06-10 - MFC - Created
--->
<cffunction name="inactivateImageGalleryPageID" access="private" returntype="void">
	<cfargument name="imgGalPageID" type="numeric" required="true">
	
	<cfquery name="inactivatePageID" datasource="#request.site.datasource#">
		UPDATE ImageGallery
		SET VersionState = 1,
			[Action] = 2
		WHERE pageid = #arguments.imgGalPageID#
	</cfquery>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$handlePhotoUpdate
Summary:
	Updates the Photo element with the structure data values.
	
	Pass in the PhotoID in the structure to update an element.
Returns:
	Struct - CCAPI Status
Arguments:
	Structure - dataVals - Data values structure to update the element
History:
	2009-07-07 - MFC - Created
--->
<cffunction name="handlePhotoUpdate" access="public" returntype="Struct" hint="Updates the Photo element with the structure data values.">
	<cfargument name="dataStruct" type="struct" required="true">
	
	<cfscript>
		var retStatus = StructNew();
		
		// Check that we have a value to update
		if ( arguments.dataStruct.pageid GT 0 ){
			// Update the datapageid to do an update
			dataStruct.values.dataPageID = arguments.dataStruct.pageid;
			// Pass the struct to the DAO
			retStatus = application.ptPhotoGallery.photoDAO.photoCCAPI(arguments.dataStruct.values);
		}
	</cfscript>
	<cfreturn retStatus>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$movePhoto
Summary:
	Moves the parameter files from a source to a destination directory.
	Creates a unique name for the file in the destination directory to avoid 
		overwriting files.
Returns:
	String - Return file name
Arguments:
	String - srcFile - Source file path
	String - destFile - Destination file path
History:
	2009-07-24 - MFC - Created
	2009-09-30 - GAC - Added CSData CSFile function
	2009-11-17 - SFS - Changed file separator from Windows-only '\' to '/' and added code to convert any passed in separators to universal '/' 
--->
<cffunction name="movePhoto" access="public" returntype="string" hint="Moves the parameter files from a source to a destination directory with a unique file name.">
	<cfargument name="srcFile" type="string" required="true" hint="Source file path">
	<cfargument name="destFile" type="string" required="true" hint="Destination file path">
	
	<cfscript>
		var retPath = "";
		var currPath = replace(arguments.destFile,"\","/","all") & ListLast(replace(arguments.srcFile,"\","/","all"), "/");
		var fileOp = StructNew();
	</cfscript>
	
	<cflock type="exclusive" timeout="30">	
		<!--- Get a unique file name ---> 
		<cfset retFileName = application.ptPhotoGallery.utils.createUniqueFileName(currPath)>
		<!--- move the file with the new filename --->
		<cfset fileOp = application.ptPhotoGallery.csdata.CSFile( 
							action: "move",
							source: arguments.srcFile,
							destination: retFileName
						) />
		<!--- <cffile action="move" 
				source="#arguments.srcFile#"
				destination="#retFileName#"> --->
	</cflock>
	<cfreturn retFileName>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$handlePhotoFormSubmit
Summary:
	Handles the photo form submit and processes the actions.  
Returns:
	Struct - 
Arguments:
	Struct - formVals - Form values structure.
History:
	2009-07-24 - MFC - Created
--->
<cffunction name="handlePhotoFormSubmit" access="public" returntype="struct" hint="Handles the photo form submit and processes the actions.">
	<cfargument name="formVals" type="struct" required="true" hint="Form values structure.">
	
	<cfscript>	
		var formFieldVals = StructNew();
		var tempPhotoDir = "";
		var catData = StructNew();
		var resizePhoto = "";
		var imgGalleryStatus = StructNew();
		var pageIDResult = StructNew();
		
		// Extract the fields from the simple form
		formFieldVals = application.ptPhotoGallery.forms.extractFromSimpleForm(arguments.formVals, "photoID");
		// Get the CE record for the Photo UUID
		dataArray = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", formFieldVals.photoID);
		// Process the photo
		pageIDResult = processPhoto(dataArray[1].pageid, dataArray[1].formid);
	</cfscript>
	<cfreturn pageIDResult>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$processPhoto
Summary:
	SUMMARY
Returns:
	ARGS
Arguments:
	ARGS
History:
	2009-00-00 - MFC - Created
--->
<cffunction name="processPhoto" access="public" returntype="struct" hint="">
	<cfargument name="datapageid" type="numeric" required="true" hint="CE data page id">
	<cfargument name="formid" type="numeric" required="true" hint="CE form id">

	<cfscript>
		var pageIDResult = StructNew();
		var dataStruct = StructNew();
		var configData = application.ptPhotoGallery.photoDAO.getDocPaths();
		var tempPhotoDir = "";
		var catData = StructNew();
		var resizePhoto = "";
		var imgGalleryStatus = StructNew();
		
		// CE Data to get the values for the element record
		dataStruct = application.ptPhotoGallery.cedata.getElementInfoByPageID(arguments.datapageid, arguments.formid);

		// Check if the photo has a value and is in the "temp" directory
		if ( ( StructKeyExists(dataStruct.values, "photo") AND ( LEN(dataStruct.values.photo) ) ) 
				AND ( ListFindNoCase(dataStruct.values.photo, "temp", "/" ) ) )
		{
			// Get the uploads directory path
			tempPhotoDir = ExpandPath(dataStruct.values.photo);
			// Get the category data structure
			catData = loadCategoryData(dataStruct.values.category, configData.docPath, configData.docURL);
			// Process the image resizing
			resizePhoto = processPhotoResize(catData, tempPhotoDir);
	
			// Check if we have an errors with the resize
			if ( NOT resizePhoto.error )
			{
				// Check if we want to upload to the Image Gallery
				if ( StructKeyExists(dataStruct.values, "includeImageGallery") AND (dataStruct.values.includeImageGallery EQ 'yes') ){
					imgGalleryStatus = application.ptPhotoGallery.photoDAO.imgGalleryUpload(resizePhoto.originalDirPath);
					// Get the pageid value out
					if ( ListFirst(imgGalleryStatus.uploadResponse,":") EQ 'Success' )
						dataStruct.values.imgGalleryPageID = ListLast(imgGalleryStatus.uploadResponse,":");
				}		
				// Update the path to store for the photo
				dataStruct.values.photo = resizePhoto.originalURLPath;						
				// Update the Photo record with new data
				pageIDResult = handlePhotoUpdate(dataStruct);
			}
			else {
				// TODO - Log the error message
				pageIDResult.contentUpdated = false;
				pageIDResult.msg = resizePhoto.errorMsg;
			}
		}
		else
		{
			pageIDResult.contentUpdated = true;
			pageIDResult.msg = "No photo processing needed.";
		}
	</cfscript>
	<cfreturn pageIDResult>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$verifyAppEnvirConfig
Summary:
	Return boolean T/F for the Applications server.ADF.environment structure exists.
Returns:
	Boolean - T/F
Arguments:
	VOID
History:
	2009-07-27 - MFC - Created
--->
<cffunction name="verifyAppEnvirConfig" access="public" returntype="boolean" hint="">
	
	<cfscript>
		if ( (StructKeyExists(server.ADF.environment, request.site.id)) AND (StructKeyExists(server.ADF.environment[request.site.id], "ptPhotoGallery")) )
			return true;
		else
			return false;
	</cfscript>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$verifyUploadsFile
Summary:
	Returns a T/F status for the verify and delete operations of the file.
Returns:
	Boolean - T/F for the status of the file verification or deletion.
Arguments:
	String - inFile
	String - categoryID
	Boolean - deleteFile
History:
	2009-06-10 - MFC - Created
--->
<cffunction name="verifyUploadsFile" access="public" returntype="boolean" hint="Returns a T/F status for the verify and delete operations of the file.">
	<cfargument name="inFile" type="string" required="true">
	<cfargument name="categoryID" type="string" required="true">
	<cfargument name="deleteFile" type="boolean" required="false" default="false">
	<cfargument name="imgGalPageID" type="string" required="false" default="0">
	
	<!--- Run the verify photo exists --->
	<cfset var retValidate = application.ptPhotoGallery.photoService.verifyPhotoExists(arguments)>
	<!--- Check if we want to delete --->
	<cfif retValidate AND deleteFile>
		<cfset retValidate = application.ptPhotoGallery.photoService.deletePhoto(arguments)>
	</cfif>
	<cfreturn retValidate>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$handlePhotoEdit
Summary:
	Handle the photo edit from the photoEditForm function
Returns:
	String - hint
Arguments:
	String - datapageid - CE data page id
	String - formid - CE form id
History:
	2009-00-00 - MFC - Created
--->
<cffunction name="handlePhotoEdit" access="remote" returntype="string" returnformat="plain" hint="Handle the photo edit from the photoEditForm function">
	<cfargument name="datapageid" type="numeric" required="true" hint="CE data page id">
	<cfargument name="formid" type="numeric" required="true" hint="CE form id">
	
	<cfset var retHTML = "">
	<cfset var photoUpdateStatus = processPhoto(arguments.datapageid, arguments.formid)>

	<cfsavecontent variable="retHTML">
		
		<cfset application.ptPhotoGallery.scripts.loadADFLightbox()>
		<cfif photoUpdateStatus.contentUpdated>
			<cfoutput>
				<p align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					<strong>Photo Update Completed!<br /><br /></strong>
					<a href="##" onclick="window.parent.location.href = window.parent.location.href;">Click here to close and refresh.</a>
				</p>
			</cfoutput>
		<cfelse>
			<cfoutput>
				<p align="center" style="font-family:Verdana,Arial; font-size:10pt;">
					<strong>Photo Upload Error!</strong><br />
					<a href="##" onclick="window.parent.location.href = window.parent.location.href;">Click here to close and refresh.</a>
				</p>
			</cfoutput>
		</cfif>
	</cfsavecontent>
	<cfreturn retHTML>
</cffunction>

<!---
/* ***************************************************************
/*
Author: 	M. Carroll
Name:
	$getPhotoURLbyPhotoID
Summary:
	Returns the photo URL for the photo ID.
Returns:
	String - Photo URL
Arguments:
	String - Photo UUID
	String - size - Photo Size to return the path
History:
	2009-07-28 - MFC - Created
	2009-12-08 - MFC - Added the size argument and call to renderService.getPhotoURL
--->
<cffunction name="getPhotoURLbyPhotoID" access="remote" returntype="string" returnformat="plain" hint="">
	<cfargument name="photoID" type="string" required="true" hint="">
	<cfargument name="size" type="string" required="false" default="" hint="">
	
	<cfscript>
		var photoURL = "";
		var dataArray = application.ptPhotoGallery.cedata.getCEData("Photo","photoid",arguments.photoid);
		if ( ArrayLen(dataArray) )
		{
			photoURL = dataArray[1].values.photo;
			
			// Check if the size is defined
			if ( LEN(arguments.size) ) {
				photoURL = application.ptPhotoGallery.renderService.getPhotoURL(photoURL, arguments.size);
			}
		}
	</cfscript>
	<cfreturn photoURL>
</cffunction>

<!---
/* *************************************************************** */
Author: 	
	PaperThin, Inc.
	M. Carroll
Name:
	$deletePhotoUID
Summary:
	SUMMARY
Returns:
	ARGS
Arguments:
	ARGS
History:
	2009-12-15 - MFC - Created
	2010-03-05 - MFC - Updated the photo deleting order to CE record then file.
--->
<cffunction name="deletePhotoUID" access="public" returntype="boolean" hint="">
	<cfargument name="photoUID" type="string" required="true" hint="">
	
	<cfscript>
		// Get the cedata record
		var photoData = application.ptPhotoGallery.cedata.getCEData("Photo", "photoid", arguments.photoUID);
		var deleteArgs = StructNew();
		var delStatus = false;
		deleteArgs.categoryID = photoData[1].values.category;
		deleteArgs.inFile = photoData[1].values.photo;
		if ( StructKeyExists(photoData[1].values, "imgGalleryPageID") )
			deleteArgs.imgGalPageID = photoData[1].values.imgGalleryPageID;
		// Delete the custom element record
		delStatus = application.ptPhotoGallery.cedata.deleteCE(photoData[1].pageid);
		if ( delStatus ){
			// Then delete the file from the server
			return application.ptPhotoGallery.photoService.deletePhoto(deleteArgs);
		}
		else
			return delStatus;
	</cfscript>
</cffunction>

</cfcomponent>