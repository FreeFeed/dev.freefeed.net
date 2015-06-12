module Github (UserRecord, MilestoneSummary, milestones) where
--
-- elm-github
-- json requests to github v3 api
--
-- github notes:
-- Blank fields are included as null instead of being omitted.
-- For unauthenticated requests, the rate limit allows you to make up to 60 requests per hour.
-- If your OAuth application needs to make unauthenticated calls with a higher rate limit,
-- you can pass your app’s client ID and secret as part of the query string.
-- X-RateLimit-Remaining header in response
-- All API requests MUST include a valid User-Agent header.
--
import Http
import String
import Dict
import Task exposing (Task)
import Json.Decode as Json
    exposing (Decoder, Value, int, string, bool, decodeValue, maybe, customDecoder, dict, value)

-- MODELS

type alias UserRecord =
    { id: Maybe Int
    , login: Maybe String
    , avatar_url: Maybe String
    , gravatar_id: Maybe String
    , url: Maybe String
    , html_url: Maybe String
    , followers_url: Maybe String
    , following_url: Maybe String
    , gists_url: Maybe String
    , starred_url: Maybe String
    , subscriptions_url: Maybe String
    , organizations_url: Maybe String
    , repos_url: Maybe String
    , events_url: Maybe String
    , received_events_url: Maybe String
    , type': Maybe String
    , site_admin: Maybe Bool
    }

type alias MilestoneSummary =
    { url: Maybe String
    , html_url: Maybe String
    , labels_url: Maybe String
    , id: Maybe Int
    , number: Maybe Int
    , state: Maybe String
    , title: Maybe String
    , description: Maybe String
    , creator: Maybe UserRecord
    , open_issues: Maybe Int
    , closed_isses: Maybe Int
    , created_at: Maybe String
    , updated_at: Maybe String
    , closed_at: Maybe String
    , due_on: Maybe String
    }

userRecord : Decoder UserRecord
userRecord =
    objectN (\dic ->
        { id = field int "id" dic
        , login = field string "login" dic
        , avatar_url = field string "avatar_url" dic
        , gravatar_id = field string "gravatar_id" dic
        , url = field string "url" dic
        , html_url = field string "html_url" dic
        , followers_url = field string "followers_url" dic
        , following_url = field string "following_url" dic
        , gists_url = field string "gists_url" dic
        , starred_url = field string "starred_url" dic
        , subscriptions_url = field string "subscriptions_url" dic
        , organizations_url = field string "organizations_url" dic
        , repos_url = field string "repos_url" dic
        , events_url = field string "events_url" dic
        , received_events_url = field string "received_events_url" dic
        , type' = field string "type" dic
        , site_admin = field bool "site_admin" dic
        })

milestoneSummary : Decoder MilestoneSummary
milestoneSummary =
    objectN (\dic ->
        { url = field string "url" dic
        , html_url = field string "html_url" dic
        , labels_url = field string "labels_url" dic
        , id = field int "id" dic
        , number = field int "number" dic
        , state = field string "state" dic
        , title = field string "title" dic
        , description = field string "description" dic
        , creator = field userRecord "creator" dic
        , open_issues = field int "open_issues" dic
        , closed_isses = field int "closed_isses" dic
        , created_at = field string "created_at" dic
        , updated_at = field string "updated_at" dic
        , closed_at = field string "closed_at" dic
        , due_on = field string "due_on" dic
        })

githubApi : String
githubApi =
    "https://api.github.com"

githubApiHeader : (String, String)
githubApiHeader =
    ("Accept", "application/vnd.github.v3+json")

makeUrl : List String -> List (String,String) -> String
makeUrl items params =
    Http.url (String.join "/" items) params

-- Get milestones list for a given github project
milestones : String -> String -> Task Http.Error (List MilestoneSummary)
milestones owner repo =
    Http.get (Json.list milestoneSummary) <|
        makeUrl [githubApi, "repos", owner, repo, "milestones"] []

-- elm json decoder supports only up to 8 fields by default
-- use objectN from https://github.com/uehaj/core/commit/3d49629bb0134f54128320bb7f9bf78c545ba864

{-| Helper function to decode object which has more than 8 fields.
-}
field : Decoder a -> String -> Dict.Dict String Value -> Maybe a
field typ fld dic = case (case Dict.get fld dic of
                            Just val -> decodeValue (maybe typ) val
                            Nothing -> Err fld) of
                      Ok res -> res
                      Err _ -> Nothing

{-| Helper function to decode object which has more than 8 fields.

    -- type alias MyData =
    --   { f1 : Maybe String
    --   , f2 : Maybe Int
    --   , f3 : Maybe Float
    --   , f4 : Maybe String
    --   , f5 : Maybe String
    --   , f6 : Maybe String
    --   , f7 : Maybe String
    --   , f8 : Maybe String
    --   , f9 : Maybe String
    --   }
    objectN : (Dict.Dict String Value -> a) -> Decoder a
    objectN f = customDecoder (dict value) (\dic -> Ok(f dic))

    myDataDecoder : Decoder MyData
    myDataDecoder = objectN (\dic ->
                    { f1 = field string "f1" dic
                    , f2 = field int "f2" dic
                    , f3 = field float "f3" dic
                    , f4 = field string "f4" dic
                    , f5 = field string "f5" dic
                    , f6 = field string "f6" dic
                    , f7 = field string "f7" dic
                    , f8 = field string "f8" dic
                    , f9 = field string "f9" dic
                    })
-}
objectN : (Dict.Dict String Value -> a) -> Decoder a
objectN f = customDecoder (dict value) (\dic -> Ok(f dic))
