
# Old Dev Build
Outlines the setup I used for Gulp

##### gulpfile.js
```
require('babel-core/register');

var gulp = require('gulp'),
  less = require('gulp-less'),
  uglify = require('gulp-uglify'),
  babel = require("gulp-babel"),
  shell = require('gulp-shell'),
  mocha = require('gulp-mocha'),
  runSequence = require('run-sequence'),
  browserify = require('gulp-browserify'),
  rename = require('gulp-rename'),
  del = require('del');

require('dotenv').config();

const { env } = process;

const config = {
  watch: {
    src: './src/*.js'
  },
  test: {
    path: {
      specs: './test/specs/*-spec.js'
    },
    mocha: {
      reporter: 'spec'
    }
  }
};

gulp.task('precompile', function () {
  return gulp.src('./src/client/less/*.less')
    .pipe(less({
      compress: true
    }))
    .pipe(gulp.dest('./build/client/css'));
});

//---- BUILD ----//
///
gulp.task('build', function (done) {
  runSequence('clean', 'transpile', 'copy:build', done);
});

gulp.task('clean', function () {
  return del(['./build', './dist']);
});

gulp.task('transpile', function () {
  return gulp.src(['./src/**/*.js', '!./src/client/less/*.js'])
    .pipe(babel())
    .pipe(gulp.dest("build"));
});

gulp.task('copy:build', function () {
  return gulp.src(['src/shared/**/*.json']).pipe(gulp.dest('build/shared'));
});

//---- DISTRIBUTE ----//
gulp.task('dist', function (done) {
  runSequence(
    'build',
    'create:dist',
    'copy:build:dist',
    'copy:ext',
    'link',
    'bundle',
    'precompile',
    'copy:data',
    'copy:assets',
    'copy:styles',
    'copy:feed',
    'tar', done);
});

gulp.task('copy:ext', function () {
  return gulp.src(['ext/**/*']).pipe(gulp.dest('dist/client/lib'));
});

gulp.task('copy:data', function () {
  return gulp.src(['src/shared/**']).pipe(gulp.dest('dist/shared'));
});

gulp.task('copy:assets', function () {
  return gulp.src(['src/client/assets/**']).pipe(gulp.dest('dist/client/lib/assets'));
});

gulp.task('copy:styles', function () {
  return gulp.src(['./build/client/css/*.css']).pipe(gulp.dest('dist/client/lib/css'));
});

gulp.task('copy:feed', function () {
  return gulp.src(['feed.xml']).pipe(gulp.dest('dist/client'));
});

gulp.task('copy:build:dist', function () {
  return gulp.src(['build/server.js', 'build/api.js', 'build/shared', 'src/**/index.html', 'package.json']).pipe(gulp.dest('dist'));
});

gulp.task('link', shell.task(['ln -s ' + process.cwd() + '/node_modules ' + process.cwd() + '/dist/node_modules']));

gulp.task('tar', shell.task(['tar -C dist -cf we-do-tdd.tar ./']));

gulp.task('bundle', function () {
  return gulp
    .src('build/client/index.js')
    .pipe(browserify({
      debug: false
    }))
    .pipe(rename('app.bundle.js'))
    .pipe(uglify())
    .pipe(gulp.dest('dist/client/scripts/'));
});


//---- TEST ----//
/*
    Added lint here too because we want to lint on first run of npm test as well
    as setup the watch from here on out on any js changes.

    Watch is configured to run lint  & tests again each time a js file changes
*/
gulp.task('create:dist', function () {
  return gulp.src(['dist/client/scripts'], {}).pipe(gulp.dest('dist/client/scripts'));
});

gulp.task('spec-frontend', function() {
  process.env.PORT = 8001;

  return gulp.src(['build/test/spec/frontend/**/*-spec.js'], {read: false})
    .pipe(mocha({
      reporter: config.test.mocha.reporter,
      ui: 'bdd'
    }));
});

gulp.task('spec-gbbackend', function () {
  process.env.PORT = 8001;
  return gulp.src(['build/test/spec/backend/**/*-spec.js'], {read: false})
    .pipe(mocha({
      reporter: config.test.mocha.reporter,
      ui: 'bdd'
    }));
});

gulp.task('spec-all', function () {
  process.env.PORT = 8001;
  return gulp.src(['build/test/spec/**/*-spec.js'], {read: false})
    .pipe(mocha({
      reporter: config.test.mocha.reporter,
      ui: 'bdd'
    }));
});
```

