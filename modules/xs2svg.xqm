xquery version "3.0";

module namespace xs2svg="http://expath.org/lib/xs2svg";

declare namespace xs="http://www.w3.org/2001/XMLSchema";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare namespace xlink="http://www.w3.org/1999/xlink";

declare namespace svg="http://www.w3.org/2000/svg";

declare variable $xs2svg:PC_STRICT  as xs:integer := 1;
declare variable $xs2svg:PC_SKIP    as xs:integer := 2;
declare variable $xs2svg:PC_LAX     as xs:integer := 3;
declare variable $xs2svg:X_INDENT   as xs:integer := 45;
declare variable $xs2svg:Y_INDENT   as xs:integer := 25;
declare variable $xs2svg:MIN_WIDTH  as xs:integer := 60;
declare variable $xs2svg:MAX_HEIGHT as xs:integer := 46;
declare variable $xs2svg:MID_HEIGHT as xs:integer := 31;
declare variable $xs2svg:MIN_HEIGHT as xs:integer := 21;



declare function xs2svg:svg($node as node()?, $model as map()) {
(:    let $nl := "&#10;"
    let $javascript := util:binary-to-string(util:binary-doc('/db/apps/xsd-lib/resources/xs2svg.js'))
    return
:)          
        element { "svg" } {
            namespace { "" } { 'http://www.w3.org/2000/svg' },
            namespace { 'xlink' } { 'http://www.w3.org/1999/xlink' },
            attribute { 'id' } { 'svg' },
            attribute { 'onload' } { 'loadSVG();' },
            element { 'title' } { 'XsdVi' },
            element { 'script' } {
                attribute { 'type' } { 'text/ecmascript' },
                attribute { 'xlink:href' } { 'xs2svg.js' }
            },
            element { 'defs' } {
                element { 'symbol' } {
                    attribute { 'class' } { 'button' },
                    attribute { 'id' } { 'plus' },
                    element { 'rect' } {
                        attribute { 'x' } { '1' },
                        attribute { 'y' } { '1' },
                        attribute { 'width' } { '10' },
                        attribute { 'height' } { '10' }
                    },
                    element { 'line' } {
                        attribute { 'x1' } { '3' },
                        attribute { 'y1' } { '6' },
                        attribute { 'x2' } { '9' },
                        attribute { 'y2' } { '6' }
                    },
                    element { 'line' } {
                        attribute { 'x1' } { '6' },
                        attribute { 'y1' } { '3' },
                        attribute { 'x2' } { '6' },
                        attribute { 'y2' } { '9' }
                    }
                },
                element { 'symbol' } {
                    attribute { 'class' } { 'button' },
                    attribute { 'id' } { 'minus' },
                    element { 'rect' } {
                        attribute { 'x' } { '1' },
                        attribute { 'y' } { '1' },
                        attribute { 'width' } { '10' },
                        attribute { 'height' } { '10' }
                    },
                    element { 'line' } {
                        attribute { 'x1' } { '3' },
                        attribute { 'y1' } { '6' },
                        attribute { 'x2' } { '9' },
                        attribute { 'y2' } { '6' }
                    }
                }
            },
            element { 'rect' } {
                attribute { 'class' } { 'button' },
                attribute { 'x' } { '300' },
                attribute { 'y' } { '10' },
                attribute { 'width' } { '20' },
                attribute { 'height' } { '20' },
                attribute { 'onclick' } { 'collapseAll()' }
            },
            element { 'line' } {
                attribute { 'x1' } { '303' },
                attribute { 'y1' } { '20' },
                attribute { 'x2' } { '317' },
                attribute { 'y2' } { '20' }
            },
            element { 'text' } {
                attribute { 'x' } { '330' },
                attribute { 'y' } { '20' },
                'collapse all'
            },
            element { 'rect' } {
                attribute { 'class' } { 'button' },
                attribute { 'x' } { '400' },
                attribute { 'y' } { '10' },
                attribute { 'width' } { '20' },
                attribute { 'height' } { '20' },
                attribute { 'onclick' } { 'expandAll()' }
            },
            element { 'line' } {
                attribute { 'x1' } { '403' },
                attribute { 'y1' } { '20' },
                attribute { 'x2' } { '417' },
                attribute { 'y2' } { '20' }
            },
            element { 'line' } {
                attribute { 'x1' } { '410' },
                attribute { 'y1' } { '13' },
                attribute { 'x2' } { '410' },
                attribute { 'y2' } { '27' }
            },
            element { 'text' } {
                attribute { 'x' } { '430' },
                attribute { 'y' } { '20' },
                'expand all'
            },
            xs2svg:process-node($node, map { 'id' := '_1', 'x-position' := 1, 'y-position' := '1' }
            )
        }
};

