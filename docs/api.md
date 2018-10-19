# API documentation

## Authentication

On installation, the print server will generate an authentication token. This (symmetric) token has to be known by every client that wants to send print requests to the server. To authenticate a single API request, the client generates a HMAC_SHA256 of the request data parameters, separated by a pipe character (`|`) concatenated with the current UNIX timestamp divided by 30, using the authentication token as the HMAC key. This HMAC is passed to the API in hexadecimal format via the `mac` parameter.

For example, to authenticate a request to print a label with a QR Code reading `example.com` and the text `Testlabel` at timestamp 1234567, you would calculate `HMAC-SHA256('example.com|Testlabel41152', key)`, where `1234567 / 30 = 41152` (integer division). 

## Methods

The API consists of only a single endpoint, in this example `http://printer.example.com`.

### Printer Info

`GET http://printer.example.com`

Returns a JSON Object including name and location of the printer.

| Property   | Format | Description                                |
| ---------- | ------ | ------------------------------------------ |
| type       | text   | Constant string `clonestore-printer`, may be used to discover printers |
| name       | text   | Human-readable name of the printer         |
| location   | text   | Human-readable location of the printer     |

### Printing

`POST http://printer.example.com/`  

Prints some data on a label. Returns a JSON Object indicating success.

| Parameter  | Format | Description                             |
| ---------- | ------ | --------------------------------------- |
| qrdata     | text   | Data to be encoded in the label QR-Code |
| text       | text   | Additional data to print as plaintext next to the QR-Code; May contain newlines |
| mac        | hex    | HMAC token of qrdata|text, see authentication |

| Property   | Format | Description                                |
| ---------- | ------ | ------------------------------------------ |
| success    | bool   | True if printing succeeded, false otherwise |
| statustext | text   | Human-readable status of the request       |