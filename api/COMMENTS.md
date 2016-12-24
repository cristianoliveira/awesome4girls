# About the project.

I have another project that is the awesome4girls where I've been collecting
projects and initiatives about diversity. I've decided to created an api
for this project and persist all this data in a Database providing it as
json

## Architecture
 - Framework

 As it is a simple json api and I think it will not grow up to much
 I picked Sinatra because it is simple and robust framework. Also it
 has a good support for extensions.
 Rails is great but I think it is too much for this soluction.

 - Database

 I picked postgress sql cause it is a great opens source SQL database and it
 has a well known integration with ActiveRecord

 - App Structure

 I did it as a MVC Architecture cause it is simple to understand and is good
 for mantaining.

 - Authentication

 It uses the Basic Authentication scheme specified in https://tools.ietf.org/html/rfc2617

- Deploy

 I would like to provide some kind of easy way either to deploy or setup development env.
 I think the better way to do this is through Doker. I am developing it in a OSX
 my experience with osx + docker was not that good but I know they had inprooved so
 I going to try.

 I also deployed on Heroku https://awesome4girl-api.herokuapp.com/

## Conclusion

I took me 2 days to create this API. I know it can be improved with better features
and a better authentication process. It has tests so to improve from here
is easier. Since it is a new api there is no problem in changing its interface
but we can implement a versioned Api.

If I had more time I would implement and job that will insert data periodically or
even better integrate with github to execute the job evey time the repository https://github.com/cristianoliveira/awesome4girls that 
is where the data come from.
