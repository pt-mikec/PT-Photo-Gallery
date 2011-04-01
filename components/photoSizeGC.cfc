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
Author: 	PaperThin Inc.
			M. Carroll
Name:
	photoSizeGC.cfc
Summary:
	Photo Size General Chooser
ADF App:
	pt_photo_gallery
Version:
	0.9.0
History:
	2009-10-16 - MFC - Created
--->
<cfcomponent displayname="photoSizeGC" extends="ADF.extensions.customfields.general_chooser.general_chooser">

<cfscript>
	// CUSTOM ELEMENT INFO
	variables.CUSTOM_ELEMENT = "Photo_Size";
	variables.CE_FIELD = "sizeID";
	variables.SEARCH_FIELDS = "title,directory,type";
	variables.ORDER_FIELD = "title";
	
	// Layout Flags
	variables.SHOW_SECTION1 = false;  // Boolean
	variables.SHOW_SECTION2 = false;  // Boolean
	
	// STYLES
	variables.MAIN_WIDTH = 400;
	variables.SELECT_BOX_HEIGHT = 150;
	variables.SELECT_BOX_WIDTH = 170;
	variables.SELECT_ITEM_WIDTH = 130;
	variables.SELECT_ITEM_CLASS = "ui-state-default";
	variables.JQUERY_UI_THEME = "ui-lightness";
	
	// ADDITIONS
	variables.SHOW_SEARCH = false;  // Boolean
	variables.SHOW_ALL_LINK = false;  // Boolean
	variables.SHOW_ADD_LINK = false;  // Boolean
	variables.SHOW_EDIT_DELETE_LINKS = false;  // Boolean
</cfscript>
 
</cfcomponent>