//=============================================

string version = "NCF v.0.1";//Altera o numero da versão no texto do medidor.
string name_meter = "[NCF] Meter_v0.1";
key creator = "2c041498-46ce-47b4-b795-85e4bd99f960";//Key do Criador do Objeto

//================= Canais ==================

integer ch_title = -998;
integer ch_admin = -999;
integer ch_meter = -1000;
integer ch_dano = -1001;
integer ch_energy = -1002;
integer ch_backup = -1003;
integer ch_send_dmg = -1004;
integer ch_verific_dmg = -1005;
integer ch_receive_dmg = -1006;
integer ch_xpgain = -1007;

//================= ADMs =====================

list adms;// Lista de ADMs para manipular o sistema.
list creator_dmg;// Lista de Criadores Autorizados a Causar Dano.
key trevor  =  "2c041498-46ce-47b4-b795-85e4bd99f960";
key kevin = "494a4515-6993-4ffb-a07f-662905062a5c";
key tanaka = "6341b39c-e141-4ac2-ba77-ae9416c198c6";

//------------- MODO TESTE --------------------

integer teste = TRUE;//Alterar esta váriavel enquanto estiver TESTANDO, para receber comando ADM.

//---- COMANDOS DOS ADMs PARA ATIVAR TESTE ----

string msg_adm_ativar_teste = "TESTE_ON";//Ativa o modo de teste para alterar um medidor ADM.
string msg_adm_inativar_teste = "TESTE_OFF";//Ativa o modo de teste para alterar um medidor ADM.

//------------- COMANDOS DOS ADMs ------------

string msg_adm_zerar = "ZERAR";//Redefine o medidor, reiniciando tudo.
string msg_adm_hp_max = "HP_MAX";//Enche o HP para o nivel máximo atual.
string msg_adm_eg_max = "ENERGY_MAX";//Enche a Energia para o nivel máximo atual.
string msg_adm_lvl_define = "DEFINE_LVL";//Altera e define o LVL do usuário.
string msg_adm_lvl_bending_define = "DEFINE_BENDING";//Altera e define o Bending LVL do usuário.
string msg_adm_xp_add = "XP_ADD";//Adiciona pontos de XP ao XP atual.
string msg_adm_xp_del = "XP_DEL";//Remove pontos de XP do XP atual.
string msg_adm_nation_define = "NATION_DEFINE";//Altera e define a nação atual do usuário.
string msg_adm_awake_define = "AWAKE_DEFINE";//Altera e define se o usuário é podrijo.
string msg_adm_avatar_define = "AVATAR_DEFINE";//Altera e define se o usuário é o AVATAR.

//---------- COMANDOS DOS PLAYERS ------------

string msg_reset = "RESET_SYSTEM";
string msg_redefine = "REDEFINE_SYSTEM";
string msg_active = "ACTIVE_SYSTEM";
string msg_inactive = "INACTIVE_SYSTEM";
string msg_minimizar = "MINIMIZE";

//============ MSGs XP e Energy ==============

string msg_xp_win = "ADD_XP_POR_VENCER";
string msg_xp_gain = "ADD_XP_POR_ACERTO";
string msg_energy_gain = "ADD_ENERGY";
string msg_energy_gasto = "REMOVE_ENERGY";

//============= Valores de Pontos ============

integer point_xp_win = 3;// Xp ganho por vencer um inimigo.
integer point_xp_hit = 1;// Xp ganho por acertar o inimigo.
integer point_bd_hit = 2;// Bending XP ganho por acertar o inimigo.

//================= AVISOS ===================

string aviso_attach = " attached the ACS meter!";
string aviso_detach = "detached the ACS meter!";
string aviso_morte = " ] ← was defeated by → [ ";
string aviso_reset = " reset the ACS system!";
string aviso_active = " activated the ACS system!";
string aviso_inactive = " inactivated the ACS system!";

//================= Usuário ==================

integer i;
float h;
key owner;
string owner_name;

//=============================================

integer resumido = FALSE;
string clan = "Uchiha";
integer cargo_trava = 1;
integer avatar_mode = 0;//Se é o Avatar ou não, 0 = NÃO | 1 = SIM.
integer awakening = 0;//Se é desperto ou não, 0 = NÃO | 1 = SIM.
integer level = 0;
integer mission_points = 1000;
integer currentXP = 1000;
float max_level = 100;
integer bendingLevel = 10;
integer currentBendingLvl = 0;
integer xp_up = 1000;
integer xpb_up = 1000;

