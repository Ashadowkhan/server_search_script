#!/bin/bash

# API keys (Replace with your own API keys)
HUNTER_API_KEY="your_hunter_api_key"
SHODAN_API_KEY="your_shodan_api_key"
FOFA_EMAIL="your_fofa_email"
FOFA_API_KEY="your_fofa_api_key"

# Initialize output file variable
OUTPUT_FILE=""

# Function to prompt user for search queries
get_user_queries() {
  read -p "Enter Hunter Query (default: product.name=\"OFBiz\"): " HUNTER_QUERY
  read -p "Enter Shodan Query (default: Set-Cookie: OFBiz.Visitor): " SHODAN_QUERY
  read -p "Enter FOFA Query (default: app=\"Apache_OFBiz\"): " FOFA_QUERY

  # Set defaults if no input is given
  HUNTER_QUERY=${HUNTER_QUERY:-'product.name="OFBiz"'}
  SHODAN_QUERY=${SHODAN_QUERY:-'Set-Cookie: OFBiz.Visitor'}
  FOFA_QUERY=${FOFA_QUERY:-'app="Apache_OFBiz"'}
}

# Function to search a single domain
search_domain() {
  local DOMAIN=$1

  echo "===== Searching for $DOMAIN ====="
  {
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

  } | tee -a "$OUTPUT_FILE"  # Output results to both terminal and output file
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
  echo "Usage: $0 [-u domain.com] [-d domain.txt] [-o outputfile.txt]"
  echo "  -u domain.com    Search for a single domain"
  echo "  -d domain.txt    Search for multiple domains from a file"
  echo "  -o outputfile.txt  Specify output file to save the results"
  exit 1
}

# Main logic for processing arguments
while getopts ":u:d:o:" opt; do
  case $opt in
    u)
      DOMAIN="$OPTARG"
      ;;
    d)
      FILE="$OPTARG"
      ;;
    o)
      OUTPUT_FILE="$OPTARG"
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

# Check if output file is set, if not default to output.txt
if [[ -z "$OUTPUT_FILE" ]]; then
  OUTPUT_FILE="output.txt"
fi

# Prompt for queries if not passed as environment variables
get_user_queries

# If a single domain is provided, search it
if [[ ! -z "$DOMAIN" ]]; then
  search_domain "$DOMAIN"
fi

# If a file of domains is provided, search all domains from the file
if [[ ! -z "$FILE" ]]; then
  search_domains_from_file "$FILE"
fi
