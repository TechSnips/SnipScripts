Get-NetTCPConnection -State Listen |
        Select-Object -Property LocalAddress,
                                LocalPort,
                                RemoteAddress,
                                RemotePort,
                                @{name='Process';expression={(Get-Process -Id $_.OwningProcess).Name}},
                                CreationTime |
        Format-Table -AutoSize