##### package.json

```
"scripts": {
    "dist": "gulp dist",
    "start": "node dist/server.js",
    "postinstall": "yarn run dist",
    "test-backend": "gulp build && gulp spec-backend",
    "test-frontend": "gulp build && yarn run flow && gulp spec-frontend",
    "test-all": "gulp build && spec-all",
    "build": "NODE_ENV=production gulp build",
    "local": "NODE_ENV=development gulp dist && npm start",
    "pushToGit": "git rebase master && git push origin -f",
    "pushProd": "NODE_ENV=production git push -f && git push production master && heroku logs --tail --app wedotdd",
    "pushStage": "NODE_ENV=staging git checkout master && git pull && git push -f staging master",
    "logStage": "heroku logs --tail --app wedotdd-staging",
    "logProd": "heroku logs --tail --app wedotdd",
    "flow": "flow; test $? -eq 0 -o $? -eq 2",
    "babel-watch": "babel --watch=./src --out-dir=./build",
    "rebase-push": " && git push origin -f",
    "list-remotes-heroku": "git remote -v",
    "list-branches": "git branch -vv",
    "list-remote": "git rev-parse --abbrev-ref --symbolic-full-name @{u} origin/mainline",
    "heroku-cache-off-staging": "heroku config:set NODE_MODULES_CACHE=false --app wedotdd-staging",
    "heroku-cache-off-production": "heroku config:set NODE_MODULES_CACHE=false --app wedotdd",
    "heroku-cache-on-staging": "heroku config:set NODE_MODULES_CACHE=true --app wedotdd-staging",
    "heroku-cache-on-production": "heroku config:set NODE_MODULES_CACHE=true --app wedotdd",
    "heroku-empty-commit-force-build": "git commit --allow-empty -m 'add on-code change to force build'"
  },
  ```
## Final Folder Structure
![webstorm-setup-minimal](/images/build-and-dist-folders.jpg)

## Local
Running the website in development locally on port `8080`

