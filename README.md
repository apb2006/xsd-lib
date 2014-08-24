xsd-lib
=======

XML Schema Function Modules

This XQuery function module is a translation of the java code from xsdvi on Sourceforge.  The software seems to have been written by Václav Slavětínský in 2008 as part of his Bachelor thesis at the University of Economics, Prague, Czech Republic.

To use this, review the following code snippet:

````xquery
import module namespace xs2svg="http://expath.org/lib/xs2svg" ;
declare namespace functx = "http://www.functx.com";
declare function functx:change-element-ns-deep
  ( $nodes as node()* ,
    $newns as xs:string ,
    $prefix as xs:string )  as node()* {

  for $node in $nodes
  return if ($node instance of element())
         then (element
               {QName ($newns,
                          concat($prefix,
                                    if ($prefix = '')
                                    then ''
                                    else ':',
                                    local-name($node)))}
               {$node/@*,
                functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)})
         else if ($node instance of document-node())
         then functx:change-element-ns-deep($node/node(),
                                           $newns, $prefix)
         else $node
 } ;

let $doc := doc('C:/Program Files (x86)/basex/webapp/static/schemas/package.xsd')//xs:schema
let $model := map:new()
let $svg := xs2svg:svg($doc, $model)
return document{
   processing-instruction{"xml-stylesheet"} {'href="xsdvi.css" type="text/css"'},
  functx:change-element-ns-deep($svg,"http://www.w3.org/2000/svg","")
}
