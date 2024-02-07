# com.microsoft.Edge

## Smart Cards

Flatpak does not do anything special by default to forward opensc PKCS#11 modules into the application sandbox (see: https://github.com/flatpak/flatpak/pull/5423). If you need to use certificates from a PKCS#11 device in a browser session, some configuration is necessary:

1. Enable the systemd p11-kit server user service with `systemctl --user enable --now p11-kit-server.service`
    - If the p11-kit user service isn't shipped by the distribution or package or if the ditribution does not use systemd (ex: alpine), additional steps are required and are beyond the scope of this README.
    - The p11-kit project has [server](https://github.com/p11-glue/p11-kit/blob/775640465d460e7be262f375830f2617917ffbbb/p11-kit/p11-kit-server.service.in) and [socket](https://github.com/p11-glue/p11-kit/blob/775640465d460e7be262f375830f2617917ffbbb/p11-kit/p11-kit-server.socket) examples for systemd. These could be adapted to other distributions, init systems or service managers if not already included.
2. Run `flatpak override -u --filesystem=xdg-run/p11-kit/pkcs11 com.microsoft.Edge` to have the user's p11-kit server socket passed into the sandbox for the application.
    - *the application name could be skipped but then this override would apply to all applications, perhaps with unintended consequences.*
3. Enjoy a browser that works with smart cards as it should.

Caveats:
- (Clearly) Relies on presence of correctly configured p11-kit on host, along with opensc and pcscd.
- Relies on presence of systemd p11-kit user service unit
- Exports all configured p11-kit modules available on the host system over the server socket. This is no different than if the application was natively installed on the system.

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