- Sets environment to "development"
- Runs [Dist](#dist) script
- Runs `npm start`

## Dist
Creates the production folder that's distributed to the web server running the site

Copies minimal parts of the build needed to run the site

#### Top Level
Runs the following _in sequence_:

- First it runs the [Build](#build) script
- Runs gulp script `create:dist` - Creates a `./dist` folder
- Runs gulp script `copy:build:dist` - copies certain files from build to dist folder
- Runs gulp script `copy:ext`
- Runs gulp script `link`
- Runs gulp script `bundle`
- Runs gulp script `precompile`
- Runs gulp script `copy:data`
- Runs gulp script `copy:assets`
- Runs gulp script `copy:styles`
- Runs gulp script `copy:feeds`
- Runs gulp script `tar`

#### Low level

##### create:dist
Creates the ./dist folder which is ultimately used to create a .tar off of.  The .tar is then used to package up the distribution and then unpacked on whatever server or image that is used to run the site in production

##### copy:build:dist
Copies the following from **./build** to **./dist**:

- `build/server.js`
- `build/api.js`
- `build/shared`
- `src/**/index.html`
- `package.json`

Result is ./dist has:
```
build
├───shared
├───api.js
├───package.json
├───server.js
```

##### copy:ext
Copies external library files in `./ext` to `dist/client/lib`

Note: jquery is used by [Sapo Ink](http://ink.sapo.pt/)
- Sapo is the UI Element and Bootstrap lib used

Result is ./dist is now:
```
build
├───client
│   └───lib
│       └───ink-3.1.10
│       └───js
│           └───jsjquery-2.2.3.min.js
├───shared
├───api.js
├───package.json
├───server.js
```
##### link
Runs a shell task in order to simlink to node_modules folder
`ln -s ' + process.cwd() + '/node_modules ' + process.cwd() + '/dist/node_modules'`
##### precompile
Compresses site's main .less files in `./src/client/less/*.less` and then copies them to `./build/client/css`
##### copy:data
Copies the site's json db files from `src/shared/**` to `dist/shared`
(doesn't seem to work though, I only see it create a shared folder but copies nothing over to it, but the website is still working, how is that?)

Result is ./dist is now:
```
build
├───client
│   └───lib
│       └───ink-3.1.10
│       └───js
│           └───jsjquery-2.2.3.min.js
├───shared
│   └───data
│       └───companies.json
├───api.js
├───package.json
├───server.js
```

##### copy:assets
Copies image files over to dist.

Copies `src/client/assets/**` to `dist/client/lib/assets`

(doesn't seem to work though, I don't see it create an assets folder, why?)

Result is ./dist is now:
```
build
├───client
│   └───lib
│       └───ink-3.1.10
│       └───js
│           └───jsjquery-2.2.3.min.js
│       └───assets
├───shared
│   └───data
│       └───companies.json
├───api.js
├───package.json
├───server.js
```

##### copy:styles
Copies `/build/client/css/*.css` to `'dist/client/lib/css`

(doesn't seem to work though, I don't see it create a css folder, why?)

Result is ./dist is now:
```
build
├───client
│   └───lib
│       └───ink-3.1.10
│       └───js
│           └───jsjquery-2.2.3.min.js
│       └───assets
├───shared
│   └───data
│       └───companies.json
├───api.js
├───package.json
├───server.js
```

##### copy:feeds
##### tar


## Build

#### Top Level

#### Low Level

## Adding Heroku Remotes
First make sure you're running the latest version of the heroku cli: `heroku update`

**First setup git to always push to heroku staging by default**
`git config heroku.remote staging`
- This will add a section to the project’s .git/config file that looks like this:
    ```
    [heroku]
    remote = staging
    ```
    - this means that all heroku commands will default to the staging app
    - To run a command on the production app, simply use the `--remote production` option

**Now add remotes for my app environments:**
*Note: whenever you add a remote, it names it as heroku, just rename the remote entry to staging or production*

`heroku git:remote -a project`
or
`git remote add <heroku environment name> <heroku app url> `

▶ `git remote add staging https://git.heroku.com/wedotdd-staging.git`

▶ `git remote -v`
```
origin  https://github.com/dschinkel/we-do-tdd.git (fetch)
origin  https://github.com/dschinkel/we-do-tdd.git (push)
staging https://git.heroku.com/wedotdd-staging.git (fetch)
staging https://git.heroku.com/wedotdd-staging.git (push)
```

▶ `git remote add production https://git.heroku.com/wedotdd.git`

▶ `git remote -v`
```
origin  https://github.com/dschinkel/we-do-tdd.git (fetch)
origin  https://github.com/dschinkel/we-do-tdd.git (push)
production      https://git.heroku.com/wedotdd.git (fetch)
production      https://git.heroku.com/wedotdd.git (push)
staging https://git.heroku.com/wedotdd-staging.git (fetch)
staging https://git.heroku.com/wedotdd-staging.git (push)
```

**Removing a remote:** `git remote rm staging`

**Updating a url on a remote:**
`git remote set-url staging https://git.heroku.com/wedotdd-staging.git`

## Pushing Code to Heroku

`git push remote name branch name` - pushes code to heroku
- e.g. git push -f staging master


`heroku git:remote -a we-do-tdd`

## Troubleshooting
If you can't build and dist cleanly first to delete `node_modules`, `dist` folder, `build` folder, and `yarn.lock`
