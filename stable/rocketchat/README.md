# Rocket.Chat

[Rocket.Chat](https://rocket.chat/) is free, unlimited and open source. Replace email, HipChat & Slack with the ultimate team chat software solution.

## Notes on installation and recommended settings

- This chart installs rocketchat chart (stable/rocketchat)
- This chart installs mongodb chart (stable/mongodb) 
- Authentication for mongodb is enabled by default (usePassword : true)

### Please set your own mongodbUsername and mongodbPassword like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here> --name my-rocketchat stable/rocketchat
```

### If you want to use another image set it like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here>,repository=<your_image> --name my-rocketchat stable/rocketchat
```

### If you want to install another version of rocket.chat image you can set the version like this:
```bash
$ helm install --set mongodb.mongodbUsername=<your_username_here>,mongodb.mongodbPassword=<your_password_here>,tag=0.74.2 --name my-rocketchat stable/rocketchat
```


