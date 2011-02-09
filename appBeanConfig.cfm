<!---
/* ***************************************************************
/*
Author: 	PaperThin Inc.
			M. Carroll
Name:
	appBeanConfig.cfm
Description:
	Application Bean Config for the pt_photo_gallery application.
ADF App:
	pt_photo_gallery
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
</cfscript>