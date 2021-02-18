string version = "NCF v.0.1";//Altera o numero da versão no texto do medidor.
string name_meter = "[NCF] Meter_v0.1";
string backupBoxName = "[NCF] Backup";
key trevor  =  "2c041498-46ce-47b4-b795-85e4bd99f960";
key kevin = "494a4515-6993-4ffb-a07f-662905062a5c";
key tanaka = "6341b39c-e141-4ac2-ba77-ae9416c198c6";
list creatorsList = [trevor,kevin,tanaka];
//=============================================
integer ch_backup = -1003;
//=============================================
//================ Backup data =====================


integer CheckCreator(key id)
{
    list details = llGetObjectDetails(id,[OBJECT_CREATOR]);
    return llListFindList(creatorsList,[llList2Key(details,0)]);
}

string GetDataString(string message)
{
    list description = llCSV2List(llGetObjectDesc());
    
    integer nation = llList2Integer(description,0);
    integer level = llList2Integer(description,1);
    //currentHealth = llList2Float(description,2);
    integer currentXP = llList2Integer(description,3);
    //bendingLevel = llList2Integer(description,4);
    //currentBendingLvl = llList2Integer(description,5); 
    //dmg_min = llList2Float(description,6);
    integer awakening = llList2Integer(description,7);
    //teste = llList2Integer(description,8);
    //title = llList2String(description,7);
    //avatar_mode = llList2Integer(description,9);
    string datasend = (string)nation + "," + (string)level + "," + (string)currentXP + "," + (string)awakening;
    return datasend;
}

Init()
{
    llListen(ch_backup, "", "", "");
}

default
{
    state_entry()
    {
        Init();
    }
    on_rez(integer startparam)
    {
        llResetScript();
    }
    link_message(integer name, integer chan, string msg, key id)
    {
        if(chan == ch_backup)
        {

        }
    }

    listen( integer chan, string name, key id, string message )
    {
        if(chan == ch_backup && llGetOwnerKey(id) == llGetOwner() && CheckCreator(id))
        {
            if(message == "StartBackup")
            {
                //llOwnerSay("Starting Backup");
                string data = "backup";
                data += GetDataString(llGetObjectDesc());
                llRegionSayTo(id, ch_backup, data);
            }

            else if(llGetSubString(message, 0, 3) == "data")
            {
                string data = llGetSubString(message, 4, -1);
                //llOwnerSay("Data Save: " + data);
                llMessageLinked(LINK_THIS, ch_backup, data, NULL_KEY);
            }
        }  
    }

    timer()
    {
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER || change & CHANGED_REGION)
        {
            llResetScript();
        }
    }
}
