<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="createItemGroup">
		<xsl:param name="productNodes"/>
		<xsl:param name="type"/>
		<xsl:param name="groupNumber"/>
		<xsl:param name="groupType"/>
		<xsl:param name="groupQuantity"/>
		<xsl:param name="applyReward"/>
		<xsl:param name="applyApportionments" select="0"/>
		<xsl:element name="ItemGroup">
			<xsl:element name="GroupType">
				<xsl:value-of select="$groupType"/>
			</xsl:element>
			<xsl:element name="GroupQuantity">
				<xsl:value-of select="$groupQuantity"/>
			</xsl:element>
			<xsl:element name="ApplyReward">
				<xsl:value-of select="$applyReward"/>
			</xsl:element>
			<xsl:element name="ApplyApportionments">
				<xsl:value-of select="$applyApportionments"/>
			</xsl:element>
			<xsl:if test="count($productNodes/StandardID) > 0">
				<xsl:for-each select="$productNodes">
					<xsl:element name="Item">
						<xsl:element name="Barcode">
							<xsl:value-of select="StandardID"/>
						</xsl:element>
						<xsl:element name="GroupLink">
							<xsl:value-of select="$type"/>
							<xsl:value-of select="$groupNumber"/>
						</xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:if>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
