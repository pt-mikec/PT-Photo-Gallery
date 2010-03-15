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
	variables.SHOW_ALL_LINK = false;  // Boolean
</cfscript>
 
</cfcomponent>