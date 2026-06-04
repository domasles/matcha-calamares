![Matcha Linux Logo](./MatchaLinuxLogo.svg)

# Matcha Calamares Installer

A fully open-source, configured Calamares installer targeted for [Matcha Linux](https://github.com/domasles/matcha-linux)

## What is it?

It is a baseline on how an Alpine GUI installer should work. It's a port for newer Alpine versions as official maintenance stopped at Alpine v3.19.

While this project is great for learning, it's still improving, so not everything might work as expected.

## What is this repository for?

This repository is strictly for developers who are trying to integrate an installer into their own distributions. It is not intended for end users, nor is it a general-purpose installer for ALL Alpine-based distributions by default.

## Project Philosophy

This installer relies on Calamares modules where possible, but also controllable shell processes where necessary.
By deploying your own installer infrastructure, you get:

- **Full Control** - Customize every aspect of the installation workflow
- **Open Source** - Transparent, auditable, and community-driven development

This installer serves as both a practical tool and an educational resource for understanding how Alpine-based system installers work.

## Features

This pre-configured installer packages:

- **Calamares** - The modular installer framework
- **Pre-configured Modules** - Ready-to-use modules for partitioning, user setup, and more
- **Straightforward Setup Sequence** - A simple, linear installation workflow for the end user
- **Custom Shell Processes** - For tasks that require more control, like package installation and system overlay from the ISO

Matcha Calamares aims to keep the system mint post-installation, so it installs everything from the ISO ROM, without reaching out to any external repositories. This ensures a consistent and reliable installation experience.

## Requirements for a Build

- **act** - To run GitHub Actions workflows locally
- **Docker** - For containerized build environment, required for act

## Build Instructions

1. **Clone the repository**:
```bash
git clone https://github.com/domasles/matcha-calamares.git
cd matcha-calamares
```

2. **Run the build**:
```bash
act workflow_dispatch
```

> NOTE: `workflow_dispatch` is required here, because `act` can't automatically detect the event to choose. Running act without an event specified will result in an error.

3. **Find your builds**:
Builds will be zipped in the `build/` directory after completion.

## Build Process Details

Every build will clean up itself - the container used to build will be deleted after the process completes. This ensures:

- No leftover build artifacts
- Clean environment for each build
- Consistent, reproducible results

## Configuration

The installer is configured through:

- **Calamares modules** in `calamares-config/`
- **Shell scripts** in `calamares-config/`
- **Branding assets** in `branding/`

## Architecture

The installer follows a modular architecture:

```
APKBUILD              # Build configuration script for the app package
build.sh              # Build script to automate the build process

calamares-config/
├── mkinitfs.conf
├── shellprocess.conf
├── shellprocess@bootstrap.conf
├── shellprocess@install.conf
└── users.conf

calamares-settings/
└── settings.conf      # Main configuration file

excludes/
└── overlay.txt        # List of files to exclude from the installation image

branding/
└── matcha/
    ├── branding.desc  # Colors, names, product info
    ├── logo.svg       # Product logo
    ├── show.qml       # Slideshow configuration
    └── slide.png      # Slideshow image
```

## Customization Guide

### Configuration Files

- **settings.conf** - Main configuration file defining module sequence
- **calamares-config/*.conf** - Module-specific configurations
- **branding/matcha/branding.desc** - Product naming and colors

Adding custom directories requires updating `APKBUILD` and `build.sh` to include them in the build context.

It is recommended to not remove any existing configuration and building steps in `APKBUILD` and `build.sh`, unless you know what you are doing.

### Branding Customization

- Replace `branding/matcha/logo.svg` with your logo
- Modify `branding/matcha/branding.desc` for colors and names
- Update `branding/matcha/show.qml` for slideshow

## Support

For issues, feature requests, or questions open an issue or pull request on GitHub

---

Built with love for the Linux community. _Open source, as intended._