declare function xs2svg:use($node as node(), $model as map()) {
    if ($node/node())
    then 
        let $qt := "&#39;"
        let $id := $model('id')
        let $qtid := 'show(' || $qt || $id || $qt || ')'
        return
        element { 'use' } {
            attribute { 'x' } { xs:integer($model('width')) + 1 },
            attribute { 'y' } { ($xs2svg:MAX_HEIGHT div 2) - 6 },
            attribute { 'xlink:href' } { '#minus' },
            attribute { 'id' } { 's' || $id },
            attribute { 'onclick' } { $qtid }
        }
    else ()
};

declare function xs2svg:draw-connection($node as node(), $model as map()) {
     if (($model('position') = $model('count')) and ($model('count') gt 1))
     then (
            element { 'line' } {
                attribute { 'class' } { 'connection' },
                attribute { 'id' } { 'p' || $model('id') },
                attribute { 'x1' } { 10 - $xs2svg:X_INDENT },
                attribute { 'y1' } { xs:integer($model('parent-y')) + ($xs2svg:MAX_HEIGHT div 2) },
                attribute { 'x2' } { 10 - $xs2svg:X_INDENT },
                attribute { 'y2' } { -15 - $xs2svg:Y_INDENT }
            },
            element { 'path' } {
                attribute { 'class' } { 'connection' },
                attribute { 'd' } { 'M' || (10 - $xs2svg:X_INDENT) || ',' || (-15 - $xs2svg:Y_INDENT) || ' Q' || (10 - $xs2svg:X_INDENT) || ',15 0,' || ($xs2svg:MAX_HEIGHT div 2) }
            }
          )
     else element { 'line' } {
                attribute { 'class' } { 'connection' },
                attribute { 'x1' } { 10 - $xs2svg:X_INDENT },
                attribute { 'y1' } { $xs2svg:MAX_HEIGHT div 2 },
                attribute { 'x2' } { 0 },
                attribute { 'y2' } { $xs2svg:MAX_HEIGHT div 2 }
            }
};

declare function xs2svg:on-mouseover($node as node(), $model as map()) {
    (
    attribute { 'onmouseover' } { "makeVisible('" || $model('id') || "')" },
    attribute { 'onmouseout' } { "makeHidden('" || $model('id') || "')" }
    )
};

declare function xs2svg:calcWidth($extraPixels as xs:integer, $str as xs:string?, $extraChars as xs:integer)  as xs:integer {
    if ($str)
    then $extraPixels + ((fn:string-length($str) + $extraChars) * 6)
    else $extraPixels + ($extraChars * 6)
};

declare function xs2svg:cardinality($node as node()) as xs:string {
    if ($node/@minOccurs)
    then if ($node/@maxOccurs)
            then if ($node/@maxOccurs/string() = '0')
                    then ""
                    else ""
            else ""
    else if ($node/@maxOccurs)
            then ""
            else ""
};

