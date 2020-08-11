# cloudimage

[![Gem Version](https://badge.fury.io/rb/cloudimage.svg)](https://badge.fury.io/rb/cloudimage) ![Build status](https://github.com/scaleflex/cloudimage-rb/workflows/Build/badge.svg)

`cloudimage` is the official Ruby API wrapper for
[Cloudimage's API](https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/introduction).

Supports Ruby `2.4` and above, `JRuby`, and `TruffleRuby`.

- [cloudimage](#cloudimage)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Hash of params](#hash-of-params)
    - [Chainable helpers](#chainable-helpers)
    - [Method aliases](#method-aliases)
    - [Custom helpers](#custom-helpers)
    - [URL aliases](#url-aliases)
    - [CNAME](#cname)
    - [Optional API version](#optional-api-version)
    - [Security](#security)
      - [URL signature](#url-signature)
      - [URL sealing](#url-sealing)
    - [Invalidation API](#invalidation-api)
  - [Development](#development)
  - [Contributing](#contributing)
  - [License](#license)
  - [Showcase](#showcase)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloudimage'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cloudimage

## Usage

The most common way to use Cloudimage is by means of your customer token. You can
find it within your Admin interface:

![token](docs/token.png)

In order to interact with Cloudimage, we'll first initialize a client service
object:

```ruby
client = Cloudimage::Client.new(token: 'mysecrettoken')
```

Cloudimage client accepts the following options:

| Option                | Type    | Additional info                                                                |
| --------------------- | ------- | ------------------------------------------------------------------------------ |
| `token`               | string  | Required if `cname` is missing.                                                |
| `cname`               | string  | Required if `token` is missing. See [CNAME](#cname).                           |
| `salt`                | string  | Optional. See [Security](#security).                                           |
| `signature_length`    | integer | Optional. Integer value in the range `6..40`. Defaults to 18.                  |
| `sign_urls`           | boolean | Optional. Defaults to `true`. See [Security](#security).                       |
| `aliases`             | hash    | Optional. See [URL aliases](#url-aliases).                                     |
| `api_key`             | string  | Optional. See [Invalidation API](#invalidation-api).                           |
| `include_api_version` | boolean | Optional. Defaults to true. See [Optional API version](#optional-api-version). |

Calling `path` on the client object returns an instance of `Cloudimage::URI`.
It accepts path to the image as a string and we we will use it to build
Cloudimage URLs.

```ruby
uri = client.path('/assets/image.png')
```

Here are some common approaches for constructing Cloudimage URLs using this gem:

### Hash of params

Pass a hash to `to_url`. Every key becomes a param in the final Cloudimage
URL so this gives you the freedom to pass arbitrary params if need be.

```ruby
uri.to_url(w: 200, h: 400, sharp: 1, gravity: 'west', ci_info: 1)
# => "https://mysecrettoken.cloudimg.io/v7/assets/image.png?ci_info=1&gravity=west&h=400&sharp=1&w=200"
```

### Chainable helpers

Every param supported by Cloudimage can be used as a helper method.

```ruby
uri.w(200).h(400).gravity('west').to_url
# => "https://mysecrettoken.cloudimg.io/v7/assets/image.png?gravity=west&h=400&w=200"
```

While every key passed into `to_url` method gets appended to the URL,
chainable helper methods will throw a `NoMethodError` when using an
unsupported method.

```ruby
uri.heigth(200).to_url
# NoMethodError (undefined method `heigth' for #<Cloudimage::URI:0x00007fae461c42a0>)
```

This is useful for catching typos and identifying deprecated methods in
case Cloudimage's API changes.

### Method aliases

The gem comes with a handful of useful aliases. Consult
[`Cloudimage::Params`](lib/cloudimage/params.rb) module for their full list.

```ruby
uri.debug.prevent_enlargement.to_url
# => "https://mysecrettoken.cloudimg.io/v7/assets/image.png?ci_info=1&org_if_sml=1"
```

From the example above you can see that params that only serve as a flag don't
need to accept arguments and will be translated into `param=1` in the final URL.

### Custom helpers

For a list of custom helpers available to you, please consult
[`Cloudimage::CustomHelpers`](lib/cloudimage/custom_helpers.rb) module.

### URL aliases

Specify [aliases](https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/domains-urls/aliases)
to automatically replace parts of path with defined values. Aliases is a hash which
maps strings to be replaced with values to be used instead.

```ruby
my_alias = 'https://store.s3-us-west-2.amazonaws.com/uploads'
client = Cloudimage::Client.new(token: 'token', aliases: { my_alias => '_uploads_' })
client.path('https://store.s3-us-west-2.amazonaws.com/uploads/image.jpg').to_url
# => "https://token.cloudimg.io/v7/_uploads_/image.jpg"
```

[URL prefix](https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/domains-urls/origin-url-prefix)
is just another form of URL alias. Simply make the target value an empty string:

```ruby
prefix = 'https://store.s3-us-west-2.amazonaws.com/uploads/'
client = Cloudimage::Client.new(token: 'token', aliases: { prefix => '' })
client.path('https://store.s3-us-west-2.amazonaws.com/uploads/image.jpg').to_url
# => "https://token.cloudimg.io/v7/image.jpg"
```

### CNAME

If you have a custom CNAME configured for your account, you can
use it to initialize the client:

```ruby
client = Cloudimage::Client.new(cname: 'img.klimo.io')
client.path('/assets/image.jpg').to_url
# => 'https://img.klimo.io/v7/assets/image.jpg'
```

### Optional API version

If your account is configured to work without the API version component in the URL,
you can configure client not to include it in the generated URL:

```ruby
client = Cloudimage::Client.new(cname: 'img.klimo.io', include_api_version: false)
client.path('/assets/image.jpg').to_url
# => "https://img.klimo.io/assets/image.jpg"
```

### Security

#### URL signature

If `salt` is defined, all URLs will be signed.

You can control the length of the generated signature by specifying `signature_length`
when initializing the client.

```ruby
client = Cloudimage::Client.new(token: 'mysecrettoken', salt: 'mysecretsalt', signature_length: 10)
uri = client.path('/assets/image.png')
uri.w(200).h(400).to_url
# => "https://mysecrettoken.cloudimg.io/v7/assets/image.png?h=400&w=200&ci_sign=79cfbc458b"
```

#### URL sealing

Whereas URL signatures let you protect your URL from any kind of
tampering, URL sealing protects the params you specify while making
it possible to append additional params on the fly.

This is useful when working with Cloudimage's
[responsive frontend libraries](https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/responsive-images).
A common use case would be sealing your watermark but letting the
React client request the best possible width.

To seal your URLs, initialize client with `salt` and set
`sign_urls` to `false`. `signature_length` setting is applied
to control the length of the generated `ci_seal` value.

Use the `seal_params` helper to specify which params to seal
as a list of arguments. These could be symbols or strings.

```ruby
client = Cloudimage::Client.new(token: 'demoseal', salt: 'test', sign_urls: false)

client
  .path('/sample.li/birds.jpg')
  .f('bright:10,contrast:20')
  .w(300)
  .h(400)
  .seal_params(:w, :f)
  .to_url
# => "https://demoseal.cloudimg.io/v7/sample.li/birds.jpg?ci_eqs=Zj1icmlnaHQlM0ExMCUyQ2NvbnRyYXN0JTNBMjAmdz0zMDA&ci_seal=67dd8cc44f6ba44ee5&h=400"

# Alternative approach:
client
  .path('/sample.li/birds.jpg')
  .to_url(f: 'bright:10,contrast:20', w: 300, h: 400, seal_params: [:w, :f])
# => "https://demoseal.cloudimg.io/v7/sample.li/birds.jpg?ci_eqs=Zj1icmlnaHQlM0ExMCUyQ2NvbnRyYXN0JTNBMjAmdz0zMDA&ci_seal=67dd8cc44f6ba44ee5&h=400"
```

This approach protects `w` and `f` values from being edited but
makes it possible to freely modify the value of `h`.

### Invalidation API

To access invalidation API you'll need to initialize client with
an API key.

The provided helper methods accept any number of strings:

```ruby
client = Cloudimage::Client.new(token: 'token', api_key: 'key')

# Invalidate original
client.invalidate_original('/v7/image.jpg')

# Invalidate URLs
client.invalidate_urls('/v7/image.jpg?w=200', '/v7/image.jpg?h=300')

# Invalidate all
client.invalidate_all
```

Consult the [API docs](https://docs.cloudimage.io/go/cloudimage-documentation-v7/en/caching-acceleration/invalidation-api)
for further details.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bundle exec rake` to run the tests. You can also run
`bin/console` for an interactive prompt that will allow you to
experiment.

## Contributing

Bug reports and pull requests are welcome. This project is intended
to be a safe, welcoming space for collaboration, and contributors
are expected to adhere to the
[code of conduct](https://github.com/scaleflex/cloudimage-rb/blob/master/CODE_OF_CONDUCT.md).

## License

[MIT](https://opensource.org/licenses/MIT)

## Showcase

Among others, `cloudimage` is used to power the following apps:

- [Robin PRO](https://apps.shopify.com/robin-pro-image-gallery) - Fast, beautiful, mobile-friendly image galleries for Shopify stores.

Using this gem in your app? Let us know in [this issue](https://github.com/scaleflex/cloudimage-rb/issues/8)
so that we can feature it.
