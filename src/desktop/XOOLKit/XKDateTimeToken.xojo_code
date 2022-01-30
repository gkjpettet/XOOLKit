#tag Class
Protected Class XKDateTimeToken
Inherits XOOLKit.XKToken
	#tag Method, Flags = &h0
		Sub Constructor(tokenStart As Integer, lineNumber As Integer, value As DateTime)
		  Super.Constructor(XKTokenTypes.DateTime, tokenStart, lineNumber)
		  Self.Value = value
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 5468697320746F6B656E27732076616C75652061732061204461746554696D65206F626A6563742E
		Value As DateTime
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
				"11 - ColorLiteral"
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
	#tag EndViewBehavior
End Class
#tag EndClass
