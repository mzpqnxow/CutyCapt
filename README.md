## CutyCapt

A Qt WebKit Web Page Rendering Capture Utility [sourceforce](http://cutycapt.sourceforce.net) created by Bjoern Hoehrmann (bjoern@hoehrmann.de)

There does not seem to be an officially maintained "upstream" CutyCapt repository, though there are some maintainers for downstream distribution packages. I do not know who they are

This repository is maintained by [mzpqnxow@github.com](https://github.com/mzpqnxow)

## Building

For dependencies, you'll need the Qt4 or Qt5 development packages installed. As of Debian 10 (Buster) you can build this fine using the Qt4 libraries

```
$ sudo apt-get install build-essential libqt4-dev libqtwebkit-dev
```

If you plan to use this for headless captures, install Xvfb:

```
$ sudo apt-get install xvfb
```

With the dependencies handled, you can use `qmake` to generate a GNU Makefile, then standard GNU `make` to build `CutyCapt`

```
$ qmake && make -j
```

If you have build errors, you probably have an issue with missing dependencies. I'm sorry that I don't have all of them documented here but it shouldn't be hard to figure out

## Running

From the [original site](http://cutycapt.sourceforce.net):

```
 % CutyCapt --help
 -----------------------------------------------------------------------------
 Usage: CutyCapt --url=http://www.example.org/ --out=localfile.png            
 -----------------------------------------------------------------------------
  --help                         Print this help page and exit                
  --url=<url>                    The URL to capture (http:...|file:...|...)   
  --out=<path>                   The target file (.png|pdf|ps|svg|jpeg|...)   
  --out-format=<f>               Like extension in --out, overrides heuristic 
  --min-width=<int>              Minimal width for the image (default: 800)   
  --min-height=<int>             Minimal height for the image (default: 600)  
  --max-wait=<ms>                Don't wait more than (default: 90000, inf: 0)
  --delay=<ms>                   After successful load, wait (default: 0)     
  --user-style-path=<path>       Location of user style sheet file, if any    
  --user-style-string=<css>      User style rules specified as text           
  --header=<name>:<value>        request header; repeatable; some can't be set
  --method=<get|post|put>        Specifies the request method (default: get)  
  --body-string=<string>         Unencoded request body (default: none)       
  --body-base64=<base64>         Base64-encoded request body (default: none)  
  --app-name=<name>              appName used in User-Agent; default is none  
  --app-version=<version>        appVers used in User-Agent; default is none  
  --user-agent=<string>          Override the User-Agent header Qt would set  
  --javascript=<on|off>          JavaScript execution (default: on)           
  --java=<on|off>                Java execution (default: unknown)            
  --plugins=<on|off>             Plugin execution (default: unknown)          
  --private-browsing=<on|off>    Private browsing (default: unknown)          
  --auto-load-images=<on|off>    Automatic image loading (default: on)        
  --js-can-open-windows=<on|off> Script can open windows? (default: unknown)  
  --js-can-access-clipboard=<on|off> Script clipboard privs (default: unknown)
  --print-backgrounds=<on|off>   Backgrounds in PDF/PS output (default: off)  
  --zoom-factor=<float>          Page zoom factor (default: no zooming)       
  --zoom-text-only=<on|off>      Whether to zoom only the text (default: off) 
  --http-proxy=<url>             Address for HTTP proxy server (default: none)
 -----------------------------------------------------------------------------
  <f> is svg,ps,pdf,itext,html,rtree,png,jpeg,mng,tiff,gif,bmp,ppm,xbm,xpm    
 -----------------------------------------------------------------------------
 http://cutycapt.sf.net - (c) 2003-2013 Bjoern Hoehrmann - bjoern@hoehrmann.de
```

### Headless Usage

Install the distribution package for Xvfb. This is a headless Xorg display that allows Qt and any other GUI application to run on a headless machine. You can either start up a long-running `xvfb` instance and set your `$DISPLAY` environment variable, or you can use as a one-time command like so:

```
$ xvfb-run --server-args="-screen 0, 1024x768x24" ./CutyCapt --url=... --out=...
```

Optionally, use the `capwrap.sh` script included here

## License

The original version of CutyCapt did not have any obvious license attached to it. No further comment.
