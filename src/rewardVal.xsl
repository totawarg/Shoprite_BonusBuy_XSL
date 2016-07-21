<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="rewardVal">
		<xsl:param name="rewardType"/>
		
		<!-- DISCOUNT AMOUNT -->
		<xsl:param name ="discountAmount">
			<xsl:choose>
				<xsl:when test="number(RetailIncentive/Offer/Get/DiscountAmount) > 0">
					<xsl:value-of select="RetailIncentive/Offer/Get/DiscountAmount"/>
				</xsl:when>
				<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/DiscountAmount)>0">
					<xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/DiscountAmount"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		
		<!-- DISCOUNT PERCENTAGE -->
		<xsl:param name="discountPercentage">
		<xsl:choose>
			<xsl:when test="number(RetailIncentive/Offer/Get/DiscountPercent)>0">
				<xsl:value-of select="RetailIncentive/Offer/Get/DiscountPercent"/>
			</xsl:when>
			<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/DiscountPercent)>0">
				<xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/DiscountPercent"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		</xsl:param>
		
		<!-- PRICE AMOUNT -->
		<xsl:param name="priceAmount">
			<xsl:choose>
				<xsl:when test="number(RetailIncentive/Offer/Get/PriceAmount) > 0">
					<xsl:value-of select="RetailIncentive/Offer/Get/PriceAmount"/>
				</xsl:when>
				<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/PriceAmount) > 0">
					<xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/PriceAmount"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
			
		</xsl:param>
		
		<!-- GrantedQuantityLowerBoundaryDecimalValue -->
		<xsl:variable name="GrantedQuantityLowerBoundaryDecimalValue" select="RetailIncentive/Offer/Get/ProductGroup/GrantedQuantityLowerBoundaryDecimalValue"/>
		
		<xsl:choose>
			<!-- DISCOUNT AMOUNT -->	
			<!-- Cash Off - Check Get then Get/ProductGroup. -->
			
			<xsl:when test="($rewardType = 1 and $discountAmount > 0) or ($rewardType = 26 and $discountAmount>0)">
				<xsl:value-of select="$discountAmount * 100"/>
			</xsl:when>
			
			<!-- DISCOUNT PERCENTAGE -->
			<!-- Percentage Off -->
			<xsl:when test="($rewardType = 2 or $rewardType = 13 or $rewardType=15) and  $discountPercentage > 0">
				<xsl:value-of select="$discountPercentage*1000"/>
			</xsl:when>
			<xsl:when test="($rewardType=26 or $rewardType=1) and $discountAmount>0">
				<xsl:value-of select="$discountAmount*100"/>
			</xsl:when>
			
			<xsl:when test="$rewardType=26 and ($discountPercentage=100 or $priceAmount=0)">0</xsl:when>  
			
			<!-- PRICE AMOUNT -->
			<xsl:when test="($rewardType = 8  or $rewardType = 21) and $priceAmount> 0">
				<xsl:value-of select="$priceAmount * 100"/>
			</xsl:when>
			
			<xsl:when test="$rewardType = 20">
				<xsl:value-of select="format-number(number($GrantedQuantityLowerBoundaryDecimalValue),'0')"/>
			</xsl:when>
			
			
			<!-- TODO:  Confirm if there is a requirement for a default of 0 or empty -->
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
