BEGIN{
    diag=0;
    event=0;
    diags = "DIAGNOSTIC_"diag"_";
    diaglast = diags;
    events = "EVENT_"event"_";
    eventlast = events;
}
{
    if(match($0,"DIAGNOSTIC_[0-9][0-9]?_"))
    {
        diaglast2 = substr($0, RSTART, RLENGTH);
        if(diaglast != diaglast2)
        {
            diag++;
            diags = "DIAGNOSTIC_"diag"_";
            diaglast=diaglast2;
        }
        gsub("DIAGNOSTIC_[0-9][0-9]?_",diags,$0);
    }
    if(match($0,"EVENT_[0-9][0-9]?_"))
    {
        eventlast2 = substr($0, RSTART, RLENGTH);
        if(eventlast != eventlast2)
        {
            event++;
            events = "EVENT_"event"_";
            eventlast=eventlast2;
        }
        gsub("EVENT_[0-9][0-9]?_",events,$0);
    }

    if(match($0,"DIAGNOSTICS"))
    {
        diag=0;
        diags = "DIAGNOSTIC_"diag"_";
        diaglast = diags;
    }
    if(match($0,"EVENTS"))
    {
        event=0;
        events = "EVENT_"event"_";
        eventlast = events;
    }
    print $0;
}
