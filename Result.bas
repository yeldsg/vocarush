B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes 
    #FullScreen: False
    #IncludeTitle: True
#End Region

Sub Process_Globals
End Sub

Sub Globals
	Private BTN_HOME As Button
	Private BTN_LEADERBOARD As Button
	Private LBL_RESULT As Label
	Private LBL_SCORE As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("layresult")

	' Retrieve score and mode from Level module
	Dim score As Int = Level.FinalScore
	Dim mode As String = Level.PlayedMode

	' Display results
	LBL_RESULT.Text = "You played " & mode & " mode."
	LBL_SCORE.Text = "Final Score: " & score
End Sub


Private Sub BTN_LEADERBOARD_Click
	Leaderboard.CurrentMode = Level.PlayedMode
	StartActivity(Leaderboard)
End Sub

Private Sub BTN_HOME_Click
	Activity.Finish
	StartActivity(Main)
End Sub