- commit changes
- change the `package_version` in the rockspec file (and anything else if needed)
- rename the rockspec file
- check it with `luarocks lint <file>`
- commit changes
- add tag
- `git push origin && git push origin --tags`
- wait for CI to succeed
- upload the new rockspec file onto luarocks

TODO: automate this process
