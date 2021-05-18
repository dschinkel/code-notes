# Git - How Tos
# Initial Notes
- Git only records the state of the files when you stage them (with git add) or when you create a commit
- Once you've created a commit which has your project files in a particular state, they're very safe, but until then Git's not really "tracking changes" to your files. (for example, even if you do git add to stage a new version of the file, that overwrites the previously staged version of that file in the staging area.)
- An easier way to think about reset and checkout is through the mental frame of Git being a content manager of three different trees. By “tree” here, we really mean “collection of files”, not specifically the data structure
- `HEAD`
    - the pointer to the current branch reference, which is in turn a pointer to the last commit made on that branch
        - That means HEAD will be the parent of the next commit that is created
    - It’s generally simplest to think of HEAD as the snapshot of your last commit on that branch
    - points to your current branch (or current commit), so all that git reset --hard HEAD will do is to throw away any uncommitted changes you have
- **snapshot**
- **staged**
    - means you did a git add which has added changed files to your local git database (adds it to its index)
- **Index**
    - your proposed next commit
    - We’ve also been referring to this concept as Git’s “Staging Area” as this is what Git looks at when you run git commit
    - Git populates this index with a list of all the file contents that were last checked out into your working directory and what they looked like when they were originally checked out
        - You then replace some of those files with new versions of them, and git commit converts that into the tree for a new commit
    - The index is not technically a tree structure — it’s actually implemented as a flattened manifest — but for our purposes it’s close enough
- **Working Directory**
    - The other two trees store their content in an efficient but inconvenient manner, inside the .git folder
        - The Working Directory unpacks them into actual files, which makes it much easier for you to edit them
    - Think of the Working Directory as a sandbox, where you can try changes out before committing them to your staging area (index) and then to history

# Commands I Use

