#tag Class
Private Class XKColorGroupToken
Inherits XOOLKit.XKToken
	#tag Method, Flags = &h0
		Sub Constructor(tokenStart As Integer, lineNumber As Integer, lightString As String, darkString As String)
		  Super.Constructor(XKTokenTypes.ColorGroupLiteral, tokenStart, lineNumber)
		  
		  Var lightLength As Integer = lightString.Length
		  Var darkLength As Integer = darkString.Length
		  
		  // Sanity check.
		  If lightLength < 3 Or lightLength > 8 Then
		    Raise New XKTokeniserException("Invalid light color string.", lineNumber, tokenStart)
		  End If
		  If darkLength < 3 Or darkLength > 8 Then
		    Raise New XKTokeniserException("Invalid dark color string.", lineNumber, tokenStart)
		  End If
		  
		  Var r, g, b As String
		  var light, dark As Color
		  
		  // ==================
		  // LIGHT COLOUR
		  // ==================
		  If lightLength = 3 Then
		    // RGB
		    r = lightString.Left(1)
		    g = lightString.Middle(1, 1)
		    b = lightString.Right(1)
		    lightString = "&h00" + r + r + g + g + b + b
		    light = Color.FromString(lightString)
		    
		  ElseIf lightLength = 6 Then
		    // RRGGBB
		    light = Color.FromString("&h00" + lightString)
		    
		  ElseIf lightLength = 8 Then
		    // RRGGBBAA
		    light = Color.FromString("&h" + lightString.Right(2) + lightString.Left(6))
		    
		  Else
		    Raise New XKTokeniserException("Invalid light color string.", lineNumber, tokenStart)
		  End If
		  
		  // ==================
		  // DARK COLOUR
		  // ==================
		  If darkLength = 3 Then
		    // RGB
		    r = darkString.Left(1)
		    g = darkString.Middle(1, 1)
		    b = darkString.Right(1)
		    darkString = "&h00" + r + r + g + g + b + b
		    dark = Color.FromString(darkString)
		    
		  ElseIf darkLength = 6 Then
		    // RRGGBB
		    dark = Color.FromString("&h00" + darkString)
		    
		  ElseIf darkLength = 8 Then
		    // RRGGBBAA
		    dark = Color.FromString("&h" + darkString.Right(2) + darkString.Left(6))
		    
		  Else
		    Raise New XKTokeniserException("Invalid dark color string.", lineNumber, tokenStart)
		  End If
		  
		  Self.Value = New ColorGroup(light, dark)
		  
		  Exception e As RuntimeException
		    Raise New XKTokeniserException("Invalid color string. " + e.Message, lineNumber, tokenStart)
		    
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Value As ColorGroup
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
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="XOOLKit.XKTokenTypes.Undefined"
			Type="XOOLKit.XKTokenTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - BooleanLiteral"
				"1 - ColorLiteral"
				"2 - Comma"
				"3 - Comment"
				"4 - DateTime"
				"5 - Dot"
				"6 - EOF"
				"7 - EOL"
				"8 - Equal"
				"9 - Identifier"
				"10 - LCurly"
				"11 - LSquare"
				"12 - NilLiteral"
				"13 - Number"
				"14 - RCurly"
				"15 - RSquare"
				"16 - StringLiteral"
				"17 - Undefined"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Lexeme"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
