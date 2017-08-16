#! /usr/bin/env bash

url='https://store.nin.com/collections/music/products/quake-ost-1xlp'
TEMPFILE=""

email="me@spike.cx"
subject="NIN Vinyl Site"

# use these vars for mailgun API use
if [[ -z "$MAILGUN_URL" || -z "$MAILGUN_KEY" ]]; then
  echo "no mailgun settings (MAILGUN_URL / MAILGUN_KEY)"
  exit 1
fi

temp::create() {
  TEMPFILE="$( mktemp '/tmp/check.XXXXXX' )"
}

temp::delete() {
  rm -rf "$TEMPFILE"
}

page::get() {
  local url="$1"

  curl -s "$url" > "$TEMPFILE"
}

page::get_value() {
  local selector="$1"

  cat "$TEMPFILE" \
    | pup "$selector text{}" \
    | sed -E \
      -e 's/[[:space:]]+/ /g' \
      -e 's/^[[:space:]]+//' \
      -e 's/[[:space:]]+$//' \
    | grep ..
}
    #| pup '#ProductPrice, div#nin-big div.description text{}' \

check::price_changed() {
  local expected="$1"

  local existing="$(page::get_value "#ProductPrice")"

  echo "Got price: [$existing]"

  [[ "$expected" != "$existing" ]]
}

check::state_changed() {
  local expected="$1"

  local existing="$(page::get_value "div#nin-big div.description")"

  echo "Got state: [$existing]"

  [[ "$expected" != "$existing" ]]
}

notify::send() {
  local msg="$1"

  curl -v \
    -XPOST \
    --user "api:${MAILGUN_KEY}" \
    --data-urlencode "to=${email}" \
    --data-urlencode "from=${email}" \
    --data-urlencode "subject=${subject}" \
    --data-urlencode "text=$msg" \
    "${MAILGUN_URL}/messages"
}

trap 'temp::delete' EXIT

temp::create
page::get "$url"

changed=0

if check::price_changed "\$0.00"; then
  echo "Price changed!"
  changed=1
else
  echo "Price is the same..."
fi

if check::state_changed "COMING SOON"; then
  echo "State changed!"
  changed=1
else
  echo "state is the same..."
fi

if (( changed )); then
  echo "Notifying"
  notify::send "It changed!"
else
  echo "not notifying'"
fi

