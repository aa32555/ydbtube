MITUBE
        ;
        ;
        ;
        Q
LISTFILES
        zsy "ls rvids/ -la > files.txt"
        New SRC,line
        Set SRC="files.txt"
        Open SRC:(readonly)
        For  Use SRC Read line Quit:$zeof  Do
        . Set line=$Translate(line,$C(13),"")
        . S V=$P($P(line," ",$L(line," ")),".",$L(line,".")-1)
        . I V="" Q
        . L +^PROCESSING(V):0  E  Q
        . U 0 W V,!
        . U 0 ZSY ("ytdl ""https://www.youtube.com/watch?v="_V_""" -o "_V)
        . U 0 ZSY ("ytdl ""https://www.youtube.com/watch?v="_V_""" -j")
        . U 0 ZSY ("ytdl ""https://www.youtube.com/watch?v="_V_""" -j > "_V_".json")
        . U 0 W "About to delete => "_("rm /data/rvids/"_$P(line," ",$L(line," "))),!
        . U 0 ZSY ("rm /data/rvids/"_$P(line," ",$L(line," ")))
        . L -^PROCESSING(V)
        Close SRC
        Q
        ;
IMPORTMP4ERROR
        S $ZE=""
        C sd
        W $ZSTATUS,! H 3
        C SRC
        G IMPORT
        Q
IMPORTMP4
        S $ZT="D IMPORTMP4ERROR"
        open sd:(readonly:fixed:recordsize=4080)
        use sd
        S C=0,SIZE=0,SEQ=$O(^YDBTUBE(""),-1)+1
        for  D  Q:$zeof
        . I $zeof Q
        . use sd
        . read x
        . s C=C+1
        . use 0 write sd,"-",$G(^YDBTUBE(SEQ)),!
        . s ^YDBTUBE(SEQ,C)=x
        . S ^YDBTUBE(SEQ)=$G(^YDBTUBE(SEQ))+$L(x)
        c sd
        Q
        ;
IMPORT
        zsy "ls /data -la > mpfiles.txt"
        New SRC,line
        Set SRC="mpfiles.txt"
        Open SRC:(readonly)
        For  Use SRC Read line Quit:$zeof  Do
        . Set line=$Translate(line,$C(13),"")
        . i $P($P(line," ",$L(line," ")),".",$L(line,"."))'="mp4" q
        . S V=$P(line," ",$L(line," "))
        . I V="" Q
        . I $D(DONE(V)) Q
        . L +^PROCESSINGVID(V):0  E  Q
        . U 0 W V,!
        . S sd="/data/"_V
        . S DONE(V)=""
        . D IMPORTMP4
        . L -^PROCESSINGVID(V)
        Close SRC
        K (DONE)
        H 5
        G IMPORT
        ;
