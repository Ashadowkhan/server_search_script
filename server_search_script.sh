#!/bin/bash

# API keys (Replace with your own API keys)
HUNTER_API_KEY="your_hunter_api_key"
SHODAN_API_KEY="your_shodan_api_key"
FOFA_EMAIL="your_fofa_email"
FOFA_API_KEY="your_fofa_api_key"

# Search queries
HUNTER_QUERY='product.name="OFBiz"'
SHODAN_QUERY='Set-Cookie: OFBiz.Visitor'
FOFA_QUERY='app="Apache_OFBiz"'

# Function to search a single domain
search_domain() {
  local DOMAIN=$1

  echo "===== Searching for $DOMAIN ====="

  # Hunter search
  echo "Searching in Hunter..."
  curl -s "https://api.hunter.io/v2/domain-search?domain=$DOMAIN&api_key=$HUNTER_API_KEY&company=$HUNTER_QUERY" | jq .

  # Shodan search
  echo "Searching in Shodan..."
  curl -s "https://api.shodan.io/shodan/host/search?key=$SHODAN_API_KEY&query=$SHODAN_QUERY domain:$DOMAIN" | jq .

  # FOFA search
  echo "Searching in FOFA..."
  FOFA_ENCODED_QUERY=$(echo -n "$FOFA_QUERY domain:$DOMAIN" | base64)
  curl -s "https://fofa.info/api/v1/search/all?email=$FOFA_EMAIL&key=$FOFA_API_KEY&qbase64=$FOFA_ENCODED_QUERY" | jq .
}

# Function to search multiple domains from a file
search_domains_from_file() {
  local FILE=$1

  if [[ ! -f "$FILE" ]]; then
    echo "File $FILE not found!"
    exit 1
  fi

  while IFS= read -r DOMAIN
  do
    search_domain "$DOMAIN"
  done < "$FILE"
}

# Usage function
usage() {
  echo "Usage: $0 [-u domain.com] [-d domain.txt]"
  echo "  -u domain.com    Search for a single domain"
  echo "  -d domain.txt    Search for multiple domains from a file"
  exit 1
}

# Main logic for processing arguments
while getopts ":u:d:" opt; do
  case $opt in
    u)
      search_domain "$OPTARG"
      ;;
    d)
      search_domains_from_file "$OPTARG"
      ;;
    *)
      usage
      ;;
  esac
done

# If no options are provided, show usage
if [[ $OPTIND -eq 1 ]]; then
  usage
fi
