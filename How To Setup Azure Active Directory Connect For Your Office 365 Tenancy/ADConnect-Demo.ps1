# Prerequisites - Office 365 Tenant account (Trial or otherwise), ActiveDirectory Domain, VM for AD Connect

# Azure AD Connect installation link
start https://www.microsoft.com/en-us/download/details.aspx?id=47594

# Trigger a manual sync of AD Connect SyncCycle
Start-ADSyncSyncCycle -PolicyType Initial