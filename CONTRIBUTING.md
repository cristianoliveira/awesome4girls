# Contribution Guidelines
This project is made under a [Code of
Conduct](https://github.com/cristianoliveira/awesome4girls/blob/master/CODE_OF_CONDUCT.md). By participating you agree to abide by its terms.

----

First of all thanks for contributing.
Please ensure your pull request adheres to the following guidelines (it is enforced by specs):

### About Content

  - Search previous suggestions before making a new one, as yours may be a duplicate.
  - Make sure that your list is useful before submitting which implies that it has enough content and every item has a good description.
  - A link back to this list from yours, so that the users can discover more lists, would be appreciated.
  - Titles should be [capitalized](http://grammar.yourdictionary.com/capitalization/rules-for-capitalization-in-titles.html).
  - The titles must be sorted alphabetically to make easy for searching.
  - Use the following template:

```
  - [Name](link)
(empty line)
    Some awesome description.
(empty line)
```

If it is not an international event/organization (no english version site) use:

```
  - [Name](link) *Loc* <country flag from wikipedia>
(empty line)
    Some awesome description.
(empty line)
```

- Project additions should be added under the relevant category.
- New categories or improvements to the existing categorization are welcome.
- Start the bio with a capital and end with a full stop/period.
- Check your spelling and grammar.
- Make sure your text editor is set to remove trailing whitespace.

#### About Pull Request

- Make an individual pull request for each suggestion.
- The pull request and commit should have a useful title.
Example: `[category]: some description of content added` for other changes please see: [semantic commits](http://seesparkbox.com/foundry/semantic_commit_messages)

#### Specs

Those specs here are enforced through tests. If you want to test your changes before creating your PR do:

```
# Considered you have Ruby(>2.2.0) in your machine.

gem install bundle
bundle install

rake setup && rake
```

Feel free to suggest changes or add more specs.

And finally, Thank so much! for your contribution!!
