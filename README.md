# Sapphire Simple HTTP webserver

## Webserver Setup

It is recommended to use paths in all the config files!
There may be some issues with relative paths. Especially in server root and document root.

A sample httpd.conf and htpassword.conf file are provided.

Once your copy of the repo has been created, install the gems specified
in the gem file via bundler:
```
bundle install
```

To run the entire test suite:
```
rspec
```

To run the web server.
```
ruby web_server.rb
```
