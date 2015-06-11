module Github where
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
import Http exposing (..)
import String exposing (join)
import Task exposing (Task)

-- MODELS

--type alias UserRecord =
--    { id: Int
--    , login: String
--    , avatar_url: String
--    , gravatar_id: String
--    , url: String
--    , html_url: String
--    , followers_url: String
--    , following_url: String
--    , gists_url: String
--    , starred_url: String
--    , subscriptions_url: String
--    , organizations_url: String
--    , repos_url: String
--    , events_url: String
--    , received_events_url: String
--    , type: String
--    , site_admin: Boolean
--    }

--type alias MilestoneSummary =
--    { url: String
--    , html_url: String
--    , labels_url: String
--    , id: Int
--    , number: Int
--    , state: String
--    , title: String
--    , description: String
--    , creator: UserRecord
--    , open_issues: Int
--    , closed_isses: Int
--    , created_at: String
--    , updated_at: String
--    , closed_at: String
--    , due_on: String
--    }

githubApi : String
githubApi =
    "https://api.github.com"

githubApiHeader : (String, String)
githubApiHeader =
    ("Accept", "application/vnd.github.v3+json")

makeUrl : List String -> List (String,String) -> String
makeUrl items params =
    url (join "/" items) params

-- Get milestones list for a given github project
milestones : String -> String -> Task Http.Error String
milestones owner repo =
    Http.getString <|
        makeUrl [githubApi, "repos", owner, repo, "milestones"] []

