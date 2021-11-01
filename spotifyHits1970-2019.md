Spotify Top Hits from 1970 to 2019
================

## Packages

``` r
library(spotifyr)
library(dplyr)
library(readr)
library(gt)
library(DataExplorer)
```

## Downloading the data

### Authentication

We use the `get_spotify_access_token()` function to get the **Access
Token** with the Spotify Client ID and the Spotify Client Secret.

``` r
access.token <- get_spotify_access_token(
  client_id = Sys.getenv("SPOTIFY_CLIENT_ID"), 
  client_secret = Sys.getenv("SPOTIFY_CLIENT_SECRET")
)
```

### Playlists IDs

The playlists’ names are like “Top Hits of YYYY”, where YYYY refer to
the year. For example for the year 2000 it would be “Top Hits of 2000”.

The years are in the range \[1970, 2019\], let’s make a vector that
stores the names.

``` r
playlists.names <- paste("Top","Hits", "of", as.character(1970:2019)) 
```

In order to get the ID for each playlist, we can use the
`search_spotify()` function to retrieve info about the playlists

``` r
search.response <- lapply(1:length(playlists.names), function(i) {
  search_spotify(q = playlists.names[i], type = "playlist", 
                 authorization = access.token, 
                 limit = 1)
}
)
```

Let’s extract the IDs from the list response and then verify that the
playlists are the ones created by Spotify

``` r
# get the IDs for the elements in the list using lapply
search.response.ID <- lapply(1:length(search.response), function(i){
   # the i-th playlist tibble in the list
   aux.playlist.info <- search.response[[i]]
   # making sure it's the playlist created by Spotify
   aux.playlist.info <- aux.playlist.info %>% 
     filter(name == playlists.names[i] & owner.display_name == "Spotify")
   # get the actual playlist id from the i-th tibble 
   aux.playlist.info[[4]]
}
)

# convert the IDs to character
playlists.IDs <- as.character(unlist(search.response.ID))
head(playlists.IDs, 10)
```

    ##  [1] "37i9dQZF1DWXQyLTHGuTIz" "37i9dQZF1DX43B4ApmA3Ee" "37i9dQZF1DXaQBa5hAMckp"
    ##  [4] "37i9dQZF1DX2ExTChOnD3g" "37i9dQZF1DWVg6L7Yq13eC" "37i9dQZF1DX3TYyWu8Zk7P"
    ##  [7] "37i9dQZF1DX6rhG68uMHxl" "37i9dQZF1DX26cozX10stk" "37i9dQZF1DX0fr2A59qlzT"
    ## [10] "37i9dQZF1DWZLO9LcfSmxX"

### Getting the playlists’ audio features using their Spotify IDs

Now, let’s use `lapply()` again to get the audio features tibbles in a
list

``` r
features.response <- lapply(1:length(playlists.IDs), function(i) {
  get_playlist_audio_features("Spotify", playlists.IDs[i], 
                 authorization = access.token
                 )
}
)
```

Concatenating the tibbles with `bind_rows`

``` r
playlists.features <- bind_rows(features.response)
```

## Verifying the downloaded data

### Counting

The total instances in the dataset

``` r
nrow(playlists.features)
```

    ## [1] 5030

The numbers of songs in each playlist

``` r
# group by playlist and count
playlists.counts <-  playlists.features %>% group_by(playlist_name) %>% summarise(n = n())
gt(playlists.counts)
```

<div id="tdgpyygdmk" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#tdgpyygdmk .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#tdgpyygdmk .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#tdgpyygdmk .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#tdgpyygdmk .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#tdgpyygdmk .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tdgpyygdmk .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#tdgpyygdmk .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#tdgpyygdmk .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#tdgpyygdmk .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#tdgpyygdmk .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#tdgpyygdmk .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#tdgpyygdmk .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#tdgpyygdmk .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#tdgpyygdmk .gt_from_md > :first-child {
  margin-top: 0;
}

#tdgpyygdmk .gt_from_md > :last-child {
  margin-bottom: 0;
}

