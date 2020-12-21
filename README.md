# GitRepos
Git Repos is an app where the user can search for repositories on GitHub. 

## Architecture
This app is using VIPER architecture.

## Github API
The app uses the GitHub API (https://developer.github.com/v3) to fetch repositories and displays the results in an elegant way in a table view.

Each item displays 
- owner's avatar image and the number of followers, 
- repository's full name, description number of watchers and forks.

### Rate Limiting
The app does not implement GitHub Authentication therefore the limits of API requests apply. For unauthenticated requests, the rate limit allows for up to 60 requests per hour. Unauthenticated requests are associated with the originating IP address, and not the user making requests.
For more information please refer to: https://docs.github.com/en/free-pro-team@latest/rest/overview/resources-in-the-rest-api#rate-limiting

## Dependencies
The app uses following external frameworks:
- SwiftLint
- SDWebImage
- JGProgressHUD

## Running the app
- After downloading and unzipping the project, open the Terminal, navigate to the project folder and run "pod install"
- Open the generated GitRepos.xcworkspace file, build and run the project.

## Using the app
- Upon opening the app user will be shown a message that invites them to start typing in the search bar to search for repositories. 
- After user stops typing, the request is sent automatically and the results are displayed. 
- Scrolling through the list will dismiss the keyboard.
- User can search with a diffeent query by again starting to type in the search bar.
- In case there are no results for a given query, the user will be presented with a message inviting them to try a different query.

## Pagination
The app implements pagination. Each request brings 30 results. When user scrolls down to the bottom of the list, the next page of results is fetched and appended to the table view.

## Testing
- UITests were implemented with a code coverage approximatelly 70%

## Screenshots
![start][1]     ![viper][2]     ![swift][3]       ![noresults][4]      


[1]: ./Screenshots/start.png
[2]: ./Screenshots/viper.png
[3]: ./Screenshots/swift.png
[4]: ./Screenshots/noresults.png
