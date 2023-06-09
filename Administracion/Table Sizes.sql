Select 
    obj.name,
    (
    Select 
        Sum(((used * 8192.00)/1024)) 
    from 
        sysindexes
    where 
        id in (select objChild.id from sysobjects objChild where objChild.name = obj.name)
        and indid in(0,1) --> Only Table Size
    ) TableSizeKb,
    (
    Select 
        Sum(((used * 8192.00)/1024))
    from 
        sysindexes
    where 
        id in (select objChild.id from sysobjects objChild where objChild.name = obj.name)
        and indid = 255 --> Only Text and Image
    ) TextImageSizeKb,
    (
    Select 
        Sum(((used * 8192.00)/1024)) 
    from 
        sysindexes
    where 
        id in (select objChild.id from sysobjects objChild where objChild.name = obj.name)
        and indid not in (255,0,1) --> Only indexes
    ) IndexSizeKb
From 
    sysobjects obj
Where 
    type = 'U' --> only user tables
Order By 
    TableSizeKb desc