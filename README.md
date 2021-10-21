# com.microsoft.Edge

## Troubleshooting

### Game controllers not working
This is a workaround rather than an actual solution: giving the application
read-only access to the `/run/udev` directory with Flatseal or the CLI by running
`flatpak override --filesystem=/run/udev:ro com.microsoft.Edge`
may get the controller running. However, this will not necessarily work on all
systems, and does not work with hotplugging. Those issues cannot be fixed
unless changes are made in the Edge browser.
