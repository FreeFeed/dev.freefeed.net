import Markdown
import Github
import String exposing (join)
import Http exposing (Error)
import Html exposing (Html)
import Task exposing (Task, andThen, onError)

--- test

main : Signal Html
main =
  Signal.map Markdown.toHtml mss.signal

mss : Signal.Mailbox String
mss =
    Signal.mailbox ""

errors : Signal.Mailbox String
errors =
    Signal.mailbox ""

titleOrNothing : Maybe String -> String
titleOrNothing x =
    case x of
        Nothing -> ""
        Just s -> s

port currentMilestone : Task Http.Error ()
port currentMilestone =
    Http.getString "//developer.freefeed.net/current_milestone"

port fetchMilestones : Task Http.Error ()
port fetchMilestones =
    Github.milestones "pepyatka" "pepyatka-html"
    `andThen` \mstones -> Signal.send mss.address <| join ", " <| List.map (\item -> titleOrNothing item.title) mstones
    `onError` \error -> Signal.send errors.address error
