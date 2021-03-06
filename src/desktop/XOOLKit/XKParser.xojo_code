#tag Class
Protected Class XKParser
	#tag Method, Flags = &h21, Description = 5365747320606D43757272656E74546F6B656E6020746F20746865206E65787420746F6B656E2C20726561647920746F206576616C756174652E
		Private Sub Advance()
		  /// Sets `mCurrentToken` to the next token, ready to evaluate.
		  
		  mPreviousToken = mCurrentToken
		  
		  If mCurrent > mTokensLastIndex Then
		    mCurrentToken = mTokens(mTokensLastIndex) // Assumes this will be an EOF token.
		    mCurrent = mTokensLastIndex + 1
		  Else
		    mCurrentToken = mTokens(mCurrent)
		    mCurrent = mCurrent + 1
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E2061727261792076616C75652E2052616973657320616E2060584B506172736572457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function ArrayValue() As Variant
		  /// Parses an array value. Raises an `XKParserException` if unsuccessful.
		  ///
		  /// Assumes we've consumed the opening `[`:
		  ///
		  /// ```
		  /// [1, 2, 3] 
		  ///  ^
		  /// ```
		  ///
		  /// Arrays cannot be nested.
		  ///
		  /// array   → LSQUARE (literal (COMMA literal)*)? RSQUARE
		  /// literal → BOOLEAN | COLOR | COLORGROUP | DATETIME | NIL | NUMBER | STRING
		  
		  // Empty array?
		  If Match(XKTokenTypes.RSquare) Then
		    Var result() As Variant
		    Return result
		  End If
		  
		  // Get all the values and their types as Pairs. Left = variant type, Right = value.
		  Var values() As Pair
		  
		  // Get the first value.
		  If Match(XKTokenTypes.BooleanLiteral) Then
		    values.Add(Variant.TypeBoolean : XKBooleanToken(mPreviousToken).Value)
		    
		  ElseIf Match(XKTokenTypes.ColorLiteral) Then
		    values.Add(Variant.TypeColor : XKColorToken(mPreviousToken).MyColor)
		    
		  ElseIf Match(XKTokenTypes.ColorGroupLiteral) Then
		    values.Add(Variant.TypeObject : XKColorGroupToken(mPreviousToken).Value)
		    
		  ElseIf Match(XKTokenTypes.DateTime) Then
		    values.Add(Variant.TypeDateTime : XKDateTimeToken(mPreviousToken).Value)
		    
		  ElseIf Match(XKTokenTypes.NilLiteral) Then
		    values.Add(Variant.TypeNil : Nil)
		    
		  ElseIf Match(XKTokenTypes.Number) Then
		    If XKNumberToken(mPreviousToken).IsInteger Then
		      values.Add(Variant.TypeInt64 : XKNumberToken(mPreviousToken).Value)
		    Else
		      values.Add(Variant.TypeDouble : XKNumberToken(mPreviousToken).Value)
		    End If
		    
		  ElseIf Match(XKTokenTypes.StringLiteral) Then
		    values.Add(Variant.TypeString : mPreviousToken.Lexeme)
		    
		  ElseIf Match(XKTokenTypes.LCurly) Then
		    Values.Add(Variant.TypeObject : InlineDict)
		    
		  ElseIf Match(XKTokenTypes.LSquare) Then
		    Values.Add(Variant.TypeArray : ArrayValue)
		    
		  Else
		    Error("Expected a value.")
		  End If
		  
		  While Match(XKTokenTypes.Comma)
		    If Match(XKTokenTypes.BooleanLiteral) Then
		      values.Add(Variant.TypeBoolean : XKBooleanToken(mPreviousToken).Value)
		      
		    ElseIf Match(XKTokenTypes.ColorLiteral) Then
		      values.Add(Variant.TypeColor : XKColorToken(mPreviousToken).MyColor)
		      
		    ElseIf Match(XKTokenTypes.ColorGroupLiteral) Then
		      values.Add(Variant.TypeObject : XKColorGroupToken(mPreviousToken).Value)
		      
		    ElseIf Match(XKTokenTypes.DateTime) Then
		      values.Add(Variant.TypeDateTime : XKDateTimeToken(mPreviousToken).Value)
		      
		    ElseIf Match(XKTokenTypes.NilLiteral) Then
		      values.Add(Variant.TypeNil : Nil)
		      
		    ElseIf Match(XKTokenTypes.Number) Then
		      If XKNumberToken(mPreviousToken).IsInteger Then
		        values.Add(Variant.TypeInt64 : XKNumberToken(mPreviousToken).Value)
		      Else
		        values.Add(Variant.TypeDouble : XKNumberToken(mPreviousToken).Value)
		      End If
		      
		    ElseIf Match(XKTokenTypes.StringLiteral) Then
		      values.Add(Variant.TypeString : mPreviousToken.Lexeme)
		      
		    ElseIf Match(XKTokenTypes.LCurly) Then
		      Values.Add(Variant.TypeObject : InlineDict)
		      
		    ElseIf Match(XKTokenTypes.LSquare) Then
		      Values.Add(Variant.TypeArray : ArrayValue)
		      
		    Else
		      Error("Expected a value.")
		    End If
		  Wend
		  
		  // We've collected all the values. Make sure we don't have any nested arrays.
		  For Each p As Pair In values
		    If p.Left = Variant.TypeArray Then
		      Error("Nested arrays are not supported.")
		    End If
		  Next p
		  
		  // Determine the common type.
		  Var commonType As Integer = values(0).Left
		  For Each p As Pair In values
		    If p.Left = Variant.TypeNil Then Continue
		    
		    If commonType = Variant.TypeNil Then
		      commonType = p.Left
		      Continue
		    End If
		    
		    If commonType <> p.Left Then
		      commonType = Variant.TypeObject
		      Exit
		    End If
		  Next p
		  commonType = If(commonType = Variant.TypeNil, Variant.TypeObject, commonType)
		  
		  If Not Match(XKTokenTypes.RSquare) Then
		    Error("Expected `]`.")
		  End If
		  
		  Select Case commonType
		  Case Variant.TypeBoolean
		    Var b() As Boolean
		    For Each p As Pair In values
		      b.Add(p.Right)
		    Next p
		    Return b
		    
		  Case Variant.TypeColor
		    Var c() As Color
		    For Each p As Pair In values
		      c.Add(p.Right)
		    Next p
		    Return c
		    
		  Case Variant.TypeDateTime
		    Var dt() As DateTime
		    For Each p As Pair In values
		      dt.Add(p.Right)
		    Next p
		    Return dt
		    
		  Case Variant.TypeDouble
		    Var d() As Double
		    For Each p As Pair In values
		      d.Add(p.Right)
		    Next p
		    Return d
		    
		  Case Variant.TypeInt32, Variant.TypeInt64
		    Var i() As Integer
		    For Each p As Pair In values
		      i.Add(p.Right)
		    Next p
		    Return i
		    
		  Case Variant.TypeObject
		    // Could this be a ColorGroup array?
		    Var isColorGroupArray As Boolean = False
		    For Each p As Pair In values
		      If p.Right IsA ColorGroup Then
		        isColorGroupArray = True
		      Else
		        isColorGroupArray = False
		        Exit
		      End If
		    Next p
		    
		    If isColorGroupArray Then
		      Var cg() As ColorGroup
		      For Each p As Pair In values
		        cg.Add(p.Right)
		      Next p
		      Return cg
		    Else
		      Var v() As Variant
		      For Each p As Pair In values
		        v.Add(p.Right)
		      Next p
		      Return v
		    End If
		    
		  Case Variant.TypeString
		    Var s() As String
		    For Each p As Pair In values
		      s.Add(p.Right)
		    Next p
		    Return s
		    
		  Else
		    Error("Error determining the common type for array.")
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 44657465726D696E65732074686520636F72726563742064696374696F6E61727920746F2061737369676E20746F20286372656174696E67206F6E65206966207265717569726564292E2052657475726E73207468652064696374696F6E61727920746F2061737369676E20746F2C20746865207061746820737472696E6720616E64206B65792E
		Private Function AssignmentPath() As Dictionary
		  /// Determines the correct dictionary to assign to (creating one if required). 
		  /// Returns the dictionary to assign to, the path string and key.
		  ///
		  /// Returns a`data` dictionary where:
		  ///   `data[assignmentPath]` is the dictionary to assign to.
		  ///   `data[pathString]` is the path as a dot-delimited string (e.g: "some.path").
		  ///   `data[key]` is the string key to assign to.
		  ///
		  /// Assumes the previous token was a keyName:
		  ///
		  /// ```
		  /// some.other.path = "hi"
		  ///     ^
		  ///
		  /// age = 40
		  ///     ^
		  /// ```
		  ///
		  /// keyName → IDENTIFIER | NIL | BOOLEAN
		  
		  // Get the path and key.
		  Var components() As String = Array(mPreviousToken.Lexeme)
		  While Match(XKTokenTypes.Dot)
		    If Match(XKTokenTypes.Identifier, XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral) Then
		      components.Add(mPreviousToken.Lexeme)
		    Else
		      Error("Expected an identifier after the dot.")
		    End If
		  Wend
		  
		  // The key is the last component of the path.
		  Var key As String = components.Pop
		  
		  // The assignment is relative to the current base path.
		  Var assignmentPath As Dictionary = mBasePath
		  
		  Var pathString As String
		  For Each component As String In components
		    pathString = pathString + component + "."
		    
		    If assignmentPath.HasKey(component) Then
		      // Make sure is either a dictionary or undefined.
		      If assignmentPath.Value(component) IsA Dictionary Then
		        assignmentPath = assignmentPath.Value(component)
		      Else
		        pathString = pathString.TrimRight(".")
		        Error(pathString + " is not a dictionary.")
		      End If
		      
		    Else
		      // Create a new dictionary.
		      Var d As New Dictionary
		      assignmentPath.Value(component) = d
		      assignmentPath = d
		    End If
		  Next component
		  
		  Return New Dictionary("assignmentPath" : assignmentPath, "pathString" : pathString, "key" : key)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5472756520696620776527766520726561636865642074686520656E64206F662074686520746F6B656E2073747265616D2E
		Private Function AtEnd() As Boolean
		  /// True if we've reached the end of the token stream.
		  
		  Return Match(XKTokenTypes.EOF)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732054727565206966207468652063757272656E7420746F6B656E27732074797065203D206074797065602E
		Private Function Check(type As XOOLKit.XKTokenTypes) As Boolean
		  /// Returns True if the current token's type = `type`.
		  
		  If mCurrentToken = Nil Then Return False
		  
		  Return mCurrentToken.Type = type
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 416476616E6365732074686520706172736572206966207468652063757272656E7420746F6B656E20697320616E79206F662060657870656374656460206F74686572776973652063616C6C7320604572726F722829602E
		Private Sub Consume(message As String, ParamArray expected() As XKTokenTypes)
		  /// Advances the parser if the current token is any of `expected` otherwise calls `Error()`.
		  
		  For Each type As XKTokenTypes In expected
		    If Check(type) Then
		      Advance
		      Return
		    End If
		  Next type
		  
		  Error(message)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52616973657320612070617273657220657863657074696F6E20617420606C6F636174696F6E60206F72207468652063757272656E74206C6F636174696F6E206966206E6F74207370656369666965642E
		Private Sub Error(message As String, location As XOOLKit.XKToken = Nil)
		  /// Raises a parser exception at `location` or the current location if not specified.
		  
		  #Pragma BreakOnExceptions False
		  
		  If location <> Nil Then
		    Raise New XKParserException(message, location)
		  ElseIf mPreviousToken <> Nil Then
		    Raise New XKParserException(message, mPreviousToken)
		  Else
		    Raise New XKParserException(message, mCurrentToken)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E73756D657320616E642068616E646C657320616E2065787072657373696F6E2E
		Private Sub Expression()
		  /// Consumes and handles an expression.
		  ///
		  /// expression → keyValue | setBasePath
		  
		  If Match(XKTokenTypes.Identifier, XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral) Then
		    KeyValue
		    
		  ElseIf Match(XKTokenTypes.LSquare) Then
		    If Match(XKTokenTypes.RSquare) Then
		      // Edge case: Switch the base path to root.
		      Consume("Expected a line ending or the EOF.", XKTokenTypes.EOL, XKTokenTypes.EOF)
		      mBasePath = mRoot
		    Else
		      SetBasePath
		    End If
		    
		  Else
		    Error("Unexpected token. Expected a key-value, inline dictionary or standard dictionary.")
		    
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E642072657475726E7320616E20696E6C696E652064696374696F6E6172792E2052616973657320612060584B506172736572457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function InlineDict() As Dictionary
		  /// Parses and returns an inline dictionary. Raises a `XKParserException` if unsuccessful.
		  ///
		  /// Assumes we've just consumed the opening `{`:
		  ///
		  /// ```
		  /// {first = "Garry", last = "Pettet"}
		  ///  ^
		  /// ```
		  ///
		  /// inlineDict         → LCURLY inlineDictKeyValue* RCURLY
		  /// inlineDictKeyValue → IDENTIFIER EQUAL literal
		  /// literal            → BOOLEAN | COLOR | COLORGROUP | DATETIME | NIL | NUMBER | STRING
		  
		  Var d As New Dictionary
		  
		  // Edge case: Empty dictionary.
		  If Match(XKTokenTypes.RCurly) Then Return d
		  
		  // Get the first key-value pair.
		  Var kv As Pair = InlineDictKeyValue
		  d.Value(kv.Left) = kv.Right
		  
		  // Additional key-values?
		  While Match(XKTokenTypes.Comma)
		    kv = InlineDictKeyValue
		    If d.HasKey(kv.Left) Then
		      Error("Redefined dictionary key `" + kv.Left.StringValue + "`.")
		    Else
		      d.Value(kv.Left) = kv.Right
		    End If
		  Wend
		  
		  // Need to see a closing brace.
		  Consume("Expected a `}`.", XKTokenTypes.RCurly)
		  
		  Return d
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E642072657475726E7320616E20696E6C696E652064696374696F6E617279206B65792D76616C7565207061697220284C656674203D206B65792C205269676874203D2076616C7565292E2052616973657320616E2060584B506172736572457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function InlineDictKeyValue() As Pair
		  /// Parses and returns an inline dictionary key-value pair (Left = key, Right = value). 
		  /// Raises an `XKParserException` if unsuccessful.
		  ///
		  /// ```
		  /// name = "Garry"
		  /// ^
		  /// ```
		  ///
		  /// inlineDictKeyValue → keyName EQUAL inlineDictValue
		  /// keyName            → IDENTIFIER | NIL | BOOLEAN
		  /// inlineDictValue    → BOOLEAN | COLOR | COLORGROUP | DATETIME | NIL | NUMBER | STRING
		  
		  Consume("Expected a key.", XKTokenTypes.Identifier, XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral)
		  Var key As String = mPreviousToken.Lexeme
		  
		  // Need to see an `=` sign.
		  Consume("Expected `=` after key name.", XKTokenTypes.Equal)
		  
		  If Match(XKTokenTypes.BooleanLiteral) Then
		    Return key : XKBooleanToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.ColorLiteral) Then
		    Return key : XKColorToken(mPreviousToken).MyColor
		    
		  ElseIf Match(XKTokenTypes.ColorGroupLiteral) Then
		    Return key : XKColorGroupToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.DateTime) Then
		    Return key : XKDateTimeToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.NilLiteral) Then
		    Return key : Nil
		    
		  ElseIf Match(XKTokenTypes.Number) Then
		    Return key : XKNumberToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.StringLiteral) Then
		    Return key : mPreviousToken.Lexeme
		    
		  Else
		    Error("Expected a boolean, color, colorgroup, datetime, number or string value or Nil.")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F2070617273652061206B65792D76616C756520706169722E
		Private Sub KeyValue()
		  /// Attempts to parse a key-value pair.
		  ///
		  /// If successful, the key-value is added relative to the current base path.
		  /// Assumes the previous token was an identifier.
		  ///
		  /// keyValue   → key EQUAL value terminator
		  /// key        → IDENTIFIER (DOT IDENTIFIER)*
		  /// value      → key | literal | array | inlineDict
		  /// literal    → STRING | NUMBER | BOOLEAN | COLOR | COLORGROUP | DATETIME | NIL
		  /// terminator → EOL | EOF
		  ///
		  /// E.g:
		  /// `name = "Garry"`
		  /// `server.ip = "123.123.123.123"`
		  
		  Var data As Dictionary = AssignmentPath
		  Var pathString As String = data.Value("pathString")
		  Var assignmentPath As Dictionary = data.Value("assignmentPath")
		  Var key As String = data.Value("key")
		  
		  // Are we about to overwrite a value?
		  If assignmentPath.HasKey(key) Then
		    Error("Cannot re-assign a value to `" + pathString + key + "`.")
		  End If
		  
		  // Need to see a `=`.
		  Consume("Expected an `=` after the key.", XKTokenTypes.Equal)
		  
		  // Assign the value.
		  assignmentPath.Value(key) = Value
		  
		  Consume("Expected EOL or EOF after the key's value.", XKTokenTypes.EOL, XKTokenTypes.EOF)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496620746865206E65787420746F6B656E206D61746368657320616E79206F662060747970657360207468656E20616476616E63657320616E642072657475726E7320547275652E
		Private Function Match(ParamArray types() As XOOLKit.XKTokenTypes) As Boolean
		  /// If the next token matches any of `types` then advances and returns True.
		  
		  For Each type As XKTokenTypes In types
		    If Check(type) Then
		      Advance
		      Return True
		    End If
		  Next type
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50757473207468652070617273657220696E746F2070616E6963206D6F64652E
		Private Sub Panic(e As XOOLKit.XKParserException)
		  /// Puts the parser into panic mode. 
		  ///
		  /// We try to put the parser back into a usable state once it has encountered 
		  /// an error. This allows the parser to keep parsing even though an error 
		  /// has occurred without causing all subsequent tokens to be mis-interpreted.
		  
		  // Add this error to our array of errors.
		  Errors.Add(e)
		  
		  // Try to recover.
		  Synchronise
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 50617273657320616E206172726179206F6620746F6B656E7320696E746F20612064696374696F6E6172792E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Function Parse(tokens() As XOOLKit.XKToken) As Dictionary
		  /// Parses an array of tokens into a dictionary. Raises an `XKException` if unsuccessful.
		  
		  #Pragma BreakOnExceptions False
		  
		  Reset(tokens)
		  
		  // Quick exit?
		  If mTokens.Count = 0 Then Return mRoot
		  
		  // The token stream must always end with the EOF token.
		  If mTokens(mTokensLastIndex).Type <> XKTokenTypes.EOF Then
		    mTokens.Add(New XOOLKit.XKToken(XKTokenTypes.EOF, 0, 1))
		  End If
		  
		  // Prime the pump.
		  Advance
		  
		  While Not AtEnd
		    Try
		      Expression
		    Catch e As XKParserException
		      Panic(e)
		    End Try
		  Wend
		  
		  Return mRoot
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657365747320746865207061727365722E
		Private Sub Reset(tokens() As XOOLKit.XKToken)
		  /// Resets the parser.
		  
		  mTokens = tokens
		  mTokensLastIndex = mTokens.LastIndex
		  mRoot = New Dictionary
		  mBasePath = mRoot
		  Errors.RemoveAll
		  mCurrent = 0
		  mCurrentToken = Nil
		  mPreviousToken = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 53657473207468652063757272656E74206261736520706174682E
		Private Sub SetBasePath()
		  /// Sets the current base path.
		  ///
		  /// If successful the dictionary is created if needed and the base path changed to this dictionary.
		  /// Assumes the previous token was a `[`:
		  ///
		  /// ```
		  /// [some.path]
		  ///  ^
		  /// ```
		  ///
		  /// setBasePath  → LSQUARE path RSQUARE terminator
		  /// path         → keyName (DOT IDENTIFIER)*
		  /// keyName      → IDENTIFIER | NIL | BOOLEAN
		  /// terminator   → EOL | EOF
		  
		  Consume("Expected an identifier.", XKTokenTypes.Identifier, _
		  XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral)
		  
		  // Get the path.
		  Var components() As String = Array(mPreviousToken.Lexeme)
		  While Match(XKTokenTypes.Dot)
		    If Match(XKTokenTypes.Identifier, XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral) Then
		      components.Add(mPreviousToken.Lexeme)
		    Else
		      Error("Expected an identifier after the dot.")
		    End If
		  Wend
		  
		  // Point to the correct dictionary.
		  mBasePath = mRoot
		  Var pathString As String
		  For Each component As String In components
		    pathString = pathString + component + "."
		    
		    If mBasePath.HasKey(component) Then
		      // Make sure is either a dictionary or undefined.
		      If mBasePath.Value(component) IsA Dictionary Then
		        mBasePath = mBasePath.Value(component)
		      Else
		        pathString = pathString.TrimRight(".")
		        Error(pathString + " is not a dictionary.")
		      End If
		      
		    Else
		      // Create a new dictionary.
		      Var d As New Dictionary
		      mBasePath.Value(component) = d
		      mBasePath = d
		    End If
		  Next component
		  
		  Consume("Expected a `]`.", XKTokenTypes.RSquare)
		  Consume("Expected a line ending or the EOF.", XKTokenTypes.EOL, XKTokenTypes.EOF)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 546865207061727365722069732070616E69636B696E67206265636175736520697420666F756E6420616E206572726F722E20476574206974206261636B206F6E20747261636B2E
		Private Sub Synchronise()
		  /// The parser is panicking because it found an error. Get it back on track.
		  ///
		  /// We simply skip tokens until we hit a statement boundary.
		  
		  While Not Match(XKTokenTypes.EOL, XKTokenTypes.EOF)
		    Advance
		  Wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 50617273657320616E642072657475726E73207468652076616C756520636F6D706F6E656E74206F662061206B65792D76616C756520706169722E
		Private Function Value() As Variant
		  /// Parses and returns the value component of a key-value pair.
		  ///
		  /// value   → key | literal | array | inlineDict
		  /// key     → IDENTIFIER (DOT IDENTIFIER)*
		  /// literal → STRING | NUMBER | BOOLEAN | COLOR | COLORGROUP | DATETIME | NIL
		  
		  If Match(XKTokenTypes.Identifier) Then
		    Var components() As String = Array(mPreviousToken.Lexeme)
		    // Consume the path.
		    While Match(XKTokenTypes.Dot)
		      If Match(XKTokenTypes.Identifier, XKTokenTypes.NilLiteral, XKTokenTypes.BooleanLiteral) Then
		        components.Add(mPreviousToken.Lexeme)
		      Else
		        Error("Expected an identifier after the dot.")
		      End If
		    Wend
		    // The key is the last component.
		    Var key As String = components.Pop
		    // A path is only valid as a value if it has already been declared.
		    Var tmpDict As Dictionary = mRoot
		    Var path As String
		    If components.Count > 0 Then
		      For Each component As String In components
		        path = path + component + "."
		        If tmpDict.HasKey(component) And tmpDict.Value(component) IsA Dictionary Then
		          tmpDict = tmpDict.Value(component)
		        Else
		          path = path.TrimRight(".")
		          Error(path + " is not a declared dictionary.")
		        End If
		      Next component
		    End If
		    If tmpDict.HasKey(key) Then
		      Return tmpDict.Value(key)
		    Else
		      Error(path + key + " is not a valid path.")
		    End If
		    
		  ElseIf Match(XKTokenTypes.StringLiteral) Then
		    Return mPreviousToken.Lexeme
		    
		  ElseIf Match(XKTokenTypes.Number) Then
		    Return XKNumberToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.BooleanLiteral) Then
		    Return XKBooleanToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.ColorLiteral) Then
		    Return XKColorToken(mPreviousToken).MyColor
		    
		  ElseIf Match(XKTokenTypes.ColorGroupLiteral) Then
		    Return XKColorGroupToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.DateTime) Then
		    Return XKDateTimeToken(mPreviousToken).Value
		    
		  ElseIf Match(XKTokenTypes.NilLiteral) Then
		    Return Nil
		    
		  ElseIf Match(XKTokenTypes.LSquare) Then
		    Return ArrayValue
		    
		  ElseIf Match(XKTokenTypes.LCurly) Then
		    Return InlineDict
		    
		  Else
		    Error("Expected a string, number, boolean, color, colorgroup, datetime, Nil, array or inline dictionary.")
		    
		  End If
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 416E79206572726F72732074686174206F6363757272656420647572696E672070617273696E672E
		Errors() As XOOLKit.XKParserException
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 5472756520696620616E79206572726F7273206F6363757272656420647572696E6720746865206D6F737420726563656E742070617273652E
		#tag Getter
			Get
			  Return Errors.Count > 0
			  
			End Get
		#tag EndGetter
		HasErrors As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 41207265666572656E636520746F207468652064696374696F6E6172792063757272656E746C79206265696E67207573656420617320746865206261736520666F722072656C61746976652070617468732E
		Private mBasePath As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 302D626173656420696E64657820696E20606D546F6B656E7360206F662074686520746F6B656E20746861742077696C6C2062652072657472696576656420776974682060416476616E63652829602E
		Private mCurrent As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652063757272656E7420746F6B656E20756E646572206576616C756174696F6E2E
		Private mCurrentToken As XOOLKit.XKToken
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652070726576696F757320746F6B656E206576616C756174656420286D6179206265204E696C292E
		Private mPreviousToken As XOOLKit.XKToken
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520726F6F742064696374696F6E6172792E
		Private mRoot As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520746F6B656E732077652772652063757272656E746C792070617273696E672E
		Private mTokens() As XOOLKit.XKToken
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4361636865732076616C7565206F6620606D546F6B656E732E4C617374496E646578602E
		Private mTokensLastIndex As Integer = -1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="HasErrors"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
