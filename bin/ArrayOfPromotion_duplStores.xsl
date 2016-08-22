<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="ArrayOfPromotion_duplStores">
		<xsl:element name="ArrayOfPromotion_sortedStores">
			<xsl:for-each select="//Promotion">
				<xsl:sort select="HeaderRecord/Store"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
