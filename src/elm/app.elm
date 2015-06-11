import Github

-- MODEL
type alias Model =
    { milestone: Field.Content
    , serverMilestone: Maybe Github.MilestoneSummary
    }

emptyModel : Model
emptyModel =
    { milestone = ""
    , serverMilestone = Nothing
    }

-- UPDATE
type Update
    = Milestone Field.Content

update : Update -> Model -> Model
update updt model =
    case updt of
        Milestone content ->

-- VIEW
view : (Int,Int) -> Model -> Element
view (w,h) model =
    color charcoal <|
        flow down
        [ spacer w 50
        , container w (h-50) midTop (viewForm model)
        ]

header : Element
header =
  Text.fromString "Review milestone"
    |> Text.height 32
    |> leftAligned

viewForm : Model -> Element
viewForm model =
    color lightGrey <|
      flow down
      [ container 360 60 middle header
      , viewField "Milestone:" model.milestone Milestone
      , viewErrors model
      , container 300 50 midRight <|
          size 60 30 <|
            Input.button (Signal.message updateChan.address Submit) "Submit"
      ]

viewField : String -> Field.Content -> (Field.Content -> Update) -> Element
viewField label content toUpdate =
  flow right
    [ container 140 36 midRight (show label)
    , container 220 36 middle <|
        size 180 26 <|
          Field.field Field.defaultStyle (Signal.message updateChan.address << toUpdate) "" content
    ]



-- SIGNALS

updateChan : Signal.Mailbox Update
updateChan =
  Signal.mailbox Submit

