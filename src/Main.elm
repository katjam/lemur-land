module Main exposing (main)

import Browser
import Dict
import Hexagons.Hex exposing (..)
import Hexagons.Layout exposing (..)
import Hexagons.Map exposing (..)
import Html exposing (..)
import Html.Attributes
import Html.Events
import Json.Decode as Json
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Svg.Lazy exposing (lazy, lazy2, lazy3)
import Task


type alias Flags =
    ()


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = viewDocument
        }


type alias Model =
    { map : Hexagons.Map.Map
    , forestCells : List Hash
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { map = Hexagons.Map.rectangularPointyTopMap 10 10
      , forestCells = []
      }
    , Cmd.none
    )


type Msg
    = SetGreen Hash


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetGreen cell ->
            ( { model | forestCells = model.forestCells ++ [ cell ] }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Lemur Land", body = [ view model ] }


renderHex model =
    let
        toSvg : Hash -> String -> Svg Msg
        toSvg hexLocation cornersCoords =
            g
                []
                (toPolygon hexLocation cornersCoords)

        toPolygon : Hash -> String -> List (Svg Msg)
        toPolygon hexLocation cornersCoords =
            [ polygon
                [ Svg.Attributes.style "cursor: pointer"
                , stroke "#2d68b7"
                , strokeWidth "1px"
                , fill <|
                    if List.member hexLocation model.forestCells then
                        "#006400"

                    else
                        "#d3d3d3"
                , points cornersCoords
                , Svg.Events.onClick <|
                    SetGreen hexLocation
                ]
                []
            ]
    in
    g
        []
    <|
        List.map2 toSvg
            (List.map getCellKey (Dict.toList model.map))
            (List.map (pointsToString << mapPolygonCorners << getCell) (Dict.toList model.map))


cellWidth =
    20.0


cellHeight =
    20.0


layout =
    { orientation = Hexagons.Layout.orientationLayoutPointy
    , size = ( 20.0, 20.0 )
    , origin = ( 0.0, 0.0 )
    }


viewBoxStringCoords : String
viewBoxStringCoords =
    String.fromFloat (-cellWidth + cellWidth * 0.1)
        ++ " "
        ++ String.fromFloat -(cellHeight + 0)
        ++ " "
        ++ String.fromInt 500
        ++ " "
        ++ String.fromInt 500


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


mapPolygonCorners : Hex -> List Point
mapPolygonCorners =
    polygonCorners layout


view : Model -> Html Msg
view model =
    div []
        [ Html.h2 [] [ Html.text "Welcome to Lemur Land!" ]
        , Html.div []
            [ Svg.svg
                [ Svg.Attributes.version "1.1"
                , Svg.Attributes.viewBox viewBoxStringCoords
                , Svg.Attributes.width "500px"
                , Svg.Attributes.height "500px"
                ]
                [ renderHex model ]
            ]
        ]
