module FormatString exposing (isEquelString)

isEquelString : String -> String -> Bool
isEquelString wordOne wordTwo =
  normalizeString wordOne == normalizeString wordTwo

normalizeString : String -> String
normalizeString word =
  (String.toLower >> String.trim) word