//-----------------------------

float currentHealth = 100;
float currentMaxHealth = 100;
float max_vida = 1000;
integer energy = 10;
string energy_cubo = "◉◉◉◉◉◉◉◉◉◉";
string health_cubo = "▣▣▣▣▣▣▣▣▣▣";
//-----------------------------
string title = "Name";
//-----------------------------
integer nation = 0;
list nations = ["Leaf", "Rain"];

//================= Fight ==================

float dmg_min = 10;
float dmg_var = 3;//Constante de variação.
float dmg_mult_lvl = 1;//Varia o dano de acordo o nivel.
float resistance = 0;
float hp_regen = 0.05;
float time_hp_regen = 3;
integer eg_regen = 1;
float time_eg_regen = 3;
float rate_fire = 0.7;

float time_hp = 3;
float time_eg = 3;

//================= Visual ==================

string currentNationName;
string nationNameFire = "火 𝙇𝙀𝘼𝙁 火";
string nationNameWater = "水 𝙍𝘼𝙄𝙉 水";

vector currentColor = <0.7, 1.0, 0.4>;
vector colorFire = <0.7, 1.0, 0.4>;
vector colorWater = <0.7, 0.55, 1.000>;
vector colorEarth = <0.639, 0.796, 0.329>;
vector colorAir = <1.000, 1.000, 1.000>;

string meter;

//============= Info Enemy ====================

key enemy_id;
string enemy_name;
integer nation_enemy;
integer lvl_enemy;
float dmg_enemy;

//=============================================

