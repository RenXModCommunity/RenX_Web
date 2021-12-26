class Rx_WebServer extends WebServer
config(Web);

const MAX_APPLICATIONS = 10;

var string Applicationss[MAX_APPLICATIONS];
var string ApplicationPathss[MAX_APPLICATIONS];

event Tick(float DeltaTime)
{
    local int i;

    for (i = 0; i < MAX_APPLICATIONS; i++)
    {
        if(Rx_WebApplication_Stats(ApplicationObjects[I]) != none)
        {
            Rx_WebApplication_Stats(ApplicationObjects[I]).Tick(DeltaTime);
        }
    }  
}

function PostBeginPlay()
{
    local int i;
    local class<WebApplication> ApplicationClass;
    local IpAddr L;
    local string S;

    // Double check we aren't a client somehow
    if (WorldInfo.NetMode == NM_Standalone || WorldInfo.NetMode == NM_Client)
    {
        Destroy();
        return;
    }
    // Disabled in config
    if (!bEnabled)
    {
        LogInternal("Webserver is not enabled. Set bEnabled to True in UDKWeb.ini");
        Destroy();
        return;
    }
    super(Actor).PostBeginPlay();

    if (ServerName == "")
    {
        GetLocalIP(L);
        S = IpAddrToString(L);
        I = InStr(S, ":");
        if(I != -1)
        {
            S = Left(S, I);
        }
        ServerURL = "http://" $ S;
    }
    else
    {
        ServerURL = "http://" $ ServerName;
    }
    if (ListenPort != 80)
    {
        ServerURL = (ServerURL $ ":") $ string(ListenPort);
    }
    if (BindPort(ListenPort) > 0)
    {
        if (Listen())
        {
            LogInternal((((((((("Web Server Created" @ ServerURL) @ "Port:") @ string(ListenPort)) @ "MaxCon") @ string(MaxConnections)) @ "ExpirationSecs") @ string(ExpirationSeconds)) @ "Enabled") @ string(bEnabled));
            LogInternal("~~~~~~~~~~~~~~~~~~~Loading Server Apps~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" @ Applicationss[0]);

            for (i = 0; i < MAX_APPLICATIONS; i++)
            {
                if(Applicationss[I] == "")
                {
                    continue;
                }
                ApplicationClass = class<WebApplication>(DynamicLoadObject(Applicationss[I], class'Class'));
                if(ApplicationClass != none)
                {
                    ApplicationObjects[I] = new (none) ApplicationClass;
                    ApplicationObjects[I].WorldInfo = WorldInfo;
                    ApplicationObjects[I].WebServer = self;
                    ApplicationObjects[I].Path = ApplicationPathss[I];
                    ApplicationObjects[I].Init();
                }
                else
                {
                    LogInternal("Failed to load" @ Applicationss[I]);
                }
            }
        }
        else
        {
            LogInternal("Unable to setup server for listen");
        }
    }
    else
    {
        LogInternal("Unable to bind webserver to a port");
    }
}

event Destroyed()
{
    local int i;

    LogInternal("Destroying WebServer");

    for (i = 0; i < MAX_APPLICATIONS; i++)
    {
        if(ApplicationObjects[I] != none)
        {
            ApplicationObjects[I].CleanupApp();
        }
    }
    super(Actor).Destroyed();
}

event GainedChild(Actor C)
{
    super(Actor).GainedChild(C);

    ConnectionCount++;

    if (MaxConnections > 0 && ConnectionCount > MaxConnections && LinkState == 2)
    {
        LogInternal("WebServer: Too many connections - closing down Listen.");
        Close();
    }   
}

event LostChild(Actor C)
{
    super(Actor).LostChild(C);

    ConnectionCount--;

    if (ConnectionCount <= MaxConnections && LinkState != 2)
    {
        LogInternal("WebServer: Listening again - connections have been closed.");
        Listen();
    } 
}

function WebApplication GetApplication(string URI, out string SubURI)
{
    local int I, L;

    SubURI = "";

    for (i = 0; i < MAX_APPLICATIONS; i++)
    {
        if(ApplicationPathss[I] != "")
        {
            L = Len(ApplicationPathss[I]);
            if((Left(URI, L) ~= ApplicationPathss[I]) && (Len(URI) == L) || Mid(URI, L, 1) == "/")
            {
                SubURI = Mid(URI, L);
                return ApplicationObjects[I];
            }
        }
    }

    return none; 
}

defaultproperties
{
    Applicationss(0)="RenX_Web.Rx_WebApplication_Stats"
    ApplicationPathss(0)="/ServerInfo"
}