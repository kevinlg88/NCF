string version = "NCF v.0.1";//Altera o numero da versão no texto do medidor.
string name_meter = "[NCF] Meter_v0.1";
//=============================================

key owner;
list admins;
list creator_dmg;
key trevor  =  "2c041498-46ce-47b4-b795-85e4bd99f960";
key kevin = "494a4515-6993-4ffb-a07f-662905062a5c";
key tanaka = "6341b39c-e141-4ac2-ba77-ae9416c198c6";

//=============================================

integer ch_admin = -999;
integer ch_meter = -1000;
integer ch_dano = -1001;
integer ch_energy = -1002;
integer ch_backup = -1003;
integer ch_send_dmg = -1004;
integer ch_verific_dmg = -1005;
integer ch_receive_dmg = -1006;
integer ch_xpgain = -1007;
integer ch_buff_externo = -1008;

//=============================================

string msg_causar_dano = "ATAQUE_VERIFICADO_PARA_CAUSAR_DANO";
string msg_verificar_dano = "ATAQUE_VERIFICADO_PARA_CAUSAR_DANO";
string msg_xp_gain = "ADD_XP_POR_ACERTO";
string msg_buff_externo = "ADD_BUFF_EXTERNO";

//================LISTA-DANOS==================

list lvl_dmg = [
//COMUM - (50L$-100L$) 
"ATK_LVL1", 1,
"ATK_LVL2", 1.05,
"ATK_LVL3", 1.1,
//MEDIO - (100L$ - 400L$) 
"ATK_LVL4", 1.25,
"ATK_LVL5", 1.5,
"ATK_LVL6", 1.75,
"ATK_LVL7", 2,
//ULTIMATE - (500L$ - 1000L$) 
"ATK_LVL8", 3,
"ATK_LVL9", 4,
"ATK_LVL10", 5];

//=============================================

integer nation;
integer level;
float currentHealth;
float dmg_min;
integer awakening;
integer avatar_mode;

//=============================================

float buff_nation;
float time_buff_nation;
float max_dist = 100;//Distancia Máxima para receber Dano

