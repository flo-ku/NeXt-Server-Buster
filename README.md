<p align="center">
  <a href="nxt.sh">
    <img src="https://nxt.sh/wp-content/uploads/2018/01/NeXt-logo.jpg">
  </a>

  <h3 align="center">NeXt-Server-Buster</h3>

  <p align="center">
    Debian Buster Version of NeXt-Server Script.
    <br>
    <a href=""><strong>NeXt-Server docs »</strong></a>
    <br>
    <br>
    <a href="https://github.com/shoujii/NeXt-Server-Buster/issues/new">Report bug</a>
    ·
    <a href="https://nxt.sh/">Blog</a>
  </p>
</p>

<br>

## Table of contents

- [What you need](#what-you-need)
- [Quick start](#quick-start)
- [What's included](#whats-included)
- [Bugs and feature requests](#bugs-and-feature-requests)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Creators](#creators)
- [Thanks](#thanks)
- [Copyright and license](#copyright-and-license)

## What you need:

A vServer with at least:
```
- 1 CPU Core
- 1 GB RAM
- KVM virtualized server (Openvz [...] will not work!)
- The latest "clean" Debian 10.x minimal installed on the server (with all updates!)
- rDNS set to the desired Domain
- root user access
- 9 GB free disk space

- IPv4 Adress
- A Domain and the ability to change the DNS Settings
- DNS Settings described in the dns_settings.txt
- Time... the DNS system may need 24 to 48 hours to recognize the changes you made!

- The will to learn something about Linux ;)
```

## Quick start

Several quick start options are available:

- Install with [git](): `cd /root/; apt-get update; apt-get install git -y; git clone https://github.com/shoujii/NeXt-Server-Buster; cd NeXt-Server-Buster; bash nxt.sh
`

Read the [Getting started page]() for information on the framework contents, templates and examples, and more.

## What's included

Within the download you'll find the following directories and files, logically grouping common assets and providing both compiled and minified variations. You'll see something like this:

```
bootstrap/
└── dist/
    ├── css/
    │   ├── bootstrap-grid.css
    │   ├── bootstrap-grid.css.map
    │   ├── bootstrap-grid.min.css
    │   ├── bootstrap-grid.min.css.map
    │   ├── bootstrap-reboot.css
    │   ├── bootstrap-reboot.css.map
    │   ├── bootstrap-reboot.min.css
    │   ├── bootstrap-reboot.min.css.map
    │   ├── bootstrap.css
    │   ├── bootstrap.css.map
    │   ├── bootstrap.min.css
    │   └── bootstrap.min.css.map
    └── js/
        ├── bootstrap.bundle.js
        ├── bootstrap.bundle.js.map
        ├── bootstrap.bundle.min.js
        ├── bootstrap.bundle.min.js.map
        ├── bootstrap.js
        ├── bootstrap.js.map
        ├── bootstrap.min.js
        └── bootstrap.min.js.map
```

We provide compiled CSS and JS (`bootstrap.*`), as well as compiled and minified CSS and JS (`bootstrap.min.*`). [source maps](https://developers.google.com/web/tools/chrome-devtools/debug/readability/source-maps) (`bootstrap.*.map`) are available for use with certain browsers' developer tools. Bundled JS files (`bootstrap.bundle.js` and minified `bootstrap.bundle.min.js`) include [Popper](https://popper.js.org/), but not [jQuery](https://jquery.com/).


## Bugs and feature requests

Have a bug or a feature request? Please first read the [issue guidelines](https://github.com/twbs/bootstrap/blob/master/CONTRIBUTING.md#using-the-issue-tracker) and search for existing and closed issues. If your problem or idea is not addressed yet, [please open a new issue](https://github.com/twbs/bootstrap/issues/new).


## Documentation

Bootstrap's documentation, included in this repo in the root directory, is built with [Jekyll](https://jekyllrb.com/) and publicly hosted on GitHub Pages at <https://getbootstrap.com/>. The docs may also be run locally.

Documentation search is powered by [Algolia's DocSearch](https://community.algolia.com/docsearch/). Working on our search? Be sure to set `debug: true` in `site/docs/4.1/assets/js/src/search.js` file.

## Contributing

Please read through our [contributing guidelines](https://github.com/twbs/bootstrap/blob/master/CONTRIBUTING.md). Included are directions for opening issues, coding standards, and notes on development.

## Creators

**Marcel Gössel**

- <https://github.com/shoujii>

**René Wurch**

- <https://github.com/BoBBer446>


## Thanks

Thanks to [Thomas Leister] and his awesome Mailserver Setup, we're using in this Script!
(https://thomas-leister.de/mailserver-debian-stretch/)


Also thanks to [Michael Thies], for the managevmail script, used for the Mailserver.
(https://github.com/mhthies/managevmail)


## Copyright and license

Code and documentation copyright 2017-2018 the [NeXt-Server-Buster Authors](https://github.com/shoujii/NeXt-Server-Buster/graphs/contributors) Code released under the [GNU General Public License v3.0](https://github.com/shoujii/NeXt-Server-Buster/blob/master/LICENSE).
