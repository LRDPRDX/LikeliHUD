# Prepare the release

- commit
- change the `package_version` in the rockspec file (and anything else if needed)
- `mv likelihud-A.BC-D likelihud-X.YZ-W`
- `luarocks lint likelihud-X.YZ-W`
- commit
- `git tag -a vX.YZ`
- `git push origin --follow-tags`
- wait for CI to succeed
- upload the new rockspec file onto luarocks

TODO: automate this process

# Fix the release

- commit changes
- `git tag -d vX.YZ`
- `git push origin --delete tag vX.YZ`
- `git tag -a vX.YZ`
- `git push origin --follow-tags`
- wait for CI to succeed
- upload the new rockspec file onto luarocks
