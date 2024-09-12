To allow the user to dynamically input the search queries, such as `HUNTER_QUERY`, `SHODAN_QUERY`, and `FOFA_QUERY`, we can modify the script to accept those values via command-line arguments or prompt the user for input.

### Updated Script with User Input for Search Queries:

```bash
#!/bin/bash

# API keys (Replace with your own API keys)
HUNTER_API_KEY="your_hunter_api_key"
SHODAN_API_KEY="your_shodan_api_key"
FOFA_EMAIL="your_fofa_email"
FOFA_API_KEY="your_fofa_api_key"

```

### Explanation:
1. **User Input for Queries**: The script will now prompt the user to input values for `HUNTER_QUERY`, `SHODAN_QUERY`, and `FOFA_QUERY`. If the user does not provide any input, default values are set (`'product.name="OFBiz"'`, `'Set-Cookie: OFBiz.Visitor'`, and `'app="Apache_OFBiz"'`).
   
2. **Search Queries**: The input queries will be used in the API requests for **Hunter**, **Shodan**, and **FOFA**.
   
3. **Run the Script**:
   - For a single domain:
     ```bash
     ./search_script.sh -u example.com -o outputfile.txt
     ```
   - For multiple domains from a file:
     ```bash
     ./search_script.sh -d domain.txt -o outputfile.txt
     ```
   
4. **Defaults**: If no `-o` flag is provided, it defaults to saving results in `output.txt`. If no queries are provided during prompts, it uses the default query strings.
