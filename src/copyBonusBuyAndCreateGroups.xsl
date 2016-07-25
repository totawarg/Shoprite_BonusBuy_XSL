<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template name="copyBonusBuyAndCreateGroups">
		<xsl:element name="Promotion">
			<xsl:element name="HeaderRecord">
				<xsl:element name="Decription">
					<xsl:value-of select="../HeaderRecord/Description"/>
				</xsl:element>
				<xsl:element name="Date">
					<xsl:value-of select="../HeaderRecord/Date"/>
				</xsl:element>
				<xsl:element name="Site">
					<xsl:value-of select="StoreInternalID"/>
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
				<Monday>1</Monday>
				<Tuesday>1</Tuesday>
				<Wednesday>1</Wednesday>
				<Thursday>1</Thursday>
				<Friday>1</Friday>
				<Saturday>1</Saturday>
				<Sunday>1</Sunday>
			</xsl:element>
			<xsl:comment>Defaulted times</xsl:comment>
			<xsl:element name="ActivationTimes">
				<MondayStart>00:00:00</MondayStart>
				<MondayEnd>23:59:00</MondayEnd>
				<TuesdayStart>00:00:00</TuesdayStart>
				<TuesdayEnd>23:59:00</TuesdayEnd>
				<WednesdayStart>00:00:00</WednesdayStart>
				<WednesdayEnd>23:59:00</WednesdayEnd>
				<ThursdayStart>00:00:00</ThursdayStart>
				<ThursdayEnd>23:59:00</ThursdayEnd>
				<FridayStart>00:00:00</FridayStart>
				<FridayEnd>23:59:00</FridayEnd>
				<SaturdayStart>00:00:00</SaturdayStart>
				<SaturdayEnd>23:59:00</SaturdayEnd>
				<SundayStart>00:00:00</SundayStart>
				<SundayEnd>23:59:00</SundayEnd>
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
</xsl:stylesheet>
