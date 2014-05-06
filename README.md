xsd-lib
=======

XML Schema Function Modules

This XQuery function module is a translation of the java code from xsdvi on Sourceforge.  The software seems to have been written by Václav Slavětínský in 2008 as part of his Bachelor thesis at the University of Economics, Prague, Czech Republic.

To use this, review the following code snippet:

    xquery version "3.0";
    
    import module namespace xs2svg="http://expath.org/lib/xs2svg" at "xs2svg.xqm";
    
    let $doc := doc('http://docbook.org/xml/5.0/xsd/docbook.xsd')//xs:schema
    let $model := map:new()
    let $svg := xs2svg:svg($doc, $model)
    return $svg
