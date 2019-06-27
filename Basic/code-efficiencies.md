# Code Efficiencies

**Contains things that allow me to be efficient as a developer that I find over time and stuff that comes up not only frequent but also infrequent worth putting here**

## IntelliJ

Remember that when you are in the IntelliJ Docs, there's a handy dropdown so you can switch between Windows, OS X, and other syntax
So if you're looking at shortcuts in their docs, just switch back and fourth from OS X to Windows or vice versa to see the diff

<img src="/images/intellij-docs-switch-syntax.png" width="200" height="113" title="The Land That Scrum Forgot Keynote">

### Keyboard Shortcuts
For non-mac people just remember this rule of thumb: `Cmd` is `Ctrl` and `Option` is `Shift`

If you do not remember a shortcut for the action you want to use, press `⇧⌘A` (OS X) or `Ctrl+Shift+A` (Windows) to find any action by name

#### Links
[Working with Source Code](https://www.jetbrains.com/help/idea/working-with-source-code.html)

#### Shortcuts

| shortcut| osx | windows | notes |
| --------| --- |-------- |------ |
| collapse all methods                                       | `cmd + shift + - `                             | `ctrl + shift + -` | |
| duplicate a line                                           | `command + d`                                  | `ctrl + d` | |
| find stuff and go to things fast(files, classes, anything) | `shift + command + O` **or** `shift + cmd + a` | `ctrl + shift + a` | |
| clean up code (remove unused imports, etc.)                | `ctrl + option + O`                            |     | |
| Reformat code using whatever linter is setup               | `option + cmd + L`                             |     | |
| Refactor to method                                         | `option + cmd + m`                             |     | |
| complete code or give code completion options              | `option + enter`                             |     | |

## Command-line

#### Keyboard Shortcuts

| shortcut| osx| example |
| --------| ---| ------- |
| `Ctrl + R`       | Search past commands you've typed .  Optional: Keep hitting this command to cycle through previous commands|
| `;` or `&&`      | chain commands | 

![bck-i-search](/images/bck-i-search.gif)

- `rf -r mydir` - remove a folder and all its contents with approval prompt (safer)
- `rf -rf mydir` - remove a folder and all its contents without approval prompt

## Git & Github

### Git Password
your Git password is the generated Personal Access Token found under your repo | **Developer Settings** | **Personal Access Tokens**, not your github website login password


## OS X

#### [Booting](https://www.idownloadblog.com/2016/05/23/mac-startup-key-combinations)
- **Recovery Mode**: start your Mac and hold `cmd` + `R`
- **Recovery Mode over Internet**: start your Mac and hold `Cmd` + `Option` + `R`
- **Startup Manager**: start your Mac and hold `option`
- **Safe Mode**: start your Mac and hold `cmd` + `V`
- **Verbose Mode**: start your Mac and hold `shift`
- **Apple Hardware Test**: start your Mac and hold `D`
- **Apple Hardware Test over the Internet**: start your Mac and hold `option` + `D`
- **Reset PRAM/NVRAM**: start your Mac and hold `cmd` + `option` + `P` + `R`
- **Reset SMC**: start your Mac and hold `shift` + `ctrl` + `option` + `power` for 10 seconds


#### Keyboard Shortcuts

| shortcut                            | example |
| ------------------------------------| ------- |
| `cmd + h`                           | hide window |
| `cmd + shift + q`                   | lock the screen |
| `ctrl + up`                         | open mission control |
| `ctrl + down`                       | exit mission control |
| `ctrl + left`, `ctrl + right`       | mission control - switch between desktops |
| `ctrl + up + space`                 | mission control - pops open the selected desktop |

### Reset OSX Keychain Password
If you get this error while trying to push code to github:

![osxkeychain-git-auth-error](/images/osxkeychain-git-auth-error.jpg)

- Open Keychain Access
- Select Keychains -> login and Category -> Passwords
- Type github.com in search box, you should see an entry (or entries) of Internet Password kind for github.com. Right click & Delete them.
- Go back to terminal and retry the git command that requires the password
- Type in your git username and password when prompted and it should reset the osx keychain with it

