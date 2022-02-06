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

Copy both `XOOLKit` and `StringKit` into your project and you're all set up. Mimicking Xojo's `ParseJSON()` and `GenerateJSON()` methods, `XOOLKit` adds two methods to the global namespace: `ParseXOOL()` and `GenerateXOOL()`. You can use them like so:

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

### Comment

A hash symbol marks the start of a comment. Comments run to the end of the line. They can occur anywhere, even within arrays.

```xool
# This is a full line comment.
key1 = "value" # This is a comment at the end of a line.
key2 = [
  1, 
  2, # inline comment
  3
]
```

### Key / Value Pair

These are the atomic building blocks of a XOOL document. Keys are on the left hand side of the equal sign and the value is on the right. Whitespace is ignored around keys and values. The key, `=` sign and value must be on the same line although certain values (e.g. strings) can span multiple lines. Values must be one of the following types:

- String
- Number
- Boolean
- Color
- DateTime
- Array
- Inline dictionary

Unspecified values are invalid:

```xool
key = # Invalid.
```

There must be a newline (or the end of the file) after a key/value pair:

```xool
key1 = "value1" key2 = "value2" # Invalid.
```

### Keys

A key may be either bare or dotted.

**Bare keys** may only contain ASCII letters, digits or the underscore (`A-Za-z0-9_`). They must begin with an ASCII letter.

```xool
key = "value"
another_key = "value"
key123 = "value"
```

A bare key must be non-empty:

```xool
= "no key name" # Invalid.
```

**Dotted keys** are a sequence of bare keys joined with a dot. This allows you to group similar properties together:

```xool
name = "Fido"
physical.breed = "Poodle"
physical.color = "Brown" # Could use a color literal here instead of a string.
```

This would translate to JSON as:

```json
{
  "name": "Fido",
  "physical": {
    "breed": "Poodle",
    "color": "Brown"
  }
}
```

Whitespace around dot-separated parts is ignored but it's best practice to not use excessive whitespace:

```xool
dog.breed = "Poodle" # Best practice
dog . temperament = "Docile" # Same as dog.temperament
dog   .sheds = True # Same as dog.sheds
```

Indentation is ignored.

Defining a key multiple times in the same dictionary is invalid:

```xool
# Don't do this
name = "Garry"
name = "Dave"
```

As long as a key hasn't been directly defined, you can still write to it and to keys within it.

```xool
# This makes the key "fruit" into a dictionary.
fruit.apple.smooth = true

# So then you can add to the dictionary "fruit" like so:
fruit.orange = 2
```

```xool
# This is invalid.

# This defines the value of fruit.apple to be an integer.
fruit.apple = 1

# But then this treats fruit.apple like it's a table.
# You can't turn an integer into a table.
fruit.apple.smooth = true
```

[stringkit]: https://github.com/gkjpettet/StringKit 