#tdgpyygdmk .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#tdgpyygdmk .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#tdgpyygdmk .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tdgpyygdmk .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#tdgpyygdmk .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#tdgpyygdmk .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#tdgpyygdmk .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#tdgpyygdmk .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#tdgpyygdmk .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#tdgpyygdmk .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#tdgpyygdmk .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#tdgpyygdmk .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#tdgpyygdmk .gt_left {
  text-align: left;
}

#tdgpyygdmk .gt_center {
  text-align: center;
}

#tdgpyygdmk .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#tdgpyygdmk .gt_font_normal {
  font-weight: normal;
}

#tdgpyygdmk .gt_font_bold {
  font-weight: bold;
}

#tdgpyygdmk .gt_font_italic {
  font-style: italic;
}

#tdgpyygdmk .gt_super {
  font-size: 65%;
}

#tdgpyygdmk .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1">playlist_name</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">n</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">Top Hits of 1970</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1971</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1972</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1973</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1974</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1975</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1976</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1977</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1978</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1979</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1980</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1981</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1982</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1983</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1984</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1985</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1986</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1987</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1988</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1989</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1990</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1991</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1992</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1993</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1994</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1995</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1996</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1997</td>
<td class="gt_row gt_right">99</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1998</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 1999</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2000</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2001</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2002</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2003</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2004</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2005</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2006</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2007</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2008</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2009</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2010</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2011</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2012</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2013</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2014</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2015</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2016</td>
<td class="gt_row gt_right">130</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2017</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2018</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">Top Hits of 2019</td>
<td class="gt_row gt_right">100</td></tr>
    <tr><td class="gt_row gt_left">NA</td>
<td class="gt_row gt_right">1</td></tr>
  </tbody>
  
  
</table>
</div>

We can see that there’s one missing value in the `playlist_name` column.
Let’s locate it.

``` r
index.na <- which(is.na(playlists.features$playlist_name))
print(paste("The row of the missing playlist:",index.na))
```

    ## [1] "The row of the missing playlist: 2780"

``` r
print(playlists.features[(index.na-2):(index.na+2), c(2,6:16)])
```

    ## # A tibble: 5 × 12
    ##   playlist_name    danceability energy   key loudness  mode speechiness
    ##   <chr>                   <dbl>  <dbl> <int>    <dbl> <int>       <dbl>
    ## 1 Top Hits of 1997        0.674  0.789     8    -6.90     1      0.0676
    ## 2 Top Hits of 1997        0.789  0.412     7    -7.52     1      0.243 
    ## 3 <NA>                   NA     NA        NA    NA       NA     NA     
    ## 4 Top Hits of 1997        0.225  0.875    11    -3.28     0      0.0458
    ## 5 Top Hits of 1997        0.663  0.925     9    -6.78     1      0.0449
    ## # … with 5 more variables: acousticness <dbl>, instrumentalness <dbl>,
    ## #   liveness <dbl>, valence <dbl>, tempo <dbl>

The missing row belongs to the 1997 playlist, but since all the audio
features are missing let’s remove it.

``` r
playlists.features <- playlists.features[-index.na,]
paste("rows:",nrow(playlists.features))
```

    ## [1] "rows: 5029"

``` r
paste("missing values in playlist_name column:" , 
      sum(is.na(playlists.features$playlist_name)))
```

    ## [1] "missing values in playlist_name column: 0"

## Selecting the audio features columns in the data

### Backup

Making a backup for the tibble in an `.rda`file, which can be later
imported into an R session with `readRDS()` function.

``` r
saveRDS(playlists.features, "playlist_features.rds")
```

### Columns

Now, there may be more missing values in other columns, but before
checking that, let’s select the columns that contain the audio features
fisrt.

It’s important to mention that not all the columns are for audio
features, some are for IDs or metadata like links to the playlist’s
cover images that could be useful for a dashboard.

The columns that will be extracted are

``` r
columns.features <- c("playlist_id", "playlist_name", "playlist_img", 
                      "playlist_owner_name", "playlist_owner_id",
                      "danceability", "energy", "key", "loudness", 
                      "mode", "speechiness", "acousticness", "instrumentalness", 
                      "liveness", "valence", "tempo", "track.id",
                      "time_signature", "added_at", "track.artists", 
                      "track.disc_number", "track.duration_ms", "track.explicit",
                      "track.name", "track.popularity",
                      "track.preview_url", "track.type",
                      "track.album.release_date", 
                      "track.album.release_date_precision",
                      "track.album.total_tracks",
                      "track.album.type", "track.album.uri"
                      )
```

