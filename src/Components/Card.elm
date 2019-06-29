module Card exposing (view)

import Html exposing (div)
import Html.Attributes exposing (class)



-- VIEW


view children = div [ class "container" ]
  [ div [ class "row justify-content-center" ]
    [ div [ class "card" ]
      [ div [ class "card-body" ]
        children
      ]
    ]
  ]
