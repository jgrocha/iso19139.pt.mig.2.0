<?xml version="1.0" encoding="UTF-8"?>

<!--
  ~ Copyright (C) 2001-2016 Food and Agriculture Organization of the
  ~ United Nations (FAO-UN), United Nations World Food Programme (WFP)
  ~ and United Nations Environment Programme (UNEP)
  ~
  ~ This program is free software; you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation; either version 2 of the License, or (at
  ~ your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful, but
  ~ WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  ~ General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program; if not, write to the Free Software
  ~ Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
  ~
  ~ Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
  ~ Rome - Italy. email: geonetwork@osgeo.org
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  version="2.0">

  <xsl:template name="langId_from_gmdlanguage19139">
    <xsl:param name="gmdlanguage" required="yes"/>
    <xsl:variable name="tmp">
      <xsl:choose>
        <xsl:when test="normalize-space($gmdlanguage/gmd:LanguageCode/@codeListValue) != ''">
          <xsl:value-of select="$gmdlanguage/gmd:LanguageCode/@codeListValue"/>
        </xsl:when>
        <xsl:when test="contains($gmdlanguage/gco:CharacterString,';')">
               <xsl:value-of  select="normalize-space(substring-before($gmdlanguage/gco:CharacterString,';'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$gmdlanguage/gco:CharacterString"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="normalize-space(string($tmp))"></xsl:value-of>
  </xsl:template>

  <!-- <xsl:variable name="mainLanguage" select="'por'" /> -->

  <xsl:variable name="mainLanguage">
    <xsl:call-template name="langId_from_gmdlanguage19139">
      <xsl:with-param name="gmdlanguage" select="/*[@gco:isoType='gmd:MD_Metadata' or name()='gmd:MD_Metadata']/gmd:language"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:template match="gmd:MD_Metadata">
    <titles>
      <xsl:apply-templates />
    </titles>
  </xsl:template>

  <xsl:variable name="locales"
    select="/*/gmd:locale/gmd:PT_Locale" />

  <xsl:template match="/gmd:MD_Metadata/gmd:identificationInfo/*/gmd:citation/*/gmd:title">
    <title>
      <xsl:attribute name="lang"><xsl:value-of select="$mainLanguage" /></xsl:attribute>
      <xsl:value-of select="gco:CharacterString" />
    </title>
      <xsl:for-each
      select="gmd:PT_FreeText/*/gmd:LocalisedCharacterString">
      <title>
        <xsl:variable name="localId" select="substring-after(@locale, '#')" />
        <xsl:attribute name="lang"><xsl:value-of
            select="$locales[@id=$localId]/gmd:languageCode/gmd:LanguageCode/@codeListValue" /></xsl:attribute>
        <xsl:value-of select="." />
      </title>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>