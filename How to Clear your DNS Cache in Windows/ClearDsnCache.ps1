#region Show DNS Cache
Get-DnsClientCache
ipconfig /displaydns
#endregion

#region Clear DNS Cache
Clear-DnsClientCache
ipconfig /flushdns

Get-DnsClientCache
#endregion