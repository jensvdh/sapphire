# Web Server Project

## Due Date 
Wednesday, February 26, at midnight.

## Overview
The purpose of this project is to write a web server application capable of a subset of the HyperText Transfer Protocol.  You will be provided with a test suite to help drive the development of this application. 

This is a two person team project.  You must get started immediately.

## Submission
A private repository will be created for your team in the class GitHub organization.  You must then download the zip from the class GitHub repository that contains a shell for this assignment: https://github.com/SFSU-CSC-667/server-project.  This zip should be unpacked in the working directory on your development machine.  Once unpacked, you must:

```
git init
git remote add origin git@github.com:SFSU-CSC-667/repository-name.git
```
Note: You must replace the `repository-name` with the repository that was created for you.

A PDF file containing the names of both students on the team, their student number, and the team name in GitHub (which will be provided to you) must be submitted to iLearn before the due date, specified above.  The pdf file should be named using the following convention:

web_server.team_name.submission_month.submission_day.pdf

For example, my submission would be named web_server.ws0.2.26.pdf. Anything other than a pdf file will not be graded, which means it will receive a ZERO. In addition, the project will be graded by whichever is latest: the submission date and time of this pdf file, or the last commit date and time in your team repository.

Please take care to properly format your code so that it is easily readable by a human. Presentation counts!



## Requirements
See Getting Started for instructions on setting up your workspace.
Ensure that you have jruby installed - the .ruby-version file specifies jruby, so your RVM or RBENV should let you know what to do if jruby is not available.
Implement according to the attached specification.

## Grading Policy
As a reminder, any student found cheating on their project will receive a zero, and be reported to the department for possible disciplinary action.  Any sharing of github repositories outside of your team will be considered cheating.

For this assignment, the standard late policy will apply.

## Specification
The test suite contains unit tests for individual objects in the project skeleton.  The minimum requirement is that all tests in the test suite pass, which may mean that you are required to implement specific classes and methods.  You may add any additional objects or methods you think necessary for your implementation; I provided a small subset of my code in order to get you started.

Generally, this project can be divided into the following milestones:

1. Read standard configuration files for use in responding to client requests
1. Parse HTTP Requests
1. Generate and send HTTP Responses
1. Respond to multiple simultaneous requests through the use of threads
1. Execute server side processes to handle server side scripts
1. Support simple authentication
1. Support simple caching

### 1. Read Standard Server Configuration
Web Servers typically read in a number of configuration files that define the behavior of the server, as well as the types of requests that the server can respond to.  Your web server must read two common file formats (the files have been copied from an Apache Web Server application): httpd.conf, and mime.types.

#### httpd.conf 
A file that provides configuration options for the server in a key value formate=, where the first entry on each line is the configuration option, and the second is the configuration value.  The following table lists the httpd.conf keys your web server must support, along with a brief description of the value. 

| Key            | Value 
|----------------|-------
| ServerRoot     | Absolute path to the root of the server installation
| Listen         | Port number that the server will listen on for incoming requests
| DocumentRoot   | Absolute path to the root of the document tree
| LogFile        | Absolute path to the file where logs should be written to
| Alias          | Two values: the first value is a symbolic path, the second value is the absolute path that the symbolic path resolves to
| ScriptAlias    | Two values: the first value is a symbolic path to a script directory, the second value is the absolute path that the symbolic path resolves to, from which scripts will be executed
| AccessFileName | The name of the file that is used to determine whether or not a directory tree requires authentication for access (default is .htaccess)
| DirectoryIndex | One or more filenames to be used as the resource name in the event that a file is not provided explicitly in the request.

#### mime.types
A file that provides a mapping between file extension and mime type.  The server uses this file in order to properly set the Content-Type header in the HTTP Response.  The format of this file is any number of lines, where each line contains the following information:

_mime-type file-extension_

Note that each line could contain any number of file extensions for the given mime type (including zero!).

Note:
When parsing either of these files, empty lines, and lines beginning with the comment character, #, should be ignored.

### 2. Parse HTTP Requests
Your server must appropriately respond to the following request methods: **GET**, **HEAD**, **POST**, and **PUT**.  For every header encountered in a request, your server should convert that header to an environment variable.  

The general format of an HTTP Request will be covered in class, and is well documented online.

### 3. Generate and Send HTTP Responses
Your server must be able to generate all of the following response codes: **200**, **201**, **304**, **400**, **401**, **403**, **404**, **500**.  The following headers must be returned in every response: Date and Server.  Note that there are additional headers that must be returned according to the protocol for each of the possible responses (including  Content-Type and Content-Length).

The general format of an HTTP Response will be covered in class, and is well documented online.

### 4. Respond to Multiple Requests Simultaneously (Threaded)
Your server must be able to handle simultaneous requests.  We will discuss strategies for testing this in class.

### 5. Execute Server Scripts
Your server must be able to execute resources that have been requested in a ScriptAlias’ed directory.  You may make use of Ruby’s [IO.popen](http://www.ruby-doc.org/core-2.1.0/IO.html#method-c-popen) method to execute script files, and obtain the results.  We will discuss this further in class.

### 6. Support Simple Authentication
Your server must be able to handle the 401/403 authentication workflow.  Permission to access a given resource will be determined by the presence of the file specified by the AccessFileName directive in the httpd.conf file anywhere in the directory tree of the requested resource.  This file contains directives in key value pairs that specify authentication information for a given set of resources.  The following table lists the .htaccess keys your web server must support, along with a brief description of the value.

| Key          | Value
|--------------|------
| AuthUserFile | Absolute path to the location of the file containing the username and password pairs, in .htpassword format
| AuthType     | The only value you will be required to support is ‘Basic’
| AuthName     | The name that will be displayed in the authentication window provided by clients
| Require      | Specifies the user or group that can access a resource.  valid-user is a special value that indicates that any user listed in the AuthUserFile can access the resource

Note that the authentication workflow requires additional headers (WWW-Authenticate, Authorization).

### 7. Support Simple Caching
Your server must be able to appropriately generate the 304 response.  Note that this requires additional headers (Expires, Age, Last-Modified).

