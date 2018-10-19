# clonestore-printer
Print server for clonestore labels

The clonestore print server provides a HTTP REST Api to print text and QR Codes. In a production environment, you might want to run the server behind a SSL-terminating proxy such as nginx or haproxy to provide encryption.

## Installation

For installation instructions, see [installation.md](docs/installation.md).

## Usage

## API

The API interface is defined in [api.md](docs/api.md). Any clonestore component should only rely on the API as it is specified here, so the print server can be replaced by any other implementation of the same API. 