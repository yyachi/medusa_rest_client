# medusa_rest_client

Provide Ruby API via gem that interacts with Medusa by REST

# Description

This gem allows Ruby developers to programmatically access [Medusa][].

The API is implemented as XML and JSON over HTTP using all four verbs (GET/POST/PUT/DELETE).
Each record has its own URL and is manipulated via API.

[medusa]: https://github.com/misasa/medusa/        "Medusa"

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
