#tag Class
Protected Class XKColorToken
Inherits XOOLKit.XKToken
	#tag Method, Flags = &h0
		Sub Constructor(tokenStart As Integer, lineNumber As Integer, length As Integer, colorString As String)
		  Super.Constructor(XKTokenTypes.ColorLiteral, tokenStart, lineNumber, length)
		  
		  // Sanity check.
		  If length < 3 Or length > 8 Then
		    Raise New XKException("Invalid color string.", lineNumber, tokenStart)
		  End If
		  
		  Var r, g, b As String
		  
		  If length = 3 Then
		    // RGB
		    r = colorString.Left(1)
		    g = colorString.Middle(1, 1)
		    b = colorString.Right(1)
		    colorString = "&h00" + r + r + g + g + b + b
		    MyColor = Color.FromString(colorString)
		    
		  ElseIf length = 6 Then
		    // RRGGBB
		    MyColor = Color.FromString("&h00" + colorString)
		    
		  ElseIf length = 8 Then
		    // RRGGBBAA
		    MyColor = Color.FromString("&h" + colorString)
		    
		  Else
		    Raise New XKException("Invalid color string.", lineNumber, tokenStart)
		  End If
		  
		  Exception e As RuntimeException
		    Raise New XKException("Invalid color string. " + e.Message, lineNumber, tokenStart)
		    
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		MyColor As Color
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
				"0 - Comma"
				"1 - Comment"
				"2 - Dot"
				"3 - EOF"
				"4 - EOL"
				"5 - Equal"
				"6 - LCurly"
				"7 - LSquare"
				"8 - RCurly"
				"9 - RSquare"
				"10 - Undefined"
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
			Name="Length"
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
		#tag ViewProperty
			Name="MyColor"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
