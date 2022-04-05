# cloudheim

kubernetes deployment for a valheim game-server. Based off the docker version by lloesche [here](https://github.com/lloesche/valheim-server-docker).

## Usage

```bash
helm install deploy-name cloudheim/cloudheim  \
  --set valheimServer.serverName="Server Name" \
  --set valheimServer.worldName="World Name" \
  --set valheimServer.serverPass="password" \
  --set valheimServer.serviceType=NodePort \
  --set valheimServer.serverPort=32456 \
  --namespace valheim .
```

## Configuration

| Parameter                        | Description                                                                    | Default                   |
| :------------------------------- | :----------------------------------------------------------------------------- | :------------------------ |
| `valheimServer.worldName`        | Prefix of the world files to use (will make new if missing)                    | `example-world-name`      |
| `valheimServer.serverName`       | Server name displayed in the server browser(s)                                 | `example-server-name`     |
| `valheimServer.password`         | Server password                                                                | `password`                |
| `valheimServer.serviceType`      | The type of service e.g `NodePort`, `LoadBalancer` or `ClusterIP`              | `ClusterIP`               |
| `valheimServer.nodeSelector`     | this can be used to select a node with specific resources for your game server | `{}`                      |
| `valheimServer.serverPublic`     | determines whether the server shows up in the public list or not               | `1`                       |
| `valheimServer.updateInterval`   | how often the server checks for updates                                        | `10800` \ 3 hours         |
| `valheimServer.backupsInterval`  | How often the worldfile is backed up                                           | `43200` \ 12 hours        |
| `valheimServer.backupsMaxAge`    | Max age of world file backups kept                                             | `3` \ 3 days              |
| `valheimServer.mods.bepinex`     | whether or not bepinex mod is enabled                                          | `false`                   |
| `valheimServer.mods.valheimPlus` | whether or not valheimPlus mod is enabled                                      | `false`                   |
| `valheimServer.status`           | wether or not the status endpoint is enabled                                   | false                     |
| `valheimServer.admins`           | list of steamID's that will be granted admin status                            | []                        |
| `persistence.claimName`          | if set will not generate a pvc and instead use existing clain                  | ""                        |
| `persistence.config.enabled`     | determines if persistence is enabled                                           | `true`                    |
| `persistence.config.size`        | size of pvc volume                                                             | `1Gi`                     |
| `image.repository`               | Specifies container image repository                                           | `lloesche/valheim-server` |
| `image.tag`                      | Specifies container image tag                                                  | `latest`                  |