declare function xs2svg:process-node($node as node()?, $model as map()) {
    if ($node) then 
    typeswitch($node) 
        case text() return $node 
        case element(xs:all) return xs2svg:all($node, $model)
        case element(xs:annotation) return xs2svg:annotation($node, $model)
        case element(xs:any) return xs2svg:any($node, $model)
        case element(xs:anyAttribute) return xs2svg:anyAttribute($node, $model)
        case element(xs:appinfo) return xs2svg:appinfo($node, $model)
        case element(xs:attribute) return xs2svg:attribute($node, $model)
        case element(xs:attributeGroup) return xs2svg:attributeGroup($node, $model)
        case element(xs:choice) return xs2svg:choice($node, $model)
        case element(xs:complexContent) return xs2svg:complexContent($node, $model)
        case element(xs:complexType) return xs2svg:complexType($node, $model)
        case element(xs:documentation) return xs2svg:documentation($node, $model)
        case element(xs:element) return xs2svg:element($node, $model)
        case element(xs:enumeration) return xs2svg:enumeration($node, $model)
        case element(xs:extension) return xs2svg:extension($node, $model)
        case element(xs:field) return xs2svg:field($node, $model)
        case element(xs:fractionDigits) return xs2svg:fractionDigits($node, $model)
        case element(xs:group) return xs2svg:group($node, $model)
        case element(xs:import) return xs2svg:import($node, $model)
        case element(xs:include) return xs2svg:include($node, $model)
        case element(xs:key) return xs2svg:key($node, $model)
        case element(xs:keyref) return xs2svg:keyref($node, $model)
        case element(xs:length) return xs2svg:length($node, $model)
        case element(xs:list) return xs2svg:list($node, $model)
        case element(xs:maxExclusive) return xs2svg:maxExclusive($node, $model)
        case element(xs:maxInclusive) return xs2svg:maxInclusive($node, $model)
        case element(xs:maxLength) return xs2svg:maxLength($node, $model)
        case element(xs:minExclusive) return xs2svg:minExclusive($node, $model)
        case element(xs:minInclusive) return xs2svg:minInclusive($node, $model)
        case element(xs:minLength) return xs2svg:minLength($node, $model)
        case element(xs:notation) return xs2svg:notation($node, $model)
        case element(xs:pattern) return xs2svg:pattern($node, $model)
        case element(xs:redefine) return xs2svg:redefine($node, $model)
        case element(xs:restriction) return xs2svg:restriction($node, $model)
        case element(xs:schema) return xs2svg:schema($node, $model)
        case element(xs:selector) return xs2svg:selector($node, $model)
        case element(xs:sequence) return xs2svg:sequence($node, $model)
        case element(xs:simpleContent) return xs2svg:simpleContent($node, $model)
        case element(xs:simpleType) return xs2svg:simpleType($node, $model)
        case element(xs:totalDigits) return xs2svg:totalDigits($node, $model)
        case element(xs:union) return xs2svg:union($node, $model)
        case element(xs:unique) return xs2svg:unique($node, $model)
        case element(xs:whiteSpace) return xs2svg:whiteSpace($node, $model)
        default return xs2svg:recurse($node, $model) 
    else () 
};

