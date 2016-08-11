<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="copyBonusBuyAndCreateGroups" >
		<xsl:element name="Promotion">
			<xsl:element name="HeaderRecord">
					
				<xsl:element name="MessageID">
					<xsl:value-of select="../HeaderRecord/MessageID"/>
				</xsl:element>	
				<xsl:element name="Decription">
					<xsl:value-of select="../HeaderRecord/Description"/>
				</xsl:element>
				<xsl:element name="Date">
					<xsl:value-of select="../HeaderRecord/Date"/>
				</xsl:element>
				<xsl:element name="Site">
					<xsl:value-of select="StoreInternalID"/>
				</xsl:element>
				<xsl:element name="FileDateTime">
				<xsl:value-of select="../HeaderRecord/FileDateTime"/>
				</xsl:element>
				
			</xsl:element>
			<xsl:copy-of select="../PromotionNo"/>
			<xsl:copy-of select="../Promotiontype"/>
			<xsl:copy-of select="../RewardType"/>
			<xsl:copy-of select="../StartDate"/>
			<xsl:copy-of select="../EndDate"/>
			<xsl:copy-of select="../Description"/>
			<xsl:copy-of select="../Rewardval"/>
			<xsl:copy-of select="../ApportAlg"/>
			<xsl:copy-of select="../LowHighReward"/>
			<xsl:copy-of select="../DelayedPromotion"/>
			<xsl:copy-of select="../MessageTypeId"/>
			<xsl:copy-of select="../TemplateId"/>
			<xsl:copy-of select="../MemberCardReq"/>
			<xsl:copy-of select="../LimitQuantity"></xsl:copy-of>
			<xsl:comment>Defaulted to 0</xsl:comment>
			<xsl:element name="CardSchemes">
				<xsl:element name="Group1">0</xsl:element>
				<xsl:element name="Group2">0</xsl:element>
				<xsl:element name="Group3">0</xsl:element>
				<xsl:element name="Group4">0</xsl:element>
				<xsl:element name="Group5">0</xsl:element>
				<xsl:element name="Group6">0</xsl:element>
				<xsl:element name="Group7">0</xsl:element>
				<xsl:element name="Group8">0</xsl:element>
				<xsl:element name="Group9">0</xsl:element>
				<xsl:element name="Group10">0</xsl:element>
			</xsl:element>
			<xsl:element name="ApplyRewards">
				<xsl:for-each select="../Items/ItemGroup">
					<xsl:text disable-output-escaping="yes">&lt;Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					<xsl:value-of select="ApplyReward"/>
					<xsl:text disable-output-escaping="yes">&lt;/Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:for-each>
			</xsl:element>
			<xsl:element name="GroupTypes">
				<xsl:for-each select="../Items/ItemGroup">
					<xsl:text disable-output-escaping="yes">&lt;Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					<xsl:value-of select="GroupType"/>
					<xsl:text disable-output-escaping="yes">&lt;/Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:for-each>
				<xsl:call-template name="loop">
					<xsl:with-param name="var">10</xsl:with-param>
					<xsl:with-param name="index"><xsl:value-of select="count(../Items/ItemGroup)+1"/></xsl:with-param>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="GroupQuantities">
				<xsl:for-each select="../Items/ItemGroup">
					<xsl:text disable-output-escaping="yes">&lt;Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
					<xsl:value-of select="GroupQuantity"/>
					<xsl:text disable-output-escaping="yes">&lt;/Group</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				</xsl:for-each>
			</xsl:element>
			<xsl:comment>Defaulted to 1</xsl:comment>
			<xsl:element name="ApplyApportionments">
				<xsl:element name="Group1">1</xsl:element>
				<xsl:element name="Group2">1</xsl:element>
				<xsl:element name="Group3">1</xsl:element>
				<xsl:element name="Group4">1</xsl:element>
				<xsl:element name="Group5">1</xsl:element>
				<xsl:element name="Group6">1</xsl:element>
				<xsl:element name="Group7">1</xsl:element>
				<xsl:element name="Group8">1</xsl:element>
				<xsl:element name="Group9">1</xsl:element>
				<xsl:element name="Group10">1</xsl:element>
			</xsl:element>
			<xsl:comment>Defaulted to 1</xsl:comment>
			<xsl:element name="ActivationDays">
				<xsl:element name="Monday">1</xsl:element>
				<xsl:element name="Tuesday">1</xsl:element>
				<xsl:element name="Wednesday">1</xsl:element>
				<xsl:element name="Thursday">1</xsl:element>
				<xsl:element name="Friday">1</xsl:element>
				<xsl:element name="Saturday">1</xsl:element>
				<xsl:element name="Sunday">1</xsl:element>
			</xsl:element>
			<xsl:comment>Defaulted times</xsl:comment>
			<xsl:element name="ActivationTimes">
				<xsl:element name="MondayStart">00:00:00</xsl:element>
				<xsl:element name="MondayEnd">23:59:00</xsl:element>
				<xsl:element name="TuesdayStart">00:00:00</xsl:element>
				<xsl:element name="TuesdayEnd">23:59:00</xsl:element>
				<xsl:element name="WednesdayStart">00:00:00</xsl:element>
				<xsl:element name="WednesdayEnd">23:59:00</xsl:element>
				<xsl:element name="ThursdayStart">00:00:00</xsl:element>
				<xsl:element name="ThursdayEnd">23:59:00</xsl:element>
				<xsl:element name="FridayStart">00:00:00</xsl:element>
				<xsl:element name="FridayEnd">23:59:00</xsl:element>
				<xsl:element name="SaturdayStart">00:00:00</xsl:element>
				<xsl:element name="SaturdayEnd">23:59:00</xsl:element>
				<xsl:element name="SundayStart">00:00:00</xsl:element>
				<xsl:element name="SundayEnd">23:59:00</xsl:element>
			</xsl:element>
			<xsl:element name="Items">
				<xsl:for-each select="../Items/ItemGroup">
					<xsl:variable name="grp">
						<xsl:value-of select="position()"/>
					</xsl:variable>
					<xsl:for-each select="Item">
						<xsl:element name="Item">
							<xsl:element name="Barcode">
								<xsl:value-of select="Barcode"/>
							</xsl:element>
							<xsl:element name="GroupLink">
								<xsl:value-of select="$grp"/>
							</xsl:element>
						</xsl:element>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="loop">
		<xsl:param name="var"/>
		<xsl:param name="index">
			<xsl:value-of select="'1'"/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="$var >=$ index">
				<xsl:text disable-output-escaping="yes">&lt;Group</xsl:text>
				<xsl:value-of select="$index"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<xsl:value-of select="1"/>
				<xsl:text disable-output-escaping="yes">&lt;/Group</xsl:text>
				<xsl:value-of select="$index"/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>

				<xsl:call-template name="loop">
					<xsl:with-param name="var">10</xsl:with-param>
					<xsl:with-param name="index">
						<xsl:number value="number($index)+1"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>I am out of the loop</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>