Init()
{
    adms = [trevor, kevin, tanaka];// Adiciona os Adms na Lista.
    creator_dmg = [trevor, kevin, tanaka];// Lista de Criadores Autorizados
    owner = llGetOwner();
    owner_name = llGetUsername(owner);
    llSetObjectName(name_meter);
    //
    llListen(ch_title,"","","");
    llListen(ch_meter,"","","");
    llListen(ch_admin,"","","");
    llListen(ch_xpgain,"","","");
    //
    BackUp(FALSE);
    //
    llSetTimerEvent(0.1);
}
string Criptografar(string msg)
{
    float hora = llGetWallclock(); 
    string date = llGetDate();
    float chave1 = llFrand(99999);
    float chave2 = chave1/hora;
    //chaves += [chave1];
    
    string cripto = llStringToBase64((string)chave2+","+(string)llGetKey()+","+(string)hora+","+date+","+(string)chave1+","+msg);
    
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
Menu()
{
    string texto = "\n• Choosing your Village:\n";
    texto += "\n    - "+nationNameFire;
    texto += "\n    - "+nationNameWater+"\n";
    
    list btn_menu = nations;
    
    llDialog(owner, texto, btn_menu, ch_meter);
}

Show()
{
    if(nation >= 0)
    {   
        SelectNation();
        
        if(!resumido)//
        {
            meter = version+"\n";
            if(teste)
                meter += "Ⓣ\n";
            meter += currentNationName + "\n";
            meter += "-"+CargoName() + "-\n";
            meter += "𝘾𝙡𝙖𝙣: "+clan + "\n";
            meter += "𝙃𝙚𝙖𝙡𝙩𝙝: " + health_cubo + "\n";
            meter += "𝘾𝙝𝙖𝙠𝙧𝙖: " + energy_cubo + "\n";
            meter += "Level: " + (string)level + "\n";
            meter += "MP: " + (string)mission_points + "\n";
            if(level < max_level)
                meter += "XP: " + (string)currentXP + " / " + (string)xp_up+"\n";
            if(title != "")
                meter += title+"\n";
            meter += "║\n║\n";
        }
        else
        {
            meter = "";
            if(teste)
                meter += "Ⓣ\n";
            meter += currentNationName + "\n";
            meter += "-"+CargoName() + "-\n";
            meter += "𝘾𝙡𝙖𝙣: "+clan + "\n";
            meter += "𝙃𝙚𝙖𝙡𝙩𝙝: " + health_cubo + "\n";
            meter += "𝘾𝙝𝙖𝙠𝙧𝙖: " + energy_cubo + "\n";
            if(title != "")
                meter += title+"\n";
            meter += "║\n║\n";
        }
    }
    else
    {
        meter = "[ Choosing your village... ]\n║\n║\n";
    }
    llSetText(meter, currentColor, 1);
    BackUp(TRUE);
    Calcular_XP_e_HP();
    /*  𝘼𝘽𝘾𝘿𝙀𝙁𝙂𝙃𝙄𝙅𝙆𝙇𝙈𝙉𝙊𝙋𝙌𝙍𝙎𝙏𝙐𝙑𝙓𝙒𝙔𝙕❓   
        𝙖𝙗𝙘𝙙𝙚𝙛𝙜𝙝𝙞𝙟𝙠𝙡𝙢𝙣𝙤𝙥𝙦𝙧𝙨𝙩𝙪𝙫𝙭𝙬𝙮𝙯 
        𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵𝟬 𝘽𝙋 𝙇𝙀𝘼𝙁  𝙍𝘼𝙄𝙉
        ▢▣██▯◉○
    */
} 

IncrementaXP(integer add)
{
    if(level < max_level)
    {
        currentXP += add;
        if(currentXP >= xp_up)
        {
            level += 1;
            currentXP = 0;
        }
    }
}

IncrementaXPBending(integer add)
{
    if(bendingLevel < max_level)
    {
        currentBendingLvl += add;
        if(currentBendingLvl >= xpb_up)
        {
            llOwnerSay("XPB: "+(string)xpb_up);
            bendingLevel += 1;
            currentBendingLvl = 0;
        }
    }
}
string CargoName()
{
    if(cargo_trava == 8)
        return "Akatsuki";
    else if(cargo_trava == 9)
        return "Jinchuuriki";
    else if(bendingLevel >= 0 && cargo_trava == 0)
        return "Jounin";
    else if(bendingLevel >= 10 && cargo_trava == 1)
        return "Jounin-Exp";
    else if(bendingLevel >= 20 && cargo_trava == 2)
        return "Jounin-Sp";
    else if(bendingLevel >= 40 && cargo_trava == 3)
        return "Jounin-Eld";
    else if(bendingLevel >= 50 && cargo_trava == 4)
        return "Jounin-Leg";
    else if(bendingLevel >= 60 && cargo_trava == 5)
        return "Anbu";
    else if(bendingLevel >= 80 && cargo_trava == 6)
        return "Sannin";
    else if(bendingLevel >= 80 && cargo_trava == 7)
        return "Kage";
    else
        return "Jounin";
}
Calcular_XP_e_HP()
{
    //Calcula o Xp atual para upar e o HP atual com base no Lvl.
    if(level > 100)
        level = 100;
    else if(level < 0)
        level = 0;
    if(level > 10){
        currentMaxHealth = 100 + (10 * (level - 10));
    }
    else
        currentMaxHealth = 100;
    xp_up = 1000*level;
    if(level == 99)
        xp_up += 1000;
    
    if(bendingLevel > 100)
        bendingLevel = 100;
    else if(bendingLevel < 0)
        bendingLevel = 0;
    if(bendingLevel > 1)
        xpb_up = 1000 * bendingLevel;
    if(bendingLevel == 99)
        xpb_up += 1000;
}

Calcular_Energy(integer add)
{
    //Soma o valor recebido, seja como debitar energia ou adicionar.
    energy += add;
    if(energy > 10)
        energy = 10;
    else if(energy < 0)
        energy = 0;
        
    energy_cubo = "";
    for(i = 1; i <= 10; i++)
    {
        if(i <= energy)
            energy_cubo += "◉";
        else
            energy_cubo += "○";
    }
}

Calcular_Health(float add)
{
    //Soma o valor recebido, seja como dano ou como regeneração.
    currentHealth += add;
    if(currentHealth > currentMaxHealth)
        currentHealth = currentMaxHealth;
    else if(currentHealth <= 0){
        currentHealth = 0; //Die
        Morte();
    }
    float div = currentMaxHealth/10;
    health_cubo = "";
    for(h = 1; h <= 10; h++)
    {
        if(currentHealth >= (div*h))
            health_cubo += "▣";
        else
            health_cubo += "▢";
    }
}
Morte()
{
    llSetText("[ Defeated ]\n║\n║\n║\n║\n",<0,0,0>,1);
    
    string texto_morte = "\n";
    texto_morte += "Defeated by: "+enemy_name+"\n";
    texto_morte += "Village: "+llList2String(nations,nation_enemy) +"\n";
    texto_morte += "Level: "+(string)lvl_enemy;
    //Envia Mensagem dando Xp ao inimigo que venceu.
    llRegionSayTo(enemy_id,ch_xpgain,Criptografar(msg_xp_win+","+(string)owner));
    Aviso_Padrao(ch_meter,"[ "+owner_name+aviso_morte+enemy_name+" ]");
    llOwnerSay(texto_morte);
    BackUp(TRUE);
    llSleep(10);
    currentHealth = currentMaxHealth;
    BackUp(TRUE);
    //Deverá enviar por mensagem RegionSayTo, um prêmio em XP para o inimigo.
    llResetScript();
}

SelectNation()
{
    if(nation == 0)//Leaf
    {
        currentNationName = nationNameFire;
        currentColor = colorFire;


        dmg_min = 11;
        
        float buffBase = dmg_min * 0.05;
        if(level == 100)
            buffBase = dmg_min * 0.1;
            
         dmg_min += buffBase;
         
        resistance = 0;
        hp_regen = 0.05;
        time_hp_regen = 4;
        eg_regen = 1;
        time_eg_regen = 4;
        rate_fire = 0.7;
    }
    else if(nation == 1)//Rain
    {
        currentNationName = nationNameWater;
        currentColor = colorWater;
        
        dmg_min = 9;
        resistance = 0;
        hp_regen = 0.05;
        time_hp_regen = 2;
        eg_regen = 1;
        time_eg_regen = 4;
        rate_fire = 1.0;
    }
    else
        nation = 0;
}

BackUp(integer case)
{
    if(case)//
    {
        if(level < 1)
            level = 1;
        if(currentMaxHealth < 100)
            currentMaxHealth = 100;
        if(xp_up < 1000)
            xp_up = 1000;
            
        string description = (string)nation+",";
        description += (string)level+",";
        description += (string)currentHealth+",";
        description += (string)currentXP+",";
        description += (string)bendingLevel+",";
        description += (string)currentBendingLvl+",";
        description += (string)dmg_min+",";
        description += (string)awakening+",";
        //description += (string)teste+",";
        description += title+",";
        description += (string)avatar_mode+",";
        description += (string)energy;
        
        llSetObjectDesc(description);
    }
    else//
    {
        list description = llCSV2List(llGetObjectDesc());
        
        nation = llList2Integer(description,0);
        level = llList2Integer(description,1);
        currentHealth = llList2Float(description,2);
        currentXP = llList2Integer(description,3);
        bendingLevel = llList2Integer(description,4);
        currentBendingLvl = llList2Integer(description,5); 
        dmg_min = llList2Float(description,6);
        awakening = llList2Integer(description,7);
        //teste = llList2Integer(description,8);
        title = llList2String(description,8);
        avatar_mode = llList2Integer(description,9);
        energy = llList2Integer(description,10);
        
        BackUp(TRUE);//Salva novamente após recuperar
        if(nation == -1)
            Menu();
    }
}
Zerar()
{
    llOwnerSay("\nExecutou função Zerar!");
    nation = -1;
    level = 1;
    currentMaxHealth = 100;
    currentHealth = 100;
    currentXP = 0;
    bendingLevel = 0;
    currentBendingLvl = 0;
    xp_up = 1000;
    xpb_up = 1000;
    awakening = 0;
    title = "";
    avatar_mode = 0;
    energy = 10;
    BackUp(TRUE);
    llResetScript();
}
integer CheckCreator(key id)
{
    list details = llGetObjectDetails(id,[OBJECT_CREATOR]);
    if(llListFindList(creator_dmg,[llList2Key(details,0)]) != -1)
        return TRUE;
    return FALSE;
}
//Função para adicionar nos Ataques e Skills para remover ou adicionar Energy.
Energy_Drenar()
{
    //Ganho
    llRegionSayTo(owner, ch_xpgain, msg_energy_gain+",3");
    //Gasto
    llRegionSayTo(owner, ch_xpgain, msg_energy_gasto+",3");
}
Aviso_Padrao(integer ch, string msg)
{
    llRegionSay(ch,Criptografar("\n• "+msg));   
}
default
{
    state_entry()
    {
       Init();
    }
    attach(key att)
    {
        if(att){}
        else{
            llRegionSay(ch_meter,aviso_detach+","+owner_name);
        }
    }
    on_rez(integer rez)
    {
        Aviso_Padrao(ch_meter,llGetUsername(llGetOwner())+","+aviso_attach);
        BackUp(TRUE);
        llResetScript();
    }
    link_message(integer name, integer chan, string msg, key id)
    {
        if(chan == ch_dano)
        {
            enemy_id = id;
            enemy_name = llGetUsername(enemy_id);//Nome do inimigo.
            
            list msg_full = llCSV2List(msg);
            nation_enemy = llList2Integer(msg_full,0);//Guarda a nação do inimigo.
            lvl_enemy = llList2Integer(msg_full,1);//Guarda o Level do inimigo.
            dmg_enemy = llList2Float(msg_full,2);
            dmg_enemy -= dmg_enemy * resistance;//Debita o valor da resistência ao dano recebido.
            
            //llOwnerSay("\n11 -Valor de Dano: "+(string)dmg_enemy);
            Calcular_Health(-dmg_enemy);
        }
        else if(chan == ch_energy)
        {
            Calcular_Energy((integer)msg);
        }
        else if(chan == ch_xpgain)
        {
            if(msg == msg_xp_gain){
                IncrementaXP(point_xp_hit);
                IncrementaXPBending(point_bd_hit);
            }
        }
        else if(chan == ch_backup)
        {
            //llOwnerSay("MAIN: " +msg);
            list data = llCSV2List(msg);
            nation = llList2Integer(data,0);
            level = llList2Integer(data,1);
            currentXP = llList2Integer(data,2);
            awakening = llList2Integer(data,3);
            BackUp(TRUE);
        }
    }
    listen(integer chan, string name, key id, string msg)
    {
        key falador = llGetOwnerKey(id);
        //Canl para adicionar Titulo.
        if(chan == ch_title && falador == llGetOwner())
        {
            title = llGetSubString(msg,0,19);
        }
        //Canal para controles do Usuário.
        if(chan == ch_meter)
        {
            list msg_full = llCSV2List(msg);
            string msg_pt1 = llList2String(msg_full,0);
            string msg_pt2 = llList2String(msg_full,1);
            if(falador == owner)
            {
                //Define a sua própria nação no inicio.
                integer index = llListFindList(nations,[msg]);
                if(index != -1)
                {
                    nation = index;
                }
                else if(msg == msg_reset)
                {
                    Aviso_Padrao(ch_meter,owner_name+aviso_reset);
                    energy = 10;
                    currentHealth = currentMaxHealth;
                }
                else if(msg == msg_minimizar)
                {
                    if(!resumido)
                        llOwnerSay("\n• The meter has been minimized.");
                    else
                        llOwnerSay("\n• The meter has been expanded.");
                    resumido = !resumido;
                }
            }
            else if(msg_pt1 == aviso_detach)
            {
                llOwnerSay(msg_pt2+" "+aviso_detach);
            }
            //Recebe noticias dos outros Players
            else if(CheckCreator(id))
            {
                llOwnerSay(Descriptografar(msg,id));
            }
                
        }
        //Canal para ganho e gasto de XP e Energy vindo de objetos rez CRIPTOGRAFADO.
        else if(chan == ch_xpgain && CheckCreator(id))
        {
            list msg_full = llCSV2List(Descriptografar(msg,id));
            string msg_pt1 = llList2String(msg_full,0);
            if(falador == owner)
            {
                integer msg_pt2 = llList2Integer(msg_full,1);
                if(msg == msg_xp_gain)
                {
                    IncrementaXP(point_xp_hit);
                }
                //Adiciona energia no valor recebido pela mensagem.
                else if(msg_pt1 == msg_energy_gain)
                {
                    //Somente se for um valor superior a Zero.
                    if(msg_pt2 > 0)
                        Calcular_Energy(msg_pt2);
                }
                //Remove da energia o valor enviado pelo ataque.
                else if(msg_pt1 == msg_energy_gasto)
                {
                    //Somente se for um valor superior a Zero.
                    if(msg_pt2 > 0)
                        Calcular_Energy(-msg_pt2);
                }
            }
            else
            {
                //Verifica se é a mensagem de Vitória e se o Falador é o mesmo da mensagem.
                if(msg_pt1 == msg_xp_win && llList2Key(msg_full,1) == falador)
                {
                    //llOwnerSay("Recebeu Xp por Matar!");
                    IncrementaXP(point_xp_win);
                }
            }
        }
        //Canal para receber comandos dos ADMs e somente deles.
        else if(chan == ch_admin && llListFindList(adms,[falador]) != -1)
        {
            integer index_adm = llListFindList(adms,[owner]);
            //Protege os próprios ADMs desses comandos, impedindo de executar, exceto em TESTE.
            if(index_adm == -1 || teste)
            {
                list msg_full = llCSV2List(msg);
                string msg_pt1 = llList2String(msg_full,0);
                integer msg_pt2 = llList2Integer(msg_full,1);
                //Redefine totalmente o sistema, zerando todas as informações.
                if(msg == msg_adm_zerar)
                {
                    Zerar();
                }
                //Restaura o HP máximo do usuário.
                else if(msg == msg_adm_hp_max)
                {
                    currentHealth = currentMaxHealth;
                }
                //Restaura a energia máxima do usuário.
                else if(msg == msg_adm_eg_max)
                {
                    energy = 10;
                }
                //Altera e Define o Level atual do usuário.
                else if(msg_pt1 == msg_adm_lvl_define)
                {
                    level = msg_pt2;
                }
                //Altera e Define o Bending Level atual do usuário.
                else if(msg_pt1 == msg_adm_lvl_bending_define)
                {
                    bendingLevel = msg_pt2;
                }
                //Adiciona pontos de XP ao XP atual do usuário.
                else if(msg_pt1 == msg_adm_xp_add)
                {
                    currentXP += msg_pt2;
                }
                //Remove pontos de XP do XP atual do usuário.
                else if(msg_pt1 == msg_adm_xp_del)
                {
                    currentXP -= msg_pt2;
                }
                //Altera e Define a nação atual do usuário.
                else if(msg_pt1 == msg_adm_nation_define)
                {
                    nation = msg_pt2;
                }
                //Altera e Define o usuário é ou não Desperto como Prodigio.
                else if(msg_pt1 == msg_adm_awake_define)
                {
                    awakening = msg_pt2;
                }
                //Altera e Define se o usuário é o AVATAR atual.
                else if(msg_pt1 == msg_adm_avatar_define)
                {
                    avatar_mode = msg_pt2;
                }
                //Usado para Desabilitar a autorização de um ADM alterar um medidor ADM.
                else if(msg == msg_adm_inativar_teste && index_adm != -1 && teste)
                {
                    teste = FALSE;
                    llOwnerSay("\nModo Teste Do Desenvolvedor DESATIVADO!");
                }
            }
            //Usado para habilitar a autorização de um ADM alterar um medidor ADM.
            else if(msg == msg_adm_ativar_teste && index_adm != -1 && !teste)
            {
                teste = TRUE;
                llOwnerSay("\nModo Teste Do Desenvolvedor ATIVADO!");
            }
        }
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == owner)
        {
            //Calcular_Energy(-1);//Teste para debitar Energia
            //Calcular_Health(-5);//Teste para debitar Vida
            //level = 1;
            IncrementaXP(xp_up);
            //Zerar();
        }
    }

    timer()
    {
        Show();
        
        if(energy < 10)
        {
            time_eg -= 0.1;//Debita do tempo de Energy.
            if(time_eg <= 0){//Quando chegar a Zero ele regenera o Energy.
                Calcular_Energy(eg_regen);
                time_eg = time_eg_regen;//Restaura o tempo de Energy.
            }
        }
        else
        {
            Calcular_Energy(0);
        }
        if(currentHealth < currentMaxHealth)
        {
            time_hp -= 0.1;//Debita do tempo de Health.
            if(time_hp <= 0){//Quando chegar a Zero ele regenera o Health.
                Calcular_Health(currentMaxHealth*hp_regen);//OBS: Hp regenera em porcentagem.
                time_hp = time_hp_regen;//Restaura o tempo de Health.
                
                //llOwnerSay("HP: "+(string)currentHealth);//Verificar Hp atual sempre que curar.
            }
        }
        else
        {
            Calcular_Health(0);
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
