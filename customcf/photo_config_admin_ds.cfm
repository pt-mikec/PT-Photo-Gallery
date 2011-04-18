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
	PaperThin, Inc.
	M Carroll
Name:
	$photo_config_dmin_ds.cfm
Summary:
	Photo Configuration Administrator Datasheet
ADF App:
	pt_photo_gallery
Version:
	2.0
History:
	2009-08-04 - MFC - Created
	2010-08-19 - MFC - Updated the load JQuery and JQuery versions to use the global versioning.
	2010-09-29 - MFC - Updated to load Forms_1_1 for Add link.
	2011-04-18 - MFC - Updated to load the App Config from the ADF Extensions.
--->

<cfset appName = "PTPhotoGallery">
<cfinclude template="/ADF/extensions/customcf/site_configuration_element/site_config_core.cfm">
