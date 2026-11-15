B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=13.1
@EndOfDesignText@
'Database code module
'Saves every finished game in a SQLite database so the leaderboard
'and the player profile are kept even after the app is closed.

Sub Process_Globals
	Private SQL1 As SQL
End Sub

Public Sub Init
	If SQL1.IsInitialized Then Return
	SQL1.Initialize(File.DirInternal, "vocarush.db", True)
	SQL1.ExecNonQuery("CREATE TABLE IF NOT EXISTS scores (id INTEGER PRIMARY KEY AUTOINCREMENT, player TEXT, mode TEXT, score INTEGER, played_at INTEGER)")
End Sub

'Saves one finished game
Public Sub SaveScore(Player As String, Mode As String, Score As Int)
	Init
	SQL1.ExecNonQuery2("INSERT INTO scores (player, mode, score, played_at) VALUES (?, ?, ?, ?)", _
		Array As Object(Player, Mode, Score, DateTime.Now))
End Sub

'Returns the top 10 scores of a mode as text, highest first
Public Sub GetLeaderboardText(Mode As String) As String
	Init
	Dim sb As StringBuilder
	sb.Initialize
	Dim rs As ResultSet = SQL1.ExecQuery2("SELECT player, score FROM scores WHERE mode = ? ORDER BY score DESC, played_at ASC LIMIT 10", Array As String(Mode))
	Dim rank As Int = 1
	Do While rs.NextRow
		sb.Append($"${rank}. ${rs.GetString("player")} - ${rs.GetInt("score")}"$).Append(CRLF)
		rank = rank + 1
	Loop
	rs.Close
	If sb.Length = 0 Then Return "No scores yet!"
	Return sb.ToString
End Sub

'Overall score = the player's best score in Kid + Average + Extreme
Public Sub GetOverallScore(Player As String) As Int
	Init
	Dim total As String = SQL1.ExecQuerySingleResult2( _
		"SELECT IFNULL(SUM(best), 0) FROM (SELECT MAX(score) AS best FROM scores WHERE player = ? GROUP BY mode)", _
		Array As String(Player))
	If total = Null Then Return 0
	Return total
End Sub

'Overall ranking = the player's place among all players by overall score.
'Returns 0 if the player has not finished a game yet.
Public Sub GetOverallRanking(Player As String) As Int
	Init
	Dim rs As ResultSet = SQL1.ExecQuery( _
		"SELECT player, SUM(best) AS total FROM (SELECT player, mode, MAX(score) AS best FROM scores GROUP BY player, mode) GROUP BY player ORDER BY total DESC")
	Dim rank As Int = 0
	Dim position As Int = 1
	Do While rs.NextRow
		If rs.GetString("player") = Player Then
			rank = position
			Exit
		End If
		position = position + 1
	Loop
	rs.Close
	Return rank
End Sub
