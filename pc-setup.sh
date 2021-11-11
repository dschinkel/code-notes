# this script may not be completely working yet, I started it
# Need to try this on a fresh instance of OS X and then fix this script, make it fully work

# brew search <search term> to search for packages

# install HomeBrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/daveschinkel/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew update

xcode-select --install

#oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Enable AppleShowAllFiles
# need to log out and back into OS X after to take effect
# once you log in, you should be able to now see hidden files such as ~/.ssh, ~/.gradle, ~/Library,
#~/.gitconfig, ~/.bash_history, /Users, /usr
defaults write com.apple.finder AppleShowAllFiles TRUE

brew install git
# installing node also installs npm
brew instal node
brew install yarn
brew install brave
brew install curl
brew install wget
brew install iterm
brew install webstorm
#brew install intellij
brew install cleanmymac
brew install boom
brew install slack
brew install keycastr
brew install sublime-text
# blackhole requires entering your mac password
brew install blackhole-2ch
brew install docker
brew instal pgadmin
