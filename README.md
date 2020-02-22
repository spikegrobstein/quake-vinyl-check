# NIN Quake Vinyl checker

check the status of the NIN Quake soundtrack Vinyl. Use mailgun API to notify of changes.

## Requirements

### Packages

 * `pup` for processing HTML
 * `curl` for using Mailgun API

### Environment variables

 * `MAILGUN_URL`
 * `MAILGUN_KEY`

## Usage

    ./check.sh

It will pull down the page, parse HTML and check for price and
`COMING SOON` string. Email if either is not there.

