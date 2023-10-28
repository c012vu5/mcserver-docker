# mcserver-docker
[![License](https://img.shields.io/github/license/c012vu5/mcserver-docker.svg?style=flat-square)](./LICENSE)

Container to deploy minecraft server.

## Usage

### init.sh
Setup .env file and download latest minecraft server jar file.

```console
> ./init.sh
```

### world.sh
```console
> ./world.sh
1.Update server version  2.Initialize world  3.Update server version and Initialize world  4.Quit
Choose the number :
```

### admin_command.sh
```console
> ./admin_command.sh <MINECRAFT_COMMAND>
```


## ToDo

- admin_command.sh
- README.md
- server.properties
  - init.sh
  - entrypoint.sh

- rconの必要性
