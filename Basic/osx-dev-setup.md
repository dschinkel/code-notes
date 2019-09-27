
# Music
my music collections
- [play lists](https://soundcloud.com/dave-schinkel/sets)
- [play list: fav mixes](https://soundcloud.com/dave-schinkel/sets/fav-mixes) - the one I usually listen to the most

## Commands
- `diskutil list` []( []() ) - lists out all your disk volumes, etc
- `xcode-select --install` - to manually install xcode

## Git Setup
See [Git - How Tos](Git/code-efficiencies.md) which includes setting up Auth for https, ssh, and other "stuff"
## Tools / Apps I Use
- [keycastr](https://github.com/keycastr/keycastr) - Show keystrokes on screen as you type
    - `brew cask install keycastr`
- [spaces-renamer](https://github.com/dado3212/spaces-renamer) - allows you to rename your Mission Control Desktops
- [chrome](https://www.google.com/chrome)
- wget - `brew install wget`
    - test it out: `cd ~/downloads | wget http://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz`
- [iTerm2](https://www.iterm2.com)
    - `cmd -`, `cmd +` to increase or decrease windows size fast
    - [iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes)
        - `CMD+i` (⌘+i) - to get to preferences
        - Schemes I like: [Arthur](https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/Arthur.itermcolors)
- [spectacle](https://github.com/eczarny/spectacle) - very useful for moving, maximizing, resizing, as well as it remembers size of windows really easy and fast
- curl - `brew install curl`
- [Homebrew](https://brew.sh)
    - Install: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
    - If you get this error:
        - `The Mac App Store version of 1Password won't work with a Homebrew-Cask-linked Google Chrome`
        - solve it by running `brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`
- [Homebrew-Cask](https://caskroom.github.io)
    - `brew install caskroom/cask/brew-cask`
- [Google Backup & Sync for Google Drive](https://www.google.com/drive/download/backup-and-sync/)
- [Theine](https://itunes.apple.com/us/app/theine/id955848755?mt=12)
    - keeps your Mac awake. It prevents your Mac from falling asleep, dimming the screen
- [WebStorm IDE](https://www.jetbrains.com/webstorm)
- [IntelliJ IDE](https://www.jetbrains.com/idea/download)
    - [markdown navigator](https://plugins.jetbrains.com/plugin/7896-markdown-navigator) - plugin of choice (not free) for editing or viewing README files
- [iStat menus](https://bjango.com/mac/istatmenus)
- [Final Cut Pro](https://www.apple.com/final-cut-pro/)
- [Motion](https://itunes.apple.com/us/app/motion/id434290957?mt=12)
- [Motion VFX](https://www.motionvfx.com/minstaller) - for downloading and installing motion plugins & templates I buy
- [Camtasia](https://www.techsmith.com/video-editor.html)
- [Boom](https://www.globaldelight.com/boom/index.php) - a great graphic equalizer
- [NTFS for Mac](https://www.paragon-software.com/home/ntfs-mac/)
    - Microsoft NTFS is one of the primary file systems of Windows. If you work on a Mac computer and want to read or write files from HDD, SSD or a flash drive formatted under Windows
- [APFS for Windows](https://www.paragon-software.com/home/apfs-windows/)
    - Apple File System (APFS) is a new file system for macOS, iOS, and other Apple devices. Use this if you work on Windows computer and want to read APFS-formatted HDD, SSD or flash drive
- [Clean My Mac](https://macpaw.com)
- [AutoZapper](https://www.appzapper.com) - a great app uninstaller
- [app cleaner](http://freemacsoft.net/appcleaner/) - good free alternative to AppZapper and also has a builtin app search which is real nice and you can remove built-in Mac apps
- [Slack Desktop](https://slack.com/downloads/osx)
- [Discord](https://discordapp.com)
- [OBS - Open Broadcaster Software](https://obsproject.com/) - for screencasts and streaming live
- [keyCastr](https://github.com/keycastr/keycastr) - when I'm doing screencasts, it shows your keystrokes to the viewers
- [Sublime Text](https://www.sublimetext.com/) - I use it as a scratch pad
- [OneNote](https://www.onenote.com/download)
- [Final Draft](https://www.finaldraft.com/)
- [Elgato Video Capture](https://www.elgato.com/en/video-capture) - for converting old vhs tapes to mp4
- [VLC](https://www.videolan.org/vlc/download-macosx.html)
- [Postman](https://www.getpostman.com)
- [MySQL Workbench](https://www.mysql.com/products/workbench/)
- [MS Office](https://www.microsoft.com/en-us/store/b/office?icid=TopNavSoftwareOffice&activetab=tab%3ahomeorpersonal)
- [Adobe Creative Cloud](https://www.adobe.com/creativecloud.html) - where I download photoshop, illustrator, etc.
- [HandBrake](https://handbrake.fr/)
    - tool for converting video from nearly any format to a selection of modern, widely supported codecs
    - I think I also tried using this to fix OBS mp4 streams that got interrupted/incomplete by system crashes
- [zsh - oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
    
    **First Step is to install zsh itself**
        
     - In order for Oh-My-Zsh to work, Zsh must be installed
        - If you want the latest and greatest, use Homebrew: `brew install zsh zsh-completions`
    - run `zsh --version` to confirm it's installed and it's the latest
    - set zsh to be your shell instead of bash: `chsh -s /bin/zsh`
        - next check what shell your terminal is using by running `echo $SHELL`.  If it's set to bash it'll say `/bin/bash`.  What it should be set to is `/usr/bin/zsh`
    - I usually copy down my [existing .zshrc](https://drive.google.com/open?id=1khpRuhdEQPUHgHGml49O1IbOmLmWLE21) which will be used (sourced) instead of .bashrc
        - now move it to my user folder's root `mv ~/downloads/zshrc ~/`
        - if you ever want to quickly create a new one, run `cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc`
    - change this line in .zshrc with your computer's name so that OS X knows about your zsh installation: 
        - `export ZSH=/Users/david.schinkel/.oh-my-zsh` - here it's david.schinkel but it will depend on whatever computer you are on
    
    **Last step is to install oh-my-zsh**
    - Use curl:
        - `sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"`
        
        or wget: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
        
    - double-check that this path works by cmd + shift + G and paste in the path for ZSH (e.g. `/Users/david.schinkel/.oh-my-zsh/oh-my-zsh.sh`) that you just specified and see if you can even get there in finder, proving it's a valid path
    Open up terminal and type `zsh` and it'll either work or it won't.  If not, you might have your PATH for ZSH wrong
        - See if you can get to it
    - **oh my zsh Themes**: note that I'm using certain zsh theme so the command-line will look different than the default in whatever command-line tool you use.  For example in iTerm since I'm using the robbyrussell theme you'll see the prompt look like **`➜  ~`** now
    - You should be able to open a terminal now and try it out by using `gst` (git status) in iTerm2 or OS X Terminal
        - For JetBrains products like intelliJ, do a command + , to get to preferences, type `terminal` in search, and then change your shell to use `/bin/zsh` instead of `/bin/bash`
            - if you're cd'd to a folder that contains a git repo locally, then you'll see the robbyrussell theme prompt look something like `➜  code-notes git:(master) ✗`
### OS X
- Enable AppleShowAllFiles - `defaults write com.apple.finder AppleShowAllFiles TRUE` then log out and back in and now you should see hidden files such as ~/.ssh, ~/.gradle, ~/Library,
~/.gitconfig, ~/.bash_history, /Users, /usr
##### Creating a Macro to convert .HEIC files
iPhone 10+ creates .HEIC files as their raw format.  You can't use those images in typical apps like OneNote, etc. so you need to convert those to jpg.
There's no built-in way to do this in OSX but you can create your own macro to allow you to.

- here's [how to do that](https://www.howtogeek.com/398927/how-to-convert-heic-images-to-jpg-on-a-mac-the-easy-way) .


## App Specific Setup / Maintenance

### Installs / Update

**[Installing or Reinstalling Windows on Macbook Pro](https://discussions.apple.com/thread/250055471?answerId=250097418022&page=2)**

**xcode**: `xcode-select --install`

**git:** `brew install git` or `brew reinstall git`

**[Docker](https://docs.docker.com/v17.12/docker-for-mac/install/#download-docker-for-mac)**

**Elang**: `brew install erlang erlang@21`

**[Elixir](https://elixir-lang.org/install.html#mac-os-x)**

**[kiex](https://github.com/taylor/kiex)**

**Phoenix**:
- is a [web framework](https://phoenixframework.org/) written in elixir
- Install: First install elixir, then `mix local.hex`

**Postgres**: `brew install postgresql@9.5` (replace with version you want after @)

**Upgrade yarn**: `brew upgrade yarn`

**XCode**: `xcode-select --install`
**Install or Update npm**: `npm install -g npm`

**NodeJS**:
- using [tj/n](https://github.com/tj/n) to install specific version
-  Using brew to install a specific version:
    ```
    □ node --version
    □ brew search node
    □ brew unlink node
    □ brew install node@6
    □ brew link node@6
    □ node --version
    ```

**[Updating Keychain with Git Password](https://help.github.com/articles/updating-credentials-from-the-osx-keychain/)**
