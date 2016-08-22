<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="ArrayOfPromotion_sortedStores">
		<xsl:element name="Messages">
			<xsl:text disable-output-escaping="yes">&lt;Message1&gt;</xsl:text>
			<xsl:for-each select="//Promotion">
				<xsl:if
					test="position = 1 or not(preceding-sibling::*[1]/HeaderRecord/Store = ./HeaderRecord/Store)">
					<xsl:if test="position = 1">
						<xsl:comment>
							First Store!
						</xsl:comment>
					</xsl:if>
					<xsl:if test="not(position = 1)">

						<xsl:comment>
							New Store!
						</xsl:comment>
					</xsl:if>

					<xsl:comment>
						Store
						<xsl:value-of select="./HeaderRecord/Store" />
					</xsl:comment>
					<xsl:text disable-output-escaping="yes">&lt;ArrayOfPromotion&gt;</xsl:text>
				</xsl:if>
				<xsl:copy-of select="." />
				<xsl:if
					test="not(following-sibling::*[1]/HeaderRecord/Store = ./HeaderRecord/Store)">
					<xsl:comment>
						Store Change!
					</xsl:comment>
					<xsl:text disable-output-escaping="yes">&lt;/ArrayOfPromotion&gt;</xsl:text>
				</xsl:if>
				<xsl:if test="position = last()">
					<xsl:comment>
						Last Store!
					</xsl:comment>
				</xsl:if>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">&lt;/Message1&gt;</xsl:text>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>