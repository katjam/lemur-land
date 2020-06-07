module HexTools exposing (getCell, getCellKey, mapPolygonCorners, pointsToString, viewBoxStringCoords)

import Hexagons.Hex exposing (..)
import Hexagons.Layout exposing (..)
import Hexagons.Map exposing (..)
import Html exposing (..)
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)


layoutConfig =
    { cellWidth = 20.0
    , cellHeight = 20.0
    , layout =
        { orientation = Hexagons.Layout.orientationLayoutPointy
        , size = ( 20.0, 20.0 )
        , origin = ( 0.0, 0.0 )
        }
    }


viewBoxStringCoords : String
viewBoxStringCoords =
    String.fromFloat (-layoutConfig.cellWidth + layoutConfig.cellWidth * 0.1)
        ++ " "
        ++ String.fromFloat -(layoutConfig.cellHeight + 0)
        ++ " "
        ++ String.fromInt 500
        ++ " "
        ++ String.fromInt 500


mapPolygonCorners : Hex -> List Point
mapPolygonCorners =
    polygonCorners layoutConfig.layout


{-| Helper to convert points to SVG string coordinates
-}
pointsToString : List Point -> String
pointsToString points =
    String.join " " (List.map pointToStringCoords points)


{-| Helper to convert points to SVG string coordinates
-}
pointToStringCoords : Point -> String
pointToStringCoords ( x, y ) =
    String.fromFloat x ++ "," ++ String.fromFloat y


getCell : ( Hash, Hex ) -> Hex
getCell ( key, hex ) =
    hex


getCellKey : ( Hash, Hex ) -> Hash
getCellKey ( key, hex ) =
    key
