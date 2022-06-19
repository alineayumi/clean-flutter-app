Feature: Login
As a customer
I want to be able to access my account and remain logged in
So I can quickly see and answer surveys

Scenario: Valid credentials
Given the customer has given valid credentials
When she or he tries to login
Then the system will send the user to the survey screen
And will maintain the user logged in

Scenario: Invalid credentials
Given the customer has given invalid credentials
When she or he tries to login
Then the system should return an error message
