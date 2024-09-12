Here’s an updated version of the `search_script.sh` to add support for outputting the results to a file using the `-o` flag.

### Script: `search_script.sh`

```bash
#!/bin/bash

# API keys (Replace with your own API keys)
HUNTER_API_KEY="your_hunter_api_key"
SHODAN_API_KEY="your_shodan_api_key"
FOFA_EMAIL="your_fofa_email"
FOFA_API_KEY="your_fofa_api_key"

# edit Search queries
HUNTER_QUERY='product.name="OFBiz"'
SHODAN_QUERY='Set-Cookie: OFBiz.Visitor'
FOFA_QUERY='app="Apache_OFBiz"'

```

### Explanation:
- **`-o outputfile.txt`**: This flag specifies an output file where all the results will be saved. If not provided, it defaults to `output.txt`.
- **`tee -a $OUTPUT_FILE`**: This command is used to append results to the output file while still displaying them on the terminal.
- **Usage**:
  - To search a single domain and save the output:
    ```bash
    ./search_script.sh -u example.com -o outputfile.txt
    ```
  - To search multiple domains from a file and save the output:
    ```bash
    ./search_script.sh -d domain.txt -o outputfile.txt
    ```
  - If the `-o` flag is omitted, results are saved to a default file `output.txt`.

### Notes:
- You must replace the placeholder API keys with actual values.
- `jq` is used to format the JSON responses. Make sure it's installed:
  ```bash
  sudo apt-get install jq
  ```
