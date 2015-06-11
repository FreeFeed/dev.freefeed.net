import Markdown
import Github
import Http exposing (Error)
import Html exposing (Html)
import Task exposing (Task, andThen)

--- test

main : Signal Html
main =
  Signal.map Markdown.toHtml mss.signal

mss : Signal.Mailbox String
mss =
    Signal.mailbox ""

port fetchMilestones : Task Http.Error ()
port fetchMilestones =
    Github.milestones "pepyatka" "pepyatka-html" `andThen` Signal.send mss.address

