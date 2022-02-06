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

# These are values of the root dictionary.
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

## Usage

To use XOOL in your projects, you'll need two components:

1. The `XOOLKit` module (found in the `/src/desktop/XOOLKit Dev Harness` project in this repo).
2. My open source `StringKit` module available in [this repo][stringkit].

Copy both `XOOLKit` and `StringKit` into your project and you're all set up. Mimicking Xojo's `ParseJSON()` and `GenerateJSON()` methods, `XOOLKit` adds to methods to the global namespace: `ParseXOOL()` and `GenerateXOOL()`. You can use them like so:

```xojo
// Convert a dictionary to a XOOL document.
Var d As New Dictionary("name" : "Garry", "age" : 40)
Var xool As String = GenerateXOOL(d)

// Parse a XOOL document (e.g. from a file) into a dictionary.
Try
d = ParseXOOL(inputXOOL) // Assumes `inputXOOL` is a XOOL document.
Catch e As XOOLKIT.XKException
// There's a problem with the input XOOL.
End Try
```

Exactly like `GenerateJSON()`, `GenerateXOOL()` can take any `Variant` value and return its XOOL representation (e.g. by double-quoting and escaping strings) but only passing a dictionary to `GenerateXOOL()` will result in a valid XOOL document.

Whilst XOOL is not designed to be capable of serialising any arbitrary data structure, it is possible to serialise your own classes if you like. To do so, your class should implement the `XOOLKit.XKSerializable` interface. It has a single method (`ToInlineDictionary()`) that expects you to return (as a string) a representation of your class as a XOOL inline dictionary. See the test app for an example of a simple serialisable contact class.

## Full Spec


[stringkit]: https://github.com/gkjpettet/StringKit 