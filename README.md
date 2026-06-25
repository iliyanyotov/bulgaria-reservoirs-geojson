# Bulgaria state reservoirs — polygon geometry

GeoJSON polygons for the **52 state-managed reservoirs of Bulgaria**, one file per reservoir under [`data/`](./data). Geometry is extracted from [OpenStreetMap](https://www.openstreetmap.org) and published under the [Open Database License v1.0 (ODbL)](https://opendatacommons.org/licenses/odbl/1-0/).

## Quick start

Drag any file from [`data/`](./data) into [geojson.io](https://geojson.io) to view the polygon on a basemap. The files are plain GeoJSON — readable by MapLibre, Mapbox GL, Leaflet, QGIS, `JSON.parse`, or anything else that speaks the format.

## Data format

One `data/<slug>.geojson` file per reservoir. Each is a single GeoJSON `Feature` with `Polygon` geometry. The `<slug>` is a stable kebab-case identifier matching the filename (e.g. `iskar`, `golyam-beglik`).

- **Coordinates** are `[longitude, latitude]` in WGS84, at 7 decimal places (~1 cm precision).
- **Geometry is always `Polygon`**, never `MultiPolygon`. Where OSM maps a reservoir as several disconnected outer rings, only the largest is kept.
- **Inner rings are preserved** and represent islands inside the reservoir (13 of the 52 files have them).
- **Properties are intentionally empty** (`{}`). This dataset is geometry only. Names, basin codes, capacities, and daily volumes are not included here; join on the filename slug if you need to attach them from another source.

## Validation

Every file is checked against [RFC 7946](https://www.rfc-editor.org/rfc/rfc7946) on each push and pull request. Run the same check locally (requires [Bun](https://bun.sh)):

```bash
./scripts/validate.sh
```

Conformance errors fail the run. The right-hand-rule winding recommendation is a non-fatal advisory — the polygons render correctly regardless of ring direction.

## Provenance & known quirks

The dataset was assembled by matching the canonical list of 52 state-managed reservoirs from Bulgaria's Ministry of Environment and Water (МОСВ — Министерство на околната среда и водите) against OpenStreetMap. A few things about the underlying OSM data are worth knowing:

- **Inconsistent tagging.** Reservoirs appear under several tag families, all of which had to be queried: `water=reservoir` (canonical), `water=basin`, `landuse=reservoir`, and `natural=water` named `яз.`/`язовир` for major ones lacking a `water=*` refinement. Chaira (Чаира) is tagged `water=lake` despite being an artificial pumped-storage reservoir.
- **Inconsistent name casing.** OSM contributors use both `яз.` and `Яз.`; matching is case-insensitive.
- **Pasarel vs Kokalyane.** МОСВ calls one upper-Iskar reservoir Kokalyane (Кокаляне, after the gorge); OSM names the same polygon Pasarel (Пасарел, after the village). This repo uses the МОСВ name (`kokalyane.geojson`); the source OSM polygon (`way/277322334`) is `яз. Пасарел`.
- **Mixed feature types.** Matches are a mix of OSM `way` and `relation` objects. Relations were stitched into single polygons by joining member ways tip-to-tip.
- **Auxiliary basins collapsed.** Where OSM maps a reservoir as a main basin plus smaller secondary ponds, only the largest polygon is kept (notably Golyam Beglik (Голям Беглик)). Consumers needing the auxiliary basins should query OSM directly.
- **Gorni Dabnik needs refinement.** The Gorni Dabnik (Горни Дъбник) polygon (`gorni-dabnik.geojson`) is the one shape that doesn't track the real lake boundary well on a basemap. It's usable but the least accurate file in the set.

## Attribution & licence

The data is available under the [Open Database License v1.0 (ODbL)](https://opendatacommons.org/licenses/odbl/1-0/); see [LICENSE](./LICENSE).

If you use these files, credit OpenStreetMap:

> © OpenStreetMap contributors

Link to <https://www.openstreetmap.org/copyright> wherever practical (footer, "About" page, or map attribution control). If you redistribute the data or a modification of it, ODbL also requires you to preserve this licence and release any derived database under ODbL. Rendered maps are "produced works" under ODbL — attribution is required, but share-alike does not extend to your map code or styling.

## Sources

- **Geometry** — [OpenStreetMap](https://www.openstreetmap.org), licensed under [ODbL 1.0](https://opendatacommons.org/licenses/odbl/1-0/).
