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
Author: 	PaperThin Inc.
			M. Carroll
Name:
	App.cfc
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-08-04 - MFC - Created
	2010-04-09 - MFC - Updated the getAppConfig function.
	2010-09-29 - MFC - Updated the getAppConfig function to build the UPLOAD_PATH variable.
--->
<cfcomponent name="AppBase" extends="ADF.core.AppBase">

<cffunction name="getAppBeanName" access="public" returntype="string">
	<cfreturn "ptPhotoGallery">
</cffunction>

<cffunction name="getAppConfig" access="public" returntype="struct">
	<cfset var configStruct = server.ADF.environment[request.site.id][getAppBeanName()]>
	<cfset configStruct.CE_FORM_ID = getPhotoFormID()>
	<!--- Get the Upload URL and create the Upload Path --->
	<cfset configStruct.UPLOAD_PATH = REPLACE(ExpandPath(configStruct.UPLOAD_URL),"\","/","all")>
	<cfreturn configStruct>
</cffunction>

<cffunction name="getPhotoFormID" access="public" returntype="numeric">
	<cfreturn application.ptPhotoGallery.cedata.getFormIDByCEName("Photo")>
</cffunction>

<cffunction name="getPhotoCategoryFormID" access="public" returntype="numeric">
	<cfreturn application.ptPhotoGallery.cedata.getFormIDByCEName("Photo Category")>
</cffunction>

<cffunction name="getPhotoSizeFormID" access="public" returntype="numeric">
	<cfreturn application.ptPhotoGallery.cedata.getFormIDByCEName("Photo Size")>
</cffunction>

</cfcomponent>