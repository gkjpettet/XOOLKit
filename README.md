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
- Nil
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

Defining dotted keys out-of-order is discouraged.

```xool
# Valid but not best practice.

apple.type = "fruit"
orange.type = "fruit"

apple.skin = "thin"
orange.skin = "thick"

apple.color = "red"
orange.color = "orange"

# Recommended.

apple.type = "fruit"
apple.skin = "thin"
apple.color = "red"

orange.type = "fruit"
orange.skin = "thick"
orange.color = "orange"
```

Keys are **case insensitive**.

### String

There are two types of string values in XOOL: **standard** and **raw**. All string must contain only valid UTF-8 characters.

**Standard strings** are surrounded by double quotes (`"`).Any Unicode character may be used except those that must be escaped. A handful of escape sequences are supported:

```nohighlight
\"          # Double quote character.
\\          # Backslash.
\b          # Backspace.
\e          # ESC character.
\n          # Newline.
\r          # Carriage return.
\t          # Tab.
\u0041      # Unicode code point (4 hex digits)
\U0001F64A  # Unicode code point (8 hex digits)
```

```xool
str = "A string. \"\t\\" # A string. "  \
```

Any Unicode character may be escaped with the `\uXXXX` or `\UXXXXXXXX` forms where `X` is a valid hexadecimal digit.

Standard strings can also span multiple lines. When they do, the newline character within the string will always be normalised to the Unix line ending (`\n`):

```xool
str = "hi
there,
again"
```

**Raw strings** are surrounded by three double quotation marks (`"""`). Characters within raw strings are treated literally with no escaping. They may also span multiple lines:

```xool
str1 = """
Roses are red
Violets are blue"""
```

To avoid introducing extraneous whitespace, use a "line ending backslash" with raw strings. When the last non-whitespace character on a line is a `\`, it will be trimmed along with all whitespace (including newlines) up to the next non-whitespace character or closing delimiter:
```
# The following strings are equivalent:
str1 = "The quick brown fox jumps over the lazy dog."

str2 = """
The quick brown \


  fox jumps over \
    the lazy dog."""

str3 = """\
       The quick brown \
       fox jumps over \
       the lazy dog.\
       """
```

### Number

Numbers may be either integers or double values. They may be prefixed with a `-` sign:

```xool
int1 = 42
int2 = -10
dbl1 = 1.0
dbl2 = -2.5
```

Non-negative integer values may be expressed in hexadecimal, octal or binary using the same syntax as Xojo uses:

```xool
# Hexadecimal with prefix `&h`
hex1 = &hDEADBEEF
hex2 = &habcdef
hex3 = &h12ab34cd

# Octal with prefix `&o`
oct1 = &o01234567
oct2 = &o755 # useful for Unix file permissions

# Binary with prefix `&b`
bin1 = &b11010110
```

Doubles are parsed as 64-bit values. A double consists of an integer part (which follows the same rules as decimal integer values) followed by a fractional part and/or an exponent part. If both a fractional part and exponent part are present, the fractional part must precede the exponent part:

```xool
# Fractional.
dbl1 = 1.0
dbl2 = 3.1415
dbl3 = -0.01

# Exponent.
dbl4 = 5e+22
dbl5 = 1e06
dbl6 = -2E-2

# Both.
dbl7 = 6.626e-34
```

A fractional part is a decimal point followed by one or more digits.

An exponent part is an `E` (upper or lower case) followed by an integer part (which follows the same rules as decimal integer values but may include leading zeros).

The decimal point, if used, must be surrounded by at least one digit on each side.

```xool
# Invalid doubles.
invalid_double_1 = .7
invalid_double_2 = 7.
invalid_double_3 = 3.e+20
```

### Boolean

Booleans are how you would expect. They are case insensitive.

```xool
bool1 = True
bool2 = false
```

### Nil

Nil is self-explanatory:

```xool
key1 = Nil
key2 = nil
```

### Color

Color literals are prefixed with `&c` and then follow the CSS convention with three possibilities:

```xool
&cRGB      # red, green, blue
&cRRGGBB   # red, red, green, green, blue, blue
&cRRGGBBAA # red, red, green, green, blue, blue, alpha, alpha
```

Where RGBA are hexadecimal digits.

### DateTime

You can specify a date and time in SQL format:

```xool
xmas2022 = 2022-12-25 00:00:00 # YYYY-MM-DD HH:SS
```

If you don't need the time you can specify just the date:

```xool
newyears = 2022-01-01 # YYYY-MM-DD
```

If you aren't interested in the date, only the time you can use this format:

```xool
bedtime = 23:30:00 # HH:MM:SS
```

### Array

Arrays are square brackets with values inside. Whitespace is ignored. Comments are permitted within arrays. Elements are separated by commas. Arrays can contain values of the same data types as allowed in key/value pairs. Values of different types may be mixed. Arrays **cannot** be nested.

```xool
integers = [ 1, 2, 3 ]
mixed_array = [1, 2, "a", "b", "c"]
string_array = [ "all", "strings", """are the same""", "type" ]

# Mixed-type arrays are allowed
numbers = [ 0.1, 0.2, 0.5, 1, 2, 5 ]
contributors = [
  "Foo Bar <foo@example.com>",
  { name = "Baz Qux", email = "bazqux@example.com", url = "https://example.com/bazqux" }
]
```

### Inline dictionary

Inline dictionaries provide a more compact method for expressing a dictionary. Inline dictionaries must be fully defined within curly braces `{` and `}`. Within the braces, zero or more comma-separated key/value pairs may appear. Key/value pairs take the same form as key/value pairs in standard dictionaries. All value types are allowed, including inline dictionaries.

Inline dictionaries are intended to appear on a single line. A terminating comma (also called trailing comma) is not permitted after the last key/value pair in an inline dictionary. No newlines are allowed between the curly braces unless they are valid within a value. Even so, it is strongly discouraged to break an inline dictionary onto multiples lines. If you find yourself needing to do this, you should use a standard dictionary with an absolute path.

### Dictionary paths

All keys entered in the document are by default children of the root dictionary. You can change this behaviour by specifying an absolute path within `[]` which will then cause all subsequent key/values to be relative to that path.

```xool
name = "Garry"
hobbies.primary = "Programming"
hobbies.secondary = "Movie watching"
education.school = "John Hampden Grammar"
education.uni = "Imperial College"
```

Equates to this in JSON:
```json
{
  "name": "Garry", 
  "hobbies": {
    "primary": "Programming",
    "secondary": "Movie watching"
  },
  "education": {
    "school": "John Hampden",
    "uni": "Imperial College"
}
```

We can however break out these assignments more cleanly:

```xool
name = "Garry"

[hobbies]
primary = "Programming"
secondary = "Movie watching"

[education]
school = "John Hampden Grammar"
uni = "Imperial College"
```

The document is parsed from top-to-bottom so to switch back to the root dictionary use `[]` on its own. This is discouraged.

[stringkit]: https://github.com/gkjpettet/StringKit 