# mcserver-docker
[![License](https://img.shields.io/github/license/c012vu5/mcserver-docker.svg?style=flat-square)](./LICENSE)

Container to deploy minecraft server.

## Usage

### Dependencies
- `curl`, `docker`, `docker-compose`, `wget`

### init.sh
Setup .env file and download latest minecraft server jar file.  
**Must be run**

```console
> ./init.sh
```

### world.sh
**Choices 1 and 3**
If a server version is specified in .env, download that version, otherwise download the latest version.

```console
> ./world.sh
1.Update server version  2.Initialize world  3.Update server version and Initialize world  4.Quit
Choose the number :
```

### admin_command.sh
```console
> ./admin_command.sh
Usage : ./admin_command.sh <MINECRAFT_COMMAND>
Ref : https://minecraft.fandom.com/wiki/Commands
```

## ToDo

- admin_command.sh
- README.md
- server.properties
  - init.sh
  - entrypoint.sh
- POSIX compliant
  - admin_command.sh
  - entrypoint.sh
  - init.sh
  - world.sh

- rconの必要性
