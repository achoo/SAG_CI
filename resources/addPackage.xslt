<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	
	<xsl:output method="xml" encoding="utf-8" indent="yes"/>
	
	<xsl:param name="paramPackageNames"/>
	<xsl:param name="repo"/>
	<xsl:param name="type"/>
											
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template name="splitPackages">
		<xsl:param name="packages" select="."/>
						
	
		<xsl:if test="string-length($packages) > 0">
			<xsl:variable name="singlePackage" select="substring-before(concat($packages, ';'), ';')"/>

			<Composite>
				<xsl:attribute name="srcAlias"><xsl:value-of select="$repo"/></xsl:attribute>					
				<xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>					
				<xsl:attribute name="displayName">Package/<xsl:value-of select="$singlePackage"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="$singlePackage"/></xsl:attribute>
			</Composite>		

			<xsl:call-template name="splitPackages">
				<xsl:with-param name="packages" select="substring-after($packages, ';')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>



	
	<xsl:template match="DeployerSpec/Projects/Project/DeploymentSet">
		<DeploymentSet>
				<xsl:apply-templates select="@* | *" />
				
				<xsl:call-template name="splitPackages">
					<xsl:with-param name="packages" select="$paramPackageNames"/>"/>
				</xsl:call-template>
												
		</DeploymentSet>
	</xsl:template>

</xsl:stylesheet>