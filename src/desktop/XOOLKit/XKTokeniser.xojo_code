#tag Class
Protected Class XKTokeniser
	#tag Method, Flags = &h21, Description = 416476616E6365732060636F756E746020706F736974696F6E73206F7220746F2074686520656E64206F662074686520736F7572636520636F6465202877686963686576657220697320736F6F6E6572292E
		Private Sub Advance(count As Integer = 1)
		  /// Advances `count` positions or to the end of the source code (whichever is sooner).
		  
		  For i As Integer = 1 To count
		    Call Consume
		  Next i
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function AtEnd() As Boolean
		  /// True if we've reached the end of the characters.
		  
		  Return mCurrent > mCharactersLastIndex
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function BinaryToken() As XOOLKit.XKNumberToken
		  /// Attempts to add a binary number token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `&`:
		  /// ```
		  /// num = &b1001
		  ///        ^
		  /// ```
		  
		  If Not Match("b") Then SyntaxError("Expected `b` at start of binary literal.")
		  
		  // Need to see at least one binary digit.
		  If Not Consume.IsBinaryDigit Then SyntaxError("Expected a binary digit.")
		  
		  // Get the remaining binary digits (if any).
		  While Peek.IsBinaryDigit
		    Advance
		  Wend
		  
		  // Need to see whitespace, `]`, `}`, a comma or EOF
		  Select Case Peek
		  Case " ", &u09, &u0A, "]", "}", ",", ""
		    // +2 to account for the `&b` prefix.
		    Var lexeme As String = ComputeLexeme(mTokenStart + 2, mCurrent - 1)
		    Return New XKNumberToken(mTokenStart, mLineNumber, Integer.FromBinary(lexeme), True)
		  Else
		    SyntaxError("Expected whitespace, `]`, `}`, `.` or EOF after binary number literal.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function ColorGroupToken() As XOOLKit.XKToken
		  /// Attempts to add a color group token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `&`:
		  /// ```
		  /// c = &gFFF:AA22FF
		  ///      ^
		  ///
		  /// c = &cgFFF
		  ///      ^
		  /// ```
		  ///
		  /// Color group literals follow the CSS format:
		  /// ```
		  /// RGB      # red, green, blue
		  /// RRGGBB   # red, red, green, green, blue, blue
		  /// RRGGBBAA # red, red, green, green, blue, blue, alpha, alpha
		  /// ```
		  /// Where `R`, `G`, `B` and `A` are hexadecimal digits.
		  /// Color groups are two colours separated by a colon.
		  /// The second colour is **not** prefixed by `&g`.
		  
		  If Not Match("g") Then SyntaxError("Expected `&g` at start of a ColorGroup literal.")
		  
		  Var light(), dark() As String
		  
		  // ===========================
		  // LIGHT COLOUR
		  // ===========================
		  // Need to see at least 3 hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  light.Add(mCharacters(mCurrent - 3))
		  light.Add(mCharacters(mCurrent - 2))
		  light.Add(mCharacters(mCurrent - 1))
		  
		  // 3 digit Color literal?
		  Select Case Peek
		  Case " ", &u09
		    // Consume whitespace.
		    While Match(" ", &u09)
		    Wend
		    If Match(":") Then
		      Goto DarkColor
		    Else
		      SyntaxError("Expected a `:` after the light ColorGroup colour.")
		    End If
		  Case ":"
		    Goto DarkColor
		  Case &u0A, ""
		    SyntaxError("Expected a `:` after the light ColorGroup colour.")
		  End Select
		  
		  // Need to see at least 3 more hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  light.Add(mCharacters(mCurrent - 3))
		  light.Add(mCharacters(mCurrent - 2))
		  light.Add(mCharacters(mCurrent - 1))
		  
		  // 6 digit Color literal?
		  Select Case Peek
		  Case " ", &u09
		    // Consume whitespace.
		    While Match(" ", &u09)
		    Wend
		    If Match(":") Then
		      Goto DarkColor
		    Else
		      SyntaxError("Expected a `:` after the light ColorGroup colour.")
		    End If
		  Case ":"
		    Goto DarkColor
		  Case &u0A, ""
		    SyntaxError("Expected a `:` after the light ColorGroup colour.")
		  End Select
		  
		  // Need to see at least 2 more hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  light.Add(mCharacters(mCurrent - 2))
		  light.Add(mCharacters(mCurrent - 1))
		  
		  // Consume whitespace.
		  While Match(" ", &u09)
		  Wend
		  
		  If Not Match(":") Then
		    SyntaxError("Expected a `:` after a ColorGroup's light colour.")
		  End If
		  
		  // ===========================
		  // DARK COLOUR
		  // ===========================
		  DarkColor:
		  // Consume whitespace.
		  While Match(" ", &u09)
		  Wend
		  
		  // Need to see at least 3 hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  dark.Add(mCharacters(mCurrent - 3))
		  dark.Add(mCharacters(mCurrent - 2))
		  dark.Add(mCharacters(mCurrent - 1))
		  
		  // 3 digit Color literal?
		  Select Case Peek
		  Case " ", &u09, &u0A, "", ",", "}", "]"
		    Return New XKColorGroupToken(mTokenStart, mLineNumber, _
		    String.FromArray(light, ""), String.FromArray(dark, ""))
		  End Select
		  
		  // Need to see at least 3 more hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  dark.Add(mCharacters(mCurrent - 3))
		  dark.Add(mCharacters(mCurrent - 2))
		  dark.Add(mCharacters(mCurrent - 1))
		  
		  // 6 digit Color literal?
		  Select Case Peek
		  Case " ", &u09, &u0A, "", ",", "}", "]"
		    Return New XKColorGroupToken(mTokenStart, mLineNumber, _
		    String.FromArray(light, ""), String.FromArray(dark, ""))
		  End Select
		  
		  // 8 digit Color literal?
		  If Peek.IsHexDigit And Peek(2).IsHexDigit Then
		    dark.Add(Consume)
		    dark.Add(Consume)
		    Select Case Peek
		    Case " ", &u09, &u0A, "", ",", "}", "]"
		      Return New XKColorGroupToken(mTokenStart, mLineNumber, _
		      String.FromArray(light, ""), String.FromArray(dark, ""))
		    Else
		      // Invalid character after these 8 hex digits.
		      SyntaxError("Expected whitespace or EOF after dark colour ColorGroup literal.")
		    End Select
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function ColorToken() As XOOLKit.XKToken
		  /// Attempts to add a color token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `&`:
		  /// ```
		  /// c = &cFFF
		  ///      ^
		  /// ```
		  ///
		  /// Color literals follow the CSS format:
		  /// ```
		  /// &cRGB      # red, green, blue
		  /// &cRRGGBB   # red, red, green, green, blue, blue
		  /// &cRRGGBBAA # red, red, green, green, blue, blue, alpha, alpha
		  /// ```
		  /// Where `R`, `G`, `B` and `A` are hexadecimal digits.
		  
		  If Not Match("c") Then SyntaxError("Expected `&c` at start of Color literal.")
		  
		  // Need to see at least 3 hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  
		  // 3 digit Color literal?
		  Select Case Peek
		  Case " ", &u09, &u0A, "", ",", "}", "]"
		    Return New XKColorToken(mTokenStart, mLineNumber, ComputeLexeme(mTokenStart + 2, mCurrent - 1))
		  End Select
		  
		  // Need to see at least 3 more hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.")
		  End If
		  
		  // 6 digit Color literal?
		  Select Case Peek
		  Case " ", &u09, &u0A, "", ",", "}", "]"
		    Return New XKColorToken(mTokenStart, mLineNumber, ComputeLexeme(mTokenStart + 2, mCurrent - 1))
		  End Select
		  
		  // 8 digit Color literal?
		  If Peek.IsHexDigit And Peek(2).IsHexDigit Then
		    Advance(2)
		    Select Case Peek
		    Case " ", &u09, &u0A, "", ",", "}", "]"
		      Return New XKColorToken(mTokenStart, mLineNumber, ComputeLexeme(mTokenStart + 2, mCurrent - 1))
		    Else
		      // Invalid character after these 8 hex digits.
		      SyntaxError("Expected whitespace or EOF after Color literal.")
		    End Select
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E73756D657320616E642072657475726E73206120636F6D6D656E7420746F6B656E2E
		Private Function CommentToken() As XKToken
		  /// Consumes and returns a comment token.
		  ///
		  /// Assumes we have just consume the starting `#` character:
		  ///
		  /// ```
		  /// 123 # Hello
		  ///      ^
		  /// ```
		  
		  Do
		    Select Case Peek
		    Case &u0A, ""
		      Exit
		    Else
		      // Keep consuming until the end of the line.
		      Advance
		    End Select
		  Loop
		  
		  Return MakeToken(XKTokenTypes.Comment)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6D7075746573206120746F6B656E2773206C6578656D652066726F6D20606D43686172616374657273287374617274296020746F20606D436861726163746572732866696E697368296020696E636C75736976652E
		Private Function ComputeLexeme(start As Integer, finish As Integer) As String
		  /// Computes a token's lexeme from `mCharacters(start)` to `mCharacters(finish)` inclusive.
		  ///
		  /// Assumes `start` and `finish` are valid indices.
		  
		  Var s() As String
		  
		  For i As Integer = start To finish
		    s.Add(mCharacters(i))
		  Next i
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 436F6E73756D657320616E642072657475726E73207468652063757272656E742063686172616374657220696E2074686520736F757263652E2052657475726E732022222069662061742074686520656E64206F662074686520736F757263652E
		Private Function Consume() As String
		  /// Consumes and returns the current character in the source. Returns "" if at the end of the source.
		  
		  If mCurrent <= mCharactersLastIndex Then
		    Var char As String = mCharacters(mCurrent)
		    mCurrent = mCurrent + 1
		    If char = &u0A Then mLineNumber = mLineNumber + 1
		    Return char
		  Else
		    Return ""
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F206164642061204461746554696D6520746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function DateTimeToken() As XKDateTimeToken
		  /// Attempts to add a DateTime token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a digit.
		  ///
		  /// ```
		  /// 2021-12-25 09:15:00
		  //   ^
		  ///
		  /// 2021-12-25
		  ///  ^
		  ///
		  /// 07:32:00
		  ///  ^
		  /// ```
		  
		  // Need to see at least one digit.
		  If Not Peek.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a digit.")
		  Else
		    Advance
		  End If
		  
		  // Could this be a time token?
		  If Peek = ":" Then
		    Advance
		    Return TimeToken
		  End If
		  
		  Var lexeme As String
		  
		  // Consume the year (two more digits).
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a four digit year.")
		  End If
		  
		  // Must see a hyphen.
		  If Consume <> "-" Then
		    SyntaxError("Invalid DateTime. Expected a `-` after the year.")
		  End If
		  
		  // Consume the two digit month.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit month.")
		  End If
		  
		  // Must see a hyphen.
		  If Consume <> "-" Then
		    SyntaxError("Invalid DateTime. Expected a `-` after the month.")
		  End If
		  
		  // Consume the two digit day.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit day.")
		  End If
		  
		  // Full DateTime? Must see a space followed by a digit (e.g: `2021-12-25 09:15:00`).
		  If Peek = " " And Peek(2).IsDigit Then
		    Advance
		    Return FullDateTimeToken
		  End If
		  
		  // Must see whitespace or EOF for this to be a date.
		  If Peek.IsSpaceOrTabOrNewline Or Peek = "" Then
		    lexeme = ComputeLexeme(mTokenStart, mCurrent - 1)
		    Var d As DateTime
		    Try
		      d = DateTime.FromString(lexeme)
		    Catch e As RuntimeException
		      SyntaxError("Invalid DateTime. " + e.Message)
		    End Try
		    Return New XOOLKit.XKDateTimeToken(mTokenStart, mLineNumber, d)
		  Else
		    SyntaxError("Invalid DateTime. Expected whitespace or EOF.")
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F2061646420612066756C6C204461746554696D6520746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function FullDateTimeToken() As XOOLKit.XKDateTimeToken
		  /// Attempts to add a full DateTime token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed the space after the minute value.
		  ///
		  /// ```
		  /// 2021-12-25 09:15:00
		  ///            ^
		  /// ```
		  
		  // Consume the two digit hour value.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit hour value.")
		  End if
		  
		  // Must see a colon.
		  If Consume <> ":" Then
		    SyntaxError("Invalid DateTime. Expected colon after the hour value.")
		  End If
		  
		  // Consume the two digit minute value.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit minute value.")
		  End if
		  
		  // Must see a colon.
		  If Consume <> ":" Then
		    SyntaxError("Invalid DateTime. Expected colon after the minute value.")
		  End If
		  
		  // Consume the two digit seconds value.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit seconds value.")
		  End if
		  
		  // Must see whitespace or EOF.
		  If Peek.IsSpaceOrTabOrNewline Or Peek = "" Then
		    Var s As String = ComputeLexeme(mTokenStart, mCurrent - 1)
		    Var year As Integer = Integer.FromString(s.Left(4))
		    Var month As Integer = Integer.FromString(s.Middle(5, 2))
		    Var day As Integer = Integer.FromString(s.Middle(8, 2))
		    Var hour As Integer = Integer.FromString(s.Middle(11, 2))
		    Var minute As Integer = Integer.FromString(s.Middle(14, 2))
		    Var second As Integer = Integer.FromString(s.Middle(17, 2))
		    Var d As DateTime
		    Try
		      d = New DateTime(year, month, day, hour, minute, second)
		    Catch e As RuntimeException
		      SyntaxError("Invalid DateTime. " + e.Message)
		    End Try
		    Return New XOOLKit.XKDateTimeToken(mTokenStart, mLineNumber, d)
		  Else
		    SyntaxError("Invalid DateTime. Expected whitespace or EOF.")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function HexToken() As XOOLKit.XKNumberToken
		  /// Attempts to add a hex number token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `&`:
		  /// ```
		  /// c = &hFF
		  ///      ^
		  /// ```
		  
		  If Not Match("h") Then SyntaxError("Expected `h` at start of hex literal.")
		  
		  // Need to see at least one hex digit.
		  If Not Consume.IsHexDigit Then SyntaxError("Expected a hexadecimal digit.")
		  
		  // Get the remaining hex digits (if any).
		  While Peek.IsHexDigit
		    Advance
		  Wend
		  
		  // Need to see whitespace, `]`, `}`, a comma or EOF
		  Select Case Peek
		  Case " ", &u09, &u0A, "]", "}", ",", ""
		    // +2 to account for the `&h` prefix.
		    Var lexeme As String = ComputeLexeme(mTokenStart + 2, mCurrent - 1)
		    Return New XKNumberToken(mTokenStart, mLineNumber, Integer.FromHex(lexeme), True)
		  Else
		    SyntaxError("Expected whitespace, `]`, `}`, `.` or EOF after hex number literal.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F2061646420616E206964656E746966657220626F6F6C65616E206F72204E696C20746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function IdentifierBooleanOrNilToken() As XKToken
		  /// Attempts to add an identifer boolean or Nil token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed an ASCII letter or underscore.
		  ///
		  /// ```
		  /// abc
		  ///  ^
		  ///
		  /// true
		  ///  ^
		  ///
		  /// nil
		  ///  ^
		  /// ```
		  ///
		  /// Valid identifiers (keys and dictionary names) match Xojo's rules. They must start with an ASCII
		  /// letter but may contain any number of ASCII letters, digits or the underscore.
		  
		  While Peek.IsASCIILetterOrDigitOrUnderscore
		    Advance
		  Wend
		  
		  // Compute the lexeme. Use it to distinguish between a boolean and an identifier token.
		  Var lexeme As String = ComputeLexeme(mTokenStart, mCurrent - 1)
		  If lexeme = "True" Then // Case insensitive.
		    Return New XKBooleanToken(mTokenStart, mLineNumber, True)
		    
		  ElseIf lexeme = "False" Then // Case insensitive.
		    Return New XKBooleanToken(mTokenStart, mLineNumber, False)
		    
		  ElseIf lexeme = "Nil" Then // Case insensitive.
		    Return New XKToken(XKTokenTypes.NilLiteral, mTokenStart, mLineNumber, lexeme)
		    
		  Else
		    Return New XKToken(XKTokenTypes.Identifier, mTokenStart, mLineNumber, lexeme)
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E732061206E657720584B546F6B656E206F6620607479706560207374617274696E6720617420606D546F6B656E53746172746020616E6420656E64696E6720617420606D43757272656E74202D2031602E
		Private Function MakeToken(type As XOOLKit.XKTokenTypes) As XOOLKit.XKToken
		  /// Returns a new XKToken of `type` starting at `mTokenStart` and ending at `mCurrent - 1`.
		  
		  Select Case type
		  Case XKTokenTypes.Comment, XKTokenTypes.Dot, XKTokenTypes.EOF, XKTokenTypes.EOL, XKTokenTypes.Equal, _
		    XKTokenTypes.LCurly, XKTokenTypes.LSquare, XKTokenTypes.RCurly, XKTokenTypes.RSquare, _
		    XKTokenTypes.NilLiteral
		    // These tokens do not store their lexeme.
		    Return New XKToken(type, mTokenStart, mLineNumber)
		    
		  Else
		    // All other tokens store their lexeme.
		    Return New XKToken(type, mTokenStart, mLineNumber, ComputeLexeme(mTokenStart, mCurrent - 1))
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496620746865206E6578742063686172616374657220697320696E20606368617261637465727360207468656E206974277320636F6E73756D656420616E6420547275652069732072657475726E65642E204F74686572776973652046616C73652069732072657475726E656420616E64206E6F7468696E6720697320636F6E73756D65642E
		Private Function Match(ParamArray characters() As String) As Boolean
		  /// If the next character is in `characters` then it's consumed and True is returned. Otherwise False is
		  /// returned and nothing is consumed.
		  
		  For Each character As String In characters
		    If Peek = character Then
		      Advance
		      Return True
		    End If
		  Next character
		  
		  Return False
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E65787420746F6B656E2E204D617920726169736520616E2060584B457863657074696F6E602E
		Private Function NextToken() As XOOLKit.XKToken
		  /// Returns the next token. May raise an `XKException`.
		  
		  SkipWhitespace
		  
		  mTokenStart = mCurrent
		  
		  If AtEnd Then Return MakeToken(XKTokenTypes.EOF)
		  
		  Var char As String = Consume
		  
		  // Only add line endings if we're not in an array or dictionary.
		  If char = &u0A Then
		    If mDepth = XKTokeniserDepths.TopLevel Then
		      Return MakeToken(XKTokenTypes.EOL)
		    Else
		      SkipWhitespace
		      mTokenStart = mCurrent
		      If AtEnd Then Return MakeToken(XKTokenTypes.EOF)
		      char = Consume
		    End If
		  End If
		  
		  // ===========================
		  // COMMENT
		  // ===========================
		  If char = "#" Then 
		    Call CommentToken
		    If Peek = &u0A Then
		      If mDepth = XKTokeniserDepths.TopLevel Then
		        Advance
		        Return MakeToken(XKTokenTypes.EOL)
		      Else
		        SkipWhitespace(True)
		        mTokenStart = mCurrent
		        If AtEnd Then Return MakeToken(XKTokenTypes.EOF)
		        char = Consume
		      End If
		    Else
		      // End of the source code.
		      Return MakeToken(XKTokenTypes.EOF)
		    End If
		  End If
		  
		  // ===========================
		  // SINGLE CHARACTER SYMBOLS
		  // ===========================
		  If char = "=" Then Return MakeToken(XKTokenTypes.Equal)
		  If char = "." Then Return MakeToken(XKTokenTypes.Dot)
		  If char = "," Then Return MakeToken(XKTokenTypes.Comma)
		  
		  // Square bracket?
		  If char = "[" Then
		    mArrayDepth = mArrayDepth + 1
		    Return MakeToken(XKTokenTypes.LSquare)
		  ElseIf char = "]" Then
		    mArrayDepth = mArrayDepth - 1
		    Return MakeToken(XKTokenTypes.RSquare)
		  End If
		  
		  // Curly brace?
		  If char = "{" Then
		    mDictDepth = mDictDepth + 1
		    Return MakeToken(XKTokenTypes.LCurly)
		  ElseIf char = "}" Then
		    mDictDepth = mDictDepth - 1
		    Return MakeToken(XKTokenTypes.RCurly)
		  End If
		  
		  // ===========================
		  // & LITERALS
		  // ===========================
		  If char = "&" Then
		    If Peek = "c" Then
		      Return ColorToken
		    ElseIf Peek = "h" Then
		      Return HexToken
		    ElseIf Peek = "g" Then
		      Return ColorGroupToken
		    ElseIf Peek = "o" Then
		      Return OctalToken
		    ElseIf Peek = "b" Then
		      Return BinaryToken
		    End If
		  End If
		  
		  // ===========================
		  // NUMBERS & DATES
		  // ===========================
		  If char = "-" Then
		    Var t As XKToken = NumberToken(True)
		    If t = Nil Then
		      SyntaxError("Expected a number after `-`.")
		    Else
		      Return t
		    End If
		  Else
		    If char.IsDigit Then
		      Var t As XKToken = NumberToken(False)
		      If t = Nil Then
		        Return DateTimeToken
		      Else
		        Return t
		      End If
		    End If
		  End If
		  
		  // ===========================
		  // STRINGS
		  // ===========================
		  If char = """" Then Return StringToken
		  
		  // ===========================
		  // IDENTIFIERS, BOOLEANS & NIL
		  // ===========================
		  If char.IsASCIILetter Then Return IdentifierBooleanOrNilToken
		  
		  SyntaxError("Unexpected character `" + char + "`.")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F206164642061206E756D62657220746F6B656E2E2052657475726E73204E696C20696620756E7375636365737366756C2E
		Private Function NumberToken(consumedMinus As Boolean) As XKNumberToken
		  /// Attempts to add a number token. Returns Nil if unsuccessful.
		  ///
		  /// Assumes we have just consumed a digit or a minus sign.
		  ///
		  /// ```
		  /// 42
		  ///  ^
		  ///
		  /// -100
		  ///  ^
		  /// ```
		  
		  // Need to see a digit after a minus sign.
		  If consumedMinus And Not Peek.IsDigit Then Return Nil
		  
		  // Cache the current status as we will have to revert if we don't find a valid number token.
		  Var oldCurrent As Integer = mCurrent
		  
		  Var isInteger As Boolean = True
		  
		  // Consume contiguous digits.
		  While Peek.IsDigit
		    Advance
		  Wend
		  
		  // Double?
		  If Peek = "." Then
		    isInteger = False
		    Advance
		    // Must see a mantissa.
		    If Not Peek.IsDigit Then
		      // Revert.
		      mCurrent = oldCurrent
		      Return Nil
		    Else
		      // Consume the mantissa.
		      While Peek.IsDigit
		        Advance
		      Wend
		    End If
		  End If
		  
		  // Exponent?
		  If Peek = "e" Then
		    isInteger = False
		    Advance
		    // Consume the optional sign character.
		    If Peek.IsExactly("-", "+") Then Advance
		    
		    // Must see at least one digit.
		    If Not Peek.IsDigit Then
		      // Revert.
		      mCurrent = oldCurrent
		      Return Nil
		    Else
		      // Consume the exponent.
		      While Peek.IsDigit
		        Advance
		      Wend
		    End If
		  End If
		  
		  // Need to see whitespace, `]`, `}`, a comma or EOF
		  Select Case Peek
		  Case " ", &u09, &u0A, "]", "}", ",", ""
		    Var lexeme As String = ComputeLexeme(mTokenStart, mCurrent - 1)
		    If isInteger Then
		      Return New XKNumberToken(mTokenStart, mLineNumber, Integer.FromString(lexeme), True)
		    Else
		      Return New XKNumberToken(mTokenStart, mLineNumber, Double.FromString(lexeme), False)
		    End If
		  Else
		    // Revert.
		    mCurrent = oldCurrent
		    Return Nil
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function OctalToken() As XOOLKit.XKNumberToken
		  /// Attempts to add an octal number token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `&`:
		  /// ```
		  /// num = &o12
		  ///        ^
		  /// ```
		  
		  If Not Match("o") Then SyntaxError("Expected `o` at start of octal literal.")
		  
		  // Need to see at least one octal digit.
		  If Not Consume.IsOctalDigit Then SyntaxError("Expected an octal digit.")
		  
		  // Get the remaining octal digits (if any).
		  While Peek.IsOctalDigit
		    Advance
		  Wend
		  
		  // Need to see whitespace, `]`, `}`, a comma or EOF
		  Select Case Peek
		  Case " ", &u09, &u0A, "]", "}", ",", ""
		    // +2 to account for the `&o` prefix.
		    Var lexeme As String = ComputeLexeme(mTokenStart + 2, mCurrent - 1)
		    Return New XKNumberToken(mTokenStart, mLineNumber, Integer.FromOctal(lexeme), True)
		  Else
		    SyntaxError("Expected whitespace, `]`, `}`, `.` or EOF after octal number literal.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206368617261637465722060706C6163657360206265796F6E64207468652063757272656E742063686172616374657220776974686F757420636F6E73756D696E672069742E2052657475726E7320222220696620776527766520726561636865642074686520656E64206F662074686520736F7572636520636F64652E
		Private Function Peek(places As Integer = 1) As String
		  /// Returns the character `places` beyond the current character without consuming it. 
		  /// Returns "" if we've reached the end of the source code.
		  ///
		  /// Assumes [places] > 0
		  
		  // -1 because peeking oe character ahead is actually at index `mCurrent`.
		  If mCurrent + places - 1 <= mCharactersLastIndex Then
		    Return mCharacters(mCurrent + places - 1)
		  Else
		    Return ""
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F2061646420612072617720737472696E6720746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function RawStringToken() As XOOLKit.XKToken
		  /// Attempts to add a raw string token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed the opening triple quotes `"""`:
		  /// ```
		  /// s = """Hello world"""
		  ///        ^
		  /// ```
		  ///
		  /// Raw strings surrounded by three quotation marks on each side and allow newlines. 
		  /// A newline immediately following the opening delimiter will be trimmed:
		  ///
		  /// ```
		  /// str1 = """
		  /// Roses are red
		  /// Violets are blue"""
		  /// ```
		  ///
		  /// All other whitespace and newline characters remain intact.
		  /// To avoid introducing extraneous whitespace, use a "line ending backslash". When the last 
		  /// non-whitespace character on a line is a `\`, it will be trimmed along with all whitespace (including 
		  /// newlines) up to the next non-whitespace character or closing delimiter:
		  /// 
		  /// ```
		  /// # The following strings are equivalent:
		  /// str1 = "The quick brown fox jumps over the lazy dog."
		  ///
		  /// str2 = """
		  /// The quick brown \
		  ///
		  ///
		  ///   fox jumps over \
		  ///     the lazy dog."""
		  ///
		  /// str3 = """\
		  ///        The quick brown \
		  ///        fox jumps over \
		  ///        the lazy dog.\
		  ///        """
		  /// ```
		  
		  // Edge case: Immediate end of the file.
		  If Peek = "" Then SyntaxError("Unterminated raw string literal.")
		  
		  // A newline immediately following the opening delimiter will be trimmed.
		  If Peek = &u0A Then Advance
		  
		  Var startLine As Integer = mLineNumber
		  
		  // Find the closing delimiter.
		  Var lexeme() As String
		  While Not AtEnd
		    If Peek = "\" Then
		      // If this the last non-whitespace character on this line, skip to the next non-whitespace character.
		      Var x As Integer = 2
		      Do
		        Select Case Peek(x)
		        Case &u0A
		          // Keep going until we hit non-whitespace.
		          Advance(x)
		          While Match(" ", &u09, &u0A)
		          Wend
		          Exit
		          
		        Case " ", &u09
		          x = x + 1
		          
		        Else
		          lexeme.Add(Consume)
		          Exit
		        End Select
		      Loop
		      
		    ElseIf Peek = """" And Peek(2) = """" And Peek(3) = """" Then
		      // Found the closing delimiter.
		      Advance(3)
		      Return New XOOLKit.XKToken(XKTokenTypes.StringLiteral, mTokenStart, startLine, _
		      String.FromArray(lexeme, ""))
		    Else
		      lexeme.Add(Consume)
		    End If
		  Wend
		  
		  // Unterminated raw string.
		  SyntaxError("Unterminated raw string literal.")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 5265736574732074686520746F6B656E6973657220746F20757365206073602061732074686520736F7572636520737472696E672E
		Private Sub Reset(s As String)
		  /// Resets the tokeniser to use `s` as the source string.
		  
		  // Standardise line endings.
		  s = s.ReplaceLineEndings(&u0A)
		  
		  // Split into characters.
		  mCharacters = s.CharacterArray
		  
		  mCharactersLastIndex = mCharacters.LastIndex
		  mCurrent = 0
		  mTokenStart = 0
		  mLineNumber = 1
		  mPreviousToken = New XKToken(XKTokenTypes.Undefined, 0, 1)
		  mDictDepth = 0
		  mArrayDepth = 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 536B697073206F76657220776869746573706163652C206578636C7564696E67206C696E6520656E64696E67732E
		Private Sub SkipWhitespace(lineEndingIsWhitespace As Boolean = False)
		  /// Skips over whitespace.
		  
		  Do
		    Select Case Peek
		    Case &u0A
		      If lineEndingIsWhitespace Then
		        Advance
		        Continue
		      Else
		        Return
		      End If
		      
		    Case " ", &u0009
		      Advance
		      Continue
		      
		    Else
		      Return
		    End Select
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F206164642061207374616E6461726420737472696E6720746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function StandardStringToken() As XOOLKit.XKToken
		  /// Attempts to add a standard string token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed the opening quote `"`:
		  /// ```
		  /// s = "Hello world"
		  ///      ^
		  /// ```
		  ///
		  /// Strings very closely mimic Wren's strings (https://wren.io/values.html)
		  /// Standard strings are surrounded in double quotes: `"hi there"`
		  /// They can also span multiple lines. When they do, the newline character within the string will always 
		  /// be normalised to &u0A (`\n`):
		  ///
		  /// ```
		  /// "hi
		  /// there,
		  /// again"
		  /// ```
		  ///
		  /// Equates to: `"hi\nthere\nagain"`
		  ///
		  /// A handful of escape sequences are supported:
		  '     `\"`         // Double quote character.
		  '     `\\`         // Backslash.
		  '     `\b`         // Backspace.
		  '     `\e`         // ESC character.
		  '     `\n`         // Newline.
		  '     `\r`         // Carriage return.
		  '     `\t`         // Tab.
		  '     `\u0041`     // Unicode code point (4 hex digits)
		  '     `\U0001F64A` // Unicode code point (8 hex digits)
		  
		  Var startLine As Integer = mLineNumber
		  
		  Var lexeme() As String
		  While Not AtEnd
		    Select Case Peek
		    Case """"
		      Advance
		      // Need to see whitespace, `]`, `}`, a comma or EOF
		      Select Case Peek
		      Case " ", &u09, &u0A, "]", "}", ",", ""
		        Return New XOOLKit.XKToken(XKTokenTypes.StringLiteral, mTokenStart, startLine, _
		        String.FromArray(lexeme, ""))
		      Else
		        SyntaxError("Expected whitespace, comma, `]` or EOF.")
		      End Select
		      
		    Case "\"
		      Advance
		      Select Case Peek
		      Case """"
		        lexeme.Add(Consume)
		        
		      Case "\"
		        lexeme.Add(Consume)
		        
		      Case "b"
		        Advance
		        lexeme.Add(&u08)
		        
		      Case "e"
		        Advance
		        lexeme.Add(&u1B)
		        
		      Case "n"
		        Advance
		        lexeme.Add(&u0A)
		        
		      Case "r"
		        Advance
		        lexeme.Add(&u0D)
		        
		      Case "t"
		        Advance
		        lexeme.Add(&u09)
		        
		      Else
		        If Peek.IsExactly("u") Then
		          Advance
		          // Need to see four hex digits.
		          If Peek.IsHexDigit And Peek(2).IsHexDigit And Peek(3).IsHexDigit And Peek(4).IsHexDigit Then
		            Var codepointString As String = Consume + Consume + Consume + Consume
		            Var codepoint As Integer = Integer.FromHex(codepointString)
		            Try
		              lexeme.Add(Text.FromUnicodeCodepoint(codepoint))
		            Catch e As RuntimeException
		              SyntaxError("Invalid unicode codepoint: `\u" + codepointString + ".")
		            End Try
		          Else
		            SyntaxError("Expected four hex digits after `\u`.")
		          End If
		          
		        ElseIf Peek.IsExactly("U") Then
		          Advance
		          // Need to see eight hex digits.
		          If Peek.IsHexDigit And Peek(2).IsHexDigit And Peek(3).IsHexDigit And Peek(4).IsHexDigit And _
		            Peek(5).IsHexDigit And Peek(6).IsHexDigit And Peek(7).IsHexDigit And Peek(8).IsHexDigit Then
		            Var codepointString As String = Consume + Consume + Consume + Consume + _
		            Consume + Consume + Consume + Consume
		            Var codepoint As Integer = Integer.FromHex(codepointString)
		            Try
		              lexeme.Add(Text.FromUnicodeCodepoint(codepoint))
		            Catch e As RuntimeException
		              SyntaxError("Invalid unicode codepoint: `\U" + codepointString + ".")
		            End Try
		          Else
		            SyntaxError("Expected eight hex digits after `\U`.")
		          End If
		          
		        Else
		          SyntaxError("Unknown string escape sequence `\" + Peek + "`.")
		        End If
		      End Select
		      
		    Else
		      lexeme.Add(Consume)
		    End Select
		  Wend
		  
		  // Unterminated raw string.
		  SyntaxError("Unterminated raw string literal.")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120737472696E6720746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function StringToken() As XOOLKit.XKToken
		  /// Attempts to add a string token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed a `"`:
		  /// ```
		  /// s = "Hello world"
		  ///      ^
		  /// ```
		  ///
		  /// Strings mimic Wren's strings (https://wren.io/values.html)
		  
		  // =======================
		  // RAW STRING
		  // =======================
		  If Peek = """" And Peek(2) = """" Then
		    Advance(2)
		    Return RawStringToken
		  End If
		  
		  // =======================
		  // STANDARD STRING
		  // =======================
		  Return StandardStringToken
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52616973657320616E2060584B457863657074696F6E60207769746820606D657373616765602061742060616273506F7360206F6E206C696E6520606C696E654E756D626572602E
		Private Sub SyntaxError(message As String)
		  /// Raises an `XKException` with `message` at `mCurrent` on line `mLineNumber`.
		  
		  #Pragma BreakOnExceptions False
		  
		  Raise New XOOLKit.XKTokeniserException(message, mLineNumber, mCurrent)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 417474656D70747320746F206164642061204461746554696D652074696D6520746F6B656E2E2052616973657320616E2060584B457863657074696F6E6020696620756E7375636365737366756C2E
		Private Function TimeToken() As XOOLKit.XKDateTimeToken
		  /// Attempts to add a DateTime time token. Raises an `XKException` if unsuccessful.
		  ///
		  /// Assumes we have just consumed the first colon and there were two preceding digits.
		  ///
		  /// ```
		  /// 07:32:00
		  ///    ^
		  /// ```
		  
		  // Consume the two digit minute value.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit minute value.")
		  End if
		  
		  // Must see a colon.
		  If Consume <> ":" Then
		    SyntaxError("Invalid DateTime. Expected colon after the minute value.")
		  End If
		  
		  // Consume the two digit seconds value.
		  If Not Consume.IsDigit Or Not Consume.IsDigit Then
		    SyntaxError("Invalid DateTime. Expected a two digit seconds value.")
		  End if
		  
		  // Must see whitespace or EOF.
		  If Peek.IsSpaceOrTabOrNewline Or Peek = "" Then
		    Var lexeme As String = ComputeLexeme(mTokenStart, mCurrent - 1)
		    Var hour As Integer = Integer.FromString(lexeme.Left(2))
		    Var minute As Integer = Integer.FromString(lexeme.Middle(3, 2))
		    Var second As Integer = Integer.FromString(lexeme.Middle(6, 2))
		    Var now As DateTime = DateTime.Now
		    Var d As DateTime
		    Try
		      d = New DateTime(now.Year, now.Month, now.Day, hour, minute, second)
		    Catch e As RuntimeException
		      SyntaxError("Invalid DateTime. " + e.Message)
		    End Try
		    Return New XOOLKit.XKDateTimeToken(mTokenStart, mLineNumber, d)
		  Else
		    SyntaxError("Invalid DateTime. Expected whitespace or EOF.")
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546F6B656E69736573206120584F4F4C20646F63756D656E7420696E746F20616E206172726179206F6620584B546F6B656E732E2052616973657320616E2060584B457863657074696F6E602069662060736020697320696E76616C69642E
		Function Tokenise(s As String) As XKToken()
		  /// Tokenises a XOOL document into an array of XKTokens. Raises an `XKException` if `s` is invalid.
		  
		  Reset(s)
		  
		  Var tokens() As XOOLKit.XKToken
		  
		  Var t As XOOLKit.XKToken
		  While Not AtEnd
		    t = NextToken
		    
		    Select Case t.Type
		    Case XKTokenTypes.EOL
		      // Don't add contiguous EOL tokens - they'll confuse the parser.
		      If mPreviousToken.Type <> XKTokenTypes.EOL Then tokens.Add(t)
		      
		    Case XKTokenTypes.Comment
		      // Don't add comment tokens as they're meaningless.
		      
		    Else
		      tokens.Add(t)
		    End Select
		    
		    mPreviousToken = t
		  Wend
		  
		  // Edge case: The first token is a superfluous EOL.
		  If tokens.Count > 0 And tokens(0).Type = XKTokenTypes.EOL Then tokens.RemoveAt(0)
		  
		  // Ensure there is a trailing EOF token.
		  If tokens.Count = 0 Then
		    tokens.Add(New XKToken(XKTokenTypes.EOF, s.Length, mLineNumber))
		  ElseIf tokens(tokens.LastIndex).Type <> XKTokenTypes.EOF Then
		    tokens.Add(New XKToken(XKTokenTypes.EOF, s.Length, mLineNumber))
		  End If
		  
		  Return tokens
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 486F77206465657020696E746F20616E2061727261792074686520746F6B656E697365722069732E20603060206D65616E73207765277265206E6F7420696E20616E2061727261792E
		Private mArrayDepth As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 5468652063686172616374657273206F662074686520584F4F4C20646F63756D656E74206265696E67207061727365642E
		Private mCharacters() As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4361636865206F6620606D436861726163746572732E4C617374496E646578602E
		Private mCharactersLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 302D626173656420696E64657820696E20606D4368617261637465727360206F6620746865206E6578742063686172616374657220746F206576616C756174652E
		Private mCurrent As Integer = 0
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21, Description = 5468652063757272656E74206465707468206F662074686520746F6B656E697365722E20546F702D6C6576656C20696E646963617465732074686520746F6B656E69736572206973206E6F742063757272656E746C79206E657374656420696E20616E206172726179206F722064696374696F6E6172792E
		#tag Getter
			Get
			  If mArrayDepth > 0 Or mDictDepth > 0 Then
			    Return XKTokeniserDepths.Nested
			  Else
			    Return XKTokeniserDepths.TopLevel
			  End If
			End Get
		#tag EndGetter
		Private mDepth As XOOLKit.XKTokeniser.XKTokeniserDepths
	#tag EndComputedProperty

	#tag Property, Flags = &h21, Description = 486F77206465657020696E746F20612064696374696F6E6172792074686520746F6B656E697365722069732E20603060206D65616E73207765277265206E6F7420696E20612064696374696F6E6172792E
		Private mDictDepth As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 54686520312D6261736564206C696E65206E756D626572206F662074686520636861726163746572206265696E67206576616C75617465642E
		Private mLineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 546865206C61737420616464656420746F6B656E2E
		Private mPreviousToken As XOOLKit.XKToken
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 302D626173656420696E64657820696E20606D4368617261637465727360206F662074686520666972737420636861726163746572206F662074686520746F6B656E2063757272656E746C79206265696E672070726F6365737365642E
		Private mTokenStart As Integer = 0
	#tag EndProperty


	#tag Enum, Name = XKTokeniserDepths, Type = Integer, Flags = &h0
		Nested
		TopLevel
	#tag EndEnum


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
	#tag EndViewBehavior
End Class
#tag EndClass
