# Installation

This guide assumes you are trying to install the CloneStore print server on a Raspberry Pi 3 running Arch Linux with a Brother QL-700 label printer. For other distributions, it should mostly suffice to replace `pacman` with your package manager of choice.

## Prerequisites

Once your system is up and running, install `git`, `gcc`, `libjpeg`, `imagemagick`, `python`, `pip`, `ruby` and `rubygems`.

```sudo pacman -S git gcc libjpeg imagemagick python python-pip ruby rubygems```

## Get the code

To get started, clone this git repository whereever you'd like to install the print server.

```git clone https://github.com/rec0de/clonestore-printer.git```

## Semi-automatic installation

In the cloned repository you'll find an installation script that attempts to automatically install the needed components and start the configuration. Simply run `bash install.sh` as the user that the server is going to run under. This is important as the script ensures the user has the permissions needed to interface with the printer.  
You may be prompted for your password as the installation requires superuser rights.

Once the installation is complete, you will receive an authentication key that needs to be entered on every client that connects to the print server. You can also retrieve this key at a later time from the `config.json` file.

## Manual installation

Should the automatic installation fail, you can follow these steps to get the print server up and running.

### 1. Install brother_ql

[brother_ql](https://github.com/pklaus/brother_ql) by Philipp Klaus is a python package for Brother Label printers, bypassing the need for custom drivers by communicating directly with the device.

```sudo pip install brother_ql```

Should you have trouble with the installation, please refer to the [brother_ql readme](https://github.com/pklaus/brother_ql/blob/master/README.md).

### 2. Install sinatra

[Sinatra](https://sinatrarb.com) is the Ruby framework used to provide a simple web server for the REST API.

```sudo gem install sinatra```

For more information, see the [Sinatra documentation](http://sinatrarb.com/documentation.html).

### 3. Install rqrcode

[rqrcode](https://github.com/whomwah/rqrcode) is a Ruby library used to create the label QR codes.

```sudo gem install rqrcode```

### 4. Add user to lp group

To be granted access to the printer, a user usually has to be in the `lp` group.

```sudo usermod -a -G lp username```

### 5. Configuration

For a somewhat guided configuration, run `ruby configure.rb`.  
To configure the server manually, just create a `config.json` file in the clonestore-printer directory with the following structure:

```
{
	"uri": "file:///dev/usb/lp0",
	"model": "QL-700",
	"dimensions": "29x90",
	"authKey": "[128bit base64 encoded random data]",
	"name": "Human readable printer name",
	"location": "Human readable printer location"
}
```

Here, `uri`, `model` and `dimensions` correspond to the arguments `brother_ql` needs to print. For a list of possible values and how to find them, please refer to the [brother_ql documentation](https://github.com/pklaus/brother_ql/blob/master/README.md).
  
The `authKey` value is used as a shared secret between the print server and the client used to authenticate incoming print requests. It should be set to a sufficiently long (128bit recommended) random string in base64 format. You will need this string on any client that should connect to the print server.