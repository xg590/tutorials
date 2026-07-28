## Configure it on Ubuntu2204
```
Claude Code 
    | MCP protocol 
Playwright MCP server 
    | browser automation 
Google Chrome (real rendering engine)
    | 
Rendered webpage screenshot / DOM / console errors 
```
### Chrome
```
$ wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
$ google-chrome --version
Google Chrome 150.0.7871.128 
```
### Playwright
* Install only for the project
``` 
mkdir -p tests && cd tests
npm install playwright
npm install @playwright/test
```
* Test Playwright (Task: Open NYU Mainpage with Chrome and check if the webpage title is "New York University")
```sh
$ cat << EOF > example.spec.js
import { test, expect } from '@playwright/test';

test('open Google', async ({ page }) => {
    await page.goto('https://www.nyu.edu/');
    await expect(page).toHaveTitle('New York University');
});
EOF

$ cat << EOF > playwright.config.js
import { defineConfig } from '@playwright/test';

export default defineConfig({
  use: {
    channel: 'chrome',
    headless: false
  }
});
EOF

npx playwright test
``` 
### Playwright MCP
* Install
```sh
npm install @playwright/mcp
npx @playwright/mcp --help
```
### Test MCP 
* Configure
```sh
$ cat << EOF > .mcp.json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": [
        "--no-install",
        "@playwright/mcp",
        "--browser",
        "chrome"
      ]
    }
  }
}
EOF
```
* Run Claude
```
$ claude
```
* Inside Cladue
```markdown
> /mcp   
  Manage MCP servers
  1 server 
    Project MCPs (~/tests/.mcp.json)
  > playwright · ✔ connected · 24 tools
``` 
* Have a conversation with Claude and get the screenshot
```
open www.baidu.com with Chrome and save the screenshot as aaa.png 
```