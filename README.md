# NIN Quake Vinyl checker

check the status of the NIN Quake soundtrack Vinyl. Use mailgun API to notify of changes.

Need to set `$MAILGUN_URL` and `$MAILGUN_KEY` to use.

run `./check.sh` and it will pull down the page, use `pup` to pull html out and check for price and
`COMING SOON` string. Email if either is not there.

