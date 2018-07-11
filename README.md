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
|`key`                 |`string` |`"your_key"` |
|`allowGetInfo`        |`boolean`|`true`       |

|Section: `services`|Type    |Default value|
|-------------------|--------|-------------|
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
- [DUB](https://github.com/dlang/dub)

**Build**
```bash
$ git clone https://github.com/JonMagon/RedKangaroo
$ cd RedKangaroo/backend
$ dub build --build=release
```

## Usage
Just run `redkangaroo-daemon`

## TODO

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