Selecting the 32 columns listed above and storing the resulting tibble
in `topHits1970_2019`

``` r
playlists.features.subset <- playlists.features[ ,columns.features]
dim(playlists.features.subset)
```

    ## [1] 5029   32

### Creating a column for the artists’ names

Now, using `glimpse()` to see the data types in the
`playlists.features.subset` tibble

``` r
glimpse(playlists.features.subset)
```

    ## Rows: 5,029
    ## Columns: 32
    ## $ playlist_id                        <chr> "37i9dQZF1DWXQyLTHGuTIz", "37i9dQZF…
    ## $ playlist_name                      <chr> "Top Hits of 1970", "Top Hits of 19…
    ## $ playlist_img                       <chr> "https://i.scdn.co/image/ab67706f00…
    ## $ playlist_owner_name                <chr> "Spotify", "Spotify", "Spotify", "S…
    ## $ playlist_owner_id                  <chr> "spotify", "spotify", "spotify", "s…
    ## $ danceability                       <dbl> 0.443, 0.755, 0.474, 0.598, 0.611, …
    ## $ energy                             <dbl> 0.403, 0.876, 0.473, 0.797, 0.470, …
    ## $ key                                <int> 0, 0, 2, 7, 4, 8, 11, 8, 5, 9, 3, 5…
    ## $ loudness                           <dbl> -8.339, -8.867, -11.454, -6.793, -9…
    ## $ mode                               <int> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1,…
    ## $ speechiness                        <dbl> 0.0322, 0.0362, 0.0601, 0.0332, 0.0…
    ## $ acousticness                       <dbl> 0.631000, 0.357000, 0.545000, 0.042…
    ## $ instrumentalness                   <dbl> 0.00e+00, 5.17e-06, 1.25e-06, 4.07e…
    ## $ liveness                           <dbl> 0.1110, 0.2200, 0.0356, 0.0717, 0.5…
    ## $ valence                            <dbl> 0.410, 0.954, 0.561, 0.622, 0.970, …
    ## $ tempo                              <dbl> 143.462, 102.762, 77.583, 123.566, …
    ## $ track.id                           <chr> "7iN1s7xHE4ifF5povM6A48", "6QhXQOpy…
    ## $ time_signature                     <int> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
    ## $ added_at                           <chr> "2021-01-26T11:30:03Z", "2021-01-26…
    ## $ track.artists                      <list> [<data.frame[1 x 6]>], [<data.fram…
    ## $ track.disc_number                  <int> 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    ## $ track.duration_ms                  <int> 243026, 174826, 199266, 147493, 134…
    ## $ track.explicit                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, …
    ## $ track.name                         <chr> "Let It Be - Remastered 2009", "Cec…
    ## $ track.popularity                   <int> 78, 74, 37, 70, 70, 77, 47, 67, 76,…
    ## $ track.preview_url                  <chr> NA, "https://p.scdn.co/mp3-preview/…
    ## $ track.type                         <chr> "track", "track", "track", "track",…
    ## $ track.album.release_date           <chr> "1970-05-08", "1970-01-26", "2014-0…
    ## $ track.album.release_date_precision <chr> "day", "day", "day", "day", "day", …
    ## $ track.album.total_tracks           <int> 12, 11, 87, 14, 12, 12, 120, 12, 12…
    ## $ track.album.type                   <chr> "album", "album", "album", "album",…
    ## $ track.album.uri                    <chr> "spotify:album:0jTGHV5xqHPvEcwL8f6Y…

The `track.artists` column is a list of dataframes, where the artists’
names are other information are stored. Let’s extract those names and
add them to a new column for simplicity in later analysis.

``` r
topHits1970_2019 <- playlists.features.subset %>% 
   mutate(artists.name = lapply(1:nrow(playlists.features.subset), function(i){
      playlists.features.subset$track.artists[[i]][[3]]
   })
   ) %>% 
   mutate(artists.name = as.character(artists.name))
```

### Missing values

Let’s look for missing values one last time before exporting the tibble.

