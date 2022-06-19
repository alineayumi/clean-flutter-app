# Remote Authentication Use Case

> ## Success case
1. ✅ The system validates data
2. ✅ The system makes a request to the login API's URL
3. The system validates the data received from the API
4. The system delivers the user's account data

> ## Exception - Invalid URL
1. ✅ The system returns an error message
> ## Exception - Invalid data
1. ✅ The system returns an error message
> ## Exception - Invalid answer
1. The system returns an error message
> ## Exception - Server failure
1. ✅ The system returns an error message
> ## Exception - Invalid credentials
1. The system returns an error message informing that the credentials are wrong
