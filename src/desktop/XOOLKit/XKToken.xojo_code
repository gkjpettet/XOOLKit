#tag Class
Protected Class XKToken
	#tag Method, Flags = &h0
		Sub Constructor(type As XKTokenTypes, tokenStart As Integer, lineNumber As Integer, length As Integer, lexeme As String = "")
		  Self.Type = type
		  Self.AbsoluteStart = tokenStart
		  Self.LineNumber = lineNumber
		  Self.Length = length
		  Self.Lexeme = lexeme
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E2074686520736F7572636520636F6465206F662074686520666972737420636861726163746572206F66207468697320746F6B656E2E
		AbsoluteStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206C656E6774682028696E206368617261637465727329206F66207468697320746F6B656E2E
		Length As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320286F7074696F6E616C29206C6578656D652E
		Lexeme As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 312D6261736564206C696E65206E756D626572206F6620746865206C61737420636861726163746572206F66207468697320746F6B656E2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320747970652E
		Type As XOOLKit.XKTokenTypes = XOOLKit.XKTokenTypes.Undefined
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
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
