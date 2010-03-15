<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	App.cfc
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2009-08-04 - MFC - Created
--->
<cfcomponent name="AppBase" extends="ADF.core.AppBase">

<cffunction name="getAppBeanName" access="public" returntype="string">
	<cfreturn "ptPhotoGallery">
</cffunction>

<cffunction name="getAppConfig" access="public" returntype="struct">
	<cfset var configStruct = server.ADF.environment[request.site.id][getAppBeanName()]>

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