declare function xs2svg:recurse($node as node()?, $model as map()) as item()* {
    if ($node) 
    then
        let $children := $node/*[('xs:all', 'xs:any', 'xs:anyAttribute', 'xs:attribute', 'xs:choice', 'xs:element', 'xs:field', 
                                            'xs:key', 'xs:keyref', 'xs:selector', 'xs:sequence', 'xs:unique') = name()]
        let $count := map:entry('count', count($children))
        let $parent-y := map:entry('parent-y', $model('y-position'))
        let $parent-x := map:entry('parent-x', $model('x-position'))
        let $x-position := map:entry('x-position', xs:integer($model('x-position')) + xs:integer($model('width')) + 45)
        let $id := $model('id')
        return
            for $cnode at $position in $children
                let $new-id := xs:string($id) || '_' || xs:string($position)
                let $new-map := map:new((
                                    map:entry('id', $new-id ),
                                    map:entry('y-position', xs:integer($model('y-position')) + (($position - 1) * (46 + 25))), 
                                    $x-position,
                                    $parent-x, 
                                    $parent-y, 
                                    $count,
                                    map:entry('position', $position)
                                    ))
                order by $position
                return xs2svg:process-node($cnode, $new-map) 
    else ()
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:all($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~
: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:all($node as node(), $model as map()) {
    let $cardinality := xs2svg:cardinality($node)
    let $width := xs2svg:calcWidth(15, $cardinality, 0)
    let $x-position := xs:integer($model('x-position'))
    let $y-position := xs:integer($model('y-position'))
    let $new-x-position := map:entry('x-position', $x-position + $width + 45)
    return (
    element { 'g' } {
        attribute { 'id' } { $model('id') },
        attribute { 'class' } { "box" },
        attribute { 'transform' } { 'translate(' || $x-position || ',' || $y-position || ')'},
        element { 'rect' } {
            attribute { 'class' } { 'boxcompositor' },
            attribute { 'x' } { '0' },
            attribute { 'y' } { '8' },
            attribute { 'width' } { $width },
            attribute { 'height' } { $xs2svg:MID_HEIGHT },
            attribute { 'rx' } { '9' }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 14 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 23 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 32 },
            attribute { 'r' } { 2 }
        },
        element { 'line' } {
            attribute { 'x1' } { ($width div 2) - 4 },
            attribute { 'y1' } { 23 },
            attribute { 'x2' } { ($width div 2) + 12 },
            attribute { 'y2' } { 23 }
        },
        element { 'polyline' } {
            attribute { 'points' } { xs:string(($width div 2) + 12) || ',32 ' || xs:string(($width div 2) + 4) || ',32 ' || 
                                     xs:string(($width div 2) + 4) || ',14 ' || xs:string(($width div 2) + 12) || ',14 ' }
        },
        if ($cardinality)
         then <text x='5' y='52'>{$cardinality}</text>
         else (),
        xs2svg:draw-connection($node, $model),
        xs2svg:use($node, map:new(($model, map:entry('width', $width))))
    },
    xs2svg:recurse($node, map:new(($model, $new-x-position)))
    )
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:annotation($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:any($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:anyAttribute($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:appinfo($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:attribute($node as node(), $model as map()) {
    let $required := false()
    let $name := $node/@name/string()
    let $namespace := fn:namespace-uri($node)
    let $type := $node/@type/string()
    let $width := fn:max((          
            xs2svg:calcWidth(15, $name, 2),
            xs2svg:calcWidth(15, $namespace, 0),
            xs2svg:calcWidth(15, $type, 0),
            xs2svg:calcWidth(15, "", 13)
))
    let $x-position := xs:integer($model('x-position'))
    let $y-position := xs:integer($model('y-position'))
    let $new-x-position := map:entry('x-position', $x-position + $width + 45)
    return (
    element { 'g' } {
        attribute { 'id' } { $model('id') },
        attribute { 'class' } { "box" },
        attribute { 'transform' } { 'translate(' || $x-position || ',' || $y-position || ')'},
        element { 'rect' } {
            attribute { 'class' } { 'shadow' },
            attribute { 'x' } { '3' },
            attribute { 'y' } { '3' },
            attribute { 'width' } { $width },
            attribute { 'height' } { $xs2svg:MAX_HEIGHT },      
            attribute { 'rx' } { '9' }
        },
        element { 'rect' } {
            attribute { 'class' } { if ($required) then 'boxattribute1' else 'boxattribute2' },
            attribute { 'x' } { '0' },
            attribute { 'y' } { '0' },
            attribute { 'width' } { $width },
            attribute { 'height' } { $xs2svg:MAX_HEIGHT },
            attribute { 'onmouseover' } { "makeVisible('" || $model('id') || "')" },
            attribute { 'onmouseout' } { "makeHidden('" || $model('id') || "')" }
        },
        if ($namespace)
        then <text class='hidden' visibility='hidden' x='5' y='13'>{$namespace}</text>
        else (),
         if ($name)
         then <text class='strong' x='5' y='27'><tspan class='big'>@</tspan>{$name}</text>
         else (),
         if ($type)
         then <text class='hidden' visibility='hidden' x='5' y='41'>{$type}</text>
         else (),
         if ($required)
         then <text class='visible' x='5' y='41'>use: required"</text>
         else <text class='visible' x='5' y='41'>use: optional"</text>,
        xs2svg:draw-connection($node, $model)
    },
    xs2svg:recurse($node, $model)
    )
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:attributeGroup($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:choice($node as node(), $model as map()) {
    let $cardinality := xs2svg:cardinality($node)
    let $width := xs2svg:calcWidth(15, $cardinality, 0)
    let $x-position := xs:integer($model('x-position'))
    let $y-position := xs:integer($model('y-position'))
    let $new-x-position := map:entry('x-position', $x-position + $width + 45)
    return
    element { 'g' } {
        attribute { 'id' } { $model('id') },
        attribute { 'class' } { "box" },
        attribute { 'transform' } { 'translate(' || $x-position || ',' || $y-position || ')'},
        element { 'rect' } {
            attribute { 'class' } { 'boxcompositor' },
            attribute { 'x' } { '0' },
            attribute { 'y' } { '8' },
            attribute { 'width' } { $width },
            attribute { 'height' } { $xs2svg:MID_HEIGHT },
            attribute { 'rx' } { '9' }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 14 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'class' } { 'empty' },
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 23 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'class' } { 'empty' },
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 32 },
            attribute { 'r' } { 2 }
        },
        element { 'polyline' } {
            attribute { 'points' } { xs:string(($width div 2) - 4) || ',23 ' || xs:string(($width div 2) - 4) || ',23 ' || 
                                     xs:string(($width div 2) + 4) || ',14 ' || xs:string(($width div 2) + 10) || ',14 ' }
        },
        if ($cardinality)
         then <text x='5' y='59'>{$cardinality}</text>
         else (),
        xs2svg:draw-connection($node, $model),
        xs2svg:use($node, map:new(($model, map:entry('width', $width))))
    }
(:    xs2svg:recurse($node, map:new(($model, $new-x-position)))  :)
};

(:~



       Overrides any setting on complexType parent.

: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:complexContent($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:complexType($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:documentation($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:element($node as node(), $model as map()) {
    let $name := $node/@name/string()
    let $namespace := fn:namespace-uri($node)
    let $type := $node/@type/string()
    let $cardinality := xs2svg:cardinality($node)
    let $substitution := ""
    let $width := fn:max((          xs2svg:calcWidth(15, $name, 3),
            xs2svg:calcWidth(15, $namespace, 0),
            xs2svg:calcWidth(15, $type, 0),
            xs2svg:calcWidth(15, $cardinality, 0),
            if ($substitution)
            then xs2svg:calcWidth(15, "", 22)
            else xs2svg:calcWidth(15, "", 11),
            xs2svg:calcWidth(15, $substitution, 8)
))
    let $x-position := xs:integer($model('x-position'))
    let $y-position := xs:integer($model('y-position'))
    let $new-x-position := map:entry('x-position', $x-position + $width + 45)
    return (
    element { 'g' } {
        attribute { 'id' } { $model('id') },
        attribute { 'class' } { "box" },
        attribute { 'transform' } { 'translate(' || $x-position || ',' || $y-position || ')'},
        element { 'rect' } {
            attribute { 'class' } { 'shadow' },
            attribute { 'x' } { '3' },
            attribute { 'y' } { '3' },
            attribute { 'width' } { $width },
            attribute { 'height' } { 46 }            
        },
        element { 'rect' } {
            attribute { 'class' } { 'boxelement' },
            attribute { 'x' } { '0' },
            attribute { 'y' } { '0' },
            attribute { 'width' } { $width },
            attribute { 'height' } { 46 },
            attribute { 'onmouseover' } { "makeVisible('" || $model('id') || "')" },
            attribute { 'onmouseout' } { "makeHidden('" || $model('id') || "')" }
        },
        if ($namespace)
        then <text class='visible' x='5' y='13'>{$namespace}</text>
        else (),
        if ($substitution)
        then (
            <text class='hidden' visibility='hidden' x='5' y='13'>subst.: {$substitution}</text>,
            <text class='hidden' visibility='hidden' x='5' y='41'>nillable: {(:"+(nillable ? "1" : "0") :)1} , abstract: {(:"+(abstr ? "1" : "0") :)1}</text>
             )
        else (
            <text class='hidden' visibility='hidden' x='5' y='13'>nillable: {(: "+(nillable ? "1" : "0") :)1}</text>,
            <text class='hidden' visibility='hidden' x='5' y='41'>abstract: {(: "+(abstr ? "1" : "0") :)1}</text>
             ),
         if ($name)
         then <text class='strong' x='5' y='27'>{$name}</text>
         else (),
         if ($type)
         then <text class='visible' x='5' y='41'>{$type}</text>
         else (),
         if ($cardinality)
         then <text x='5' y='59'>{$cardinality}</text>
         else (),
        xs2svg:draw-connection($node, $model),
        xs2svg:use($node, map:new(($model, map:entry('width', $width))))
    },
    xs2svg:recurse($node, map:new(($model, $new-x-position)))
    )
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:enumeration($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:extension($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


A subset of XPath expressions for use
in fields

A utility type, not for public
use

The following pattern is intended to allow XPath
                           expressions per the same EBNF as for selector,
                           with the following change:
          Path    ::=    ('.//')? ( Step '/' )* ( Step | '@' NameTest ) 
         

 : @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:field($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:fractionDigits($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:group($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:import($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:include($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:key($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:keyref($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:length($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~

          itemType attribute and simpleType child are mutually
          exclusive, but one or other is required
        

 : @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:list($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:maxExclusive($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:maxInclusive($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:maxLength($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:minExclusive($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:minInclusive($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:minLength($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:notation($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:pattern($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:redefine($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~

          base attribute and simpleType child are mutually
          exclusive, but one or other is required
        

 : @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:restriction($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:schema($node as node(), $model as map()) {
    let $new-map := map:new(($model, map:entry('width', 63), map:entry('x-position', 20)))
    return
    (<g id='{$model('id')}' class='box' transform='translate(20,50)'>
        <rect class='boxschema' x='0' y='12' width='63' height='21'/>
        <text x='5' y='27'><tspan class='big'>/ </tspan>schema</text>
        {xs2svg:use($node, map:new(($model, map:entry('width', 63))))}
    </g>,
    xs2svg:recurse($node, $new-map)) 
};

(:~


A subset of XPath expressions for use
in selectors

A utility type, not for public
use

The following pattern is intended to allow XPath
                           expressions per the following EBNF:
          Selector    ::=    Path ( '|' Path )*  
          Path    ::=    ('.//')? Step ( '/' Step )*  
          Step    ::=    '.' | NameTest  
          NameTest    ::=    QName | '*' | NCName ':' '*'  
                           child:: is also allowed
         

 : @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:selector($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:sequence($node as node(), $model as map()) {
    let $cardinality := xs2svg:cardinality($node)
    let $width := xs2svg:calcWidth(15, $cardinality, 0)
    let $x-position := xs:integer($model('x-position'))
    let $y-position := xs:integer($model('y-position'))
    let $new-x-position := map:entry('x-position', $x-position + $width + 45)
    return (
    element { 'g' } {
        attribute { 'id' } { $model('id') },
        attribute { 'class' } { "box" },
        attribute { 'transform' } { 'translate(' || $x-position || ',' || $y-position || ')'},
        element { 'rect' } {
            attribute { 'class' } { 'boxcompositor' },
            attribute { 'x' } { '0' },
            attribute { 'y' } { '8' },
            attribute { 'width' } { $width },
            attribute { 'height' } { $xs2svg:MID_HEIGHT },
            attribute { 'rx' } { '9' }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 14 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 23 },
            attribute { 'r' } { 2 }
        },
        element { 'circle' } {
            attribute { 'cx' } { ($width div 2) + 12 },
            attribute { 'cy' } { 32 },
            attribute { 'r' } { 2 }
        },
        element { 'text' } {
            attribute { 'class' } { 'small' },
            attribute { 'x' } { $width div 2 },
            attribute { 'y' } { 17 },
            '1'
        },
        element { 'text' } {
            attribute { 'class' } { 'small' },
            attribute { 'x' } { $width div 2 },
            attribute { 'y' } { 26 },
            '2'
        },
        element { 'text' } {
            attribute { 'class' } { 'small' },
            attribute { 'x' } { $width div 2 },
            attribute { 'y' } { 35 },
            '3'
        },
        element { 'line' } {
            attribute { 'x1' } { ($width div 2) + 12 },
            attribute { 'y1' } { 14 },
            attribute { 'x2' } { ($width div 2) + 12 },
            attribute { 'y2' } { 32 }
        },
        if ($cardinality)
         then <text x='5' y='52'>{$cardinality}</text>
         else (),
        xs2svg:draw-connection($node, $model),
        xs2svg:use($node, map:new(($model, map:entry('width', $width))))
    },
    xs2svg:recurse($node, map:new(($model, $new-x-position)))  
    )
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:simpleContent($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:simpleType($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:totalDigits($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~

          memberTypes attribute must be non-empty or there must be
          at least one simpleType child
        

 : @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:union($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:unique($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};

(:~


: @author  Auto generated
: @version 1.0
: @param   $node the current node being processed
: @param   $model a map() used for passing additional information between the levels
:)
declare function xs2svg:whiteSpace($node as node(), $model as map()) {
    xs2svg:recurse($node, $model)
};
