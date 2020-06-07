module HexTest exposing (suite)

import Expect exposing (Expectation)
import HexTools exposing (..)
import Main exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "Points to string"
        [ test "points to string" <|
            \() ->
                pointsToString [ ( 1, 1 ), ( 2, 2 ) ]
                    |> Expect.equal "1,1 2,2"
        ]