//=============================================
list chaves;
//=============================================
Init()
{
    owner = llGetOwner();
    llListen(ch_send_dmg,"","","");
    llListen(ch_receive_dmg,"","","");
    llListen(ch_verific_dmg,"","","");
    llListen(ch_buff_externo,"","","");
    admins = [trevor, kevin, tanaka];
    creator_dmg = [trevor, kevin, tanaka];
    llSetTimerEvent(0.1);
}
string Criptografar(string msg)
{
    float hora = llGetWallclock();
    string date = llGetDate();
    float chave1 = llFrand(99999);
    float chave2 = chave1/hora;
    //chaves += [chave1];
    
    string cripto = llStringToBase64((string)chave2+","+(string)owner+","+(string)hora+","+date+","+(string)chave1+","+msg);
    
    if(llGetSubString(cripto,llStringLength(cripto)-2,llStringLength(cripto)-1) == "==")
        cripto = llDeleteSubString(cripto,llStringLength(cripto)-2,llStringLength(cripto)-1);
        
    return cripto;
}
string Descriptografar(string msg, key av_id)
{ 
    list decod = llCSV2List(llBase64ToString(msg));
    float hora = llList2Float(decod,2);
    string date = llList2String(decod,3);
    integer chave1 = llList2Integer(decod,4);
    float chave2 = llList2Float(decod,0);
    integer chave_dec = (integer)(chave2*hora);
    key avatar = llList2Key(decod,1);
    //llOwnerSay("\n1 - Decod: "+msg);
    float hora_atu = llGetWallclock();
    if(av_id == avatar && llGetDate() == date)
    {
        //llOwnerSay("\n2 - Avatar e Data Corretos!\nCh1: "+(string)chave1+"\nCh2: "+(string)chave2+"\nHora: "+(string)hora+"\nAtual: "+(string)hora_atu+"\nDecod: "+(string)(chave2*hora));
        if((chave1 == chave_dec ||(chave1 - chave_dec) == 1 || (chave_dec - chave1) == 1) && hora <= hora_atu && hora >= hora_atu-3)
        {
            //llOwnerSay("\n3 - Chaves Aceitas!");
            decod = llDeleteSubList(decod,0,4);
            return llList2CSV(decod);
        }
    }
    return "Error";
}
Atk_Send_Dano()
{
    //Função que os Ataques Devem Ter Para Enviar Dano.
    key enemy = kevin;
    string msg_dano = msg_verificar_dano+",0,ATK_LVL1";
    //llOwnerSay("\nDano Enviado ao Main");
    Send_Msg(enemy, ch_receive_dmg, msg_dano);
}
//Verifica os Status atuais na Descrição do Medidor.
CheckMyStatus()
{
    list description = llCSV2List(llGetObjectDesc());
    
    nation = llList2Integer(description,0);
    level = llList2Integer(description,1);
    currentHealth = llList2Float(description,2);
    avatar_mode = llList2Integer(description,9);
    dmg_min = llList2Float(description,6);
}
//Acrescenta Buffs no dano que é capaz de causar.
Verificar_Buff()
{
    CheckMyStatus();
    dmg_min += llFrand(3);
    
    dmg_min += dmg_min * ((float)level/10);
    if(buff_nation > 0)
        dmg_min += dmg_min * buff_nation;
}
//Envia Mensagem para o inimigo para verificar se pode receber o dano.
Send_Verificador(key enemy, list msg)
{
    string msg_do_atk = msg_verificar_dano +","+ llList2String(msg,0) +","+ llList2String(msg,1);
    //llOwnerSay("\n3 - Msg: "+msg_do_atk);
    Send_Msg(enemy, ch_verific_dmg, (string)msg_do_atk);
}
//Envia o dano para o inimigo após o pedido de verificação.
Send_Dmg(key enemy, integer nation_atk, integer index_atk_lvl)
{
    Verificar_Buff();
    if(index_atk_lvl != -1 && (nation == nation_atk || avatar_mode) && currentHealth > 0)
    {
        
        float atk_dmg = dmg_min*llList2Float(lvl_dmg,(index_atk_lvl+1));
        llOwnerSay("\nDano Com Buff: "+(string)atk_dmg);
        
        string msg_send = msg_causar_dano+","+(string)nation+","+(string)level+","+(string)atk_dmg;
        
        Send_Msg(enemy, ch_send_dmg, msg_send);
        
        llMessageLinked(LINK_SET, ch_xpgain,msg_xp_gain, NULL_KEY);
        
        //llOwnerSay("\n6 - Msg Dano Enviada: "+msg_send);
    }
    
}
//Envia mensagens para avatares ou objetos em especifico.
Send_Msg(key id, integer ch, string msg)
{
    llRegionSayTo(id,ch,Criptografar(msg));
}
//Envia mensagens diretamente para o Script Main.
Send_To_Main(list msg, key enemy)
{
    /*integer msg_pt2 = llList2Integer(msg_full,1);//Nação
    integer msg_pt3 = llList2Integer(msg_full,2);//Level
    float msg_pt1 = llList2Float(msg_full,3);//Dano*/
    
    //llOwnerSay("\n10 - Enviou Dano ao Main!");
    string msg_dano = llList2String(msg,0) +","+ llList2String(msg,1) +","+ llList2String(msg,2);
    llMessageLinked(LINK_SET, ch_dano,msg_dano, enemy);
}
//Verifica se o criador do objeto é um Criador autorizado a causar dano no sistema.
integer CheckCreator(key id)
{
    list details = llGetObjectDetails(id,[OBJECT_CREATOR]);
    if(llListFindList(creator_dmg,[llList2Key(details,0)]) != -1)
        return TRUE;
    return FALSE;
}
//Verifica se o criador ou owner é membro dos ADMs.
integer CheckAdm(key id, integer type)
{
    list details = llGetObjectDetails(id,[type]);
    if(llListFindList(admins,[llList2Key(details,0)]) != -1)
        return TRUE;
    return FALSE;
}
//Verifica a Distancia entre nós e o inimigo.
integer GetOwnerPos(key id)
{
    if(llVecDist(llGetPos(),llList2Vector(llGetObjectDetails(id,[OBJECT_POS]),0)) <= max_dist)
    {
        return TRUE;
    }
    return FALSE;
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
        if(chan == ch_dano)
        {
            //
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        key falador = llGetOwnerKey(id);
        //Recebe a Solicitação de Dano do Ataque Inimigo.
        if(chan == ch_receive_dmg && falador != owner && CheckCreator(id) && currentHealth > 0)
        {
            //llOwnerSay("\n1 - Recebendo solicitação de Dano!");
            list msg_full = llCSV2List(Descriptografar(msg,id));
            string msg_pt1 = llList2String(msg_full,0);//Msg Causar Dano
            if(msg_pt1 == msg_verificar_dano && GetOwnerPos(falador))
            {
                //llOwnerSay("\n2 - Entrou no IF com Sucesso!");
                //llOwnerSay("HP:"+(string)currentHealth);
                msg_full = llDeleteSubList(msg_full,0,0);
                Send_Verificador(falador,msg_full);
            }
        }
        //Recebe a Solicitação de Verificação do inimigo para saber se o ataque é Seu.
        else if(chan == ch_verific_dmg && falador != owner && name == name_meter)
        {
            //llOwnerSay("\n4 - Veficando seu Dano!");
            list msg_full = llCSV2List(Descriptografar(msg,falador));
            string msg_pt1 = llList2String(msg_full,0);//Msg Verificar Dano
            //Verifica se a mensagem recebida contem a mensagem de verificação de Dano.
            if(msg_pt1 == msg_verificar_dano)
            {    
                //llOwnerSay("\n5 - Verificação entrou no IF");
                integer msg_pt2 = llList2Integer(msg_full,1);//Nação DO ATAQUE
                string msg_pt3 = llList2String(msg_full,2);//Level DO ATAQUE
                
                Send_Dmg(falador,msg_pt2,llListFindList(lvl_dmg,[msg_pt3]));
            }
        }
        //Recebe a mensagem verificada vinda do Send_Dmg() Inimigo.
        else if(chan == ch_send_dmg && falador != owner)
        {
            //llOwnerSay("\n7 - Chegou a Verificação");
            //Verifica o nome do Sistema e se foi criador por alguem cadastrado.
            if(name == name_meter && CheckCreator(id))
            {
                //llOwnerSay("\n8 - Entrou na Verificação de nome!");
                list msg_full = llCSV2List(Descriptografar(msg,falador));
                string msg_pt1 = llList2String(msg_full,0);//Msg Causar Dano
                //Verifica a mensagem de verificação padrão.
                if(msg_pt1 == msg_causar_dano)
                {
                    //llOwnerSay("\n9 - Autorizou a Causar Dano!");
                    //Remove a parte da mensagem de verificação para enviar ao Main.
                    msg_full = llDeleteSubList(msg_full,0,0);
                    //AQUI IRÁ RECEBER O DANO
                    Send_To_Main(msg_full, falador);
                    state pause;
                }
            }
        }
        //Recebe a mensagem de um Buffer Externo, somente se for criado por um ADM e de um ADM.
        else if(chan == ch_buff_externo && CheckAdm(id,OBJECT_CREATOR) && CheckAdm(falador,OBJECT_OWNER))
        {
            //llOwnerSay("\n1 - Recebeu Buff");
            list msg_full = llCSV2List(Descriptografar(msg,id));
            string msg_pt1 = llList2String(msg_full,0);//Mensagem padrão do Buff.
            integer msg_pt2 = llList2Integer(msg_full,1);//Nação autorizada a receber o Buff.
            if(msg_pt1 == msg_buff_externo && (nation == msg_pt2 || avatar_mode))
            {
                vector msg_pt3 = (vector)llList2String(msg_full,2);//Posição atual do Buffer.
                float msg_pt4 = llList2Float(msg_full,3);//Distância minima para receber o Buff.
                float dist_buffer = llVecDist(msg_pt3,llGetPos());
                //llOwnerSay("\n2 - Recebeu Buff\nPos: "+(string)msg_pt3+"\nMSG: "+msg);
                if(dist_buffer <= msg_pt4)
                {
                    buff_nation = llList2Float(msg_full,4);//Valor do Buff enviado.
                    //llOwnerSay("\n3 - Recebeu Buff: "+(string)buff_nation);
                    time_buff_nation = 3;
                }
            }
        }
    }
    timer()
    {
        CheckMyStatus();
        //Removedor de Buff de Area por Nação
        if(buff_nation > 0)
        {
            time_buff_nation -= 0.1;
            if(time_buff_nation <= 0)
            {
                time_buff_nation = 0;
                buff_nation = 0;
            }
        }
    }
    changed(integer change)
    {
        if(change & CHANGED_OWNER || change & CHANGED_REGION)
        {
            llResetScript();
        }
    }
}
state pause
{
    state_entry()
    {
        state default;
    }
}