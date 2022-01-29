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

	#tag Method, Flags = &h21, Description = 417474656D70747320746F20616464206120636F6C6F7220746F6B656E2E2052616973657320616E20584B457863657074696F6E20696620756E7375636365737366756C2E
		Private Function ColorToken() As XOOLKit.XKToken
		  /// Attempts to add a color token. Raises an XKException if unsuccessful.
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
		  // Where `R`, `G`, `B` and `A` are hexadecimal digits.
		  
		  If Not Match("c") Then SyntaxError("Expected `c` at start of Color literal.", mLineNumber, mCurrent)
		  
		  Var lexeme() As String
		  
		  // Need to see at least 3 hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.", mLineNumber, mCurrent)
		  End If
		  
		  // 3 digit Color literal?
		  Var s As String = Peek
		  If s.IsSpaceOrTabOrNewline Or s = "" Then
		    For i As Integer = mTokenStart + 2 To mCurrent - 1
		      lexeme.Add(mCharacters(i))
		    Next i
		    Return New XKColorToken(mTokenStart, mLineNumber, 3, String.FromArray(lexeme, ""))
		  End If
		  
		  // Need to see at least 3 more hex digits.
		  If Not Consume.IsHexDigit Or Not Consume.IsHexDigit Or Not Consume.IsHexDigit Then
		    SyntaxError("Expected a hexadecimal digit.", mLineNumber, mCurrent)
		  End If
		  
		  // 6 digit Color literal?
		  s = Peek
		  If s.IsSpaceOrTabOrNewline Or s = "" Then
		    For i As Integer = mTokenStart + 2 To mCurrent - 1
		      lexeme.Add(mCharacters(i))
		    Next i
		    Return New XKColorToken(mTokenStart, mLineNumber, 6, String.FromArray(lexeme, ""))
		  End If
		  
		  // 8 digit Color literal?
		  If Peek.IsHexDigit And Peek(2).IsHexDigit Then
		    Advance(2)
		    s = Peek
		    If s.IsSpaceOrTabOrNewline Or s = "" Then
		      For i As Integer = mTokenStart + 2 To mCurrent - 1
		        lexeme.Add(mCharacters(i))
		      Next i
		      Return New XKColorToken(mTokenStart, mLineNumber, 8, String.FromArray(lexeme, ""))
		    Else
		      // Invalid character after these 8 hex digits.
		      SyntaxError("Expected whitespace or EOF after Color literal,", mLineNumber, mCurrent)
		    End If
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

	#tag Method, Flags = &h21, Description = 52657475726E732061206E657720584B546F6B656E206F6620607479706560207374617274696E6720617420606D546F6B656E53746172746020616E6420656E64696E6720617420606D43757272656E74202D2031602E
		Private Function MakeToken(type As XOOLKit.XKTokenTypes) As XOOLKit.XKToken
		  /// Returns a new XKToken of `type` starting at `mTokenStart` and ending at `mCurrent - 1`.
		  
		  Select Case type
		  Case XKTokenTypes.EOF, XKTokenTypes.EOL, XKTokenTypes.Dot, XKTokenTypes.Equal, XKTokenTypes.LSquare, _
		    XKTokenTypes.RSquare
		    // These tokens do not store their lexeme.
		    Return New XKToken(type, mTokenStart, mLineNumber, mCurrent - mTokenStart)
		    
		  Else
		    // All other tokens store their lexeme.
		    Var lexeme() As String
		    For i As Integer = mTokenStart To mCurrent - 1
		      lexeme.Add(mCharacters(i))
		    Next i
		    Return New XKToken(type, mTokenStart, mLineNumber, mCurrent - mTokenStart, String.FromArray(lexeme, ""))
		    
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 496620746865206E65787420636861726163746572206973206063686172616374657260207468656E20697420697320636F6E73756D656420616E6420547275652069732072657475726E65642E204F74686572776973652046616C73652069732072657475726E656420616E64206E6F7468696E6720697320636F6E73756D65642E
		Private Function Match(character As String) As Boolean
		  /// If the next character is `character` then it is consumed and True is returned. Otherwise False is
		  /// returned and nothing is consumed.
		  
		  If Peek = character Then
		    Advance
		    Return True
		  Else
		    Return False
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320746865206E65787420746F6B656E2E204D617920726169736520616E20584B457863657074696F6E2E
		Private Function NextToken() As XOOLKit.XKToken
		  /// Returns the next token. May raise an XKException.
		  
		  SkipWhitespace
		  
		  mTokenStart = mCurrent
		  
		  If AtEnd Then Return MakeToken(XKTokenTypes.EOF)
		  
		  Var char As String = Consume
		  
		  If char = &u0A Then Return MakeToken(XKTokenTypes.EOL)
		  
		  // Comment?
		  If char = "#" Then Return CommentToken
		  
		  // Assignment?
		  If char = "=" Then Return MakeToken(XKTokenTypes.Equal)
		  
		  // Dot?
		  If char = "." Then Return MakeToken(XKTokenTypes.Dot)
		  
		  // Comma?
		  If char = "," Then Return MakeToken(XKTokenTypes.Comma)
		  
		  // Square bracket?
		  If char = "[" Then
		    Return MakeToken(XKTokenTypes.LSquare)
		  ElseIf char = "]" Then
		    Return MakeToken(XKTokenTypes.RSquare)
		  End If
		  
		  // Curly brace?
		  If char = "{" Then
		    Return MakeToken(XKTokenTypes.LCurly)
		  ElseIf char = "}" Then
		    Return MakeToken(XKTokenTypes.RCurly)
		  End If
		  
		  // Color literal?
		  If char = "&" Then Return ColorToken
		  
		  // Date?
		  
		  
		  // Number?
		  
		  
		  // String?
		  
		  SyntaxError("Unexpected character `" + char + "`.", mLineNumber, mCurrent)
		  
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
		  mPreviousToken = New XKToken(XKTokenTypes.Undefined, 0, 1, 0)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 536B697073206F76657220776869746573706163652C206578636C7564696E67206C696E6520656E64696E67732E
		Private Sub SkipWhitespace()
		  /// Skips over whitespace, excluding line endings.
		  
		  Do
		    Select Case Peek
		    Case &u0A
		      Return
		      
		    Case " ", &u0009
		      Advance
		      Continue
		      
		    Else
		      Return
		    End Select
		  Loop
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52616973657320616E20584B457863657074696F6E207769746820606D657373616765602061742060616273506F7360206F6E206C696E6520606C696E654E756D626572602E
		Private Sub SyntaxError(message As String, lineNumber As Integer, absPos As Integer)
		  /// Raises an XKException with `message` at `absPos` on line `lineNumber`.
		  
		  #Pragma BreakOnExceptions False
		  
		  Raise New XOOLKit.XKException(message, lineNumber, absPos)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 546F6B656E69736573206120584F4F4C20646F63756D656E7420696E746F20616E206172726179206F6620584B546F6B656E732E20526169736573206120584B457863657074696F6E2069662060736020697320696E76616C69642E
		Function Tokenise(s As String) As XKToken()
		  /// Tokenises a XOOL document into an array of XKTokens. Raises a XKException if `s` is invalid.
		  
		  Reset(s)
		  
		  Var tokens() As XOOLKit.XKToken
		  
		  Var t As XOOLKit.XKToken
		  While Not AtEnd
		    t = NextToken
		    If t.Type = XKTokenTypes.EOL Then
		      // Don't add contiguous EOL tokens - they'll confuse the parser.
		      If mPreviousToken.Type <> XKTokenTypes.EOL Then tokens.Add(t)
		    Else
		      tokens.Add(t)
		    End If
		    mPreviousToken = t
		  Wend
		  
		  // Remove the trailing EOF if present.
		  If mPreviousToken.Type = XKTokenTypes.EOF Then Call tokens.Pop
		  
		  Return tokens
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21, Description = 5468652063686172616374657273206F662074686520584F4F4C20646F63756D656E74206265696E67207061727365642E
		Private mCharacters() As String
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 4361636865206F6620606D436861726163746572732E4C617374496E646578602E
		Private mCharactersLastIndex As Integer = -1
	#tag EndProperty

	#tag Property, Flags = &h21, Description = 302D626173656420696E64657820696E20606D4368617261637465727360206F6620746865206E6578742063686172616374657220746F206576616C756174652E
		Private mCurrent As Integer = 0
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
