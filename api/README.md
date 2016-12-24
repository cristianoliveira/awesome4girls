# awesome4girls-api [![Build Status](https://travis-ci.org/cristianoliveira/awesome4girls-api.svg?branch=master)](https://travis-ci.org/cristianoliveira/awesome4girls-api)
The [api](https://awesome4girls-api.herokuapp.com/) for the [awesome4girls](https://github.com/cristianoliveira/awesome4girls) project.

## Motivation
Since the beginning of the awesome4girls project I wondered that it will become
a site where you can know more about the projects collected.
This api is the first step to construct the site.

## Main Routes

These are data routes.

| Data      | Route                                | Methods             | Restricted                   |
|-----------|--------------------------------------|---------------------|------------------------------|
|home       | `/`                                  | GET                 | No                           |
|sections   | `/sections`                          | GET/POST/PUT/DELETE | user: POST/PUT/DELETE        |
|subsections| `/sections/1/subsections`            | GET                 | No                           |
|subsections| `/subsections`                       | GET/POST/PUT/DELETE | user: POST/PUT/DELETE        |
|projects   | `/subsections/1/projects`            | GET                 | No                           |
|projects   | `/projects`                          | GET/POST/PUT/DELETE | user: POST/PUT/DELETE        |

## Meta Info

These are auxiliar routes with application meta info.

| Data      | Route                                | Methods             | Restricted                   |
|-----------|--------------------------------------|---------------------|------------------------------|
|users      | `/users`                             | GET/POST/DELETE     | Only Admin                   |
|action     | `/sync`                              | POST                | Only Admin                   |
|dashboard  | `/workers`                           | GET/POST/PUT/DELETE | Only Admin                   |

## Endpoints examples
It uses Basic Authentication so in order to manipulate some data you need
to provide user and password.

Default users:
 - Admin: `admin:admin`
 - Regular: `user:user`

### Users
Users are divided in roles: ADMIN(1), USER(2) and GUEST(3)

Listing:
```bash
curl https://awesome4girls-api.herokuapp.com/users -u admin:admin
```

Get one:
```bash
curl https://awesome4girls-api.herokuapp.com/users/1 -u admin:admin
```

Creating:
```bash
curl -XPOST https://awesome4girls-api.herokuapp.com/users -u admin:admin -d'name=john&password=bla&role=1'
```

Deleting:
```bash
curl -XDELETE https://awesome4girls-api.herokuapp.com/users/:id -u admin:admin
```

### Sections
Sections are the top categories. Like 'Meetups', 'Summits', 'Conferences'

Listing is open and is not required an user
```bash
curl https://awesome4girls-api.herokuapp.com/sections
```

Get one:
```bash
curl https://awesome4girls-api.herokuapp.com/sections/1
```

Creating:
```bash
curl -XPOST https://awesome4girls-api.herokuapp.com/sections -u user:user -d'title=john&description=foo'
```

Updating:
```bash
curl -XPUT https://awesome4girls-api.herokuapp.com/sections/:id -u user:user -d'title=john&description=foo'
```

Deleting:
```bash
curl -XDELETE https://awesome4girls-api.herokuapp.com/sections/:id -u user:user
```

### Subsections
Subsections are related to sections.

Listing is open and is not required an user
```bash
curl https://awesome4girls-api.herokuapp.com/sections/1/susections
```

Get one:
```bash
curl https://awesome4girls-api.herokuapp.com/sections/1/subsections/1
```

Creating:
```bash
curl -XPOST https://awesome4girls-api.herokuapp.com/subsections -u user:user -d'title=john&description=foo'
```

Creating:
```bash
curl -XPUT https://awesome4girls-api.herokuapp.com/subsections/:id -u user:user -d'title=john&description=foo'
```

Deleting:
```bash
curl -XDELETE https://awesome4girls-api.herokuapp.com/subsections/1 -u user:user
```

### Projects
Projects are the main data. It is under Section>Subsection>Projects.

Listing is open and is not required an user
```bash
curl https://awesome4girls-api.herokuapp.com/projects
```

Filtered by subsection:
```bash
curl https://awesome4girls-api.herokuapp.com/subsections/1/projects
```

Get one:
```bash
curl https://awesome4girls-api.herokuapp.com/projects/1
```

Creating:
```bash
curl -XPOST https://awesome4girls-api.herokuapp.com/projects -u user:user -d'title=john&description=foo&language=pt&subsection=1'
```

Deleting:
```bash
curl -XDELETE https://awesome4girls-api.herokuapp.com/projects/1 -u user:user
```

## Setup and Running
It uses Postgres as the main database make sure it has installed.
```bash
make setup
```

The application runs in port 3000 by default.
```bash
make run
```

## Working in progress
  - [x] Docker
  - [x] Api documentation
  - [x] Heroku deploy
  - [ ] Better query on projects data
  - [ ] Ruby client lib
  - [ ] Parser Markdown for updating data
  - [ ] Job for updating data

## Contributing

You can contribute following this simple steps:
   - Fork it!
   - Create your feature branch: `git checkout -b my-new-feature`
   - Commit your changes: `git commit -am 'feature: some feature'`
   - Push to the branch: `git push origin my-new-feature`
   - Make sure the tests are passing. `make test`
   - Submit a pull request

Pull Requests are really welcome! Others support also.

**Pull Request should have unit tests**

We use [semantic commits](https://seesparkbox.com/foundry/semantic_commit_messages)
make sure the commits follow that standard:
```
feat: add hat wobble
^--^  ^------------^
|     |
|     +-> Summary in present tense.
|
+-------> Type: chore, docs, feat, fix, refactor, style, or test.
```

## Code Style

This project uses [Rubocop](https://github.com/bbatsov/rubocop) as a code linter
when contributing make sure you've executed it: `make style`

## License

This project was made under MIT License.
