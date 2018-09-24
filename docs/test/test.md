# Creative HotHouse iOS Test
This document defines the test for the Creative HotHouse iOS developer role. For this test, you must create a small application according to the requirements described below. The app must be delivered in less than a week after you receive this document. If for any reason you don’t consider it to be enough time, let us know upon receiving this document.

## What to do

You must create a client app to show information about cryptocurrencies, including their price, market cap, volume, etc... In addition to this, the app users must be able to manage their own crypto portfolio.

If you are not familiar with the crypto world you can check the coinmarketcap.com website, which is the most used website to track cryptocurrencies. For instance, you could check information about our J8T token at https://coinmarketcap.com/currencies/jet8/.

## What we expect

We want you to create an iOS app able to download information about cryptocurrencies from an API and show that information in the app. The app must have one view that shows all cryptocurrencies. Each cell of the list must show the name, current price, and percentage change of the cryptocurrency. Feel free to add more information on each cell if you think it is appropriate.

The app must have a second view that shows all the specific details about a cryptocurrency. It must be shown when a user taps on a cryptocurrency from the list. You can put as much information as you want on this view, remember that all available information will be provided by the API. Additionally, and most important, you are required to display historical data of the cryptocurrency price. This information must be displayed on a chart. You can choose which chart is the best one to represent this kind of data and how complex and interactive to the user the chart can be.

Finally, there is a third view which will show the user portfolio. A portfolio is a list of cryptocurrencies a users owns. For each cryptocurrency we must save the amount, the price and the date the user made the trade. The user must be able at least to add cryotocurrencies to its portfolio from the detail view. It is required to show the total price in USD for each cryptocurrency the user owns and for the hole portfolio.

All the details about the API you will be using to fetch and store data can be found on this [link](api_doc.md).

**Guidelines**

- The app must be written in Swift, using latest available version to date.
- The app must work off-line, user has to be able to see information about their portfolio even if there is no Internet connection.
- The app must use Realm database to store data locally.
- You can add any functionality you think is appropriate, but we prefer quality than quantity.
- Libraries are welcome, use Cocoapods, Carthage or Swift Package Manager to import them.
## Deliveries
- We expect you to deliver the app on a public Github repo or inviting us to your private Github repo.
- A few lines explaining what you have developed and the architecture used.
- Any decision taken that you think is of interest.
- The source code must be documented.
## What we will check
- Code quality: we look for good clean code, with good practices and properly documented.
- Architecture: the global architecture of the app is important to us, decisions on how you implemented multi threading, caching systems, layer separation, etc will be really important.
- Design: this is a developer test, not a designer test, so we are not looking for fancy designs, but you should follow the [Apple Human Interface Guidelines](https://developer.apple.com/design/).
