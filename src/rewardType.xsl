<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:n1="urn:sap.shoprite.co.za:retail:pp">
	<xsl:template name="rewardType">
		<!-- RetailIncentiveOfferDiscountTypeCode-->
		<xsl:param name="discountTypeCode">
			<xsl:choose>
				<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode =2 or RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode=2">2</xsl:when>
				<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode =3 or RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode=3">3</xsl:when>
				<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode =4 or RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode=4">4</xsl:when>
				<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode"><xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode"/></xsl:when>
				<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode"><xsl:value-of select="RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- Article Type -->
		<xsl:param name="articleType">
			<xsl:choose>
				<xsl:when test="count(RetailIncentive/Offer/Get/ProductGroup/Product[*[local-name() = 'ArticleType']='ZCOU'])>0">ZCOU</xsl:when>
				<xsl:when test="count(RetailIncentive/Offer/Get/ProductGroup/Product[*[local-name() = 'ArticleType']='ZBON'])>0>0">ZBON</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		
		<!-- DISCOUNT % -->
		<xsl:param name="discountPercentage">
			<xsl:choose>
				<xsl:when test="RetailIncentive/Offer/Get/DiscountPercent = 100.0 or RetailIncentive/Offer/Get/ProductGroup/DiscountPercent = 100.0">DP100</xsl:when>
				<!-- discount % not zero % -->
				<xsl:when test="RetailIncentive/Offer/Get/DiscountPercent>0 or RetailIncentive/Offer/Get/ProductGroup/DiscountPercent>0 ">DPGTZERO</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- PRICE AMOUNT -->
		<xsl:param name="priceAmount">
			<xsl:choose>
				<xsl:when test="RetailIncentive/Offer/Get/PriceAmount >0">GET</xsl:when>
				<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/PriceAmount >0">PG</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- DISCOUNT AMOUNT NOT ZERO -->
		<xsl:param name="discountAmount">
			<xsl:choose>
				<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/DiscountAmount=0">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- GET HAS PRODUCT GROUP -->
		<xsl:param name="getHasProductGroup">
			<xsl:choose>
				<xsl:when test="count(RetailIncentive/Offer/Get/ProductGroup) > 0">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!-- #########################################################REWARD TYPE ##############################################################################-->
		<!-- #rule11 -->
		<xsl:variable name="countDTC">
			<xsl:value-of select="count(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode)"/>
		</xsl:variable>
		<!-- #rule12 -->
		<xsl:variable name="countDTCmatchingFirst">
			<xsl:value-of select="count(RetailIncentive/Offer/Get/ProductGroup[RetailIncentiveOfferDiscountTypeCode=$discountTypeCode])"/>
		</xsl:variable>
				
		<xsl:choose>
		    <!-- #rule11 and #rule12 -->
			<!-- POS can only handle one RewardType, therefore all Get side Discount Type Codes should be the same. -->
			<xsl:when test="not($countDTC = $countDTCmatchingFirst)">99</xsl:when>

			<!--START  RetailIncentiveOfferDiscountTypeCode = 2-->
			<!-- S12V4  Buy Group at  Total  Price-->
			<!-- #rule1 -->
			<xsl:when test="$discountTypeCode=2 and $priceAmount='GET'">8</xsl:when>
			<!-- S8V4 Buy 1 at specific Price -->
			<!-- #rule2 -->
			<xsl:when test="$discountTypeCode=2  and $priceAmount='PG'">21</xsl:when>
			<!-- Cash Off - S12V3, S6V3: Buy products get cash off of Basket -->
			<!-- END RetailIncentiveOfferDiscountTypeCode = 2-->
			<!-- START RetailIncentiveOfferDiscountTypeCode = 3-->
			<!-- Cash Off - S7V3 Buy X and get Amount off of specific Products. -->
			<!-- #rule3 -->
			<xsl:when test="($discountTypeCode = 3 and $discountAmount) and $articleType='ZCOU'">26</xsl:when>
			<!--
			<-xsl:when test="(RetailIncentive/Offer/Get/RetailIncentiveOfferDiscountTypeCode = 3 and not(RetailIncentive/Offer/Get/DiscountAmount = 0)) and RetailIncentive/Offer/Get/ProductGroup/Product[n1:ArticleType='ZCOU']">26</xsl:when>
			-->
			<!-- #rule4 -->
			<xsl:when test="$discountTypeCode = 3">1</xsl:when>
			<!-- END RetailIncentiveOfferDiscountTypeCode = 3-->
			<!-- START RetailIncentiveOfferDiscountTypeCode = 4-->
			<!-- S1V7: Spend R200, get a free/collectable item. -->
			<!-- Discount Percent - S7V1 Buy X and get Percentage off of specific Products. -->
			<xsl:when test="$discountTypeCode = 4">
				
				<xsl:choose>
					<!-- #rule7 -->
					<xsl:when test="$discountPercentage='DP100' and $articleType='ZBON'">20</xsl:when>
					<!-- #rule6 -->
					<xsl:when test="$articleType='ZCOU'">26</xsl:when>
					<!-- #rule10 -->
					<xsl:when test="$discountPercentage='DPGTZERO' and $getHasProductGroup='false'">13</xsl:when>
					<!-- #rule9 -->
					<xsl:when test="$discountPercentage='DPGTZERO' and $getHasProductGroup">2</xsl:when>
					
					<!-- #rule8 -->
					<xsl:when test="$discountPercentage='DPGTZERO'">2</xsl:when>
					<!-- 368 -->
					<!-- #rule5 -->
					<xsl:when test="$discountPercentage='DP100' and ( not ($articleType='ZCOU') and not($articleType='ZBON'))">15</xsl:when>
					<!-- Not 100 Percent Discount -->
					
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
</xsl:stylesheet>
