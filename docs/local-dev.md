# Local Development (Devcontainer)

This repo is a ZMK module (shield), not a full firmware workspace. The devcontainer below gives you the right toolchain so you can build locally without waiting for GitHub Actions.

## What the devcontainer provides

- `west` for Zephyr/ZMK workspace management
- Zephyr build dependencies (`cmake`, `ninja`, `dtc`, etc.)
- Zephyr SDK (ARM toolchain) installed at `/opt/zephyr-sdk-0.16.5`
- A persistent `ccache` volume for faster rebuilds

## Recommended workflow

All commands below run **inside the devcontainer**.

1. Bootstrap a local ZMK workspace (requires network):

```bash
bash scripts/bootstrap-zmk.sh
```

This creates `.zmk-workspace/` and initializes `west` using `zmk/app`.
By default, the script uses ZMK `v0.3.0`. Override with `ZMK_REF`, for example:

```bash
ZMK_REF=main bash scripts/bootstrap-zmk.sh
```

2. Build using your `zmk-config` repo:

```bash
bash scripts/build-local.sh \
  -b nice_nano_v2 \
  -s "kyria_left nice_view_adapter nice_view_gem" \
  -c /workspaces/zmk-config/config
```

Notes:
- The shield list should match what you would normally put in `build.yaml`.
- The `-c` path must point at the `config/` directory from your `zmk-config` repo.

## Manual build command (reference)

```bash
west build -p auto \
  -s .zmk-workspace/zmk/app \
  -d .zmk-workspace/build/nice_nano_v2 \
  -b nice_nano_v2 \
  -- \
  -DSHIELD="kyria_left nice_view_adapter nice_view_gem" \
  -DZMK_CONFIG=/workspaces/zmk-config/config \
  -DZMK_EXTRA_MODULES=/workspaces/nice-view-gem
```

## What you get after a successful build

The build output directory is printed at the end of the build. By default it is:

```
.zmk-workspace/build/<board>
```

For example, with `-b nice_nano_v2`, outputs land in:

```
.zmk-workspace/build/nice_nano_v2/zephyr/
```

Key artifacts:

- `zmk.uf2` (drag-and-drop to the board’s UF2 bootloader)
- `zmk.hex` (use with programmers that expect HEX)

## How this maps to the GitHub Actions firmware zip

GitHub Actions typically packages multiple builds and names them based on the
board + shield list. Locally, the output is always `zmk.uf2` (and `zmk.hex`) in
the build folder. If you need distinct names like the CI zip, rename the output
after the build, for example:

```
mv .zmk-workspace/build/nice_nano_v2/zephyr/zmk.uf2 \
  kyria_rev3_left+nvc_nice_view_adapter+nice_view_gem-nice_nano_v2-zmk.uf2
```

## Flashing notes

1. Put the target half into UF2 bootloader mode.
2. Copy `zmk.uf2` onto the mounted UF2 drive.
3. Repeat with the other half if you build it separately.
