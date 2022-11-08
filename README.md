# com.microsoft.Edge

## Troubleshooting

### Game controllers not working
This is a workaround rather than an actual solution: giving the application
read-only access to the `/run/udev` directory with Flatseal or the CLI by running
`flatpak override --filesystem=/run/udev:ro com.microsoft.Edge`
may get the controller running. However, this will not necessarily work on all
systems, and does not work with hotplugging. Those issues cannot be fixed
unless changes are made in the Edge browser.

### Passing custom flags
We encourage users to insert all flags inside `~/.var/app/com.microsoft.Edge/config/edge-flags.conf`. If this file doesn't exist, then create one. For each flag, they should be separated by newlines. For example, if you want to pass `--ozone-platform=wayland` and `--enable-features=UseOzonePlatform`, then the `edge-flags.conf` file will look like the following:

```
--ozone-platform=wayland
--enable-features=UseOzonePlatform
```
