class Rx_WebApplication_Stats extends WebApplication;

var Rx_Game Game;
var float fps;
var const string Prefix;
var Rx_TeamInfo Team[2];

function Init()
{
    LogInternal("Init Web Application" @ string(self.Class));
    Game = Rx_Game(WorldInfo.Game);  
}

event Tick(float DT)
{
    fps = 1.0 / DT;  
}

event Query(WebRequest Request, WebResponse Response)
{
    switch(Request.URI)
    {
        case "/Prome":
            HandlePrometheus(Request, Response);
            break;
        default:
    }    
}

function HandlePrometheus(WebRequest Request, WebResponse Response)
{
    local int NodVehicles, GDIVehicles, VehicleLimit, NodBots, GDIBots, NodPlayers, GDIPlayers,PlayerLimit, AliveNodBuildings, AliveGDIBuildings, TotalNodBuildings, TotalGDIBuildings, NodDefenses, GDIDefenses, NodPoints, GDIPoints, NodMines, GDIMines, MineLimit, NodTechBuildings, GDITechBuildings, NeuTechBuildings, TotalTechBuildings, NodCP, GDICP, CPLimit, NodCredits, GDICredits, NodKills, GDIKills, NodRecruits, GDIRecruits, NodVets, GDIVets, NodElites, GDIElites, NodHeroics, GDIHeroics;
    local float NodVP, GDIVP;

    Team[0] = Rx_TeamInfo(WorldInfo.GRI.Teams[0]);
    Team[1] = Rx_TeamInfo(WorldInfo.GRI.Teams[1]);
    GetVehicleCount(GDIVehicles, NodVehicles, VehicleLimit);
    GetPlayerCount(GDIPlayers, NodPlayers, PlayerLimit);
    GetBotCount(GDIBots, NodBots);
    GetBuildingCount(AliveGDIBuildings, AliveNodBuildings, TotalGDIBuildings, TotalNodBuildings);
    GetDefenseCount(GDIDefenses, NodDefenses);
    GetPoints(GDIPoints, NodPoints);
    GetMineCount(GDIMines, NodMines, MineLimit);
    GetTechBuildingCount(GDITechBuildings, NodTechBuildings, NeuTechBuildings, TotalTechBuildings);
    GetCommandPoints(GDICP, NodCP, CPLimit);
    GetCredits(GDICredits, NodCredits);
    GetKills(GDIKills, NodKills);
    GetVP(GDIVP, NodVP);
    GetVetRanks(GDIRecruits, GDIVets, GDIElites, GDIHeroics, NodRecruits, NodVets, NodElites, NodHeroics);
    Response.SendStandardHeaders("text/plain");
    Response.SendText(Prefix
    $ "all_players" @ string(Game.NumPlayers) @ Prefix
    $ "all_bots" @ string(Game.NumBots) @ Prefix
    $ "nod_vehicles" @ string(NodVehicles) @ Prefix
    $ "gdi_vehicles" @ string(GDIVehicles) @ Prefix
    $ "veh_limit" @ string(VehicleLimit) @ Prefix
    $ "nod_bots" @ string(NodBots) @ Prefix
    $ "gdi_bots" @ string(GDIBots) @ Prefix
    $ "nod_players" @ string(NodPlayers) @ Prefix
    $ "gdi_players" @ string(GDIPlayers) @ Prefix
    $ "player_limit" @ string(PlayerLimit) @ Prefix
    $ "nod_buildings" @ string(AliveNodBuildings) @ Prefix
    $ "total_nod_buildings" @ string(TotalNodBuildings) @ Prefix
    $ "gdi_buildings" @ string(AliveGDIBuildings) @ Prefix
    $ "total_gdi_buildings" @ string(TotalGDIBuildings) @ Prefix
    $ "nod_defenses" @ string(NodDefenses) @ Prefix
    $ "gdi_defenses" @ string(GDIDefenses) @ Prefix
    $ "nod_points" @ string(NodPoints) @ Prefix
    $ "gdi_points" @ string(GDIPoints) @ Prefix
    $ "nod_mines" @ string(NodMines) @ Prefix
    $ "gdi_mines" @ string(GDIMines) @ Prefix
    $ "mine_limit" @ string(MineLimit) @ Prefix
    $ "nod_tech_buildings" @ string(NodTechBuildings) @ Prefix
    $ "gdi_tech_buildings" @ string(GDITechBuildings) @ Prefix
    $ "neu_tech_buildings" @ string(NeuTechBuildings) @ Prefix
    $ "total_tech_buildings" @ string(TotalTechBuildings) @ Prefix
    $ "nod_commandpoints" @ string(NodCP) @ Prefix
    $ "gdi_commandpoints" @ string(GDICP) @ Prefix
    $ "commandpoints_limit" @ string(CPLimit) @ Prefix
    $ "nod_credits" @ string(NodCredits) @ Prefix
    $ "gdi_credits" @ string(GDICredits) @ Prefix
    $ "nod_kills" @ string(NodKills) @ Prefix
    $ "gdi_kills" @ string(GDIKills) @ Prefix
    $ "nod_vp" @ string(NodVP) @ Prefix
    $ "gdi_vp" @ string(GDIVP) @ Prefix
    $ "nod_recruits" @ string(NodRecruits) @ Prefix
    $ "gdi_recruits" @ string(GDIRecruits) @ Prefix
    $ "nod_veterans" @ string(NodVets) @ Prefix
    $ "gdi_veterans" @ string(GDIVets) @ Prefix
    $ "nod_elite" @ string(NodElites) @ Prefix
    $ "gdi_elite" @ string(GDIElites) @ Prefix
    $ "nod_heroic" @ string(NodHeroics) @ Prefix
    $ "gdi_heroic" @ string(GDIHeroics) @ Prefix
    $ "fps" @ string(fps)
    @ Prefix, true);
    return;   
}

