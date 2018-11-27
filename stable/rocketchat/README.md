# Rocket.Chat

[Rocket.Chat](https://rocket.chat/) is free, unlimited and open source. Replace email, HipChat & Slack with the ultimate team chat software solution.

## Notes on installation and recommended settings

- This chart installs rocketchat chart (stable/rocketchat)
- This chart installs mongodb chart (stable/mongodb) 
- Authentication for mongodb is enabled by default (usePassword : true)
- Default mongodbUsername : rocketchat, mongodbPassword : rocketchat and mongodbDatabase : rocketchat
- Default rocket.chat repo image defaultImage : rocket.chat
- Default rocket.chat version : latest

### Please set your own mongodbUsername and mongodbPassword like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here> --name my-rocketchat stable/rocketchat
```

Also if you want to use another image set it like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here>,image=<your_image> --name my-rocketchat stable/rocketchat
```

And if you want to install another version of rocket.chat image you can set the version like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here>,version=0.69.1 --name my-rocketchat stable/rocketchat
```


