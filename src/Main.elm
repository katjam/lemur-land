module Main exposing (main)

import Browser
import Dict
import HexTools exposing (..)
import Hexagons.Hex exposing (..)
import Hexagons.Layout exposing (..)
import Hexagons.Map exposing (..)
import Html exposing (..)
import Html.Events
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)


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
    , gameMode : GameMode
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { map = Hexagons.Map.rectangularPointyTopMap 10 10
      , forestCells = []
      , gameMode = SetUp
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDocument : Model -> Browser.Document Msg
viewDocument model =
    { title = "Lemur Land", body = [ view model ] }


type GameMode
    = SetUp
    | Playing


type Msg
    = SetForest Hash
    | SwitchMode
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetForest cell ->
            ( { model | forestCells = model.forestCells ++ [ cell ] }, Cmd.none )

        SwitchMode ->
            ( { model
                | gameMode =
                    if model.gameMode == SetUp then
                        Playing

                    else
                        SetUp
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


renderBoard model =
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
                , if model.gameMode == SetUp then
                    Svg.Events.onClick <| SetForest hexLocation

                  else
                    Svg.Events.onClick <| NoOp
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


modeText model =
    case model.gameMode of
        SetUp ->
            "Press to play"

        Playing ->
            "Press to edit"


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ Html.text "Welcome to Lemur Land!" ]
        , div [] [ button [ Html.Events.onClick SwitchMode ] [ Html.text (modeText model) ] ]
        , div []
            [ Svg.svg
                [ Svg.Attributes.version "1.1"
                , Svg.Attributes.viewBox viewBoxStringCoords
                , Svg.Attributes.width "500px"
                , Svg.Attributes.height "500px"
                ]
                [ renderBoard model ]
            ]
        ]
