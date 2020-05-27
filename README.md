# Elm project

### Prerequisites
Follow official install instructions for your setup:
- [Elm](http://elm-lang.org/) 0.19
- node
- [Parcel](https:://parceljs.org) Builds and bundles the app, runs dev server.

### Development build
- `npm start` for a hot-reload dev server

### Tests
- `npm test`

### Production build
- `npm run build`

### Deploy to GitHub pages with Travis
We're using [Travis](https://travis-ci.org).
- On every push to the repo, Travis will build and run tests
- To trigger a deploy to gh-pages, create and push a tag (e.g. `git tag v1.0.0 && git push origin --tags`
Encrypted vars can be added to `.travis.yml` using the travis cli tools as decribed in the [travis docs](https://docs.travis-ci.com/user/encryption-keys/#usage).
Currently configured with GITHUB_TOKEN value.
