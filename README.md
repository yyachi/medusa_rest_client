# medusa_rest_client

Provide Ruby API via gem that interacts with Medusa by REST

# Description

This gem is a client for interacting with [Medusa][] web service. [Medusa][] provides RESTful [API][api], which is implemented as XML and JSON over HTTP using all four verbs (GET/POST/PUT/DELETE).
This gem allows Ruby developers to programmatically access the [API][].
This gem provides some useful functions to manage records on the Medusa programatically.

[medusa]: https://github.com/misasa/medusa/        "Medusa"
[api]: http://dream.misasa.okayama-u.ac.jp/documentation/MedusaRestAPI/ "Medusa Rest API"
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
