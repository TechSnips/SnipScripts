configuration webserver
{
    node "localhost"
    {
        WindowsFeature IIS {
            Ensure = "Present"
            Name   = "Web-Server"
        }
    }
}