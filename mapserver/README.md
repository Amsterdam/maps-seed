### Adding luchtfotos

Adding luchtfotos is a 2-step process in two different repositories. We provide these as regular luchtfotos and infrarood.

    1) Add luchtfotos in this repo following the procedure described below
    2) Add shapefiles to the [mapserver](https://github.com/Amsterdam/mapserver) repository and a corresponding WMS layer that exposes these shapefiles

Note that the shapefiles added to the mapserver repository should use the Rijksdriehoek-coordinaten, not webmercator.

#### Generating luchtfotos and infrarood TMS tiles

Creating a new Lufo year of tiles and service follow these steps:

- Copy the aerial pictures (tif) to localhost
- Run [./tools/lufopyramids.sh in mapserver repo](./tools/lufopyramids.sh)
- Start mapserver docker
- Run seed commands against the mapserver, e.g.:
    ```bash
    docker-compose run topo-lufo
    ```

- Move generated tiles from `/mnt/tiles/lufo_rd_cache_EPSG28992/` to: `/mnt/tiles/lufo<YEAR>_rd_cache_EPSG28992/`

- Upload the tiles to the objectstore using rclone

```bash
rclone sync lufo2018_rd_cache_EPSG28992 tilesacc:/ -vvv --transfers=20 --checkers=20
rclone sync lufo2018_rd_cache_EPSG28992 tiles:/ -vvv --transfers=20 --checkers=20
```

- Upload pyramid directory to objectstore