``` r
plot_missing(topHits1970_2019)
```

![](spotifyHits1970-2019_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

The result is that only the column `track.preview_url` has missing
values, the column contains links which open a popup with a 30 min
preview of the track. This is not a problem since it’s not necessary for
the audio analysis.

## Exporting the data to .csv

Finally, let’s save the data in a `.csv` file.

``` r
file.output <- "Spotify_TopHits_of_1970_2019.csv"

if (file.exists(file.output)) {
   print(paste("The file already exists:", file.output))
} else {
   write_csv(topHits1970_2019, file = file.output)
}
```

    ## [1] "The file already exists: Spotify_TopHits_of_1970_2019.csv"

``` r
#write_csv(topHits1970_2019, "Spotify_TopHits_of_1970_2019.csv")
```

So, the file saved has the columns

``` r
glimpse(topHits1970_2019)
```

    ## Rows: 5,029
    ## Columns: 33
    ## $ playlist_id                        <chr> "37i9dQZF1DWXQyLTHGuTIz", "37i9dQZF…
    ## $ playlist_name                      <chr> "Top Hits of 1970", "Top Hits of 19…
    ## $ playlist_img                       <chr> "https://i.scdn.co/image/ab67706f00…
    ## $ playlist_owner_name                <chr> "Spotify", "Spotify", "Spotify", "S…
    ## $ playlist_owner_id                  <chr> "spotify", "spotify", "spotify", "s…
    ## $ danceability                       <dbl> 0.443, 0.755, 0.474, 0.598, 0.611, …
    ## $ energy                             <dbl> 0.403, 0.876, 0.473, 0.797, 0.470, …
    ## $ key                                <int> 0, 0, 2, 7, 4, 8, 11, 8, 5, 9, 3, 5…
    ## $ loudness                           <dbl> -8.339, -8.867, -11.454, -6.793, -9…
    ## $ mode                               <int> 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1,…
    ## $ speechiness                        <dbl> 0.0322, 0.0362, 0.0601, 0.0332, 0.0…
    ## $ acousticness                       <dbl> 0.631000, 0.357000, 0.545000, 0.042…
    ## $ instrumentalness                   <dbl> 0.00e+00, 5.17e-06, 1.25e-06, 4.07e…
    ## $ liveness                           <dbl> 0.1110, 0.2200, 0.0356, 0.0717, 0.5…
    ## $ valence                            <dbl> 0.410, 0.954, 0.561, 0.622, 0.970, …
    ## $ tempo                              <dbl> 143.462, 102.762, 77.583, 123.566, …
    ## $ track.id                           <chr> "7iN1s7xHE4ifF5povM6A48", "6QhXQOpy…
    ## $ time_signature                     <int> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
    ## $ added_at                           <chr> "2021-01-26T11:30:03Z", "2021-01-26…
    ## $ track.artists                      <list> [<data.frame[1 x 6]>], [<data.fram…
    ## $ track.disc_number                  <int> 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
    ## $ track.duration_ms                  <int> 243026, 174826, 199266, 147493, 134…
    ## $ track.explicit                     <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, …
    ## $ track.name                         <chr> "Let It Be - Remastered 2009", "Cec…
    ## $ track.popularity                   <int> 78, 74, 37, 70, 70, 77, 47, 67, 76,…
    ## $ track.preview_url                  <chr> NA, "https://p.scdn.co/mp3-preview/…
    ## $ track.type                         <chr> "track", "track", "track", "track",…
    ## $ track.album.release_date           <chr> "1970-05-08", "1970-01-26", "2014-0…
    ## $ track.album.release_date_precision <chr> "day", "day", "day", "day", "day", …
    ## $ track.album.total_tracks           <int> 12, 11, 87, 14, 12, 12, 120, 12, 12…
    ## $ track.album.type                   <chr> "album", "album", "album", "album",…
    ## $ track.album.uri                    <chr> "spotify:album:0jTGHV5xqHPvEcwL8f6Y…
    ## $ artists.name                       <chr> "The Beatles", "Simon & Garfunkel",…

**Note:** The column `artists.name` contains strings like
`c("artist 1", "artist 2", "artist 3")` when there are multiple artists.
When there’s only one artist it’s just a string like `artist 1`.
