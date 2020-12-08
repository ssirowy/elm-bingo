module Bingo exposing (main)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List exposing (map, member)
import List.Extra exposing (remove)
import Random exposing (generate)
import Random.List exposing (shuffle)


type alias BingoEntry =
    String


type alias BingoEntries =
    List BingoEntry


type alias Model =
    { tiles : BingoEntries
    , selected : BingoEntries
    }


type Msg
    = GenerateBingoTiles
    | ShuffleEntries BingoEntries
    | ToggleTile BingoEntry


allEntries : BingoEntries
allEntries =
    [ "Krishna Starbucks reference"
    , "\"You're on mute\""
    , "Richard use crab emoji"
    , "Someone finishes their demo in < 30 seconds"
    , "Someone takes longer than 5 minutes to complete demo"
    , "Someone's animal shows up in frame"
    , "Someone's kid shows up in frame"
    , "\"From the bottom of my heart\""
    , "Someone writes a pun in Meet chat"
    , "Someone joins 10 minutes late"
    , "Someone isn't prepared to demo and is skipped"
    , "\"Woohoo!!\""
    , "\"Woohoo!!\" Anyone BUT Katie (and not you)"
    , "Someone (not you) demos from the Dashboards team"
    , "Someone (not you) demos from the Explore team"
    , "Someone (not you) demos from the Integrated Experiences team"
    , "Someone (not you) demos from the Discovery and Navigation team"
    , "Someone (not you)  demos from the Mobile team"
    , "At least 5 people are using the blurred background effect"
    , "The demoer (not you) started at Looker in 2020"
    , "A designer demos something"
    , "Someone is visibly eating their lunch"
    , "Someone is enjoying a potent potable"
    , "This is a demoer's first time demoing in front of group"
    , "Demoer indicates which team they work on (e.g \"I am on the explore team\")"
    , "Ronaldo shows up"
    , "There are more than 30 people in attendance"
    , "I am a demoer"
    , "Someone (not you) says \"performance\""
    , "Someone (not you) says \"React\""
    , "Someone (not you) says \"Angular\""
    , "Someone is unable to share their screen"
    , "Kevin has a demo dashboard"
    , "Someone's demo breaks"
    , "A speaker works in the the word \"yummy\" into their demo"
    , "A speaker works in the the word \"indubitably\" into their demo"
    , "A speaker works in the the word \"croissant\" into their demo"
    , "A speaker works in the the phrase \"Ninny Muggins\" into their demo"
    , "Someone who is not on the demo list demos anyway"
    , "There are more than 6 demos"
    , "There are less than 6 demos"
    , "Someone demos 3 or more things in one demo"
    , "Someone's (not yours) background references a meme"
    , "Even number of demos"
    , "Odd number of demos"
    , "Todd plays a sound effect"
    , "There's at least one technical writer in the meeting"
    , "There's at least one quality engineer in the meeting"
    ]


entries : BingoEntries -> BingoEntries
entries =
    List.take 25


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
        ShuffleEntries vals ->
            ( { model | tiles = entries vals }, Cmd.none )

        ToggleTile selected ->
            let
                newSelected =
                    if member selected model.selected then
                        remove selected model.selected

                    else
                        selected :: model.selected
            in
            ( { model | selected = newSelected }, Cmd.none )

        _ ->
            ( model, Cmd.none )


bingoTileView : BingoEntries -> BingoEntry -> Html Msg
bingoTileView selected tile =
    div
        [ class "bingo-tile"
        , class
            (if member tile selected then
                "selected"

             else
                "unselected"
            )
        , onClick <| ToggleTile tile
        ]
        [ text tile ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Bingo" ]
        , div [ class "bingo-card" ] (map (bingoTileView model.selected) model.tiles)
        ]
