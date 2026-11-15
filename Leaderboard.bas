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
	Public CurrentMode As String
End Sub

Sub Globals
	Private BTN_QUIT As Button
	Private LBL_LEADERBOARD As Label
	Private LBL_TITLE As Label
	Private BTN_EXTREME As Button
	Private BTN_KID As Button
	Private BTN_AVE As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("layLeaderboard")

	If CurrentMode = "" Then CurrentMode = "Kid" ' Default to Kid mode
	ShowLeaderboard
End Sub


Private Sub BTN_QUIT_Click
	Activity.Finish
End Sub

Sub ShowLeaderboard
	LBL_TITLE.Text = CurrentMode & " Leaderboard"
	LBL_LEADERBOARD.Text = Database.GetLeaderboardText(CurrentMode)
End Sub

Private Sub BTN_KID_Click
	CurrentMode = "Kid"
	ShowLeaderboard
End Sub

Private Sub BTN_AVE_Click
	CurrentMode = "Average"
	ShowLeaderboard
End Sub

Private Sub BTN_EXTREME_Click
	CurrentMode = "Extreme"
	ShowLeaderboard
End Sub

