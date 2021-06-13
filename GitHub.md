## Create a Depository
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
4. In terminal, connect to the github.com
```shell
ssh -T github.com
```
you will get the response "Hi xxx! You've successfully authenticated, but GitHub does not provide shell access."
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
~Done

## Rename a remote directory
```shell
git clone git@github.com:AccountName/RepoName.git
cd RepoName
git mv path_name new_path_name
git commit -m "Problematic Name in Windows"
git push origin master
```
## Manual Change
'''
git add -u . 
git add *
git status 
git commit -m 'LoRa'
git push  
'''
