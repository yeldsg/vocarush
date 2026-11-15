B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
    #FullScreen: True
    #IncludeTitle: False
#End Region

Sub Process_Globals
	Public FinalScore As Int
	Public PlayedMode As String
	Public PlayerName As String
End Sub

Sub Globals
	Private LBL_AVERAGE As Label
	Private BTN_BACK As Button
	Private LBL_EXTREME As Label
	Private LBL_KID As Label
	Private LBL_HTP As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("layLevel")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


Private Sub LBL_AVERAGE_Click
	StartActivity(Average)
End Sub



Private Sub BTN_BACK_Click
	Activity.Finish
	StartActivity(Main)
End Sub

' In your Level module or wherever you show the leaderboard:

Sub lstModeSelect_ItemClick (Position As Int, Value As Object)
	' Remove the selection dialog
	
	' Set the mode based on selection
	Select Case Position
		Case 0
			Leaderboard.CurrentMode = "Kid"
		Case 1
			Leaderboard.CurrentMode = "Average"
		Case 2
			Leaderboard.CurrentMode = "Extreme"
	End Select
    
	StartActivity(Leaderboard)
End Sub

Private Sub LBL_KID_Click
	StartActivity(Kid)
End Sub

Private Sub LBL_EXTREME_Click
	StartActivity(Extreme)
End Sub

Private Sub LBL_HTP_Click
	StartActivity(Instructions)
End Sub