function bool GetVehicleCount(out int GDI, out int Nod, out int Max)
{
    GDI = Team[0].GetVehicleCount();
    Nod = Team[1].GetVehicleCount();
    Max = (GDI + Nod) + 2;
    return true;   
}

function bool GetPlayerCount(out int GDI, out int Nod, out int Max)
{
    GDI = Team[0].PlayerSize;
    Nod = Team[1].PlayerSize;
    Max = Game.MaxPlayers;
    return true;   
}

function bool GetBotCount(out int GDI, out int Nod)
{
    GDI = Team[0].ReplicatedSize - Team[0].PlayerSize;
    Nod = Team[1].ReplicatedSize - Team[1].PlayerSize;
    return true;  
}

function bool GetBuildingCount(out int GDI, out int Nod, out int MaxGDI, out int MaxNod)
{
    local Rx_Building_Team_Internals Building;

    // Loop all buildings
    foreach WorldInfo.AllActors(class'Rx_Building_Team_Internals', Building)
    {
        // Skip tech buildings
        if(Rx_Building_TechBuilding_Internals(Building) != none)
            continue;

        // Don't double count airstrip
        if(Rx_Building_AirStrip_Internals(Building) != none)
            continue;            

        if(Building.GetTeamNum() == 0)
        {
            MaxGDI++;
            
            if(!Building.IsDestroyed())
                GDI++;
        }
        if(Building.GetTeamNum() == 1)
        {
            MaxNod++;

            if(!Building.IsDestroyed())
                Nod++;
        }        
    }    
    return true;   
}

function bool GetDefenseCount(out int GDI, out int Nod)
{
    local Rx_Defence Def;

    foreach WorldInfo.AllPawns(class'Rx_Defence', Def)
    {
        if (Def.GetTeamNum() == 0)
            GDI++;

        if (Def.GetTeamNum() == 1)
            Nod++;    
    }

    return true;   
}

function bool GetPoints(out int GDI, out int Nod)
{
    GDI = Team[0].GetDisplayRenScore();
    Nod = Team[1].GetDisplayRenScore();

    return true; 
}

function bool GetMineCount(out int GDI, out int Nod, out int Max)
{
    GDI = Team[0].MineCount;
    Nod = Team[1].MineCount;
    Max = Team[0].MineLimit;

    return true; 
}

function bool GetTechBuildingCount(out int GDI, out int Nod, out int Neutral, out int Max)
{
    local Rx_Building_TechBuilding_Internals Building;

    foreach WorldInfo.AllActors(class'Rx_Building_TechBuilding_Internals', Building)
    {
        if (Building.GetTeamNum() == 0)
            GDI++;
        else if (Building.GetTeamNum() == 1)
            Nod++;
        else
            Neutral++;

        Max++;        
    }    
    return true;   
}

function bool GetCommandPoints(out int GDI, out int Nod, out int Max)
{
    GDI = int(Team[0].GetCommandPoints());
    Nod = int(Team[1].GetCommandPoints());
    Max = int(Team[0].GetMaxCommandPoints());
    return true;
    //return ReturnValue;    
}

function bool GetCredits(out int GDI, out int Nod)
{
    local Rx_PRI PRI;
    local int I;

    for (i = 0; I < WorldInfo.GRI.PRIArray.Length; i++)
    {
        PRI = Rx_PRI(WorldInfo.GRI.PRIArray[I]);

        if (PRI != none)
        {
            if (PRI.GetTeamNum() == 0)
                GDI += int(PRI.GetCredits());
            if (PRI.GetTeamNum() == 1)
                Nod += int(PRI.GetCredits());
        }
    }
    return true;  
}

function bool GetKills(out int GDI, out int Nod)
{
    GDI = Team[0].GetKills();
    Nod = Team[1].GetKills();
    return true;
    //return ReturnValue;    
}

function bool GetVP(out float GDI, out float Nod)
{
    local Rx_PRI PRI;
    local int I;

    for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
    {
        PRI = Rx_PRI(WorldInfo.GRI.PRIArray[I]);
        if(PRI != none)
        {
            if(PRI.GetTeamNum() == 0)
            {
                GDI += PRI.Veterancy_Points;
            }
            else if(PRI.GetTeamNum() == 1)
            {
                Nod += PRI.Veterancy_Points;
            }
        }
    }
    if(GDI > float(0))
    {
        GDI /= float(Team[0].ReplicatedSize);
    }
    if(Nod > float(0))
    {
        Nod /= float(Team[1].ReplicatedSize);
    }
    return true;   
}

function bool GetVetRanks(out int GDIRecruit, out int GDIVet, out int GDIElite, out int GDIHeroic, out int NodRecruit, out int NodVet, out int NodElite, out int NodHeroic)
{
    local Rx_PRI PRI;
    local int I;

    for (i = 0; I < WorldInfo.GRI.PRIArray.Length; i++)
    {
        PRI = Rx_PRI(WorldInfo.GRI.PRIArray[I]);
        if (PRI != none)
        {
            switch(PRI.VRank)
            {
                case 0:
                    PRI.GetTeamNum() == 0 ? GDIRecruit++ : NodRecruit++;
                    break;
                case 1:
                    PRI.GetTeamNum() == 0 ? GDIVet++ : NodVet++;
                    break;
                case 2:
                    PRI.GetTeamNum() == 0 ? GDIElite++ : NodElite++;
                    break;
                case 3:
                    PRI.GetTeamNum() == 0 ? GDIHeroic++ : NodHeroic++;
                    break;
            }
        }    
    }
    return true;          
}

defaultproperties
{
    Prefix="\n"
}
