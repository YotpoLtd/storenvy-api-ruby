# Storenvy::Api::Ruby


## Installation

Add this line to your application's Gemfile:

    gem 'storenvy-api-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install storenvy-api-ruby

## Usage

This is the flow you need to follow in order to communicate with Storenvy API.

The first thing you wanna do, is to have Storenvy store owners authorize your application.

```ruby

require 'oauth2'


oauth_client = OAuth2::Client.new "app_key",
                                  "secret",
                                  {:site => "https://www.storenvy.com/oauth"}

authorize_uri = oauth_client.authorize_url :redirect_uri => "redirect_url", #must be consistent with the one defined in Storenvy API
                                           :response_type => "code",
                                           :scope => "user store_read store_write",
                                           :client_id => oauth_client.client_credentials.client_params['client_id']

```


The users will be then redirected to the redirect_uri with the oauth2 code, you will need to convert the code to access_token for the future requests we are about to make.

```ruby

oauth_client = OAuth2::Client.new "app_key",
                                  "secret",
                                  {:site => "https://api.storenvy.com/oauth"}

access_token = oauth_client.auth_code.get_token params[:code], {:redirect_uri => redirect_uri}
shop_token = access_token.token

```

That's it, from now on, we will assume you have an access_token for the store your application is going to be integrated in.

What we will do now, is to make some calls to the API. As mentioned before, each such call should get access_token as one of the parameters. Lets get all the shop products.


```ruby

products = []
pagination_argument = nil
begin
  hsh = {:access_token => self.shop_token}
  hsh[pagination_argument[0].to_sym] = pagination_argument[1] if pagination_argument

  tmp_products = Storenvy.get_products hsh
  products += tmp_products.body.data.products

  pagination_argument = tmp_products.body.pagination.next_url.match(/newer_than_id=[0-9]+/).to_s.split("=") if tmp_products.body.pagination.next_url
end while tmp_products.body.data.products.count > 0

```

That's it for now. We would love if you contribute more examples, as well as more functionality to this humble wrapper of us.

We would also love it if some can help us write some tests.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
