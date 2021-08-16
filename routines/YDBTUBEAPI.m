YDBTUBEAPI ; YottaDB Web Server API Entry Point; 05-07-2021
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
API(%Q,%R,%A)
	s $ET="D ERR^%YDBTUBEAPI"
	N %J
	S %R("mime")="application/json"
	S %R("header","Access-Control-Allow-Origin")="*"
	S %R("header","Access-Control-Allow-Headers")="Origin, X-Requested-With, Content-Type, Accept"
	I '$D(@%Q("body")) Q
	N %RR D DECODE^YDBTUBE(%Q("body"),"%RR")
	N %ROUTINE S %ROUTINE=%RR("routine")
	K %RR("routine") K %J
	N (%RR,%J,%WTCP,%ROUTINE,%Q,%R,%A,%YDBTUBERESP)
	D @(%ROUTINE_"(.%RR,.%J)")
	K @%R D ENCODE^YDBTUBE("%J",%R)
	Q
	;
SERVESTATIC(%Q,%R,%A)	
	N PATH S PATH=$G(%Q("path")) 
	I PATH="" S PATH="/YDBTube/index.html"
	I PATH="/" S PATH="/YDBTube/index.html"
	I PATH="/YDBTube" S PATH="/YDBTube/index.html"
	I PATH="/YDBTube/" S PATH="/YDBTube/index.html"
	I $E(PATH,1,9)'="/YDBTube/" D SETERROR^%YDBTUBE(404) Q
	N FILEPATHS
	S FILEPATH="dist/spa/"_$E(PATH,10,$L(PATH))
	I $P(FILEPATH,".",$L(FILEPATH,"."))["?" D
	. S $P(FILEPATH,".",$L(FILEPATH,"."))=$P($P(FILEPATH,".",$L(FILEPATH,".")),"?")
	I '$$FileExists^YDBTUBEUTILS(FILEPATH) D
	. S FILEPATH="dist/spa/index.html"
	N EXT S EXT=$P(FILEPATH,".",$L(FILEPATH,"."))
	S %R("mime")=$$GetMimeType^YDBTUBE(EXT)
	N OUTPUT
	D ReadFileByChunk^YDBTUBEUTILS(FILEPATH,4080,.OUTPUT)
	M @%R=OUTPUT
	Q
	;	
PING(I,O)
	S O("data","RESULT")="PONG"
	Q
	;
ERR ;
	Q
	;
UPLOAD(I,O)
	new url,currentDevice
	set currentDevice=$I
	set tempFile=$j_".temp"
	open tempFile:(newversion)
	use tempFile do SaveVideoByUrl(I("data","URL")) close tempFile
	use currentDevice
	q
	;
IMPORTMP4ERROR
        set $ZE=""
        close sd
        quit
	;
SaveVideoByUrl(url)
	set $ZT="D IMPORTMP4ERROR^YDBTUBEAPI"
	set url=$p(url,"?v=",2)
	new return
 	;zsystem "ytdl ""https://www.youtube.com/watch?v="_url_""" -o "_url_" "
    ;zsystem "ytdl ""https://www.youtube.com/watch?v="_url_""" -j > "_url_".json"
	do RunShellCommand^YDBTUBEUTILS("ytdl ""https://www.youtube.com/watch?v="_url_""" -o "_url,.return)
    hang 0.1
	do RunShellCommand^YDBTUBEUTILS("ytdl ""https://www.youtube.com/watch?v="_url_""" -j > "_url_".json",.return)
    k ^TEMP($j)
	new sd
	set sd=url_".json"
	open sd:(readonly:fixed:recordsize=4080:chset="M")
    use sd
    S C=0,SIZE=0
    for  use sd  read x Q:$ZEOF  d
    . s C=C+1
    . s ^TEMP($j,C)=x
    . S ^TEMP($j)=$G(^TEMP($j))+$L(x)
    c sd
    do DECODE^YDBTUBE($name(^TEMP($j)),"response")
	n thumbnailIndex
	set thumnnailIndex=$o(response("videoDetails","thumbnails",""),-1)
	if thumnnailIndex do 
	. s thumbnailUrl=response("videoDetails","thumbnails",thumnnailIndex,"url")
	. s thumnailWidth=response("videoDetails","thumbnails",thumnnailIndex,"width")
	. s thumnailHeight=response("videoDetails","thumbnails",thumnnailIndex,"height")
	. n return
	. d RunShellCommand^YDBTUBEUTILS("wget  --no-http-keep-alive"_" -O "_url_" "_thumbnailUrl,.return)
	new title
	set title=response("videoDetails","title")
	set ^YDBTUBEDETAILS(url,"title")=title
	set ^YDBTUBEDETAILS(url,"sequence")=$I(^YDBTUBECOUNTER)
	do IMPORTMP4(url)
	hang 0.1
	do IMPORTIMG(url)
	zsystem "rm "_url_".mp4"
	zsystem "rm "_url_".json"
	q
	;
IMPORTMP4(ID)
        set $ZT="D IMPORTMP4ERROR^YDBTUBEAPI"
        kill ^YDBTUBE(ID)
		s sd=ID_".mp4"
		open sd:(readonly:fixed:recordsize=4080)
        use sd
        S C=0,SIZE=0
        for  D  Q:$zeof
        . I $zeof Q
        . use sd
        . read x
        . s C=C+1
        . s ^YDBTUBE(ID,C)=x
        . S ^YDBTUBE(ID)=$G(^YDBTUBE(ID))+$L(x)
        c sd
        Q
        ;
IMPORTIMG(ID)
        set $ZT="D IMPORTMP4ERROR^YDBTUBEAPI"
        kill ^YDBTUBEIMG(ID)
		s sd=ID
		open sd:(readonly:fixed:recordsize=4080)
        use sd
        S C=0,SIZE=0
        for  D  Q:$zeof
        . I $zeof Q
        . use sd
        . read x
        . s C=C+1
        . s ^YDBTUBEIMG(ID,C)=x
        . S ^YDBTUBEIMG(ID)=$G(^YDBTUBEIMG(ID))+$L(x)
        c sd
        Q
		;
GETVIDSLIST(I,O)
		new video,counter
		set video="" for  set video=$order(^YDBTUBE(video)) quit:video=""  do
		. set counter=^YDBTUBEDETAILS(video,"sequence")
		. set O("data","LIST",counter,"id")=video
		. set O("data","LIST",counter,"name")=^YDBTUBEDETAILS(video,"title")
		quit
	;
	;
GETIMGS(HTTPREQ,HTTPRSP,HTTPARGS)
	set HTTPRSP("mime")=$$GetMimeType^YDBTUBE("png")
	set id=$piece(HTTPREQ("query"),"img=",2)
	merge @HTTPRSP=@$na(^YDBTUBEIMG(id))
	zkill @HTTPRSP
	quit
	;
	;
GETVIDEOS(HTTPREQ,HTTPRSP,HTTPARGS)
	set HTTPRSP("mime")="video/mp4"
	set range=$get(HTTPREQ("header","range"))
	set (start,end,length,tmp,vidsize)=0
	set id=$zpiece(HTTPREQ("query"),"v=",2)
	set videoSize=^YDBTUBE(id)
	set start=$zpiece($piece(range,"=",2),"-") if start=""  do  quit
	. set HTTPRSP("header","Content-Range")="bytes "_0_"-"_0_"/"_videoSize
	set fStart=(start\4080),remain=(start#4080),end=0
	if 'remain S @HTTPRSP@(1)="$NA("_$name(^YDBTUBE(id,fStart+1))_")"
	if remain S @HTTPRSP@(1)=$extract(^YDBTUBE(id,fStart+1),remain+1,$length(^YDBTUBE(id,fStart+1)))
	set size=$length(^YDBTUBE(id,fStart+1))-remain S done=0
	for I=2:1:2240 Q:done  D
	. if '$data(^YDBTUBE(id,fStart+I)) set done=1 quit
	. set @HTTPRSP@(I)="$NA("_$name(^YDBTUBE(id,fStart+I))_")"
	. S size=size+$length(^YDBTUBE(id,fStart+I))
	S HTTPRSP("header","Content-Range")="bytes "_start_"-"_(start+size-1)_"/"_videoSize
	S HTTPRSP("partial")=""
	quit