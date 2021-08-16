YDBTUBEUTILS ; YottaDB Utilities Entry Point; 05-07-2021
	;#################################################################
	;#                                                               #
	;# Copyright (c) 2021 YottaDB LLC and/or its subsidiaries.       #
	;# All rights reserved.                                          #
	;#                                                               #
	;#   This source code contains the intellectual property         #
	;#   of its copyright holder(s), and is made available           #
	;#   under a license.  If you do not know the terms of           #
	;#   the license, please stop and do not read further.           #
	;#                                                               #
	;#################################################################		
	Q
	;
	;
RunShellCommand(COMMAND,RET) 	D RunShellCommand^YDBTUBEUTILS2(.COMMAND,.RET) Q
DirectoryExists(PATH) 			Q $$DirectoryExists^YDBTUBEUTILS2(.PATH)
CreateDirectoryTree(PATH) 		Q $$CreateDirectoryTree^YDBTUBEUTILS2(.PATH)
GetRoutineList(RTNS,PATTERN) 	D GetRoutineList^YDBTUBEUTILS2(.RTNS,.PATTERN) Q
GetGlobalList(GLBLS,PATTERN)	D GetGlobalList^YDBTUBEUTILS2(.GLBLS,.PATTERN) Q
FileExists(PATH)				Q $$FileExists^YDBTUBEUTILS2(.PATH)
ReadFileByLine(FILE,RET)		D ReadFileByLine^YDBTUBEUTILS2(.FILE,.RET) Q
ReadFileByChunk(FILE,CHUNK,RET) D ReadFileByChunk^YDBTUBEUTILS2(.FILE,.CHUNK,.RET) Q
WriteFile(FILE,DATA)			D WriteFile^YDBTUBEUTILS2(.FILE,.DATA) Q
UP(STR)							Q $$UP^YDBTUBEUTILS2(.STR)
LOW(STR)						Q $$LOW^YDBTUBEUTILS2(.STR)
RoutinePaths(RET)				D RoutinePaths^YDBTUBEUTILS1(.RET) Q
DeleteFile(FILE)				D DeleteFile^YDBTUBEUTILS1(.FILE) Q
	;							
	;
	;