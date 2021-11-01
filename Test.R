# This Script Downloads the Audio Features for 
# the Playlist Top Hits of 1970. The purpose is to
# view the data and see how to select the desired columns
# before making the general script that gets the playlists
# from 1970 to 2019.

# libraries
library(spotifyr)
library(dplyr)

# Get the Access Token
access.token <- get_spotify_access_token(
  client_id = Sys.getenv("SPOTIFY_CLIENT_ID"), 
  client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET")
)

# Top Hits of 1970 ID: 37i9dQZF1DWXQyLTHGuTIz
# user: Spotify

hits.1970 <- get_playlist_audio_features(
  "Spotify", # creator of the playlist
  "37i9dQZF1DWXQyLTHGuTIz", # playlist's id
  authorization = access.token 
)

# write the tibble in a csv
write_csv(hits.1970, "test_hits_1970.csv")

# ******** Getting the playlist's ID with a search query ******** 
# in order to have reproducibility, the ID must be obtained with code, in this 
# case with the function search_spotify() which looks for a playlist info

p.name <- "Top Hits of 1970"
playlists.search <- search_spotify(q = p.name,
                                type = "playlist", authorization = access.token,
                                limit = 1)

# making sure the result is the playlist created by Spotify
playlist.info <- playlists.search %>% 
  filter(owner.display_name=="Spotify" & name == p.name)

playlist.id <- playlist.info$id
playlist.id
