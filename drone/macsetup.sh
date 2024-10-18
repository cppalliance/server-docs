#!/bin/bash

# Older version, now use bootstrap_mac.sh from https://github.com/CPPAlliance/ansible-dronerunner/blob/master/scripts/bootstrap_mac.sh

set -xe

if [ ! -f /etc/sudoers.d/administrator ]; then
    echo "administrator ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/administrator
    echo "You may need to logout and login again before continuing."
    exit 0
fi

# Install brew
if [ ! -f /usr/local/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew install wget
brew install cmake
brew install lcov
brew install valgrind || true
brew install doxygen
brew install ccache || true
brew install pkg-config

if [[ "$(sw_vers -productVersion)" =~ "10.15" ]] ; then
    sudo xcrun gem install xcode-install --no-document
    xcversion install 10 --no-switch
    xcversion install 10.1 --no-switch
    xcversion install 10.2 --no-switch
    xcversion install 10.3 --no-switch
    xcversion install 11.1 --no-switch
    xcversion install 11   --no-switch
    xcversion install 11.1 --no-switch
    xcversion install 11.2 --no-switch
    xcversion install 11.2.1 --no-switch
    xcversion install 11.3 --no-switch
    xcversion install 11.4 --no-switch
    xcversion install 11.5 --no-switch
    xcversion install 11.6 --no-switch
    xcversion install 11.7 --no-switch
    xcversion install 12   --no-switch
    xcversion install 12.0 --no-switch
    xcversion install 12.1 --no-switch
    xcversion install 12.2 --no-switch
    xcversion install 12.3 --no-switch
    xcversion install 12.4 --no-switch

    cd /Applications

    sudo mv /Library/Developer/CommandLineTools /Library/Developer/CommandLineTools.bck
    sudo xcode-select -switch /Applications/Xcode-11.7.app/Contents/Developer
    sudo xcodebuild -license accept
    sudo xcode-select -switch /Applications/Xcode-12.3.app/Contents/Developer
    sudo xcodebuild -license accept

    brew install bash
fi

if [[ "$(sw_vers -productVersion)" =~ "10.13" ]] ; then
    brew install git
    brew install ruby
    echo 'export PATH="/usr/local/lib/ruby/gems/2.7.0/bin:/usr/local/opt/ruby/bin:$PATH"' >> ~/.profile
    . ~/.profile
    sudo xcrun gem install xcode-install --no-document
    xcversion install 6.4 --no-switch
    xcversion install 7 --no-switch
    xcversion install 7.1 --no-switch
    xcversion install 7.2 --no-switch
    xcversion install 7.3 --no-switch
    xcversion install 8 --no-switch
    xcversion install 8.1 --no-switch
    xcversion install 8.2 --no-switch
    xcversion install 8.3 --no-switch
    xcversion install 8.3.2 --no-switch
    xcversion install 8.3.3 --no-switch
    xcversion install 9 --no-switch
    xcversion install 9.1 --no-switch
    xcversion install 9.2 --no-switch
    xcversion install 9.3 --no-switch
    xcversion install 9.4 --no-switch
    xcversion install 9.4.1 --no-switch

    cd /Applications
    # may not be necessary:
    ln -s Xcode-6.4.app Xcode-6.app
    # one repo references this:
    ln -s Xcode-8.app Xcode-8.0.app

    sudo xcode-select -switch /Applications/Xcode-9.4.1.app/Contents/Developer
    sudo mv /Library/Developer/CommandLineTools /Library/Developer/CommandLineTools.bck
    sudo xcodebuild -license accept
fi

sudo xcrun gem install coveralls-lcov --no-document
sudo xcrun gem install asciidoctor --no-document
sudo xcrun gem install asciidoctor-pdf --no-document
sudo xcrun gem install coderay --no-document

