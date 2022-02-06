#tag Class
Protected Class SerializableContact
Implements XOOLKit.XKSerializable
	#tag Method, Flags = &h0
		Sub Constructor(name As String, age As Integer)
		  Self.Name = name
		  Self.Age = age
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToInlineDictionary() As String
		  // Part of the XOOLKit.XKSerializable interface.
		  
		  Var s() As String
		  s.Add("{")
		  s.Add("name = " + GenerateXOOL(Self.Name))
		  s.Add(", ")
		  s.Add("age = " + GenerateXOOL(Self.Age))
		  s.Add("}")
		  
		  Return String.FromArray(s, "")
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		Age As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		Name As String
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
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
