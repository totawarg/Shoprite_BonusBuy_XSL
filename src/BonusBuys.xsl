<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n0="http://sap.com/xi/SAPGlobal20/Global">
<xsl:include href="mapBonusBuy.xsl"/>
<xsl:include href="copyBonusBuyAndCreateGroups.xsl"/>

<xsl:include href="ArrayOfPromotion_duplStores.xsl"/>
<xsl:include href="ArrayOfPromotion_sortedStores.xsl"/>
	<!--
	Questions:
	- Which field can we use for store number?  Shaun - new field in HeaderRecord.
	- Do we need to generate all the groupX elements?  Shaun - no, if empty POS will ignore. Will test when done.
	  - Solution if required: Create a 5th mapping step (Message Mapping) to MapWithDefault(0) for the empty groups.
	
	-->
	<!-- First pass, generate main structure and item groups -->
	<xsl:template match="n0:RetailIncentiveERPStoreOfferReplicationBulkRequest_V1">
		<xsl:element name="ArrayOfPromotion_withStores">
			<xsl:for-each select="//RetailIncentiveERPStoreOfferReplicationRequestMessage_V1">
				<xsl:call-template name="mapBonusBuy"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!-- Second pass, duplicate bonus buy per ReceiverStore and map group assignments -->
	<xsl:template match="ArrayOfPromotion_withStores">
		<xsl:element name="ArrayOfPromotion_duplStores">
			<xsl:for-each select="//Promotion/ReceivingStore">
				<xsl:call-template name="copyBonusBuyAndCreateGroups"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<!-- Third pass, sort by Store -->
	<xsl:template match="ArrayOfPromotion_duplStores">
		<xsl:call-template name="ArrayOfPromotion_duplStores"/>
	</xsl:template>
	<!-- Fourth pass, split into Store files -->
	<xsl:template match="ArrayOfPromotion_sortedStores">
		<xsl:call-template name="ArrayOfPromotion_sortedStores"/>
	</xsl:template>
	<!-- Creating the main POS structure -->


	
</xsl:stylesheet>
