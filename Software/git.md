
### GitHub
* Push a new local repo to GitHub (Short ver.)
  ```shell
  echo "# test" >> README.md
  git init
  git add README.md
  git commit -m "first commit"                         # record changes 
  git branch -M main                                   # name current branch called main
  git remote add origin git@github.com:xg590/test.git  # give the remote depo git@github.  com:xg590/test.git a shorter REMOTENAME "origin"
  git push -u origin main                              # push current branch to origin
  ```
* Push a new local repo to GitHub (Long full ver.)

  0. Prepare a pair of key on local machine
      ```shell
      ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/github
      ``` 
  1. Sign up an account on github.com
  2. In the setting of your GitHub account, paste the public key.
  3. In terminal, Add new entry in local ~/.ssh/config.
      ```shell
      cat << EOF >> ~/.ssh/config 
      host github.com
          user git 
          port 22
          identityfile ~/.ssh/github
      EOF
      ``` 
  4. In terminal, test a password-free connection to the github.com
      ```shell
      ssh -T github.com
      ```
  * you will get the response "Hi xxx! You've successfully authenticated, but GitHub does not   provide shell access."
  
  5. Install git in terminal
      ```shell
      sudo apt-get/apt-cyg/yum install git
      ```
  6. Configure your local git
      ```shell
      git config --global user.name  "your_name"   # This info is nothing to do with GitHub
      git config --global user.email "your_email"  # This info is nothing to do with GitHub
      ```
  7. Initialize the directory containing to-be-uploaded files
      ```shell
      git init
      ```
  8. Make a test file
      ```shell
      echo "success" > test.txt
      ```
  9. Add the test file to index 
      ```shell
      git add test.txt
      ```
  10. Add the indexed file to HEAD 
      ```shell
      git commit -m "comment to this time of action"
      ```
  11. Create a new repository on Github 
      ```shell
      curl -u 'AccountName' https://api.github.com/user/repos -d '{"name":"NewRepoName"}'
      ```
  * Enter you password
  12. Specify the upload destination
      ```shell
      git remote add just_a_placeholder git@github.com:yourName/NewRepoName.git
      ```
  13. Upload
      ```shell
      git push just_a_placeholder master
      ```
  * ~Done
* [Remove sensitive file](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
  ```
  git clone git@github.com:xg590/IoT.git
  cd IoT/
  git filter-repo --invert-paths --path xxx/xxx/xxx.ipynb 
  git remote add origin git@github.com:xg590/IoT.git
  git push origin --force --all
  ```
* Undo `git add *`
  ```
  git status && git reset && git status
  ```  
* Rename a remote directory 
  ```shell
  git clone git@github.com:AccountName/RepoName.git
  cd RepoName
  git mv path_name new_path_name
  git commit -m "Problematic Name in Windows"
  git push origin master
  ```
* Commit and push new change
  ```shell
  git add -u . 
  git add *
  git status 
  git commit -m 'LoRa'
  git push  
  ```
* Revert vs. Reset
  ```
  git log --oneline
  git revert specified_HEAD # Only undo one specified commit
  git reset  specified_HEAD # All commit after one specified commit
  ```
* Host a Git server

  1. Set up a remote depo on a remote server
      ```
      sudo su
      apt install -y git
      useradd -m -s /bin/bash git
      su - git
      mkdir ~/.ssh
      ssh-keygen -t ed25519 -C '' -N '' -f "${HOME}/.ssh/id_ed25519"
      cp ~/.ssh/id_ed25519.pub ~/.ssh/authorized_keys
      mkdir abc.git && cd abc.git
      git init --bare
      ```
  2. Local Machine
      ```
      mkdir abc && cd abc
      git init 
      git add * 
      git commit -m "testMyGitServer"
      git remote add origin git@remote_ip:abc.git
      git push origin master
      ```
* Proxy
  ```
  git config --global http.proxy 'socks5h://192.168.x.xx:1080' 
  git config --global --unset http.proxy
  ```
* Other 
  ```
  git branch -l                        # what is current branch name
  git remote -v                        # what is remote (what does origin stand for)
  ```