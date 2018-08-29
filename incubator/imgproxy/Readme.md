# imgproxy

[imgproxy](https://github.com/darthsim/imgproxy#imgproxy) is a fast and secure standalone server for resizing and converting remote images. The main principles of imgproxy are simplicity, speed, and security.

## TL;DR

To install imgproxy to your kubernetes cluster simply run:

```shell
helm install --name imgproxy --namespace imgproxy incubator/imgproxy
```

## Introduction

imgproxy can be used to provide a fast and secure way to replace all the image resizing code of your web application (like calling ImageMagick or GraphicsMagick, or using libraries), while also being able to resize everything on the fly, fast and easy. imgproxy is also indispensable when handling lots of image resizing, especially when images come from a remote source.

imgproxy does one thing — resizing remote images — and does it well. It works great when you need to resize multiple images on the fly to make them match your application design without preparing a ton of cached resized images or re-doing it every time the design changes.

imgproxy is a Go application, ready to be installed and used in any Unix environment — also ready to be containerized using Docker.

See this article for a good intro and all the juicy details! [imgproxy: Resize your images instantly and securely](https://evilmartians.com/chronicles/introducing-imgproxy)

See [official README](https://github.com/darthsim/imgproxy#imgproxy) for more.

## Prerequisites

* Kubernetes 1.4+ with Beta APIs enabled

## Installing chart

```shell
helm install --name imgproxy --namespace imgproxy incubator/imgproxy
```

The command deploys imgproxy on the Kubernetes cluster in the default configuration. The [configuration section](#configuration) lists various ways to override default configuration during deployment.

> **Tip:** To list all releases use `helm list`

## Uninstalling the Chart

```shell
helm delete imgproxy
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

Specify each parameter using the `--set key=value[,key=value]` argument to helm install or provide your own file via `-f values.yaml`. For example,

```shell
helm install \
  --name imgproxy \
  --namespace imgproxy \
  --set image.tag=v1.1.6 \
  incubator/imgproxy
```

The above command installs a specified version of imgproxy.

## Supporterd Chart values

These are the values used to configure imgproxy itself:

|Value|Description|Default|
|-----|-----------|-------|
|**key**|hex-encoded key for URL encoding|**CHANGE IT!!!**|
|**salt**|hex-encoded salt for URL encoding|**CHANGE IT!!!**|
|**readTimeout**|the maximum duration (in seconds) for reading the entire image request, including the body|`10`|
|**writeTimeout**|the maximum duration (in seconds) for writing the response|`10`|
|**downloadTimeout**|the maximum duration (in seconds) for downloading the source image|`5`|
|**concurrency**|the maximum number of image requests to be processed simultaneously|`double number of CPU cores`|
|**maxClients**|the maximum number of simultaneous active connections|`concurrency * 10`|
|**ttl**|duration in seconds sent in Expires and Cache-Control: max-age headers.|`3600`|
|**useEtag**|when true, enables using ETag header for the cache control|`false`|
|**localFileSystemRoot**|root of the local filesystem. See [Serving local files](https://github.com/darthsim/imgproxy#serving-local-files). Keep empty to disable serving of local files.||
|**allowOrigin**|when set, enables CORS headers with provided origin. CORS headers are disabled by default.||
|**maxSrcDimension**|the maximum dimensions of the source image, in pixels, for both width and height. Images with larger real size will be rejected.|`8192`|
|**maxSrcResolution**|the maximum resolution of the source image, in megapixels. Images with larger real size will be rejected|`16.8`|
|**secret**|the authorization token. If specified, request should contain the `Authorization: Bearer %secret%` header||
|**quality**|quality of the resulting image, percentage|`80`|
|**gzipCompression**|GZip compression level|`5`|
|**jpegProgressive**|when true, enables progressive compression of JPEG|`false`|
|**pngInterlaced**|when true, enables interlaced compression of PNG|`false`|
|**baseUrl**|base URL part which will be added to every requestsd image URL. For example, if base URL is `http://example.com/images` and `/path/to/image.png` is requested, imgproxy will download the image from `http://example.com/images/path/to/image.png`||

See `values.yaml` for some more Kubernetes-specific configuration options.
