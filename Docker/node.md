# Nodejs

```sh
cat << EOF > .bashrc
umask 0000
cd /root/wechaty
EOF

docker run --rm -it --name node \
    -v ${PWD}/.bashrc:/root/.bashrc \
    -v ${PWD}:/root/wechaty \
    node:24.9.0-trixie-slim bash 

# Use npmmirror for speed
npm config set registry https://registry.npmmirror.com/ 
npm install wechaty

cat << EOF > bot.js
import { WechatyBuilder } from 'wechaty'
import { FileBox } from 'file-box'
import qrcodeTerminal from 'qrcode-terminal'

const bot = WechatyBuilder.build()

bot
  .on('scan', (qrcode, status) => {
    qrcodeTerminal.generate(qrcode, { small: true })
  })
  .on('login', async user => {
    console.log(\`✅ User ${user} logged in\`) 
    try {
      await bot.say('Hello FileHelper!', 'filehelper')
      const file = FileBox.fromFile('/root/wechaty/The_Making_of_a_Nation_mp3.zip')
      await bot.say(file, 'filehelper')
    } catch (err) {
      console.error('❌ Failed to send:', err.message)
    } 
  })

bot.start()

EOF


docker container commit --pause --author xg590@nyu.edu --change='CMD ["/usr/sbin/sshd", "-D"]' 6105a7f5a989 claude:sshd
docker image prune -f
```