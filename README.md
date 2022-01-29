# XOOLKit
A XOOL parser for Xojo.

## Xojo Optimised Obvious Language (XOOL)

XOOL (pronounced Zool) is a human readable file format for saving configuration data. Think JSON, only simpler. XOOLKit is the reference parser for XOOL written in Xojo.

## Aims

There are already many formats for saving configuration data but none of them satisfy these aims:

1. Human readable
2. Directly translatable to Xojo code
3. Support comments within the document

JSON has curly braces all over the place and doesn't support comments. YAML supports comments but uses whitespace for indentation. This means large configuration files can become difficult to edit by hand without an IDE to help. TOML comes really close but as it has matured it has, in my opinion, become overly complex for my needs. 

## Example

```xool
# This is a comment.

# These are values of the root dictionary...
stringValue = "Some value"
doubleValue = 1.00
integerValue = 42
booleanValue = True # Comments run to the end of the line.
colorValue = &cABCDEF

multiLineStringValue = """
Roses are red
Violets are blue"""

[database]
ports = [8080, 80]
enabled = False

[servers.debug]
ip = "123.456.789.0"
password = "123456"

[servers.production]
ip = "123.456.111.2"
password = "password1"
```

The above XOOL is equivalent to the following JSON:

```json
{
  "stringValue": "Some value", 
  "doubleValue": 1.00, 
  "integerValue": 42,
  "booleanValue": true,
  "colorValue": "&cABCDEF", 
  "multilineStringValue": "Roses are red\nViolets are blue",
  
  "database": {
    "ports": [8080, 80], 
    "enabled": false
  }, 
  
  "servers": {
    "debug": {
      "ip": "123.456.789.0",
      "password": "123456"
    }, 
    "production": {
      "ip": "123.456.111.2", 
      "password": "password1"
    }
  }
}
```
