### Install latest Nodejs on Ubuntu22045
* The default version of Nodejs on ubuntu 22045 is 12.22.9 and it is too old to use.
  ```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash # install nvm

  nvm install 22 # install Node.js: 
  node -v        # Should print v22.12.0
  nvm current    # Should print v22.12.0
  npm -v         # Should print 10.9.0
  ```