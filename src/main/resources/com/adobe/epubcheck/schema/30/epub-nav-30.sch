<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"  queryBinding="xslt2">

    <ns uri="http://www.w3.org/1999/xhtml" prefix="html"/>
    <ns uri="http://www.idpf.org/2007/ops" prefix="epub"/>

    <pattern id="nav-ocurrence">
        <rule context="html:body">
            <assert test="count(.//html:nav[tokenize(@epub:type,'\s+')='toc']) = 1">Exactly one 'toc' nav element
                must be present</assert>
            <assert test="count(.//html:nav[tokenize(@epub:type,'\s+')='page-list']) &lt; 2">Multiple occurrences of
                the 'page-list' nav element</assert>
            <assert test="count(.//html:nav[tokenize(@epub:type,'\s+')='landmarks']) &lt; 2">Multiple occurrences of
                the 'landmarks' nav element</assert>
        </rule>
    </pattern>

    <pattern id="span-no-sublist">
        <rule context="html:body//html:nav//html:span">
            <assert test="count(.//ol) = 0"> The span element must only be used as heading for flat
                sublists (not hierarchical navigation structures) </assert>
        </rule>
    </pattern>

    <pattern id="landmarks">
        <rule context="html:nav[tokenize(@epub:type,'\s+')='landmarks']//html:ol//html:a">
            <let name="current_type_normalized" value="normalize-space(lower-case(@epub:type))"/>
            <let name="current_href_normalized" value="normalize-space(lower-case(@html:href))"/>

            <!-- Check for missing epub:type attributes -->
            <assert test="@epub:type">Missing epub:type attribute on anchor inside 'landmarks' nav element</assert>

            <!--
                landmarks anchors should be unique (#493)
                and only reported within the same ancestor landmarks element
            -->
            <assert test="
                count(ancestor::html:nav[tokenize(@epub:type,'\s+')='landmarks']//html:ol//html:a[
                    normalize-space(lower-case(@epub:type)) = $current_type_normalized and
                    normalize-space(lower-case(@html:href)) = $current_href_normalized
                    ]) = 1">WARNING: Duplicate 'a' elements with the same 'epub:type' and 'href' attributes inside 'landmarks' nav element</assert>
        </rule>
    </pattern>

    <pattern id="link-labels">
        <rule context="html:nav//html:ol//html:a">
            <assert
                test="string-length(normalize-space(concat(.,./html:img/@alt,.//@aria-label))) > 0"
                >Anchors within nav elements must contain text</assert>
        </rule>
    </pattern>

    <pattern id="span-labels">
        <rule context="html:nav//html:ol//html:span">
            <assert
                test="string-length(normalize-space(concat(.,./html:img/@alt,.//@aria-label))) > 0"
                >Spans within nav elements must contain text</assert>
        </rule>
    </pattern>

    <pattern id="req-heading">
        <rule
            context="html:nav[not(tokenize(@epub:type,'\s+') = ('toc','page-list','landmarks'))]">
            <let name="fc" value="local-name(./*[1])"/>
            <assert test="(starts-with($fc,'h') and string-length($fc) = 2) or ($fc = 'hgroup')">nav
                elements other than 'toc', 'page-list' and 'landmarks' must contain a heading as the
                first child</assert>
        </rule>
    </pattern>

    <pattern id="heading-content">
        <rule context="html:h1|html:h2|html:h3|html:h4|html:h5|html:h6|html:hgroup">
            <assert
                test="string-length(normalize-space(concat(.,./html:img/@alt,.//@aria-label))) > 0"
                >Heading elements must contain text</assert>
        </rule>
    </pattern>


    <!-- warnings mode <pattern id="page-list-flat">
        <rule context="html:body//html:nav[@epub:type='page-list']">
        <assert test="count(.//html:ol) = 1">The page-list navigation structure should be a
        list, not a nested hierarchy</assert>
        </rule>
        </pattern> 
    -->

</schema>
