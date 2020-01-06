# Github Install

A script to help download and install github executable from the release page.

## Example

Install the latest:

```bash
curl -L https://git.io/fjaxx | repo=ysmood/gokit bin=godev sh
```

Or

```bash
wget -O- https://git.io/fjaxx | repo=ysmood/gokit bin=godev sh
```

Install a specific version:

```bash
wget -O- https://git.io/fjaxx | repo=ysmood/gokit bin=godev ver=v0.10.3 sh
```

The default value of bin is the repo name.
