# medusa_rest_client

A series of Ruby interfaces to Medusa

# Description

A series of Ruby interfaces to Medusa.  This gem is a client for
interacting with [Medusa][] by REST.  [Medusa REST API][api] follows
the Rails's RESTful conventions, so this gem uses [ActiveResource][]
to interact with the Medusa REST API.  This gem allows Ruby developers
to programmatically  access the API and provides some useful functions
to manage records on the Medusa programmatically.

[medusa]: https://github.com/misasa/medusa/        "Medusa"
[api]: http://dream.misasa.okayama-u.ac.jp/documentation/MedusaRestAPI/ "Medusa Rest API"
[ActiveResource]: https://github.com/rails/activeresource/ "ActiveResource"
# Installation

Add this line to your application's Gemfile:

    source 'http://devel.misasa.okayama-u.ac.jp/gems/'
    gem 'medusa_rest_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem sources -a http://devel.misasa.okayama-u.ac.jp/gems/
    $ gem install medusa_rest_client

# Commands

No command is installed by this gem but one for debug.

Commands are summarized as:

| command   | description                                       | note  |
|-----------|---------------------------------------------------|-------|
| medusa    | Provide debug console for interaction with Medusa |       |


# Usage

See specfile how to call Ruby API.

Or see online document:

    $ medusa --help
