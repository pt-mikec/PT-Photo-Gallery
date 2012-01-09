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
	appBeanConfig.cfm
Description:
	Application Bean Config for the pt_photo_gallery application.
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-06-09 - MFC - Created
	2010-12-13 - MFC - Updated AppBeanConfig to load scripts_1_5
	2011-01-25 - MFC - Updated to load scripts_1_1 and forms_1_1
--->
<cfscript>
	// App specific variables
	appBeanName = "ptPhotoGallery";
	// Get the com path for the current custom application
	appComPath = getComPathForCustomAppDir(GetCurrentTemplatePath());
	
	// Load the APP Base
	addSingleton("#appComPath#App", appBeanName);

	// Load the STARTER APP service component
	/* 
		addSingleton("#appComPath#MYCOMPONENT", "MYCOMPONENT");
		addConstructorDependency(appBeanName, "MYCOMPONENT");
	 */
	addSingleton("#appComPath#photoService", "photoService");
	addConstructorDependency(appBeanName, "photoService");
	addSingleton("#appComPath#renderService", "renderService");
	addConstructorDependency(appBeanName, "renderService");
	addSingleton("#appComPath#photoUploadService", "photoUploadService");
	addConstructorDependency(appBeanName, "photoUploadService");
	addSingleton("#appComPath#photoDAO", "photoDAO");
	addConstructorDependency(appBeanName, "photoDAO");
	addSingleton("#appComPath#photoSizeGC", "photoSizeGC");
	addConstructorDependency(appBeanName, "photoSizeGC");
	addSingleton("#appComPath#photoGC", "photoGC");
	addConstructorDependency(appBeanName, "photoGC");
	addTransient("#appComPath#photoForms", "photoForms");
	addConstructorDependency(appBeanName, "photoForms");
	
	
	// Dependecies from ADF Lib
	addConstructorDependency(appBeanName, "cedata_1_1", "cedata");
	addConstructorDependency(appBeanName, "csdata_1_1", "csdata");
	addConstructorDependency(appBeanName, "scripts_1_1", "scripts");
	addConstructorDependency(appBeanName, "utils_1_1", "utils");
	addConstructorDependency(appBeanName, "forms_1_1", "forms");
	addConstructorDependency(appBeanName, "ui_1_0", "ui");
</cfscript>