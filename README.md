# Installation

Prerequisites

* Ruby (Recommended Version: 2.3.1p112)
* Rails (Recommended Version: 5.0.3)
* PostgreSQL (Recommended Version: 9.5.3)
* Redis server (Recommended Version 3.2.1)

User Defined Gems

* For managing environment variables: figaro
* For creating, editing, listing and showing records: Active Admin
* For external http and https requests: HTTParty
* For background jobs: sidekiq
* Test Suit: rspec

Architecture

a. Models

    * User

        - atttibutes

            1. name

    * Email

        - attributes

            1. address
            2. user_id
            3. verified
            4. resend

        - methods

            1. update_email


b. Controllers

    * EmailsController

        - activate
        - update

c. Jobs

    * EmailJob

        - perform

d. Services

    * Mailgun

        - MailgunEmailData

            1. get_message
            2. get_subject

        - MailgunMessageService

            1. initialize
            2. send_email

        - MailgunSuppressionService

            1. initialize
            2. suppressed?

    * Logging

        - MailgunWebhook

            1. initialize
            2. log
            3. close

Key Decisions

1. Separating the user model from email with expectation that user model will contain more attributes specific to user
   later in the future. Also email contains a lot of attributes which are just specific to some actions on email.

2. Storing a boolean variable in emails table resend which will be true if

    *. user has not clicked the email and
    *. email has not bounced and
    *. email has not unsubscribed and
    *. email has not complained and
    *. resend mail has not been sent,

    this variable is updated through webhooks. In case webhook fails then as fallback check if email is on supression
    list before sending the reminder email. This approach provides a complete solution wherein we are protected againt
    unexpected failure of webhooks also we don't have to make multiple API calls in all the cases, hence saving on rate
    limit Mailgun and memory of web server.

3. Storing the user_id instead of whole user object in redis for jobs. This will again help us save a lot of memory on
   web server.

4. Sending emails asynchronously will improve the performace of create user api.
