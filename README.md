<p align="center"><b>RedKangaroo is no longer being developed.</b></p>

<p align="center">
   <img src="https://raw.githubusercontent.com/JonMagon/RedKangaroo/master/assets/images/kangaroo-shape.png" width="128" height="128"/>
</p>

# RedKangaroo
### Current version: `0.0.0-dev`

## Installation
* [Precompiled binaries](https://github.com/JonMagon/RedKangaroo/releases)

## Server side configuration
|Section: `RedKangaroo`|Type     |Default value|
|----------------------|---------|-------------|
|`host`                |`string` |`"0.0.0.0"`  |
|`port`                |`number` |`19000`      |
|`token`               |`string` |`""`         |
|`stepWindow`          |`number` |`30`         |
|`previousFrames`      |`numer`  |`1`          |
|`futureFrames`        |`number` |`1`          |
|`allowGetInfo`        |`boolean`|`true`       |
* Leave a field `token` empty if you don't care about that field. It will be automatically filled in.
* Don't change fields `stepWindow`, `previousFrames` and `futureFrames` if you don't know what they mean.
	* Ideally the client and server times should be in sync.
	* It's not recommended to provide any value other than the default.

|Section: `services`|Type    |Default value|
|-------------------|--------|-------------|
|`pwbuild`          |`number`|`155`        |
|`gdeliverydPort`   |`number`|`29100`      |
|`gamedbdPort`      |`number`|`29400`      |

|Section: `mysql`|Type    |Default value|
|----------------|--------|-------------|
|`host`          |`string`|`"0.0.0.0"`  |
|`port`          |`number`|`3306`       |
|`user`          |`string`|`"root"`     |
|`password`      |`string`|`"qwerty"`   |
|`database`      |`string`|`"pw"`       |

## Manual installation
**Requirements**
* [DUB](https://github.com/dlang/dub)

**Build**
```bash
$ git clone https://github.com/JonMagon/RedKangaroo
$ cd RedKangaroo/backend
$ dub build --build=release
```
## Usage
Just run `redkangaroo-daemon`

## TODO
* Runtime memory patching

## Special Thanks
* Vladislav Pavlov (werewolf)
* Alexander Karaev ([Smertig](https://github.com/Smertig))

Thanks to everyone who has posted great ideas, suggestions, and bug reports on issue trackers, forums, and via Discord.
Thanks to all users for supporting the project.

## Credits
This application uses Open Source components. You can find the source code of their open source projects along with license information below. We acknowledge and are grateful to these developers for their contributions to open source.

Image: Kangaroo shape  
Copyright (c) https://www.flaticon.com/  
Flaticon Basic License

Project: vibe.d (https://github.com/vibe-d/vibe.d)  
Copyright (c) 2012-2018 RejectedSoftware e.K.  
License (MIT)

Project: mysql-native (https://github.com/mysql-d/mysql-native)  
Copyright (c) 2011-2017 Steve Teale, James W. Oliphant, Simen Endsjø, Sönke Ludwig, Sergey Shamov, and Nick Sabalausky  
License (BSL-1.0)
