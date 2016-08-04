<?xml version="1.0" encoding="UTF-8"?>
<!--
 	*************************Documentation***********************************************************************
 	
 	#START STORE : Creates node for list of stores.
 	#START HEADER : Created Header node
 	#START REWARD TYPE : Calls rewardType template XSL for evaluating reward type for a given discount 
 						 type code and discount amount, discount percentage , price amount,
 						 product group ,article type and etc.	
 	#START REWARD VAL	: Calls rewardVal template XAL for evaluating reward val for a given reward type
 						  discount amount, discount percentage , price amount etc
 	#START LOW HIGH REWARD:
 	#START DELAYED PROMOTION:
 	#START LIMITED QUANTITY:
 	#START BUY AND GET PRODUCT MATCH: Calls a java function to check if buy and get product standard id
 	#START SINGLE BUY AND GET 'OR' CONDITION : OUT OF SCOPE
 	#START BUY CONDTION AT HEADER LEVEL: If require minimum amount is set a header level no item group 
 										 should be created on offer buy side Node : Offer/Buy/RequirementMinimumAmount
 	 
 	
 	**************************************************************************************************************
 -->
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:shoprite="za.co.invictus.xsl.Utils" xmlns:n1="urn:sap.shoprite.co.za:retail:pp" >
	<xsl:include href="rewardType.xsl"/>
	<xsl:include href="rewardVal.xsl"/>
	<xsl:include href="createItemGroup.xsl"/>
	<xsl:param name="MessageId"/>
		<xsl:variable name="piMessageId">
			<xsl:value-of select="$MessageId"/>
		</xsl:variable>
	
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
		<xsl:variable name="checkArticleType">
			<xsl:choose>
				<xsl:when test="count(RetailIncentive/Offer/Get/ProductGroup/Product[*[local-name() = 'ArticleType']='ZBON'])>0">ZBON</xsl:when>
				<xsl:when test="count(RetailIncentive/Offer/Get/ProductGroup/Product[*[local-name() = 'ArticleType']='ZCOU'])>0">ZCOU</xsl:when>
				<xsl:otherwise>OTHERARTICLETYPES</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="Promotion">
			<xsl:comment>Carry stores for splitting later...</xsl:comment>
			<!-- START STORES-->
			<xsl:for-each select="RetailIncentive/ReceivingStore">
				<xsl:element name="ReceivingStore">
					<xsl:element name="StoreInternalID">
						<xsl:value-of select="format-number(shoprite:addCheckDigitToSite(StoreInternalID),'000000')"/>
					</xsl:element>
				</xsl:element>
			</xsl:for-each>
			<!-- END OF STORES -->
			
			<!-- START HEADER -->
			<xsl:element name="HeaderRecord">
			    <xsl:element name="MessageID">
			    	<xsl:value-of select="$piMessageId"/>
			    </xsl:element> 
				<xsl:element name="Description">
					<xsl:value-of select="RetailIncentive/Offer/Description/Description"/>
				</xsl:element>
				<xsl:element name="Date">
					<!--Source Creation Date yyyy-MM-ddTHH:MM:ssZ" to yyyy-MM-dd-->
					<xsl:value-of select="shoprite:convertUTCtoSouthAfricaTimezone2(MessageHeader/CreationDateTime)"/>
				</xsl:element>
				<!--Source Creation Date yyyy-MM-ddThh:mm:ssZ" to yyyyMMddHHmmss-->
				<xsl:element name="FileDateTime">
					<xsl:value-of select="shoprite:convertUTCtoSouthAfricaTimezone(MessageHeader/CreationDateTime)"/>
				</xsl:element>
			</xsl:element>
			<!-- END HEADER -->
			
			<!-- TODO:  limit to 9 chars - What is going to be the SAP Number Range?  Can we do a substring()/right()? -->
			<xsl:element name="PromotionNo">
				<xsl:value-of select="RetailIncentive/RetailBonusBuyID"/>
			</xsl:element>
			<xsl:comment>Defaulted to 3</xsl:comment>
			<xsl:element name="Promotiontype">3</xsl:element>
			
			<!-- START REWARD TYPE -->
			<xsl:element name="RewardType">
				<xsl:value-of select="$rewardType"/>
			</xsl:element>
			<!-- END REWARD TYPE -->
			
			<xsl:element name="StartDate">
				<xsl:value-of select="RetailIncentive/SalesPeriod/StartDate"/>
			</xsl:element>
			<xsl:element name="EndDate">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/ActivationStatusCode=2">
						<xsl:value-of select="shoprite:getPreviousDateForActivationStatusCode2(RetailIncentive/SalesPeriod/StartDate)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="RetailIncentive/SalesPeriod/EndDate"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="Description">
				<xsl:value-of select="RetailIncentive/Offer/Description/Description"/>
			</xsl:element>
			
			<!-- START REWARD VAL -->
			<xsl:element name="Rewardval">
				<xsl:call-template name="rewardVal">
					<xsl:with-param name="rewardType">
						<xsl:value-of select="$rewardType"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			<!-- END REWARD VAL -->
			
			<xsl:comment>Defaulted to 1</xsl:comment>
			<xsl:element name="ApportAlg">1</xsl:element>
			
			<!-- START LOW HIGH REWARD -->
			<xsl:element name="LowHighReward">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode) = 2">0</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode) = 2">0</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- END LOW HIGH REWARD -->
			
			<!-- START DELAYED PROMOTION -->
			<xsl:element name="DelayedPromotion">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode = 600">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/RetailIncentiveOfferConditionCode) = 2">1</xsl:when>
					<xsl:when test="number(RetailIncentive/Offer/Get/ProductGroup/RetailIncentiveOfferConditionCode) = 2">1</xsl:when>
					<!-- TODO: maybe sum GroupQuantity1 to 10 and if greater than 10 (in second step)? -->
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- END DELAYED PROMOTION-->
			
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
			
			<!-- START LIMITED QUANTITY -->
			<xsl:element name="LimitQuantity">
				<xsl:choose>
					<xsl:when test="RetailIncentive/Offer/GrantingMaximumNumberValue > 0">
						<xsl:value-of select="RetailIncentive/Offer/GrantingMaximumNumberValue"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<!-- END LIMITED QUANTITY -->
			
			<xsl:element name="Items">
				<!-- Matching Buy and Get nodes? -->
				
				<!-- START BUY AND GET PRODUCT MATCH -->
				<xsl:variable name="buyAndGetMatches">
					<xsl:variable name="buyProducts" select="RetailIncentive/Offer/Buy/ProductGroup/Product/StandardID"/>
					<xsl:variable name="getProducts" select="RetailIncentive/Offer/Get/ProductGroup/Product/StandardID"/>
					<xsl:value-of select="string(shoprite:compareQueues($buyProducts, $getProducts))"/>
				</xsl:variable>
				<!-- END BUY AND GET PRODUCT MATCH -->
				
				<!--  AndOrBusinessRuleExpressionTypeCode = 'O'/ OR CONDITION WILL NOT BE CONFIGUERED IN SAP,
					  BELOW WAS BUILT BEFORE DECISION  -->
				<!-- START SINGLE BUY AND GET 'OR' CONDITION -->	  
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
				<!-- END SINGLE BUY AND GET 'OR' CONDITION -->	
				
				<xsl:comment>ItemGroups for next mapping step</xsl:comment>
				<!-- Buy conditions on Header level. -->
				<!-- START BUY CONDTION AT HEADER LEVEL -->
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
				<!-- END BUY CONDTION AT HEADER LEVEL -->
				<xsl:choose>
					<!-- For Free Item only, if Buy and Get contains same items then merge the groups. -->
					<xsl:when test="$rewardType = 15 and string($buyAndGetMatches) = 'true'">
						<xsl:comment>Suppress Buy:  Free Item and Buy &amp; Get Matches</xsl:comment>
					
					</xsl:when>
				
				    <!-- AndOrBusinessRuleExpressionTypeCode" "O"-->
				    <!-- START OF BUY-OR NOT ALL RULES IMPLEMENTED YET NOT IN SCOPE-->
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
								<xsl:value-of select="format-number($groupQuantity,0)"/>
							</xsl:with-param>
							<xsl:with-param name="applyReward">
								<xsl:value-of select="$applyReward"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<!--  END OF BUY-OR -->
					
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
									<xsl:value-of select="format-number($groupQuantity,0)"/>
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
					<xsl:when test="$checkArticleType='ZBON' or $checkArticleType='ZCOU'">
					<xsl:comment>Do not map any Get groups for article type ZBON and ZCOU</xsl:comment>
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
										<xsl:value-of select="format-number($groupQuantity,0)"/>
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
											<xsl:when test="number(../DiscountPercent) > 0">1</xsl:when>
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
										<xsl:when test="$rewardType = 15 and string($buyAndGetMatches) = 'true'">
										<xsl:value-of select="number(../../Buy/ProductGroup/RequirementQuantityDecimalValue) + number(GrantedQuantityLowerBoundaryDecimalValue)"/>
									</xsl:when>
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
											<xsl:value-of select="format-number($groupQuantity,0)"/>
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