| git syntax                                                                                | [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh/wiki/Cheatsheet) syntax                         | desc                           |
|:------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------|:------------------------------- |
| git add .                                                                                 | ga .                                                                                                  | updates the index using the current content found in the working tree, to prepare the content staged for the next commit|
| git add -p                                                                                | ga -p                                                                                                 | git add patch mode - walks you through each diff line and lets you accept or deny each change per line.<br> Stated from github docs: Interactively choose hunks of patch between the index and the work tree and add them to the index.  This gives the user a chance to review the difference before adding modified contents to the index|
| git add -i                                                                                | ga -i                                                                                                 | git add interactively - Add modified contents in the working tree interactively to the index|
| git branch                                                                                | gb                                                                                                    | show a list of local branches|
| git checkout <branch name>                                                                | gco <branch name>                                                                                     | switch to a local branch |
| git checkout --track <branch name> (e.g. origin/newsletter)                               | gco --track <branch name>                                                                             | check out a remote branch (creates it locally) already tracked <br>(so you don't have to set that later on your first push) |
| git checkout -                                                                            | gco -                                                                                                 | checkout the previous branch you were just on |
| git branch -D <branch name>                                                               | gb -D <branch name>                                                                                   | delete a local branch |
| git push --delete develop LT-71-end-call                                                  | gp -D develop LT-71-end-call                                                                          | delete a remote branch |
| git config -l                                                                             | gcf l                                                                                                 | show contents of your global gitconfig file |
| git push --set-upstream origin <branch name>                                              | gcf l                                                                                                 | push up a new branch to remote |
| git remote -v                                                                             | gr -v                                                                                                 | show remote branch info |
| git remote add origin [http/ssh...repo url]                                               | gr -v                                                                                                 | ties your local repo to a remote repo |
| git branch -v                                                                             | gr -v                                                                                                 | show local branch info - verbose which includes commit log |
| git clean                                                                                 | gclean                                                                                                | Remove untracked files from the working tree |
| git clean -i                                                                              | gclean -i                                                                                             | checkout the previous branch you were just on |
| git clean -n                                                                              | gclean -n                                                                                             | shows you what will be deleted |
| git clean -f                                                                              | gclean -f                                                                                             | untrack/delete tracked files, not just untracks them |
| git clean -f -d                                                                           | gclean -f -d                                                                                          | untrack/deletes tracked directories |
| git clean -f -x                                                                           | gclean -f -x (our gclean -fx)                                                                         | untrack/delete ignored and non-ignored files |
| git stash                                                                                 | gst                                                                                                   |  Stash the changes in a dirty working directory away |
| git stash save                                                                            | gsta                                                                                                  | like git stash but you can add extra options |
| git stash save "some message"                                                             | gsta "some message"                                                                                   | stash and give it a description so when you list stashes easy to see its state |
| git stash save -u                                                                         | gsta -u                                                                                               | stash untracked files |
| git stash list                                                                            | gst list                                                                                              | show stashes (will show descriptions if you gave them any) |
| git stash show                                                                            | gst show                                                                                              | shows the summary of the stash diffs |
| git stash show --text                                                                     | gsta --text                                                                                           | shows the summary of the stash diffs |
| git stash apply                                                                           | gstaa                                                                                                 | takes the top most stash in the stack and applies it to the repo |
| git stash apply stash@{1}                                                                 | gstaa stash@{1}                                                                                       | apply a specific stash |
| git commit --amend                                                                        | gc --amend                                                                                            | update a commit message if you haven't pushed it yet |
| git log                                                                                   | glg                                                                                                   | see commit history |
| git log --graph                                                                           | glg --graph                                                                                           | adds a nice little ASCII graph showing your branch and merge history |
| git [reset](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset) HEAD       | grh                                                                                                   | the most direct, DANGEROUS, and frequently used option.  Moves the HEAD ref pointer and the current branch ref pointer |
| git reset HEAD --hard                                                                     | grhh                                                                                                  | ref pointers are updated to the specified commit. Then, the Staging Index and Working Directory are reset to match that of the specified commit.<br><br>Any previously pending changes to the Staging Index and the Working Directory gets reset to match the state of the Commit Tree. This means any pending work that was hanging out in the Staging Index and Working Directory will be lost. There is a real risk of losing work with git reset. Git reset will never delete a commit, however, commits can become 'orphaned' which means there is no direct path from a ref to access them. These orphaned commits can usually be found and restored using git reflog.<br><br>Git will permanently delete any orphaned commits after it runs the internal garbage collector. By default, Git is configured to run the garbage collector every 30 days.<br><br>Commit History is one of the 'three git trees' the other two, Staging Index and Working Directory are not as permanent as Commits.<br><br>Care must be taken when using this tool, as it’s one of the only Git commands that have the potential to lose your work |
| git [revert](https://www.atlassian.com/git/tutorials/undoing-changes/git-revert) HEAD     | ??? doesn't seem to be one                                                                            | designed to safely undo a public commit unlike git reset which is designed to undo local changes to the Staging Index and Working Directory.<br><br>Because of their distinct goals, the two commands are implemented differently: resetting completely removes a changeset, whereas reverting maintains the original changeset and uses a new commit to apply the undo |

[deleting a git branch](https://stackoverflow.com/questions/2003505/how-do-i-delete-a-git-branch-locally-and-remotely)

**Note**: The `-d` option is an alias for `--delete`, which only deletes the branch if it has already 
  been fully merged in its upstream branch. You could also use `-D`, which is an alias for 
  `--delete --force`, which deletes the branch "irrespective of its merged status.

[stashing](https://stackoverflow.com/questions/52704/how-do-i-discard-unstaged-changes-in-git)
    - [Useful tricks you might not know about Git stash](https://medium.freecodecamp.org/useful-tricks-you-might-not-know-about-git-stash-e8a9490f0a1a)
[cleaning](https://stackoverflow.com/questions/61212/how-to-remove-local-untracked-files-from-the-current-git-working-tree)

# Most Common Scenarios
**New Local Project - Not Tracked Locally and Needs to be initially Pushed to github or bitbucket**

- `cd existing-project`
- `git init`
- `git add --all`
- `git commit -m "Initial Commit"`
- `git remote add origin https://github.com/dschinkel/rock-paper-scissors-kotlin.git`
- `git push -u origin master`


**Project You've Cloned Down - Already initialized and tracked**

- `cd existing-project`
- `git remote set-url origin https://mygithub/some-repo.git`
- `git push -u origin --all`
- `git push origin --tags`

**Undoing staged Files / Folders**

| Scenario                                                                                        | Resolution            | Command                           |
|:------------------------------------------------------------------------------------------------|:----------------------|:--------------------------------|
| **Undo Staging a folder**  | unstage it and keep the folder on disk <br>*e.g. you forgot to add it to your gitignore* | git rm --cached -r .idea/ <br> adding -r flag will also delete it from disk|
| **Undo Staging a folder**  | unstage it and keep the folder on disk so that it matches HEAD *(the current/latest commit)* | git reset <path>|
| **Undo Staging a file**    | unstage it but keep the file on disk<br>*e.g. you forgot to add it to your gitignore* | git rm <filename> --cached <br> adding -r flag will also delete it from disk |
| **Undo Staging a file**    | unstage it *and* revert the file back to the state it was in before the changes we can use<br>*e.g. you forgot to add it to your gitignore*| git checkout -- <file> |
| **Undo Staging a file**    | unstage it *and* revert it back to the latest commit in the branch<br>*This will unstage the file but maintain the modifications* | git reset HEAD <file> |

**Adding/Removing Remotes**

| Scenario                                                                                                            | Resolution            | Command     |
|:--------------------------------------------------------------------------------------------------------------------|:----------------------|:------------|
| **add a new remote**<br> *when your local repo was just initialized<br> or just doesn't have a remote defined yet*  |  | git remote add origin git@github.com:User/UserRepo.git |
| **change an exiting remote url**  |  | git remote set-url origin git@github.com:User/UserRepo.git|

**Pushing to Remote - First Time**

`git push -u origin master`
- will push your code to the master branch of the remote repository defined with origin and -u let you point your current local branch to the remote master branch

or

`git push -u origin HEAD`
- I use this a lot when I've created a new local branch and want to push code for that branch up to the remote (that's already defined) for the first time.  This'll create the branch on the remote for you.

# Auth
### Authenticating over https
- [create an access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line) -   This is an OAuth token that you will use to auth at the command-line
    - Personal access tokens function like ordinary OAuth access tokens. They can be used instead of a password for Git over HTTPS or can be used to authenticate to the API over Basic Authentication
    - Go to Settings | Developer Settings | Personal Access Tokens
    - Create a key
    - use the key as the password whenever you need to auth for github for the first time on a new PC image
- be sure to also [update your OS X Keychain with it](https://help.github.com/articles/updating-credentials-from-the-osx-keychain):
    - Manually
    - or easier, via command-line just run `git config --global credential.helper osxkeychain` which will prompt you for your next push to github, it'll prompt you for your username and password then saves it once you enter it
    
### Setting up SSH
####1)  First, generate a local ssh key
- `ssh-keygen -t ed25519 -C "dschinkel@gmail.com"`
    - This creates a new ssh key, using the provided email as a label
    - When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.
    - At the prompt, type a [secure passphrase](https://docs.github.com/en/github/authenticating-to-github/working-with-ssh-key-passphrases)
    
####2) Create a Secure Passphrase

With SSH keys, if someone gains access to your computer, they also gain access to every system that uses that key. To add an extra layer of security, you can add a passphrase to your SSH key. You can use ssh-agent to securely save your passphrase so you don't have to reenter it.

Create/Update a passphrase for your ssh key

- `ssh-keygen -p -f ~/.ssh/id_ed25519`
- Now save it to the OS X keychain
    - On Mac OS X Leopard through OS X El Capitan, these default private key files are handled automatically:
      - .ssh/id_rsa
      - .ssh/identity
    - The first time you use your key, you will be prompted to enter your passphrase. If you choose to save the passphrase with your keychain, you won't have to enter it again
    - Otherwise, you can store your passphrase in the keychain when you add your key to the ssh-agent.

####3) Add your key to the SSH Agent
Before adding a new SSH key to the ssh-agent to manage your keys, you should have checked for existing SSH keys and generated a new SSH key

When adding your SSH key to the agent, use the default macOS ssh-add command, and not an application installed by macports, homebrew, or some other external source
  
- **Start the ssh-agent in the background**: `eval "$(ssh-agent -s)"`
- If you're using macOS Sierra 10.12.2 or later, you will need to modify your ~/.ssh/config file to automatically load keys into the ssh-agent and store passphrases in your keychain
    - First, check to see if your ~/.ssh/config file exists in the default location: `open ~/.ssh/config`
    - If the file doesn't exist, create the file: `touch ~/.ssh/config`
- **Open your ~/.ssh/config file**, then modify the file to contain the following lines. If your SSH key file has a different name or path than the example code, modify the filename or path to match your current setup
    - ```Host *
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519```
      
    - Note: If you chose not to add a passphrase to your key, you should omit the UseKeychain line.
    
- **Add your SSH private key to the ssh-agent and store your passphrase in the keychain**: `ssh-add -K ~/.ssh/id_ed25519`
    -  If you created your key with a different name, or if you are adding an existing key that has a different name, replace id_ed25519 in the command with the name of your private key file
    
- Finally, **Add the SSH key to your account on GitHub**

# Errors & Resolutions

`fatal: 'master' does not appear to be a git repository`
`fatal: Could not read from remote repository`
 Resolution: `git pull origin master`

 # Resources
 - [the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)
 - [alebcay/awesome-shell](https://github.com/alebcay/awesome-shell) - curated list of awesome command-line frameworks, toolkits, guides and gizmos
 - [unixorn/awesome-zsh-plugins](https://github.com/unixorn/awesome-zsh-plugins) - collection of ZSH frameworks, plugins, tutorials & themes


# Repo for Scaffolding New Projects

How to take a repo and clone it and use it as a base for a new repo that's unrelated.

We'll take an example using NodeJS scaffolding for katas repo I created which I use to:
- consolidate babel and other settings I routinely setup in projects
- use for quick setup if I want to do a kata

### Steps

1. Delete any existing folders of the repo you're going to use for scaffolding
2. Clone down a new copy of the repo you'll use as scaffolding:
    - `git clone https://github.com/dschinkel/nodejs-kata-scaffolding.git` some-new-project
      - notice here I named the folder as my new repo's name because that's what this folder will end up representing

3. Delete the local git database so we can start fresh. We do not want to retain history of the scaffolding project, we don't care about that for a new project:
    - `cd nodejs-kata-scaffolding`
    - `rm -rf .git`
    - `git init`
4. Now we need to set this local DB again and wire it up to the new repo we'll be using for our project:
- **Add the server so it knows what remote repo to communicate with:**
  - `git remote add origin https://github.com/dschinkel/e1-kata-dry-run.git`
- **Add remote refs**
  - `git remote add e1-kata-dry-run https://github.com/dschinkel/e1-kata-dry-run.git`
5. verify it looks good: `git remote -vv`
Should look like this:
    ```
    e1-kata-dry-run	https://github.com/dschinkel/e1-kata-dry-run.git (fetch)
    e1-kata-dry-run	https://github.com/dschinkel/e1-kata-dry-run.git (push)
    origin	https://github.com/dschinkel/e1-kata-dry-run.git (fetch)Branch 'master' set up to track remote bran
    origin	https://github.com/dschinkel/e1-kata-dry-run.git (push)
    ```
Note: be sure you don't add the remote using ssh which looks like this:
  - `git@github.com:dschinkel/e1-kata-dry-run.git`.  At least in my case I want to auth via https

If you mess any of this up you can always update any of the entries like this:
- `git remote set-url origin https://github.com/dschinkel/e1-kata-dry-run.git`
  - here I updated / corrected the origin url
1. See if you can push something:
Note: I use zsh to shorten git commands

    - `gst` (git status)
    - `ga .` (git add all)
    - `gcmsg "initial commit"`
    - `git push --set-upstream origin master`

if all is good you get a successful push:
```
Counting objects: 16, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (13/13), done.
Writing objects: 100% (16/16), 149.11 KiB | 24.85 MiB/s, done.
Total 16 (delta 0), reused 0 (delta 0)
To https://github.com/dschinkel/e1-kata-dry-run.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
 * 
 ```

# Starting New
### Add a remote repo to your local repo
`git remote add origin [http...your repo url]`
- First you need to create the repo (formally called a "project" on github) on github first manually, OR try some ways below:
- 
#### Create a new _remote_ repository from command-line
##### Try [Binit](https://github.com/theJacobDev/binit)

##### [Creating it using Github API v3](https://developer.github.com/v3/repos/#create)
*Note*: [v4](https://developer.github.com/v4) of the Github Developer API now uses GraphQL.  Prior versions were using REST

- REST
  - to do it with an access token: `curl https://api.github.com/user/repos?access_token=myAccessToken -d '{"name":"REPO"}'`
    - to make it private during creation: `'{"name":"REPO", "private":"true"}'`
      - example: `curl -u 'dschinkel' https://api.github.com/user/repos -d '{"name":"nodejs-kata-scaffolding", "private": "true", "description":"Basic setup of NodeJS: Babel, Mocha, and Jest"}'`
        - Result:
          ![example of a successful auth](https://github.com/WeDoTDD/code-notes/raw/master/images/github-v3-example-successful-project-creation.png)

##### Creating it using using Github API v4 - GraphQL
  - about [creating queries and mutations](https://developer.github.com/v4/guides/forming-calls/#about-query-and-mutation-operations)
    - [example mutation](https://developer.github.com/v4/guides/forming-calls/#example-mutation)
    - [Github's graphql explorer](https://developer.github.com/v4/explorer) - try out graphql calls to the github API OR to explore the API and see what mutations are there, what entities are there, etc.
      - [using the explorer](https://developer.github.com/v4/guides/using-the-explorer/#using-graphiql) - talks about adding your bearer token in the explorer GUI http headers
    - To query GraphQL using cURL, make a POST request with a JSON payload.

    ###### Step 1: Auth into developer API
        ```
        curl -H "Authorization: bearer token" -X POST -d " \
         { \
           \"query\": \"query { viewer { login }}\" \
         } \
        " https://api.github.com/graphql
        ```
      - replace _token_ above with your personal access token

        ![example of a successful auth](https://github.com/WeDoTDD/code-notes/raw/master/images/github-v4-example-successful-auth.png)

    ###### Step 2: Call mutation to [create a new project](https://developer.github.com/v4/mutation/createproject) (repo):
    note: `$ownerId: ID!` is an example of a mutation query variable
          these will be replaced by the query variable/value pairs you
          send in
    ```
    mutation ($ownerId: ID!, $name: String!, $body: String, $clientMutationId: String!) {
      createProject(input: {ownerId: $ownerId, name: $name, body: $body, clientMutationId: $clientMutationId}) {
        project {
          name
          owner {
            ... on Repository {
              name
              owner {
                login
              }
            }
            ... on Organization {
              login
            }
          }
          body
          number
          creator {
            login
          }
          createdAt
          updatedAt
        }
      }
    }
    ```
    Query variables (which will be injected in the above mutation)
    ```
    {
      "ownerId": "???????",
    	"name": "test-github-v4-api",
      "body": "Basic setup of NodeJS: Babel, Mocha, and Jest",
      "clientMutationId": "1234"
    }
    ```

#### Once Created then:
- `touch README.md`
- `git init`
- `git add README.md`
- `git commit -m "first commit"`
- `git remote add origin git@github.com:alexpchin/<reponame>.git`
- `git push -u origin master`

Then push it so it creates the new repo on the remote (github):
- `git remote add origin git@github.com:dschinkel/<reponame>.git`
- `git push -u origin master`

# Forking
A [fork]((https://help.github.com/articles/fork-a-repo)) is a copy of a repository.

- allows you to freely experiment with changes without affecting the original project
- commonly used to either propose changes to someone else's project or to use someone else's project as a starting point for your own idea
- allows you to spawn a new repository from a common ancestor. Forking is essentially the same as cloning with a couple extra steps:
- you can also tell git to sync your fork with the original repo.  So you can pull new changes made in the parent.  So if you have a boilerplate repo you created for all your projects, you can fork it for new projects and have those new projects pull updates if you make changes to the boilerplate
- A brand new repository is created based off the parent
- A new remote repository is added to the new repo to specify the parent project
- once you have forked a repo, you will just clone it down like normal and start working with it

# State
### Switch to a previous state of the repository
`git reset --hard`
- resets the _current branch_
- `hard` - the staged snapshot and the working directory are both updated to match the specified commit.  In this case we're not specifying a specific commit so it's referring the current branch
- throws away all your uncommitted changes so do a git status first to make sure you want to lose what's in your current repo
- `--hard` resets the index and working tree. Any changes to tracked files in the working tree since <commit> are discarded.

`git reset --hard HEAD` -
- `HEAD` - points to the **current branch**
    - so I think this command is the same as above, it infers the current branch

`git reset --hard f414f31` - sets it back to a specific commit where f414f31 is the sha
- this is rewriting the history of your branch, so you should avoid it
- also, the commits you did after f414f31 will no longer be in the history of your master branch
- It's better to create a new commit that represents exactly the same state of the project as f414f31, but just adds that on to the history, so you don't lose any history:
`git reset --hard f414f31`
`git reset --soft HEAD@{1}`
`git commit -m "Reverting to the state of the project at f414f31"`

### Switch to a previous state of the repository

`git checkout <sha>`
`git checkout master` - to get back to latest and out of this state

### Removing uncommitted changes
uncommitted: non-tracked files that have changed but you have not staged them yet (have not done a git add)

`git clean -n` - show what will be deleted
`git clean -f` - this will delete those files

- To remove directories, run `git clean -f -d` or `git clean -fd`
- To `remove` ignored files, run `git clean -f -X` or `git clean -fX`
- To remove ignored and non-ignored files, run `git clean -f -x` or `git clean -fx`

### Renaming a Repository
Scenario: You'd like to rename the remote repository then update your local
to point to that new name

First rename the repository on github via settings

Now update your local to reflect the new name:
- example of updating local repo to sync to new name:
`git remote set-url origin https://github.com/WeDoTDD/react-tdd-redux-e1-react-utils.git`
- verify that it changed: `git remote -v`


# My Rebase Workflow
### General Commands

`git pull`
- this does a `git fetch && git merge` under the hood
    - `fetch` just pulls remote changes into your local repository. It doesn't merge them into any local branch
- use it when I have no local changes but just want to pull latest

`qa!` - exit a rebase
`git rebase --abort` - exit or do a rebase over
`i` - switch to interactive (edit) mode in vim
`esc` - exit interactive mode in vim

### Rebasing Flow
*Note:* if you only did one commit period, and that's the latest then you don't need to rebase, just do a git fetch && git rebase origin/develop

- First make sure I can compile, run lint, run tests
- Find the latest commit: `git log --graph --decorate --pretty=oneline --abbrev-commit`
- rebase interactively based on latest commit (the commit sha before your changes occurred): `git rebase -i <hash of current base commit>`
- `squash` all my commits except for the first
- `esc` - to exit interactive mode after done editing
- `:x!` - to save changes in vim and finish rebasing
- if I mess up, `rebase --edit-todo` or `git rebase --abort` to just cancel the rebase completely and start over
- `git fetch && git rebase origin/develop`  (make sure it's develop or whatever your master is.  If you only work off master make it origin/master)
- `gp -f` (zsh shortcut for git push -f)

# References
- [How do I use 'git reset --hard HEAD' to revert to a previous commit?](https://stackoverflow.com/questions/9529078/how-do-i-use-git-reset-hard-head-to-revert-to-a-previous-commit)
- [Git Tools - Reset Demystified](https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified)
- [Resetting, Checking Out & Reverting - Atlassian](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting)
- [How to remove local (untracked) files from the current Git working tree?](https://stackoverflow.com/questions/61212/how-to-remove-local-untracked-files-from-the-current-git-working-tree)
- [Renaming a repository](https://help.github.com/articles/renaming-a-repository)
- [Changing a remote's URL](https://help.github.com/articles/changing-a-remote-s-url)
- [create a GitHub repo via the command line using the GitHub API](https://stackoverflow.com/questions/2423777/is-it-possible-to-create-a-remote-repo-on-github-from-the-cli-without-opening-br/10325316#10325316)
- [createProject mutation not working?](https://platform.github.community/t/createproject-mutation-not-working/1010)
- [Using a repository's code as a starting point](https://community.atlassian.com/t5/Git-questions/Using-a-repository-s-code-as-a-starting-point/qaq-p/90803)
- [Fork a repo](https://help.github.com/articles/fork-a-repo)
- [Forking Projects](https://guides.github.com/activities/forking)
- [The difference between cloning and forking a repository on GitHub](https://github.community/t5/Support-Protips/The-difference-between-forking-and-cloning-a-repository/ba-p/1372)
- [Duplicating a git repository to another repository - Bitbucket](https://www.ravisagar.in/blog/duplicating-git-repository-another-repository-bitbucket)
- [Help, I keep getting a 'Permission Denied (publickey)' error when I push!](https://gist.github.com/adamjohnson/5682757)
- [Error: Permission denied (publickey)](https://help.github.com/articles/error-permission-denied-publickey)
- [Changing a remote's URL](https://help.github.com/articles/changing-a-remote-s-url)
- [Git Forks And Upstreams: How-to and a cool tip](https://www.atlassian.com/git/articles/git-forks-and-upstreams)
- [3.5 Git Branching - Remote Branches](https://git-scm.com/book/en/v2/Git-Branching-Remote-Branches)
- [hackjutsu/upstream.md](https://gist.github.com/hackjutsu/33b970dd117889485491c018543e5118)
- [How can I tell a local branch to track a remote branch?](https://www.git-tower.com/learn/git/faq/track-remote-upstream-branch)
- [Duplicating a repository](https://help.github.com/articles/duplicating-a-repository)
- [Unstage](https://docs.gitlab.com/ee/university/training/topics/unstage.html)
