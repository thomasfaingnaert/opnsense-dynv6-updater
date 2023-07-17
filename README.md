# OPNsense dynv6 Dynamic DNS Updater

This repository adds a simple configd action to update your IPv4 address and IPv6 prefix on the dynamic DNS provider [dynv6](https://dynv6.com/).

## How to install

1. Download the latest release from the GitHub releases page, e.g. using `fetch`:

```bash
fetch https://github.com/thomasfaingnaert/opnsense-dynv6-updater/releases/latest/download/opnsense-dynv6-updater.txz
```

2. Install the package using:

```bash
pkg install ./opnsense-dynv6-updater.txz
```

3. In your OPNsense web interface, go to System > Settings > Cron, and add a cron job with the following configuration:
    - Minutes: e.g. `*/5` to run every 5 minutes.
    - Hours / Day of the month / Months / Days of the week: `*`
    - Command: Update dynv6 Dynamic DNS
    - Parameters: `<zone> <password>`, where you can obtain your password in the "Instructions" tab of dynv6.
    - Description: Update Dynamic DNS

## How to build

Run the Makefile in the repository:

```bash
make
```
