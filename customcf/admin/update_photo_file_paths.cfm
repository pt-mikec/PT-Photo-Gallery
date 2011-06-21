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
	PaperThin Inc.
	M. Carroll
Name:
	update_photo_file_paths.cfm
Summary:
	Admin script to update the Photo CE records photo URL paths.
	This is used if the site URL is changed and global updates 
		are needed for the photo url paths.
	Follow the TODO steps to make the updates to work on your site.
ADF App:
	PT Photo Gallery
Version:
	1.0.0
History:
	2010-08-05 - MFC - Created
	2011-06-20 - MFC - Updated to remove the hard-coded variables.
--->
<!--- Get the data records.
		TODO: Update the FormID and FieldID from your site
 --->
<cftry>
<cfscript>
	// Set variables for the replace site name
	currentSitePath = "/intranet/";
	newSitePath = "/";
	
	// Get the photo form ID
	photoFormID = application.ptPhotoGallery.getPhotoFormID();
	photoUploadFieldID = application.ptPhotoGallery.ceData.findFileCEFieldID(ceName="Photo",fieldName="photo");
</cfscript>
<cfquery name="getData" datasource="#request.site.datasource#">
	select pageid, fieldValue 
	from data_fieldvalue 
	where formid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#photoFormID#"> 
	and fieldid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#photoUploadFieldID#"> 
	and versionState = 2
	order by pageid
</cfquery>
<cfdump var="#getData#" label="getData" expand="false">

<!--- Loop over the records --->
<cfloop query="getData">
	
	<!--- Update the fieldvalue field --->
	<!--- TODO: Update your logic for the IF condition --->
	<!--- <cfif ListFirst(getData.fieldvalue,"/") EQ "mysite"> --->
		
		<!--- TODO: Update the newPath variable --->
		<cfset newPath = Replace(getData.fieldvalue, "#currentSitePath#", "#newSitePath#")>
		<cfoutput><p><cfdump var="#newPath#"></p></cfoutput>
	
		<!--- Commented Out For Your Protection!! --->
		<!--- TODO: Update and Uncomment the query below --->
		<!--- <cfquery name="setData" datasource="#request.site.datasource#">
		  	UPDATE data_fieldvalue 
			SET fieldvalue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newPath#">
			<!--- SELECT *
			FROM data_fieldvalue --->
			where formid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#photoFormID#">  
			and fieldid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#photoUploadFieldID#"> 
			and versionState = 2
			and pageid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#getData.pageid#">
			and fieldvalue = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getData.fieldvalue#">
			<!--- order by pageid --->
		</cfquery> --->
		<!--- <cfdump var="#setData#"> --->
	<!---  </cfif> --->
</cfloop>

<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>

</cftry>