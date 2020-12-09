module Bingo exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List exposing (drop, map, member, take)
import List.Extra exposing (remove)
import Random exposing (generate)
import Random.List exposing (shuffle)


type BingoTile
    = FreeTile
    | BingoTile String


type alias BingoTiles =
    List BingoTile


type alias BingoEntries =
    List String


type alias Model =
    { tiles : BingoTiles
    , selected : BingoEntries
    }


type Msg
    = GenerateBingoTiles
    | ShuffleEntries BingoEntries
    | ToggleTile BingoTile


allEntries : BingoEntries
allEntries =
    [ "Krishna Starbucks reference"
    , "Someone talks at length while muted"
    , "Richard use crab emoji"
    , "A demo is less than 30 seconds"
    , "A demo exceeds 5 minutes"
    , "A demo exceeds 10 minutes"
    , "An animal shows up in frame"
    , "Someone's kid shows up in frame"
    , "\"From the bottom of my heart\""
    , "Someone writes a pun in Meet chat"
    , "Someone joins 10 minutes late"
    , "3 people are wearing Looker shirts"
    , "Someone isn't prepared to demo and is skipped"
    , "Katie delivers a \"Woohoo!!\""
    , "\"Woohoo!!\" Anyone BUT Katie (and not you)"
    , "Someone (not you) demos from the Dashboards team"
    , "Someone (not you) demos from the Explore team"
    , "Someone (not you) demos from the IE team"
    , "Someone (not you) demos from the DiscoNav team"
    , "Someone (not you) demos from the Mobile team"
    , "At least 5 people are using a blurred background"
    , "The demoer (not you) started at Looker in 2020"
    , "A designer demos something"
    , "Someone is visibly eating their lunch"
    , "Someone is enjoying a potent potable"
    , "Demoer's first time in front of group"
    , "Demoer indicates which team they work on"
    , "Ronaldo shows up"
    , "A dog barks in the background"
    , "There are more than 30 people in attendance"
    , "I am a demoer"
    , "Someone (not you) says \"performance\""
    , "Someone (not you) says \"React\""
    , "Someone (not you) says \"Angular\""
    , "Someone is unable to share their screen"
    , "Kevin has a demo dashboard"
    , "Someone's demo breaks"
    , "Demoer works the word \"yummy\" into demo"
    , "Demoer works the word \"indubitably\" into demo"
    , "Demoer works the word \"croissant\" into demo"
    , "Demoer works the phrase \"Ninny Muggins\" into demo"
    , "Someone who is not on the demo list demos anyway"
    , "There are more than 6 demos"
    , "There are less than 6 demos"
    , "Someone demos 3 or more things in one demo"
    , "Someone's (not yours) background references a meme"
    , "Even number of demos"
    , "Odd number of demos"
    , "Todd plays a sound effect"
    , "\"Can you see my screen?\""
    , "There's at least one technical writer present"
    , "There's at least one quality engineer present"
    ]


top24Entries : BingoEntries -> BingoEntries
top24Entries =
    take 24


entriesToTiles : BingoEntries -> BingoTiles
entriesToTiles entries =
    let
        top24 =
            top24Entries entries

        top12 =
            take 12 top24

        bottom12 =
            drop 12 top24
    in
    map BingoTile top12 ++ [ FreeTile ] ++ map BingoTile bottom12


initialModel : Model
initialModel =
    { tiles = []
    , selected = []
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, generate ShuffleEntries (shuffle allEntries) )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShuffleEntries entries ->
            ( { model | tiles = entriesToTiles entries }, Cmd.none )

        ToggleTile selected ->
            case selected of
                BingoTile val ->
                    let
                        newSelected =
                            if member val model.selected then
                                remove val model.selected

                            else
                                val :: model.selected
                    in
                    ( { model | selected = newSelected }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


freeTileView : Html Msg
freeTileView =
    div [ class "selected", class "bingo-tile" ] []


bingoTileView : BingoEntries -> BingoTile -> Html Msg
bingoTileView selected tile =
    case tile of
        BingoTile val ->
            div
                [ class "bingo-tile"
                , class
                    (if member val selected then
                        "selected"

                     else
                        "unselected"
                    )
                , onClick <| ToggleTile tile
                ]
                [ text val ]

        FreeTile ->
            freeTileView


view : Model -> Html Msg
view model =
    div []
        [ div [ class "bingo" ]
            [ div [ class "pink" ] [ text "B" ]
            , div [ class "pink" ] [ text "I" ]
            , div [ class "gray" ] [ text "N" ]
            , div [ class "gray" ] [ text "G" ]
            , div [ class "gray" ] [ text "O" ]
            ]
        , div [ class "bingo-card" ] (map (bingoTileView model.selected) model.tiles)
        ]
