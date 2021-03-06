<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <!-- Sort the attributes by name and remove the xml:base attribute -->
      <xsl:for-each select="@*[name()!='xml:base']">
        <xsl:sort select="name( . )"/>
        <xsl:attribute name="{local-name()}"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- Remove duplicate model nodes -->
  <xsl:key name="model-by-name" match="model" use="@name" />
  <xsl:template match="models">
    <models>
      <xsl:for-each select="model[count(. | key('model-by-name', @name)[1]) = 1]">
        <xsl:copy>
          <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:for-each>
    </models>
  </xsl:template>

  <xsl:template match="text()|comment()|processing-instruction()">
    <xsl:copy/>
  </xsl:template>

</xsl:stylesheet>
