<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:shoprite="za.co.invictus.xsl.Utils">
	<xsl:include href="rewardType.xsl"/>
	<xsl:include href="rewardVal.xsl"/>
	<xsl:include href="createItemGroup.xsl"/>
	
	<xsl:template name="mapBonusBuy">
		<xsl:comment>Mapping <xsl:value-of select="RetailIncentive/RetailBonusBuyID"/>
		</xsl:comment>
		<xsl:comment>
			<xsl:value-of select="count(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode[.=RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode[1]])"/>
		</xsl:comment>
		<xsl:comment>
			<xsl:value-of select="count(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode)"/>
		</xsl:comment>
		<xsl:comment>
			<xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferDiscountTypeCode[1]"/>
		</xsl:comment>
		<xsl:variable name="rewardType">
			<xsl:call-template name="rewardType"/>
		</xsl:variable>
		<xsl:element name="Promotion">
			<xsl:comment>Carry stores for splitting later...</xsl:comment>
			<xsl:for-each select="RetailIncentive/ReceivingStore">
				<xsl:element name="ReceivingStore">
					<xsl:element name="StoreInternalID">
						<xsl:value-of select="StoreInternalID"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<xsl:element name="HeaderRecord">
			    <xsl:element name="MessageID">
			    	<xsl:value-of select="MessageHeader/ID"/>
			    </xsl:element> 
				<xsl:element name="Description">
					<xsl:value-of select="RetailIncentive/Offer/Description/Description"/>
				</xsl:element>
				<xsl:element name="Date">
					<!--Source Creation Date YYYY-MM-DDTHH:MM:SSZ" -->
					<xsl:value-of select="substring(MessageHeader/CreationDateTime,0,11)"/>
				</xsl:element>
				<xsl:element name="FileDateTime">
					<xsl:value-of select="shoprite:convertUTCtoSouthAfricaTimezone(MessageHeader/CreationDateTime)"/>
				</xsl:element>
			</xsl:element>
			<!-- TODO:  limit to 9 chars - What is going to be the SAP Number Range?  Can we do a substring()/right()? -->
			<xsl:element name="PromotionNo">
				<xsl:value-of select="RetailIncentive/RetailBonusBuyID"/>
			</xsl:element>
			<xsl:comment>Defaulted to 3</xsl:comment>
			<xsl:element name="Promotiontype">3</xsl:element>
			<xsl:element name="RewardType">
				<xsl:value-of select="$rewardType"/>
			</xsl:element>
			<xsl:element name="StartDate">
				<xsl:value-of select="RetailIncentive/SalesPeriod/StartDate"/>
			</xsl:element>
			<xsl:element name="EndDate">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/ActivationStatusCode=2">
						<xsl:value-of select="concat(substring(RetailIncentive/SalesPeriod/StartDate,0,9),number(substring(RetailIncentive/SalesPeriod/StartDate,9,11))-1)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="RetailIncentive/SalesPeriod/EndDate"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="Description">
				<xsl:value-of select="RetailIncentive/Offer/Description/Description"/>
			</xsl:element>
			<xsl:element name="Rewardval">
				<xsl:call-template name="rewardVal">
					<xsl:with-param name="rewardType">
						<xsl:value-of select="$rewardType"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			<xsl:comment>Defaulted to 1</xsl:comment>
			<xsl:element name="ApportAlg">1</xsl:element>
			<xsl:element name="LowHighReward">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode) = 2">0</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode) = 2">0</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="DelayedPromotion">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode) = 2">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode) = 2">1</xsl:when>
					<!-- TODO: maybe sum GroupQuantity1 to 10 and if greater than 10 (in second step)? -->
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:element>
			<!-- TODO:  clarify mapping instruction from Andy -->
			<xsl:element name="MessageTypeId">
				<xsl:choose>
					<xsl:when test="$rewardType=26">
					<!-- Substring last three digits of internal ID-->
						<xsl:value-of select="RetailIncentive/Offer/Get/ProductGroup/Product/InternalID"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="TemplateId">0</xsl:element>
			<xsl:element name="MemberCardReq">0</xsl:element>
			<xsl:element name="LimitQuantity">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/GrantingMaximumNumberValue > 0">
						<xsl:value-of select="RetailIncentive/Offer/GrantingMaximumNumberValue"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="Items">
				<!-- Matching Buy and Get nodes? -->
				<xsl:variable name="buyAndGetMatches">
					<xsl:variable name="buyProducts" select="RetailIncentive/Offer/Buy/ProductGroup/Product/StandardID"/>
					<xsl:variable name="getProducts" select="RetailIncentive/Offer/Get/ProductGroup/Product/StandardID"/>
					
					<xsl:value-of select="string(shoprite:compareQueues($buyProducts, $getProducts))"/>
					
				</xsl:variable>
				
				<xsl:variable name="singleBuyGroup">
					<xsl:choose>
						<xsl:when test="RetailIncentive/Offer/Buy/AndOrBusinessRuleExpressionTypeCode = 'O'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="singleGetGroup">
					<xsl:choose>
						<xsl:when test="RetailIncentive/Offer/Get/AndOrBusinessRuleExpressionTypeCode = 'O'">1</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:comment>ItemGroups for next mapping step</xsl:comment>
				<!-- Buy conditions on Header level. -->
				<xsl:if test="count(RetailIncentive/Offer/Buy/RequirementMinimumAmount) > 0 and not(RetailIncentive/Offer/Buy/RequirementMinimumAmount = 0)">
					<!-- Inject a group with no items -->
					<xsl:call-template name="createItemGroup">
						<xsl:with-param name="productNodes" select="."/>
						<xsl:with-param name="type">BUY</xsl:with-param>
						<xsl:with-param name="groupNumber">1</xsl:with-param>
						<xsl:with-param name="groupType">5</xsl:with-param>
						<xsl:with-param name="groupQuantity">
							<xsl:value-of select="RetailIncentive/Offer/Buy/RequirementMinimumAmount * 100"/>
						</xsl:with-param>
						<xsl:with-param name="applyReward">0</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:choose>
					<!-- For Free Item only, if Buy and Get contains same items then merge the groups. -->
					<xsl:when test="$rewardType = 15 and $buyAndGetMatches">
						<xsl:comment>Suppress Buy:  Free Item and Buy &amp; Get Matches</xsl:comment>
					
					</xsl:when>
				
				    <!-- AndOrBusinessRuleExpressionTypeCode" "O"-->
					<xsl:when test="number($singleBuyGroup) > 0">
						<xsl:comment>Found ProductGroup OR condition for Buy side, create single group number</xsl:comment>
						<!-- TODO:  All the BUY rules for the single group must be considered here -->
						<xsl:variable name="applyReward">
							<xsl:choose>
								<xsl:when test="false"/>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="groupType">
							<xsl:choose>
								<xsl:when test="false"/>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="groupQuantity">
							<xsl:choose>
								<xsl:when test="false"/>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="createItemGroup">
							<xsl:with-param name="productNodes" select="RetailIncentive/Offer/Buy/ProductGroup/Product"/>
							<xsl:with-param name="type">BUY</xsl:with-param>
							<xsl:with-param name="groupNumber">1</xsl:with-param>
							<xsl:with-param name="groupType">
								<xsl:value-of select="$groupType"/>
							</xsl:with-param>
							<xsl:with-param name="groupQuantity">
								<xsl:value-of select="$groupQuantity"/>
							</xsl:with-param>
							<xsl:with-param name="applyReward">
								<xsl:value-of select="$applyReward"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					
					<!-- AndOrBusinessRuleExpressionTypeCode" "A"-->
					<xsl:otherwise>
						<xsl:for-each select="RetailIncentive/Offer/Buy/ProductGroup">
							<xsl:variable name="group">
								<xsl:value-of select="position()"/>
							</xsl:variable>
							<!-- OFFER BUY SIDE -->
							<!-- TODO:  All the BUY rules for the groups must be considered here -->
							<!-- ApplyReward will always be 0 on the Buy side. -->
							<xsl:variable name="applyReward">0</xsl:variable>
							<xsl:variable name="groupType">
								<xsl:choose>
								    <xsl:when test="RequirementMinimumAmount>0 and not(RequirementQuantityDecimalValue=0)">3</xsl:when>
									<xsl:when test="not(RequirementQuantityDecimalValue = 0)">1</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="groupQuantity">
								<xsl:choose>
									<xsl:when test="not(RequirementQuantityDecimalValue = 0) and RequirementMinimumAmount>0">
										<xsl:value-of select="RequirementMinimumAmount"/>
									</xsl:when>	
									<xsl:when test="RequirementQuantityDecimalValue > 0 and count(RequirementMinimumAmount)=0">
										<xsl:value-of select="RequirementQuantityDecimalValue"/>
									</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:call-template name="createItemGroup">
								<xsl:with-param name="productNodes" select="Product"/>
								<xsl:with-param name="type">BUY</xsl:with-param>
								<xsl:with-param name="groupNumber">
									<xsl:value-of select="$group"/>
								</xsl:with-param>
								<xsl:with-param name="groupType">
									<xsl:value-of select="$groupType"/>
								</xsl:with-param>
								<xsl:with-param name="groupQuantity">
									<xsl:value-of select="$groupQuantity"/>
								</xsl:with-param>
								<xsl:with-param name="applyReward">
									<xsl:value-of select="$applyReward"/>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- OFFER GET SIDE -->
				<!-- Do the Get side. -->
				<xsl:choose>
					<xsl:when test="$rewardType=26">
						<xsl:comment>RewardType 26 - do not map any Get groups.</xsl:comment>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
						     <!-- AndOrBusinessRuleExpressionTypeCode" "O"-->
							<xsl:when test="number($singleGetGroup) > 0">
								<xsl:comment>Found ProductGroup OR condition for Get side, create single group number</xsl:comment>
								<!-- TODO:  All the GET rules for the single group must be considered here -->
								<xsl:variable name="applyReward">
									<xsl:choose>
										<!-- S7V3 -->
										<xsl:when test="number(DiscountAmount[1]) > 0">1</xsl:when>
										<!-- S12V3 -->
										<xsl:when test="number(../DiscountAmount[1]) > 0">0</xsl:when>
										<xsl:when test="number(DiscountPercent[1]) > 0">1</xsl:when>
										<xsl:when test="number(../DiscountPercent[1]) > 0">0</xsl:when>
										<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="groupType">
									<xsl:choose>
										<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="groupQuantity">
									<xsl:choose>
										<!-- Quantities must be the same!  Trap here if PI to check. -->
										<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:call-template name="createItemGroup">
									<xsl:with-param name="productNodes" select="RetailIncentive/Offer/Get/ProductGroup/Product"/>
									<xsl:with-param name="type">GET</xsl:with-param>
									<xsl:with-param name="groupNumber">1</xsl:with-param>
									<xsl:with-param name="groupType">
										<xsl:value-of select="$groupType"/>
									</xsl:with-param>
									<xsl:with-param name="groupQuantity">
										<xsl:value-of select="$groupQuantity"/>
									</xsl:with-param>
									<xsl:with-param name="applyReward">
										<xsl:value-of select="$applyReward"/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<!-- AndOrBusinessRuleExpressionTypeCode" "A"-->
							<xsl:otherwise>
								<xsl:for-each select="RetailIncentive/Offer/Get/ProductGroup">
									<xsl:variable name="group">
										<xsl:value-of select="position()"/>
									</xsl:variable>
									<!-- TODO:  All the GET rules for the groups must be considered here -->
									<xsl:variable name="applyReward">
										<xsl:choose>
											<!-- S7V3 -->
											<xsl:when test="number(DiscountAmount) > 0">1</xsl:when>
											<!-- S12V3 -->
											<xsl:when test="number(../DiscountAmount) > 0">0</xsl:when>
											<xsl:when test="number(DiscountPercent) > 0">1</xsl:when>
											<!-- Andy to confirm if Discount Percent at Get level applies to Basket or Groups -->
											<xsl:when test="number(../DiscountPercent) > 0">0</xsl:when>
											<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">1</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="groupType">
										<xsl:choose>
											<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">1</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:variable name="groupQuantity">
										<xsl:choose>
											<xsl:when test="not(GrantedQuantityLowerBoundaryDecimalValue = 0)">
												<xsl:value-of select="GrantedQuantityLowerBoundaryDecimalValue"/>
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="createItemGroup">
										<xsl:with-param name="productNodes" select="Product"/>
										<xsl:with-param name="type">GET</xsl:with-param>
										<xsl:with-param name="groupNumber">
											<xsl:value-of select="$group"/>
										</xsl:with-param>
										<xsl:with-param name="groupType">
											<xsl:value-of select="$groupType"/>
										</xsl:with-param>
										<xsl:with-param name="groupQuantity">
											<xsl:value-of select="$groupQuantity"/>
										</xsl:with-param>
										<xsl:with-param name="applyReward">
											<xsl:value-of select="$applyReward"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
