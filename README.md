# CSC 667 Web Server Project

In this document we will describe and document our process of bringing this project to a good ending.


## Webserver Setup

We recommend using absolute paths in all the config files!
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

To run the web server (nothing will happen until you implement...):
```
ruby web_server.rb
```

## Extra Developer Notes


### What we completed
We managed to nearly complete all the feature projects. We started of by making sure all the unit tests passed. As of now all the unit tests still pass.

We then added a basic request response cycle. And implemented the 200 status code, followed by the 404, page not found.

After that we started working on authentication. We successfully implemented both the 403 and 401 responses as well as created successful integration with the HtAccess and HtPassword files.

We also implemented caching. The server returns a 304 not modified header for files that have not changed on the server and that have been cached by the browser.

Our server can handle errors both on the request and response side by returning 400 or 500 responses if need be.

We also return the correct 201 header for PUTS requests.

On top of that we successfully added support for CGI scripting. Our server can also successfully pass parameters into the scripts and can parse headers returned from script output.

Last but not least we successfully implemented logging according to the Common Log Format.









### What we failed to do
We believe we have implemented all the required features. However if we had a little bit more time we would have liked to implement the following features:

* Virtual Hosts support
* We did not end up using the Configuration base class. We should have. That would have saved us a lot of code duplication.
* Supporting the connection-keep:alive header coming from browsers. i.e keeping sockets open until no more requests are coming from the client instead of constantly opening and closing new sockets per request/response cycle. This would have improved the performance of our webserver.
We would have loved to have added some  extra unit tests , especially for authentication

### Things we had problems with
Both the authentication and CGI implementations took us a while to figure out. They weren’t specifically hard to implement but there are a lot of different conditions going on and a lot of things to be aware of. Testing step by step was very crucial. Especially with the CGI standard being kind of vague.

We also ran into some very hard to debug multi-threading bugs. For example, instead of copying the default headers over from the Response module, we passed them on by reference. Multiple threads would start modifying each other’s headers which lead to invalid content_length errors and images returning with the text/html mime_type. Considering it was a multi threading bug it took us a long time to figure that out.
We also had to use a mutex to make sure multiple threads were not accessing the same log file at the same time.


### How does our implementation differ?
Our implementation is fairly standard. We passed all the default unit tests provided.

However, we did make some changes to the htaccess and httpd config tests.
We were running into a lot of issues with the “Construct” library, that creates mock files. We ended up rolling our own implementation and manually created files through the default Ruby utilities. This did not really affect the tests nor their outcome but it made our life significantly easier.

We also ended up making some changes in image_test.js. We believe the original implementation was not correctly showing us the multi-threaded implementation. Because our local server was so fast the 7MB PNG would come in really quickly. Because the 7MB PNG was on the DOM it would end up blocking the render thread of the browser, because rendering a massive PNG like that takes at least a full second, even on a fast machine. We ended up just loading the image in memory and just outputted a line of text when it finished loading.

Tools we used for testing and development
We extensively used the Chrome Developer Tools (especially the network request tools). Because they allow us to see the exact requests and headers the browser sends.

These developer tools also allowed us to get a sense of the timing of the network requests. We feel like the Chrome Developer Tools saved us a lot of time.

We also ended up using the Rubymine IDE. We started out using a regular text editor like Sublime Text but we ended up logging too much errors to the console. Rubymine helped us with breakpoints, code completion, runtime expression and a whole slew of other amazing features.

Last but not least we ended up using Postman. Postman is a tool that allows you to make HTTP requests. It’s basically a visual layer on top of CURL. Postman has been really helpful in making the more uncommon requests like PUTS and POST.


