<p align="center">
   <img src="https://raw.githubusercontent.com/JonMagon/RedKangaroo/master/assets/images/kangaroo-shape.png" width="128" height="128"/>
</p>

# RedKangaroo
### Current version: `0.0.0-dev`

## Installation
* [Precompiled binaries](https://github.com/JonMagon/RedKangaroo/releases)

## Server side configuration
|Section: `services`|Type    |Default value|
|-------------------|--------|-------------|
|`RedKangarooPort`  |`number`|`19000`      |
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
```
git clone https://github.com/JonMagon/RedKangaroo
cd RedKangaroo/backend
dub build --build=release
```

## Usage
Just run RedKangaroo-Daemon

## TODO

## Credits
This application uses Open Source components and free resources. You can find the source code of their open source projects along with license information below. We acknowledge and are grateful to these developers for their contributions to open source.

Image: Kangaroo shape  
Copyright (c) https://www.flaticon.com/  
Flaticon Basic License

Project: mysql-native (https://github.com/mysql-d/mysql-native)  
Copyright (c) Nick Sabalausky (https://github.com/Abscissa)  
License (BSL-1.0)

