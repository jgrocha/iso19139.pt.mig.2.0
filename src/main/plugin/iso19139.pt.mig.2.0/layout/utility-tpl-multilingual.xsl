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
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xslutil="java:org.fao.geonet.util.XslUtil"
  version="2.0"
  exclude-result-prefixes="#all">

  <xsl:import href="../../iso19139/layout/utility-tpl-multilingual.xsl" />

  <!-- Get the main metadata languages -->
  <xsl:template name="get-iso19139.pt.mig.2.0-language">
    <xsl:call-template name="get-iso19139-language" />
  </xsl:template>

  <!-- Get the list of other languages in JSON -->
  <xsl:template name="get-iso19139.pt.mig.2.0-other-languages-as-json">
    <xsl:call-template name="get-iso19139-other-languages-as-json" />
  </xsl:template>

  <!-- Get the list of other languages -->
  <xsl:template name="get-iso19139.pt.mig.2.0-other-languages">
    <xsl:call-template name="get-iso19139-other-languages" />
  </xsl:template>

</xsl:stylesheet>