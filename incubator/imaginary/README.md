# Imaginary

[Imaginary](https://github.com/h2non/imaginary/blob/master/README.md#imaginary-----) is a fast HTTP microservice written in Go for high-level image processing backed by bimg and libvips.

## TL;DR

To install Imaginary to your kubernetes cluster simply run:

```shell
helm install --name imaginary --namespace imaginary-prod incubator/imaginary
```

## Introduction

As the [official repo states](https://github.com/h2non/imaginary/blob/master/README.md#imaginary-----):

**[Fast](#benchmarks) HTTP [microservice](http://microservices.io/patterns/microservices.html)** written in Go **for high-level image processing** backed by [bimg](https://github.com/h2non/bimg) and [libvips](https://github.com/jcupitt/libvips). `imaginary` can be used as private or public HTTP service for massive image processing with first-class support for [Docker](#docker) & [Heroku](#heroku).
It's almost dependency-free and only uses [`net/http`](http://golang.org/pkg/net/http/) native package without additional abstractions for better [performance](#performance).

Supports multiple [image operations](#supported-image-operations) exposed as a simple [HTTP API](#http-api),
with additional optional features such as **API token authorization**, **HTTP traffic throttle** strategy and **CORS support** for web clients.

`imaginary` **can read** images **from HTTP POST payloads**, **server local path** or **remote HTTP servers**, supporting **JPEG**, **PNG**, **WEBP**, and optionally **TIFF**, **PDF**, **GIF** and **SVG** formats if `libvips@8.3+` is compiled with proper library bindings.

`imaginary` is able to output images as JPEG, PNG and WEBP formats, including transparent conversion across them.

`imaginary` also optionally **supports image placeholder fallback mechanism** in case of image processing error or server error of any nature, therefore an image will be always returned by the server in terms of HTTP response body and content MIME type, even in case of error, matching the expected image size and format transparently.

It uses internally `libvips`, a powerful and efficient library written in C for image processing
which requires a [low memory footprint](http://www.vips.ecs.soton.ac.uk/index.php?title=Speed_and_Memory_Use)
and it's typically 4x faster than using the quickest ImageMagick and GraphicsMagick
settings or Go native `image` package, and in some cases it's even 8x faster processing JPEG images.

See [official README](https://github.com/h2non/imaginary/blob/master/README.md#contents) for more.

## Prerequisites

* Kubernetes 1.4+ with Beta APIs enabled

## Installing chart

```shell
helm install --name imaginary --namespace imaginary-prod incubator/imaginary
```

The command deploys Imaginary on the Kubernetes cluster in the default configuration. The [configuration section](#configuration) lists various ways to override default configuration during deployment.

> **Tip:** To list all releases use `helm list`

## Uninstalling the Chart

```shell
helm delete imaginary
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to helm install or provide your own file via `-f values.yaml`. For example,

```shell
helm install \
  --name imaginary \
  --namespace imaginary-prod \
  --set image.tag=1.0.15 \
  incubator/imaginary
```

The above command installs a specified version of Imaginary.

## Supporterd Chart values

These are the values used to configure Imaginary itself:

|Value|Description|Default|
|-----|-----------|-------|
|**config.pathPrefix**|Url path prefix to listen to|`/`|
|**config.cors**|Enable CORS support||
|**config.gzip**|Enable gzip compression (deprecated)||
|**config.disableEndpoints**|Comma separated endpoints to disable. E.g: form,crop,rotate,health||
|**config.key**|Define API key for authorization||
|**config.mount**|Mount server local directory||
|**config.httpCacheTTL**|The TTL in seconds. Adds caching headers to locally served files.||
|**config.httpReadTimeout**|HTTP read timeout in seconds|`30`|
|**config.httpWriteTimeout**|HTTP write timeout in seconds|`30`|
|**config.enableURLSource**|Restrict remote image source processing to certain origins (separated by commas)||
|**config.enablePlaceholder**|Enable image response placeholder to be used in case of error|
|**config.enableAuthForwarding**|Forwards X-Forward-Authorization or Authorization header to the image source server. -enable-url-source flag must be defined. Tip: secure your server from public access to prevent attack vectors||
|**config.enableURLSignature**|Enable URL signature (URL-safe Base64-encoded HMAC digest)|`false`|
|**config.urlSignatureKey**|The URL signature key (32 characters minimum)||
|**config.allowedOrigins**|Restrict remote image source processing to certain origins (separated by commas)||
|**config.maxAllowedSize**|Restrict maximum size of http image source (in bytes)||
|**config.authorization**|Defines a constant Authorization header value passed to all the image source servers. -enable-url-source flag must be defined. This overwrites authorization headers forwarding behavior via X-Forward-Authorization||
|**config.placeholder**|Image path to image custom placeholder to be used in case of error. Recommended minimum image size is: 1200x1200||
|**config.concurrency**|Throttle concurrency limit per second||
|**config.burst**|Throttle burst max cache size|`100`|
|**config.mrelease**|OS memory release interval in seconds|`30`|
|**config.cpus**|Number of used cpu cores.||

See `values.yaml` for some more Kubernetes-specific configuration options.
